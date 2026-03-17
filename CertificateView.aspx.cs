using CertifyApp.Data;
using CertifyApp.Models;
using System;
using System.Web.UI;

namespace CertifyApp
{
    public partial class CertificateView : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

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

           
            if (Session["CertificateID"] != null)
            {
                int certId = Convert.ToInt32(Session["CertificateID"]);
                cert = data.GetCertificateById(certId);
            }
            else if (Request.QueryString["id"] != null)
            {
                int certId = Convert.ToInt32(Request.QueryString["id"]);
                cert = data.GetCertificateById(certId);
            }
            else
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (cert != null)
            {
                DisplayCertificate(cert);

                
                Session.Remove("CertificateID");
            }
            else
            {
                
                string errorScript = @"
                    <script>
                        alert('Certificate not found! Redirecting to form.');
                        window.location='Default.aspx';
                    </script>";
                Response.Write(errorScript);
            }
        }

        private void DisplayCertificate(Certificate cert)
        {
           
            lblCertificateTitle.Text = "OF PARTICIPATION";

           
            lblPersonName.Text = cert.PersonName?.ToUpper() ?? "JOHN DOE";

            
            lblWorkshopName.Text = cert.WorkshopName?.ToUpper() ?? "DEVOPS";

          
            lblCompanyName.Text = "Texas College of Management and IT";

           
            if (cert.WorkshopDate.HasValue)
            {
                DateTime startDate = cert.WorkshopDate.Value;
                
                DateTime endDate = startDate.AddDays(12);

                string startDateFormatted = GetFormattedDateWithSuffix(startDate);
                string endDateFormatted = endDate.ToString("dd MMMM yyyy");

                lblWorkshopDate.Text = $"{startDateFormatted} to {endDateFormatted}";
            }
            else
            {
                lblWorkshopDate.Text = "13th July 2025 to 25 July 2025";
            }

            
            lblDirectorName.Text = cert.DirectorName?.ToUpper() ?? "DR. SUMAN THAPALIYA";

            
            lblDirectorTitle.Text = cert.DirectorTitle ?? "Director of IT";

            lblPrincipalName.Text = "Shyam Sundar Shrestha";

            lblPrincipalTitle.Text = "Principal";


            lblCertificateNumber.Text = cert.CertificateNumber ?? "CERT-" + cert.CertificateID.ToString("D6");


            lblIssueDate.Text = cert.IssueDate != DateTime.MinValue
    ? cert.IssueDate.ToString("dd-MM-yyyy")
    : DateTime.Now.ToString("dd-MM-yyyy");


        }

        private string GetFormattedDateWithSuffix(DateTime date)
        {
            int day = date.Day;
            string suffix;

            if (day >= 11 && day <= 13)
            {
                suffix = "th";
            }
            else
            {
                switch (day % 10)
                {
                    case 1:
                        suffix = "st";
                        break;
                    case 2:
                        suffix = "nd";
                        break;
                    case 3:
                        suffix = "rd";
                        break;
                    default:
                        suffix = "th";
                        break;
                }
            }

            return $"{day}{suffix} {date:MMMM yyyy}";
        }
    }
}