using System;
using System.Web.UI;
using CertifyApp.Models;
using CertifyApp.Data;

namespace CertifyApp
{
    public partial class CertificateDetails : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCertificateDetails();
            }
        }

        private void LoadCertificateDetails()
        {
            if (Request.QueryString["id"] != null)
            {
                int certificateId = Convert.ToInt32(Request.QueryString["id"]);
                Certificate cert = data.GetCertificateById(certificateId);

                if (cert != null)
                {
                    DisplayCertificateDetails(cert);
                }
                else
                {
                    ShowError("Certificate not found.");
                }
            }
        }

        private void DisplayCertificateDetails(Certificate cert)
        {
            // Preview section
            lblCertificateTitle.Text = cert.CertificateTitle;
            lblPersonName.Text = cert.PersonName;
            lblWorkshopName.Text = string.IsNullOrEmpty(cert.WorkshopName) ? "Not specified" : cert.WorkshopName;

            // Workshop Date
            if (cert.WorkshopDate.HasValue)
            {
                pnlWorkshopDate.Visible = true;
                lblWorkshopDate.Text = cert.WorkshopDate.Value.ToString("dd MMMM yyyy");
            }
            else
            {
                pnlWorkshopDate.Visible = false;
            }

            // Total Hours
            if (cert.TotalHours.HasValue)
            {
                pnlTotalHours.Visible = true;
                lblTotalHours.Text = cert.TotalHours.Value.ToString();
            }
            else
            {
                pnlTotalHours.Visible = false;
            }

            lblIssueDate.Text = cert.IssueDate.ToString("dd MMMM yyyy");
            lblDirectorName.Text = string.IsNullOrEmpty(cert.DirectorName) ? "Not specified" : cert.DirectorName;
            lblDirectorTitle.Text = string.IsNullOrEmpty(cert.DirectorTitle) ? "Not specified" : cert.DirectorTitle;

            // Details section
            lblCertificateID.Text = cert.CertificateID.ToString();
            lblDetailCertificateTitle.Text = cert.CertificateTitle;
            lblDetailPersonName.Text = cert.PersonName;
            lblDetailIssueDate.Text = cert.IssueDate.ToString("dd MMMM yyyy");
            lblDetailWorkshopName.Text = string.IsNullOrEmpty(cert.WorkshopName) ? "Not specified" : cert.WorkshopName;
            lblDetailWorkshopDate.Text = cert.WorkshopDate?.ToString("dd MMMM yyyy") ?? "Not specified";
            lblDetailTotalHours.Text = cert.TotalHours?.ToString() ?? "Not specified";
            lblDetailDirectorName.Text = string.IsNullOrEmpty(cert.DirectorName) ? "Not specified" : cert.DirectorName;
            lblDetailDirectorTitle.Text = string.IsNullOrEmpty(cert.DirectorTitle) ? "Not specified" : cert.DirectorTitle;
            lblDetailCreatedDate.Text = cert.CreatedDate?.ToString("dd MMMM yyyy HH:mm") ?? "Not available";
            lblDetailCertNumber.Text = cert.CertificateNumber ?? "Not Generated";

            // Certificate Number in preview
            lblCertNumber.Text = cert.CertificateNumber ?? "Not Generated";

            // Set page title
            Page.Title = $"Certificate Details - {cert.CertificateNumber ?? cert.CertificateTitle}";

            // Show the panel
            pnlCertificateDetails.Visible = true;
        }

        private void ShowError(string message)
        {
            // Check if controls exist before using them
            if (pnlError != null)
            {
                pnlError.Visible = true;
            }

            if (lblError != null)
            {
                lblError.Text = message;
            }

            if (pnlCertificateDetails != null)
            {
                pnlCertificateDetails.Visible = false;
            }
        }

        // Remove this duplicate ShowError method - keep only one

        protected void btnGeneratePDF_Click(object sender, EventArgs e)
        {
            try
            {
                string certificateId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(certificateId))
                {
                    // Store certificate ID in session and redirect to certificate view
                    Session["CertificateID"] = Convert.ToInt32(certificateId);
                    Response.Redirect("CertificateView.aspx");
                }
                else
                {
                    ShowError("Unable to generate PDF: Certificate ID is missing.");
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error generating PDF: {ex.Message}");
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Certificates.aspx");
        }

        // If you need these methods, make sure the controls exist in your .aspx file
        // Otherwise, you can remove them
        private void PopulatePreview(Certificate cert)
        {
            // Check if controls exist before using them
            if (lblCertificateTitle != null)
                lblCertificateTitle.Text = cert.CertificateTitle;

            if (lblPersonName != null)
                lblPersonName.Text = cert.PersonName;

            if (lblWorkshopName != null)
                lblWorkshopName.Text = string.IsNullOrEmpty(cert.WorkshopName) ? "N/A" : cert.WorkshopName;

            // Handle optional WorkshopDate field
            if (pnlWorkshopDate != null)
            {
                if (cert.WorkshopDate.HasValue)
                {
                    pnlWorkshopDate.Visible = true;
                    if (lblWorkshopDate != null)
                        lblWorkshopDate.Text = cert.WorkshopDate.Value.ToString("dd MMMM yyyy");
                }
                else
                {
                    pnlWorkshopDate.Visible = false;
                }
            }

            if (pnlTotalHours != null)
            {
                if (cert.TotalHours.HasValue)
                {
                    pnlTotalHours.Visible = true;
                    if (lblTotalHours != null)
                        lblTotalHours.Text = cert.TotalHours.Value.ToString();
                }
                else
                {
                    pnlTotalHours.Visible = false;
                }
            }

            if (lblIssueDate != null)
                lblIssueDate.Text = cert.IssueDate.ToString("dd MMMM yyyy");

            if (lblDirectorName != null)
                lblDirectorName.Text = string.IsNullOrEmpty(cert.DirectorName) ? "N/A" : cert.DirectorName;

            if (lblDirectorTitle != null)
                lblDirectorTitle.Text = string.IsNullOrEmpty(cert.DirectorTitle) ? "N/A" : cert.DirectorTitle;
        }

        private void PopulateDetails(Certificate cert)
        {
            // Detailed information section
            if (lblCertificateID != null)
                lblCertificateID.Text = cert.CertificateID.ToString();

            if (lblDetailCertificateTitle != null)
                lblDetailCertificateTitle.Text = cert.CertificateTitle;

            if (lblDetailPersonName != null)
                lblDetailPersonName.Text = cert.PersonName;

            if (lblDetailIssueDate != null)
                lblDetailIssueDate.Text = cert.IssueDate.ToString("dd MMMM yyyy");

            if (lblDetailWorkshopName != null)
                lblDetailWorkshopName.Text = string.IsNullOrEmpty(cert.WorkshopName) ? "Not specified" : cert.WorkshopName;

            // Handle WorkshopDate as DateTime?
            if (lblDetailWorkshopDate != null)
            {
                lblDetailWorkshopDate.Text = cert.WorkshopDate.HasValue
                    ? cert.WorkshopDate.Value.ToString("dd MMMM yyyy")
                    : "Not specified";
            }

            if (lblDetailTotalHours != null)
            {
                lblDetailTotalHours.Text = cert.TotalHours.HasValue
                    ? cert.TotalHours.Value.ToString()
                    : "Not specified";
            }

            if (lblDetailDirectorName != null)
                lblDetailDirectorName.Text = string.IsNullOrEmpty(cert.DirectorName) ? "Not specified" : cert.DirectorName;

            if (lblDetailDirectorTitle != null)
                lblDetailDirectorTitle.Text = string.IsNullOrEmpty(cert.DirectorTitle) ? "Not specified" : cert.DirectorTitle;
        }
    }
}