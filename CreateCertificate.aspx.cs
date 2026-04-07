using System;
using System.Web.UI;
using CertifyApp.Models;
using CertifyApp.Data;
using System.Web.UI.WebControls;

namespace CertifyApp
{
    public partial class CreateCertificate : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        private bool IsEditMode => hfCertificateId.Value != "0" && hfCertificateId.Value != "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Admin"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Pre-set today's date
                txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Check if we're in edit mode (edit?id=XX)
                if (Request.QueryString["edit"] != null && int.TryParse(Request.QueryString["edit"], out int editId))
                {
                    LoadForEdit(editId);
                }
            }
        }

        private void LoadForEdit(int certId)
        {
            Certificate cert = data.GetCertificateById(certId);
            if (cert == null)
            {
                ShowError("Certificate not found.");
                return;
            }

            // Switch page to edit mode
            hfCertificateId.Value = certId.ToString();
            hfCertType.Value = cert.CertificateType ?? "Participation";

            txtCertificateTitle.Text = cert.CertificateTitle;
            txtPersonName.Text = cert.PersonName;
            txtStudentEmail.Text = cert.StudentEmail;
            txtIssueDate.Text = cert.IssueDate.ToString("yyyy-MM-dd");
            txtWorkshopName.Text = cert.WorkshopName;
            txtWorkshopDate.Text = cert.WorkshopDate.HasValue ? cert.WorkshopDate.Value.ToString("dd-MM-yyyy") : "";
            txtTotalHours.Text = cert.TotalHours.HasValue ? cert.TotalHours.Value.ToString() : "12";
            txtDirectorName.Text = cert.DirectorName;
            txtDirectorTitle.Text = cert.DirectorTitle;
            txtStudentBatch.Text = cert.StudentBatch;

            lblPageTitle.Text = "Edit Certificate";
            lblPageBreadcrumb.Text = "Edit Certificate";
            btnSave.Text = "Update Certificate";
            pnlEditBadge.Visible = true;
            pnlCancelEdit.Visible = true;
            lblEditCertNumber.Text = cert.CertificateNumber ?? $"ID {cert.CertificateID}";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                DateTime issueDate = DateTime.Parse(txtIssueDate.Text);
                string certType = hfCertType.Value;
                if (string.IsNullOrEmpty(certType)) certType = "Participation";

                Certificate cert = new Certificate
                {
                    CertificateTitle = txtCertificateTitle.Text.Trim(),
                    PersonName = txtPersonName.Text.Trim(),
                    StudentEmail = txtStudentEmail.Text.Trim(),
                    IssueDate = issueDate,
                    WorkshopName = txtWorkshopName.Text.Trim(),
                    WorkshopDate = DateTime.TryParse(txtWorkshopDate.Text.Trim(), out var wDate) ? wDate : (DateTime?)null,
                    TotalHours = string.IsNullOrEmpty(txtTotalHours.Text) ? (int?)null : int.Parse(txtTotalHours.Text),
                    DirectorName = txtDirectorName.Text.Trim(),
                    DirectorTitle = txtDirectorTitle.Text.Trim(),
                    CertificateType = certType,
                    StudentBatch = certType == "Academic" ? txtStudentBatch.Text.Trim() : null
                };

                if (IsEditMode)
                {
                    // UPDATE
                    cert.CertificateID = int.Parse(hfCertificateId.Value);
                    bool updated = data.UpdateCertificate(cert);
                    if (updated)
                        ShowSuccess($"Certificate updated successfully! <a href='CertificateView.aspx?id={cert.CertificateID}' style='color:#0f2044; font-weight:600;'>View Certificate →</a>");
                    else
                        ShowError("Failed to update certificate.");
                }
                else
                {
                    // INSERT
                    int newId = data.InsertCertificate(cert);
                    if (newId > 0)
                    {
                        string certNumber = $"CERT-{issueDate:yyyyMMdd}-{newId:D4}";
                        data.UpdateCertificateNumber(newId, certNumber);
                        ShowSuccess($"Certificate <strong>{certNumber}</strong> created successfully! <a href='CertificateView.aspx?id={newId}' style='color:#0f2044; font-weight:600;'>View Certificate →</a>");
                        ClearForm();
                    }
                    else
                    {
                        ShowError("Failed to save certificate.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error: {ex.Message}");
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AllCertificates.aspx");
        }

        private void ClearForm()
        {
            txtCertificateTitle.Text = "";
            txtPersonName.Text = "";
            txtStudentEmail.Text = "";
            txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtWorkshopName.Text = "";
            txtWorkshopDate.Text = "";
            txtTotalHours.Text = "12";
            txtDirectorName.Text = "";
            txtDirectorTitle.Text = "Director";
            txtStudentBatch.Text = "";
            hfCertificateId.Value = "0";
            hfCertType.Value = "Participation";
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
    }
}
