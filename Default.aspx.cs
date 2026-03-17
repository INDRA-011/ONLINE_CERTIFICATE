using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CertifyApp.Models;
using CertifyApp.Data;
using System.Net.Mail;
using System.Net;

namespace CertifyApp
{
    public partial class Default : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Admin"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCertificates();
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
                        TotalHours = string.IsNullOrEmpty(txtTotalHours.Text) ? (int?)null : int.Parse(txtTotalHours.Text),
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
            else if (e.CommandName == "SendEmail")
            {
                ViewState["CertID"] = e.CommandArgument.ToString();
                ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "openModal",
                    "var modal = new bootstrap.Modal(document.getElementById('emailModal')); modal.show();",
                    true
                );
            }
        }

        protected void btnSendEmailNow_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(ViewState["CertID"]?.ToString(), out int certificateId))
                {
                    ShowError("Invalid certificate selected. Please try again.");
                    return;
                }

                string email = txtStudentEmail.Text.Trim(); 
                if (string.IsNullOrEmpty(email)) 
                { ShowError("Please enter a valid email address.", true);
                return; }

                string link = Request.Url.GetLeftPart(UriPartial.Authority) + "/CertificateView.aspx?id=" + certificateId;

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("ecertificatefortexascollege@gmail.com");
                mail.To.Add(email);
                mail.Subject = "Your Certificate";
                mail.Body = "Hello,\n\nYour certificate is ready.\n\nView it here:\n" + link;
                mail.IsBodyHtml = false;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587)
                {
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential("ecertificatefortexascollege@gmail.com", "njcl ksjc vjvg wwhi") // <-- App password
                };

                smtp.Send(mail);
                ShowSuccess("Email sent successfully.", true); // temporary
            }
            catch (SmtpException smtpEx)
            {
                ShowError("SMTP Error: " + smtpEx.Message, true);
            }
            catch (Exception ex)
            {
                ShowError("Email sending failed: " + ex.Message, true);
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
            lblSuccess.Text = "Certificates loaded: " + certificates.Count;
            pnlSuccess.Visible = true;

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
            txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtWorkshopName.Text = "Sci-Research Workshop";
            txtWorkshopDate.Text = "02-04 April 2025";
            txtTotalHours.Text = "12";
            txtDirectorName.Text = "DR. Suman Thapaliya";
            txtDirectorTitle.Text = "Director";
        }

        private void ShowSuccess(string message, bool isTemporary = false)
        {
            pnlSuccess.Visible = true;
            lblSuccess.Text = message;
            pnlError.Visible = false;

            if (isTemporary)
            {
                string defaultMessage = $"Certificates loaded: {data.GetAllCertificates().Count}";
                string script = $"showTemporaryMessage('{pnlSuccess.ClientID}', '{defaultMessage}');";
                ScriptManager.RegisterStartupScript(this, GetType(), "expireSuccess", script, true);
            }
        }

        private void ShowError(string message, bool isTemporary = false)
        {
            pnlError.Visible = true;
            lblError.Text = message;
            pnlSuccess.Visible = false;

            if (isTemporary)
            {
                string defaultMessage = $"Certificates loaded: {data.GetAllCertificates().Count}";
                string script = $"showTemporaryMessage('{pnlError.ClientID}', '{defaultMessage}');";
                ScriptManager.RegisterStartupScript(this, GetType(), "expireError", script, true);
            }
        }

        private void GenerateCertificate(int certificateId)
        {
            Session["CertificateID"] = certificateId;
            Response.Redirect("CertificateView.aspx");
        }
    }
}