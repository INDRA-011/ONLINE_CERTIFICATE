using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;
using CertifyApp.Data;
using CertifyApp.Models;

namespace CertifyApp
{
    public partial class BulkUpload : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        // ── PREVIEW ROW MODEL ─────────────────────────────────────────────────────────
        // Matches the new CSV format:
        // ID, Certificate Title, Student Name, Email Address,
        // Issue Date, Workshop/Event Name, Event Date, Total Hour

        public class PreviewRow
        {
            public int Row { get; set; }
            public string CertificateTitle { get; set; }   // per-row title from CSV
            public string PersonName { get; set; }   // "Student Name"
            public string EmailAddress { get; set; }   // "Email Address"
            public string IssueDate { get; set; }   // "Issue Date"
            public string WorkshopName { get; set; }   // "Workshop/Event Name"
            public string EventDate { get; set; }   // "Event Date" (optional)
            public string TotalHour { get; set; }   // "Total Hour" (optional)
            public string Status { get; set; }   // "Valid" or "Invalid"
            public string Notes { get; set; }   // error details
        }

        // ── PAGE LOAD ────────────────────────────────────────────────────────────────

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Admin"] == null) { Response.Redirect("~/Login.aspx"); return; }
        }

        // ── DOWNLOAD TEMPLATE ────────────────────────────────────────────────────────

        protected void btnDownloadTemplate_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", "attachment; filename=bulk_certificate_template.csv");

            // Header row — must match exactly what the parser expects
            Response.Write("ID,Certificate Title,Student Name,Email Address,Issue Date,Workshop/Event Name,Event Date,Total Hour\r\n");

            // Sample rows
            Response.Write("1,Certificate of Participation,John Doe,john@example.com,8/2/2026,Project Management,1/5/2025,30\r\n");
            Response.Write("2,Certificate of Completion,Jane Smith,jane@example.com,8/2/2026,DevOps Bootcamp,,20\r\n");
            Response.Write("3,Certificate of Achievement,Ram Sharma,ram@example.com,8/2/2026,Web Development,,\r\n");

            Response.End();
        }

        // ── PREVIEW ──────────────────────────────────────────────────────────────────

        protected void btnPreview_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
            { ShowError("Please select a CSV file first."); return; }

            string ext = Path.GetExtension(fileUpload.FileName).ToLower();
            if (ext != ".csv")
            { ShowError("Only .csv files are accepted."); return; }

            try
            {
                var rows = ParseCsv(fileUpload.FileContent);
                if (rows == null || rows.Count == 0)
                { ShowError("The CSV file appears to be empty or has no data rows."); return; }

                // Store in session for the generate step
                Session["BulkRows"] = rows;
                Session["BulkDirector"] = txtBulkDirector.Text.Trim();
                Session["BulkDirTitle"] = txtBulkDirectorTitle.Text.Trim();
                Session["BulkCertType"] = ddlCertType.SelectedValue;

                int valid = 0, invalid = 0;
                foreach (var r in rows) { if (r.Status == "Valid") valid++; else invalid++; }

                lblValidCount.Text = valid.ToString();
                lblInvalidCount.Text = invalid.ToString();

                gvPreview.DataSource = rows;
                gvPreview.DataBind();

                pnlUpload.Visible = false;
                pnlPreview.Visible = true;
            }
            catch (Exception ex)
            {
                ShowError("Error reading CSV: " + ex.Message);
            }
        }

        protected void gvPreview_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var row = (PreviewRow)e.Row.DataItem;
                e.Row.CssClass = row.Status == "Valid" ? "row-valid" : "row-invalid";

                // Status column is index 8 (0-based)
                int statusCell = 8;
                if (e.Row.Cells.Count > statusCell)
                {
                    string badge = row.Status == "Valid"
                        ? "<span class='badge-valid'>&#10003; Valid</span>"
                        : "<span class='badge-invalid'>&#10007; Invalid</span>";
                    e.Row.Cells[statusCell].Text = badge;
                }
            }
        }

        protected void btnBackToUpload_Click(object sender, EventArgs e)
        {
            pnlPreview.Visible = false;
            pnlUpload.Visible = true;
        }

        // ── GENERATE ─────────────────────────────────────────────────────────────────

        protected void btnGenerateAll_Click(object sender, EventArgs e)
        {
            var rows = Session["BulkRows"] as List<PreviewRow>;
            if (rows == null) { ShowError("Session expired. Please re-upload the file."); return; }

            string directorName = Session["BulkDirector"]?.ToString() ?? "";
            string directorTitle = Session["BulkDirTitle"]?.ToString() ?? "Director";
            string certType = Session["BulkCertType"]?.ToString() ?? "Participation";

            var toInsert = new List<Certificate>();

            foreach (var row in rows)
            {
                if (row.Status != "Valid") continue;

                // Parse optional fields safely
                DateTime? eventDate = null;
                if (!string.IsNullOrEmpty(row.EventDate) && DateTime.TryParse(row.EventDate, out DateTime ed))
                    eventDate = ed;

                int? totalHours = null;
                if (!string.IsNullOrEmpty(row.TotalHour) && int.TryParse(row.TotalHour, out int th))
                    totalHours = th;

                toInsert.Add(new Certificate
                {
                    CertificateTitle = row.CertificateTitle,   // per-row title from CSV
                    PersonName = row.PersonName,
                    StudentEmail = row.EmailAddress,
                    WorkshopName = row.WorkshopName,
                    IssueDate = DateTime.Parse(row.IssueDate),
                    WorkshopDate = eventDate,
                    TotalHours = totalHours,
                    DirectorName = directorName,
                    DirectorTitle = directorTitle,
                    CertificateType = certType,
                });
            }

            if (toInsert.Count == 0)
            { ShowError("No valid rows to insert. Please fix the errors and re-upload."); return; }

            try
            {
                var ids = data.BulkInsertCertificates(toInsert);
                Session.Remove("BulkRows");
                pnlPreview.Visible = false;
                pnlUpload.Visible = true;
                ShowSuccess($"<strong>{ids.Count} certificates</strong> generated successfully! " +
                            $"<a href='AllCertificates.aspx' style='color:#0f2044; font-weight:600;'>View All Certificates &rarr;</a>");
            }
            catch (Exception ex)
            {
                ShowError("Error generating certificates: " + ex.Message);
            }
        }

        // ── CSV PARSER ───────────────────────────────────────────────────────────────

        private List<PreviewRow> ParseCsv(Stream stream)
        {
            var rows = new List<PreviewRow>();

            using (var reader = new StreamReader(stream, Encoding.UTF8))
            {
                string headerLine = reader.ReadLine();
                if (headerLine == null) return rows;

                string[] headers = SplitCsvLine(headerLine);

                // Map header names to column indexes (case-insensitive)
                int colId = IndexOf(headers, "ID");
                int colTitle = IndexOf(headers, "Certificate Title");
                int colName = IndexOf(headers, "Student Name");
                int colEmail = IndexOf(headers, "Email Address");
                int colDate = IndexOf(headers, "Issue Date");
                int colEvent = IndexOf(headers, "Workshop/Event Name");
                int colEvtDt = IndexOf(headers, "Event Date");
                int colHours = IndexOf(headers, "Total Hour");

                // Minimum required columns
                if (colName < 0 || colDate < 0)
                    throw new Exception("CSV must have at least 'Student Name' and 'Issue Date' columns. " +
                                        "Please download the template and use the correct column names.");

                int rowNum = 0;
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(line)) continue;
                    rowNum++;

                    string[] cells = SplitCsvLine(line);

                    string certTitle = GetCell(cells, colTitle);
                    string name = GetCell(cells, colName);
                    string email = GetCell(cells, colEmail);
                    string date = GetCell(cells, colDate);
                    string eventName = GetCell(cells, colEvent);
                    string eventDate = GetCell(cells, colEvtDt);
                    string totalHour = GetCell(cells, colHours);

                    string status = "Valid";
                    string notes = "";

                    // Validation
                    if (string.IsNullOrEmpty(name))
                    { status = "Invalid"; notes += "Missing Student Name. "; }

                    if (string.IsNullOrEmpty(date))
                    { status = "Invalid"; notes += "Missing Issue Date. "; }
                    else if (!DateTime.TryParse(date, out _))
                    { status = "Invalid"; notes += "Invalid Issue Date format (use M/d/yyyy). "; }

                    if (!string.IsNullOrEmpty(eventDate) && !DateTime.TryParse(eventDate, out _))
                    { status = "Invalid"; notes += "Invalid Event Date format (use M/d/yyyy). "; }

                    if (!string.IsNullOrEmpty(totalHour) && !int.TryParse(totalHour, out _))
                    { status = "Invalid"; notes += "Total Hour must be a number. "; }

                    rows.Add(new PreviewRow
                    {
                        Row = rowNum,
                        CertificateTitle = certTitle,
                        PersonName = name,
                        EmailAddress = email,
                        IssueDate = date,
                        WorkshopName = eventName,
                        EventDate = eventDate,
                        TotalHour = totalHour,
                        Status = status,
                        Notes = notes.Trim()
                    });
                }
            }
            return rows;
        }

        // ── CSV HELPERS ───────────────────────────────────────────────────────────────

        private string[] SplitCsvLine(string line)
        {
            var result = new List<string>();
            bool inQuotes = false;
            var current = new StringBuilder();

            foreach (char c in line)
            {
                if (c == '"') { inQuotes = !inQuotes; }
                else if (c == ',' && !inQuotes) { result.Add(current.ToString().Trim()); current.Clear(); }
                else { current.Append(c); }
            }
            result.Add(current.ToString().Trim());
            return result.ToArray();
        }

        private int IndexOf(string[] arr, string key)
        {
            for (int i = 0; i < arr.Length; i++)
                if (arr[i].Trim().Equals(key, StringComparison.OrdinalIgnoreCase)) return i;
            return -1;
        }

        private string GetCell(string[] cells, int index)
        {
            if (index < 0 || index >= cells.Length) return "";
            return cells[index].Trim().Trim('"');
        }

        // ── UI HELPERS ────────────────────────────────────────────────────────────────

        private void ShowSuccess(string msg) { pnlSuccess.Visible = true; lblSuccess.Text = msg; pnlError.Visible = false; }
        private void ShowError(string msg) { pnlError.Visible = true; lblError.Text = msg; pnlSuccess.Visible = false; }
    }
}
