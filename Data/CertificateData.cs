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

        public int InsertCertificate(Certificate cert)
        {
            if (cert == null)
                throw new ArgumentNullException(nameof(cert));

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO Certificates
                (CertificateTitle, PersonName, IssueDate, WorkshopName, WorkshopDate,
                 TotalHours, DirectorName, DirectorTitle, CreatedDate, CertificateType)
                VALUES
                (@CertificateTitle, @PersonName, @IssueDate, @WorkshopName, @WorkshopDate,
                 @TotalHours, @DirectorName, @DirectorTitle, @CreatedDate, @CertificateType);
                
                SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CertificateTitle", cert.CertificateTitle ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@PersonName", cert.PersonName ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@IssueDate", cert.IssueDate);
                    cmd.Parameters.AddWithValue("@WorkshopName", string.IsNullOrEmpty(cert.WorkshopName) ? (object)DBNull.Value : cert.WorkshopName);
                    cmd.Parameters.AddWithValue("@WorkshopDate", cert.WorkshopDate.HasValue ? (object)cert.WorkshopDate.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@TotalHours", cert.TotalHours.HasValue ? (object)cert.TotalHours.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@DirectorName", string.IsNullOrEmpty(cert.DirectorName) ? (object)DBNull.Value : cert.DirectorName);
                    cmd.Parameters.AddWithValue("@DirectorTitle", string.IsNullOrEmpty(cert.DirectorTitle) ? (object)DBNull.Value : cert.DirectorTitle);
                    cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@CertificateType", string.IsNullOrEmpty(cert.CertificateType) ? "Participation" : cert.CertificateType);

                    conn.Open();

                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        public List<Certificate> GetAllCertificates()
        {
            var certificates = new List<Certificate>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT CertificateID, CertificateNumber, CertificateTitle, PersonName, 
                        IssueDate, WorkshopName, WorkshopDate, TotalHours, 
                        DirectorName, DirectorTitle, CreatedDate, CertificateType
                 FROM Certificates 
                 ORDER BY CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            certificates.Add(MapCertificate(reader));
                        }
                    }
                }
            }

            return certificates;
        }

        public Certificate GetCertificateById(int certificateId)
        {
            if (certificateId <= 0)
                throw new ArgumentException("Invalid certificate ID", nameof(certificateId));

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT CertificateID, CertificateNumber, CertificateTitle, PersonName, 
                IssueDate, WorkshopName, WorkshopDate, TotalHours, 
                DirectorName, DirectorTitle, CreatedDate, CertificateType
         FROM Certificates 
         WHERE CertificateID = @CertificateID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CertificateID", certificateId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return MapCertificate(reader);
                        }
                    }
                }
            }
            return null;
        }

        public bool UpdateCertificate(Certificate cert)
        {
            if (cert == null || cert.CertificateID <= 0)
                throw new ArgumentException("Invalid certificate data", nameof(cert));

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Certificates 
                                SET CertificateNumber = @CertificateNumber,
                                    CertificateTitle = @CertificateTitle,
                                    PersonName = @PersonName,
                                    IssueDate = @IssueDate,
                                    WorkshopName = @WorkshopName,
                                    WorkshopDate = @WorkshopDate,
                                    TotalHours = @TotalHours,
                                    DirectorName = @DirectorName,
                                    DirectorTitle = @DirectorTitle
                                WHERE CertificateID = @CertificateID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CertificateID", cert.CertificateID);
                    cmd.Parameters.AddWithValue("@CertificateNumber", string.IsNullOrEmpty(cert.CertificateNumber) ? (object)DBNull.Value : cert.CertificateNumber);
                    cmd.Parameters.AddWithValue("@CertificateTitle", cert.CertificateTitle ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@PersonName", cert.PersonName ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@IssueDate", cert.IssueDate);
                    cmd.Parameters.AddWithValue("@WorkshopName", string.IsNullOrEmpty(cert.WorkshopName) ? (object)DBNull.Value : cert.WorkshopName);
                    cmd.Parameters.AddWithValue("@WorkshopDate", cert.WorkshopDate.HasValue ? (object)cert.WorkshopDate.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@TotalHours", cert.TotalHours.HasValue ? (object)cert.TotalHours.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@DirectorName", string.IsNullOrEmpty(cert.DirectorName) ? (object)DBNull.Value : cert.DirectorName);
                    cmd.Parameters.AddWithValue("@DirectorTitle", string.IsNullOrEmpty(cert.DirectorTitle) ? (object)DBNull.Value : cert.DirectorTitle);

                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool DeleteCertificate(int certificateId)
        {
            if (certificateId <= 0)
                throw new ArgumentException("Invalid certificate ID", nameof(certificateId));

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

        private Certificate MapCertificate(SqlDataReader reader)
        {
            var certificate = new Certificate();

            int certIdOrdinal = reader.GetOrdinal("CertificateID");
            certificate.CertificateID = reader.IsDBNull(certIdOrdinal) ? 0 : reader.GetInt32(certIdOrdinal);

            int certNumOrdinal = reader.GetOrdinal("CertificateNumber");
            certificate.CertificateNumber = reader.IsDBNull(certNumOrdinal) ? null : reader.GetString(certNumOrdinal);

            int certTitleOrdinal = reader.GetOrdinal("CertificateTitle");
            certificate.CertificateTitle = reader.IsDBNull(certTitleOrdinal) ? string.Empty : reader.GetString(certTitleOrdinal);

            int personNameOrdinal = reader.GetOrdinal("PersonName");
            certificate.PersonName = reader.IsDBNull(personNameOrdinal) ? string.Empty : reader.GetString(personNameOrdinal);

            int issueDateOrdinal = reader.GetOrdinal("IssueDate");
            certificate.IssueDate = reader.IsDBNull(issueDateOrdinal) ? DateTime.Now : reader.GetDateTime(issueDateOrdinal);

            int workshopNameOrdinal = reader.GetOrdinal("WorkshopName");
            certificate.WorkshopName = reader.IsDBNull(workshopNameOrdinal) ? null : reader.GetString(workshopNameOrdinal);

            // Handle nullable DateTime for WorkshopDate
            int workshopDateOrdinal = reader.GetOrdinal("WorkshopDate");
            if (reader.IsDBNull(workshopDateOrdinal))
                certificate.WorkshopDate = null;
            else
                certificate.WorkshopDate = reader.GetDateTime(workshopDateOrdinal);

            // Handle nullable int for TotalHours
            int totalHoursOrdinal = reader.GetOrdinal("TotalHours");
            if (reader.IsDBNull(totalHoursOrdinal))
                certificate.TotalHours = null;
            else
                certificate.TotalHours = reader.GetInt32(totalHoursOrdinal);

            int directorNameOrdinal = reader.GetOrdinal("DirectorName");
            certificate.DirectorName = reader.IsDBNull(directorNameOrdinal) ? null : reader.GetString(directorNameOrdinal);

            int directorTitleOrdinal = reader.GetOrdinal("DirectorTitle");
            certificate.DirectorTitle = reader.IsDBNull(directorTitleOrdinal) ? null : reader.GetString(directorTitleOrdinal);

            // Handle nullable DateTime for CreatedDate
            int createdDateOrdinal = reader.GetOrdinal("CreatedDate");
            if (reader.IsDBNull(createdDateOrdinal))
                certificate.CreatedDate = null;
            else
                certificate.CreatedDate = reader.GetDateTime(createdDateOrdinal);

            // ADD THIS BLOCK
            int certTypeOrdinal = reader.GetOrdinal("CertificateType");
            certificate.CertificateType = reader.IsDBNull(certTypeOrdinal) ? "Participation" : reader.GetString(certTypeOrdinal);

            return certificate;
        }

        public bool UpdateCertificateNumber(int certificateId, string certificateNumber)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Certificates 
                        SET CertificateNumber = @CertificateNumber
                        WHERE CertificateID = @CertificateID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CertificateID", certificateId);
                    cmd.Parameters.AddWithValue("@CertificateNumber", certificateNumber ?? (object)DBNull.Value);

                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }
    }
}
