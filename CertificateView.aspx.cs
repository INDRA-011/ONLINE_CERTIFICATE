using CertifyApp.Data;
using CertifyApp.Models;
using System;
using System.Web.UI;

// ──────────────────────────────────────────────────────────────────────────────
// PDF DOWNLOAD REQUIRES SelectPdf (free tier)
// Install via NuGet Package Manager Console:
//   Install-Package SelectPdf
// Or right-click References → Manage NuGet Packages → search "SelectPdf"
// ──────────────────────────────────────────────────────────────────────────────

namespace CertifyApp
{
    public partial class CertificateView : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        // Exposed so the Edit link can use it in the .aspx
        public int CertificateId { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCertificate();
            }
        }

        private void LoadCertificate()
        {
            Certificate cert = null;

            if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int qsId))
            {
                CertificateId = qsId;
                cert = data.GetCertificateById(qsId);
            }
            else if (Session["CertificateID"] != null)
            {
                int sessionId = Convert.ToInt32(Session["CertificateID"]);
                CertificateId = sessionId;
                cert = data.GetCertificateById(sessionId);
                Session.Remove("CertificateID");
            }
            else
            {
                Response.Redirect("~/AllCertificates.aspx");
                return;
            }

            if (cert != null)
            {
                DisplayCertificate(cert);
                // Wire up the edit link
                btnEditLink.HRef = "CreateCertificate.aspx?edit=" + cert.CertificateID;
            }
            else
            {
                Response.Redirect("~/AllCertificates.aspx");
            }
        }

        private void DisplayCertificate(Certificate cert)
        {
            // Title reflects certificate type
            string titleText = "OF PARTICIPATION";
            switch (cert.CertificateType?.ToLower())
            {
                case "achievement": titleText = "OF ACHIEVEMENT"; break;
                case "academic": titleText = "OF ACADEMIC EXCELLENCE"; break;
                case "completion": titleText = "OF COMPLETION"; break;
                default: titleText = "OF PARTICIPATION"; break;
            }
            lblCertificateTitle.Text = titleText;

            lblPersonName.Text = cert.PersonName?.ToUpper() ?? "STUDENT NAME";
            lblWorkshopName.Text = cert.WorkshopName?.ToUpper() ?? "EVENT NAME";
            lblCompanyName.Text = "Texas College of Management and IT";

            if (cert.WorkshopDate.HasValue)
            {
                DateTime startDate = cert.WorkshopDate.Value;
                DateTime endDate = startDate.AddDays(cert.TotalHours.HasValue ? cert.TotalHours.Value : 12);
                lblWorkshopDate.Text = $"{GetFormattedDateWithSuffix(startDate)} to {endDate:dd MMMM yyyy}";
            }
            else
            {
                lblWorkshopDate.Text = cert.IssueDate.ToString("dd MMMM yyyy");
            }

            lblDirectorName.Text = cert.DirectorName?.ToUpper() ?? "DR. SUMAN THAPALIYA";
            lblDirectorTitle.Text = cert.DirectorTitle ?? "Director";
            lblPrincipalName.Text = "Shyam Sundar Shrestha";
            lblPrincipalTitle.Text = "Principal";

            lblCertificateNumber.Text = cert.CertificateNumber ?? "CERT-" + cert.CertificateID.ToString("D6");
            lblIssueDate.Text = cert.IssueDate != DateTime.MinValue
                ? cert.IssueDate.ToString("dd-MM-yyyy")
                : DateTime.Now.ToString("dd-MM-yyyy");
        }

        // ── PDF DOWNLOAD ──────────────────────────────────────────────────────────────
        protected void btnDownloadPdf_Click(object sender, EventArgs e)
        {
            try
            {
                // Build the URL of this certificate page to render as PDF
                string certId = Request.QueryString["id"] ?? Session["CertificateID"]?.ToString() ?? "0";
                string pageUrl = Request.Url.GetLeftPart(UriPartial.Authority)
                               + Request.ApplicationPath.TrimEnd('/')
                               + "/CertificateView.aspx?id=" + certId + "&pdf=1";

                // ── SelectPdf ────────────────────────────────────────────────────────
                var converter = new SelectPdf.HtmlToPdf();

                converter.Options.PdfPageSize = SelectPdf.PdfPageSize.A4;
                converter.Options.PdfPageOrientation = SelectPdf.PdfPageOrientation.Landscape;
                converter.Options.MarginTop = 10;
                converter.Options.MarginBottom = 10;
                converter.Options.MarginLeft = 10;
                converter.Options.MarginRight = 10;
                converter.Options.DisplayHeader = false;
                converter.Options.DisplayFooter = false;

                SelectPdf.PdfDocument doc = converter.ConvertUrl(pageUrl);

                byte[] pdfBytes = doc.Save();
                doc.Close();

                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", $"attachment; filename=Certificate_{certId}.pdf");
                Response.AddHeader("Content-Length", pdfBytes.Length.ToString());
                Response.BinaryWrite(pdfBytes);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                // SelectPdf not installed yet — show friendly message
                string msg = ex.Message.Contains("SelectPdf") || ex.Message.Contains("namespace")
                    ? "PDF library not installed. Run: Install-Package SelectPdf in NuGet Package Manager Console."
                    : "PDF generation error: " + ex.Message;

                ScriptManager.RegisterStartupScript(this, GetType(), "pdfErr",
                    $"alert('{msg.Replace("'", "\\'")}');", true);
            }
        }

        private string GetFormattedDateWithSuffix(DateTime date)
        {
            int day = date.Day;
            string suffix;
            if (day >= 11 && day <= 13) suffix = "th";
            else switch (day % 10)
                {
                    case 1: suffix = "st"; break;
                    case 2: suffix = "nd"; break;
                    case 3: suffix = "rd"; break;
                    default: suffix = "th"; break;
                }
            return $"{day}{suffix} {date:MMMM yyyy}";
        }
    }
}
