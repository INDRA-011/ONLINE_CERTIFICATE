using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using CertifyApp.Models;

namespace CertifyApp.Data
{
    public class CertificateData
    {
        private readonly string connectionString;

        public CertificateData()
        {
            connectionString = ConfigurationManager.ConnectionStrings["Default"]?.ConnectionString
                ?? throw new InvalidOperationException("Connection string 'Default' not found.");
        }

        // ─── INSERT ──────────────────────────────────────────────────────────────────

        public int InsertCertificate(Certificate cert)
        {
            if (cert == null) throw new ArgumentNullException(nameof(cert));

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO Certificates
                        (CertificateTitle, PersonName, IssueDate, WorkshopName, WorkshopDate,
                         TotalHours, DirectorName, DirectorTitle, CreatedDate, CertificateType,
                         StudentEmail, StudentBatch)
                    VALUES
                        (@CertificateTitle, @PersonName, @IssueDate, @WorkshopName, @WorkshopDate,
                         @TotalHours, @DirectorName, @DirectorTitle, @CreatedDate, @CertificateType,
                         @StudentEmail, @StudentBatch);
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    AddCertificateParams(cmd, cert);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        // ─── BULK INSERT ─────────────────────────────────────────────────────────────

        /// <summary>
        /// Inserts multiple certificates at once. Returns list of new IDs.
        /// </summary>
        public List<int> BulkInsertCertificates(List<Certificate> certs)
        {
            var ids = new List<int>();
            foreach (var cert in certs)
            {
                int newId = InsertCertificate(cert);
                if (newId > 0)
                {
                    string certNumber = GenerateCertificateNumber(newId, cert.IssueDate);
                    UpdateCertificateNumber(newId, certNumber);
                    ids.Add(newId);
                }
            }
            return ids;
        }

        // ─── GET ALL (with optional filters) ─────────────────────────────────────────

        public List<Certificate> GetAllCertificates(string certType = null, string batch = null, DateTime? fromDate = null, DateTime? toDate = null)
        {
            var certificates = new List<Certificate>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT CertificateID, CertificateNumber, CertificateTitle, PersonName,
                           IssueDate, WorkshopName, WorkshopDate, TotalHours,
                           DirectorName, DirectorTitle, CreatedDate, CertificateType,
                           StudentEmail, StudentBatch
                    FROM Certificates
                    WHERE 1=1
                    " + (string.IsNullOrEmpty(certType) ? "" : " AND CertificateType = @CertificateType")
                      + (string.IsNullOrEmpty(batch)    ? "" : " AND StudentBatch = @StudentBatch")
                      + (fromDate.HasValue              ? " AND IssueDate >= @FromDate" : "")
                      + (toDate.HasValue                ? " AND IssueDate <= @ToDate"   : "")
                      + " ORDER BY CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(certType)) cmd.Parameters.AddWithValue("@CertificateType", certType);
                    if (!string.IsNullOrEmpty(batch))    cmd.Parameters.AddWithValue("@StudentBatch",    batch);
                    if (fromDate.HasValue)               cmd.Parameters.AddWithValue("@FromDate",        fromDate.Value);
                    if (toDate.HasValue)                 cmd.Parameters.AddWithValue("@ToDate",          toDate.Value);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                        while (reader.Read())
                            certificates.Add(MapCertificate(reader));
                }
            }
            return certificates;
        }

        // ─── GET BY ID ────────────────────────────────────────────────────────────────

        public Certificate GetCertificateById(int certificateId)
        {
            if (certificateId <= 0) throw new ArgumentException("Invalid certificate ID", nameof(certificateId));

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT CertificateID, CertificateNumber, CertificateTitle, PersonName,
                           IssueDate, WorkshopName, WorkshopDate, TotalHours,
                           DirectorName, DirectorTitle, CreatedDate, CertificateType,
                           StudentEmail, StudentBatch
                    FROM Certificates
                    WHERE CertificateID = @CertificateID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CertificateID", certificateId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                        if (reader.Read()) return MapCertificate(reader);
                }
            }
            return null;
        }

        // ─── GET STATS ────────────────────────────────────────────────────────────────

        public int GetTotalCount() => GetScalar("SELECT COUNT(*) FROM Certificates");
        public int GetTodayCount() => GetScalar("SELECT COUNT(*) FROM Certificates WHERE CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE)");
        public int GetCountByType(string type) => GetScalar("SELECT COUNT(*) FROM Certificates WHERE CertificateType = @p0", type);

        private int GetScalar(string query, string param = null)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (param != null) cmd.Parameters.AddWithValue("@p0", param);
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // ─── GET DISTINCT BATCHES (for filter dropdown) ───────────────────────────────

        public List<string> GetDistinctBatches()
        {
            var batches = new List<string>();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT DISTINCT StudentBatch FROM Certificates WHERE StudentBatch IS NOT NULL AND StudentBatch <> '' ORDER BY StudentBatch DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                        while (reader.Read())
                            batches.Add(reader.GetString(0));
                }
            }
            return batches;
        }

        // ─── UPDATE ───────────────────────────────────────────────────────────────────

        public bool UpdateCertificate(Certificate cert)
        {
            if (cert == null || cert.CertificateID <= 0)
                throw new ArgumentException("Invalid certificate data", nameof(cert));

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Certificates SET
                        CertificateTitle = @CertificateTitle,
                        PersonName       = @PersonName,
                        IssueDate        = @IssueDate,
                        WorkshopName     = @WorkshopName,
                        WorkshopDate     = @WorkshopDate,
                        TotalHours       = @TotalHours,
                        DirectorName     = @DirectorName,
                        DirectorTitle    = @DirectorTitle,
                        CertificateType  = @CertificateType,
                        StudentEmail     = @StudentEmail,
                        StudentBatch     = @StudentBatch
                    WHERE CertificateID = @CertificateID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    AddCertificateParams(cmd, cert);
                    cmd.Parameters.AddWithValue("@CertificateID", cert.CertificateID);
                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool UpdateCertificateNumber(int certificateId, string certificateNumber)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Certificates SET CertificateNumber = @CertificateNumber WHERE CertificateID = @CertificateID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CertificateID",     certificateId);
                    cmd.Parameters.AddWithValue("@CertificateNumber", certificateNumber ?? (object)DBNull.Value);
                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        // ─── DELETE ───────────────────────────────────────────────────────────────────

        public bool DeleteCertificate(int certificateId)
        {
            if (certificateId <= 0) throw new ArgumentException("Invalid certificate ID", nameof(certificateId));

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Certificates WHERE CertificateID = @CertificateID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CertificateID", certificateId);
                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        // ─── HELPERS ──────────────────────────────────────────────────────────────────

        private void AddCertificateParams(SqlCommand cmd, Certificate cert)
        {
            cmd.Parameters.AddWithValue("@CertificateTitle", cert.CertificateTitle ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@PersonName",       cert.PersonName       ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IssueDate",        cert.IssueDate);
            cmd.Parameters.AddWithValue("@WorkshopName",     string.IsNullOrEmpty(cert.WorkshopName) ? (object)DBNull.Value : cert.WorkshopName);
            cmd.Parameters.AddWithValue("@WorkshopDate",     cert.WorkshopDate.HasValue ? (object)cert.WorkshopDate.Value : DBNull.Value);
            cmd.Parameters.AddWithValue("@TotalHours",       cert.TotalHours.HasValue   ? (object)cert.TotalHours.Value   : DBNull.Value);
            cmd.Parameters.AddWithValue("@DirectorName",     string.IsNullOrEmpty(cert.DirectorName)  ? (object)DBNull.Value : cert.DirectorName);
            cmd.Parameters.AddWithValue("@DirectorTitle",    string.IsNullOrEmpty(cert.DirectorTitle) ? (object)DBNull.Value : cert.DirectorTitle);
            cmd.Parameters.AddWithValue("@CreatedDate",      cert.CreatedDate ?? (object)DateTime.Now);
            cmd.Parameters.AddWithValue("@CertificateType",  string.IsNullOrEmpty(cert.CertificateType) ? "Participation" : cert.CertificateType);
            cmd.Parameters.AddWithValue("@StudentEmail",     string.IsNullOrEmpty(cert.StudentEmail) ? (object)DBNull.Value : cert.StudentEmail);
            cmd.Parameters.AddWithValue("@StudentBatch",     string.IsNullOrEmpty(cert.StudentBatch) ? (object)DBNull.Value : cert.StudentBatch);
        }

        private string GenerateCertificateNumber(int certificateId, DateTime issueDate)
        {
            return $"CERT-{issueDate:yyyyMMdd}-{certificateId:D4}";
        }

        private Certificate MapCertificate(SqlDataReader r)
        {
            return new Certificate
            {
                CertificateID     = r.IsDBNull(r.GetOrdinal("CertificateID"))     ? 0    : r.GetInt32(r.GetOrdinal("CertificateID")),
                CertificateNumber = r.IsDBNull(r.GetOrdinal("CertificateNumber")) ? null : r.GetString(r.GetOrdinal("CertificateNumber")),
                CertificateTitle  = r.IsDBNull(r.GetOrdinal("CertificateTitle"))  ? ""   : r.GetString(r.GetOrdinal("CertificateTitle")),
                PersonName        = r.IsDBNull(r.GetOrdinal("PersonName"))        ? ""   : r.GetString(r.GetOrdinal("PersonName")),
                IssueDate         = r.IsDBNull(r.GetOrdinal("IssueDate"))         ? DateTime.Now : r.GetDateTime(r.GetOrdinal("IssueDate")),
                WorkshopName      = r.IsDBNull(r.GetOrdinal("WorkshopName"))      ? null : r.GetString(r.GetOrdinal("WorkshopName")),
                WorkshopDate      = r.IsDBNull(r.GetOrdinal("WorkshopDate"))      ? (DateTime?)null : r.GetDateTime(r.GetOrdinal("WorkshopDate")),
                TotalHours        = r.IsDBNull(r.GetOrdinal("TotalHours"))        ? (int?)null : r.GetInt32(r.GetOrdinal("TotalHours")),
                DirectorName      = r.IsDBNull(r.GetOrdinal("DirectorName"))      ? null : r.GetString(r.GetOrdinal("DirectorName")),
                DirectorTitle     = r.IsDBNull(r.GetOrdinal("DirectorTitle"))     ? null : r.GetString(r.GetOrdinal("DirectorTitle")),
                CreatedDate       = r.IsDBNull(r.GetOrdinal("CreatedDate"))       ? (DateTime?)null : r.GetDateTime(r.GetOrdinal("CreatedDate")),
                CertificateType   = r.IsDBNull(r.GetOrdinal("CertificateType"))   ? "Participation" : r.GetString(r.GetOrdinal("CertificateType")),
                StudentEmail      = r.IsDBNull(r.GetOrdinal("StudentEmail"))      ? null : r.GetString(r.GetOrdinal("StudentEmail")),
                StudentBatch      = r.IsDBNull(r.GetOrdinal("StudentBatch"))      ? null : r.GetString(r.GetOrdinal("StudentBatch")),
            };
        }
    }
}
