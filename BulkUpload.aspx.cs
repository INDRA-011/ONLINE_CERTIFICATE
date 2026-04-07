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

        // Preview row model
        public class PreviewRow
        {
            public int Row { get; set; }
            public string PersonName { get; set; }
            public string StudentEmail { get; set; }
            public string WorkshopName { get; set; }
            public string IssueDate { get; set; }
            public string StudentBatch { get; set; }
            public string Status { get; set; }  // "Valid" or "Invalid"
            public string Notes { get; set; }  // error detail
        }

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
            Response.Write("PersonName,StudentEmail,WorkshopName,IssueDate,StudentBatch\r\n");
            Response.Write("John Doe,john@example.com,Sci-Research Workshop,2025-07-15,2024-2025\r\n");
            Response.Write("Jane Smith,jane@example.com,DevOps Bootcamp,2025-07-15,\r\n");
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

                // Store parsed rows in session for the generate step
                Session["BulkRows"] = rows;
                Session["BulkTitle"] = txtBulkTitle.Text.Trim();
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

                // Style the Status cell
                int statusCell = 6;
                if (e.Row.Cells.Count > statusCell)
                {
                    string badge = row.Status == "Valid"
                        ? "<span class='badge-valid'>✓ Valid</span>"
                        : "<span class='badge-invalid'>✗ Invalid</span>";
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

            string certTitle = Session["BulkTitle"]?.ToString() ?? "Certificate of Participation";
            string directorName = Session["BulkDirector"]?.ToString() ?? "";
            string directorTitle = Session["BulkDirTitle"]?.ToString() ?? "Director";
            string certType = Session["BulkCertType"]?.ToString() ?? "Participation";

            var toInsert = new List<Certificate>();
            foreach (var row in rows)
            {
                if (row.Status != "Valid") continue;

                toInsert.Add(new Certificate
                {
                    CertificateTitle = certTitle,
                    PersonName = row.PersonName,
                    StudentEmail = row.StudentEmail,
                    WorkshopName = row.WorkshopName,
                    IssueDate = DateTime.Parse(row.IssueDate),
                    StudentBatch = row.StudentBatch,
                    DirectorName = directorName,
                    DirectorTitle = directorTitle,
                    CertificateType = certType,
                    TotalHours = 12
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
                            $"<a href='AllCertificates.aspx' style='color:#0f2044; font-weight:600;'>View All Certificates →</a>");
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

                // Map column positions from header
                string[] headers = SplitCsvLine(headerLine);
                int colName = IndexOf(headers, "PersonName");
                int colEmail = IndexOf(headers, "StudentEmail");
                int colEvent = IndexOf(headers, "WorkshopName");
                int colDate = IndexOf(headers, "IssueDate");
                int colBatch = IndexOf(headers, "StudentBatch");

                if (colName < 0 || colDate < 0)
                    throw new Exception("CSV must have at least 'PersonName' and 'IssueDate' columns.");

                int rowNum = 0;
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(line)) continue;
                    rowNum++;

                    string[] cells = SplitCsvLine(line);

                    string name = GetCell(cells, colName);
                    string email = GetCell(cells, colEmail);
                    string evt = GetCell(cells, colEvent);
                    string date = GetCell(cells, colDate);
                    string batch = GetCell(cells, colBatch);

                    string status = "Valid";
                    string notes = "";

                    if (string.IsNullOrEmpty(name))
                    { status = "Invalid"; notes += "Missing PersonName. "; }

                    if (!string.IsNullOrEmpty(date) && !DateTime.TryParse(date, out _))
                    { status = "Invalid"; notes += "Invalid IssueDate (use yyyy-MM-dd). "; }

                    if (string.IsNullOrEmpty(date))
                    { status = "Invalid"; notes += "Missing IssueDate. "; }

                    rows.Add(new PreviewRow
                    {
                        Row = rowNum,
                        PersonName = name,
                        StudentEmail = email,
                        WorkshopName = evt,
                        IssueDate = date,
                        StudentBatch = batch,
                        Status = status,
                        Notes = notes.Trim()
                    });
                }
            }
            return rows;
        }

        private string[] SplitCsvLine(string line)
        {
            // Simple CSV split (handles quoted fields)
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

        // ── HELPERS ──────────────────────────────────────────────────────────────────

        private void ShowSuccess(string msg) { pnlSuccess.Visible = true; lblSuccess.Text = msg; pnlError.Visible = false; }
        private void ShowError(string msg) { pnlError.Visible = true; lblError.Text = msg; pnlSuccess.Visible = false; }
    }
}
