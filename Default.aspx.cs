using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CertifyApp.Models;
using CertifyApp.Data;

namespace CertifyApp
{
    public partial class Default : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCertificates();


                txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtWorkshopDate.Text = "02-04 April 2025";
                txtTotalHours.Text = "12";
                txtWorkshopName.Text = "Sci-Research Workshop";
                txtDirectorName.Text = "DR. Suman Thapaliya";
                txtDirectorTitle.Text = "Director";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    DateTime issueDate = DateTime.Parse(txtIssueDate.Text);

                    Certificate cert = new Certificate
                    {
                        CertificateTitle = txtCertificateTitle.Text.Trim(),
                        PersonName = txtPersonName.Text.Trim(),
                        IssueDate = issueDate,
                        WorkshopName = txtWorkshopName.Text.Trim(),
                        WorkshopDate = DateTime.TryParse(txtWorkshopDate.Text.Trim(), out var workshopDate)
                            ? workshopDate
                            : (DateTime?)null,
                        TotalHours = string.IsNullOrEmpty(txtTotalHours.Text)
                            ? (int?)null
                            : int.Parse(txtTotalHours.Text),
                        DirectorName = txtDirectorName.Text.Trim(),
                        DirectorTitle = txtDirectorTitle.Text.Trim()
                    };

                    

                    int newId = data.InsertCertificate(cert);

                    if (newId > 0)
                    {
                        string certNumber = GenerateCertificateNumber(newId, issueDate);
                        data.UpdateCertificateNumber(newId, certNumber);

                        ShowSuccess($"Certificate saved successfully! Certificate Number: {certNumber}");
                        LoadCertificates();
                        ClearForm();
                    }
                    else
                    {
                        ShowError("Failed to save certificate.");
                    }
                }
                catch (Exception ex)
                {
                    ShowError($"Error saving certificate: {ex.Message}");
                }
            }
        }



        protected void gvCertificates_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewCertificate")
            {
                int certificateId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"CertificateDetails.aspx?id={certificateId}");
            }
            else if (e.CommandName == "GenerateCertificate")
            {
                int certificateId = Convert.ToInt32(e.CommandArgument);
                GenerateCertificate(certificateId);
            }
        }

        protected void gvCertificates_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCertificates.PageIndex = e.NewPageIndex;
            LoadCertificates();
        }

        private void LoadCertificates()
        {
            var certificates = data.GetAllCertificates();


            foreach (var cert in certificates)
            {
                if (string.IsNullOrEmpty(cert.CertificateNumber))
                {
                    cert.CertificateNumber = GenerateCertificateNumber(cert.CertificateID, cert.IssueDate);
                }
            }

            gvCertificates.DataSource = certificates;
            gvCertificates.DataBind();
        }

        private string GenerateCertificateNumber(int certificateId, DateTime issueDate)
        {

            return $"CERT-{issueDate:yyyyMMdd}-{certificateId:D4}";


        }

        private void ClearForm()
        {
            txtCertificateTitle.Text = "";
            txtPersonName.Text = "";
            // IDNumber field removed
            txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtWorkshopName.Text = "Sci-Research Workshop";
            txtWorkshopDate.Text = "02-04 April 2025";
            txtTotalHours.Text = "12";
            txtDirectorName.Text = "DR. Suman Thapaliya";
            txtDirectorTitle.Text = "Director";
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            lblSuccess.Text = message;
            pnlError.Visible = false;
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
            pnlSuccess.Visible = false;
        }

        private void GenerateCertificate(int certificateId)
        {
            Session["CertificateID"] = certificateId;
            Response.Redirect("CertificateView.aspx");
        }
    }
}