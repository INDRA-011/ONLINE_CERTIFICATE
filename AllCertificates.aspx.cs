using CertifyApp.Data;
using CertifyApp.Models;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Mail;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CertifyApp
{
    public partial class AllCertificates : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Admin"] == null) { Response.Redirect("~/Login.aspx"); return; }

            if (!IsPostBack)
            {
                // Pre-fill type filter from query string (e.g. ?type=Academic from sidebar)
                if (Request.QueryString["type"] != null)
                    ddlFilterType.SelectedValue = Request.QueryString["type"];

                LoadBatches();
                LoadCertificates();
            }
        }

        private void LoadBatches()
        {
            ddlFilterBatch.Items.Clear();
            ddlFilterBatch.Items.Add(new ListItem("All Batches", ""));
            foreach (string batch in data.GetDistinctBatches())
                ddlFilterBatch.Items.Add(new ListItem(batch, batch));
        }

        private void LoadCertificates()
        {
            string type = ddlFilterType.SelectedValue;
            string batch = ddlFilterBatch.SelectedValue;
            DateTime? from = DateTime.TryParse(txtFromDate.Text, out var fd) ? fd : (DateTime?)null;
            DateTime? to = DateTime.TryParse(txtToDate.Text, out var td) ? td : (DateTime?)null;

            var certs = data.GetAllCertificates(
                string.IsNullOrEmpty(type) ? null : type,
                string.IsNullOrEmpty(batch) ? null : batch,
                from, to);

            lblCount.Text = certs.Count.ToString();

            int totalPages = (int)Math.Ceiling((double)certs.Count / gvCertificates.PageSize);
            if (totalPages < 1) totalPages = 1;

            lblCurrentPage.Text = (gvCertificates.PageIndex + 1).ToString();
            lblTotalPages.Text = totalPages.ToString();

            btnPrev.Enabled = gvCertificates.PageIndex > 0;
            btnNext.Enabled = gvCertificates.PageIndex < totalPages - 1;

            gvCertificates.DataSource = certs;
            gvCertificates.DataBind();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvCertificates.PageIndex = 0;
            LoadCertificates();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlFilterType.SelectedIndex = 0;
            ddlFilterBatch.SelectedIndex = 0;
            txtFromDate.Text = "";
            txtToDate.Text = "";
            gvCertificates.PageIndex = 0;
            LoadCertificates();
        }

        protected void gvCertificates_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCertificates.PageIndex = e.NewPageIndex;
            LoadCertificates();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (gvCertificates.PageIndex > 0)
            {
                gvCertificates.PageIndex--;
                LoadCertificates();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            gvCertificates.PageIndex++;
            LoadCertificates();
        }

        protected void gvCertificates_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SendEmail")
            {
                ViewState["EmailCertID"] = e.CommandArgument.ToString();

                // Pre-fill email from DB if available
                if (int.TryParse(e.CommandArgument.ToString(), out int cid))
                {
                    var cert = data.GetCertificateById(cid);
                    if (cert != null && !string.IsNullOrEmpty(cert.StudentEmail))
                        txtEmailAddress.Text = cert.StudentEmail;
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "openModal",
                    "new bootstrap.Modal(document.getElementById('emailModal')).show();", true);
            }
            else if (e.CommandName == "DeleteCert")
            {
                if (int.TryParse(e.CommandArgument.ToString(), out int deleteId))
                {
                    bool deleted = data.DeleteCertificate(deleteId);
                    if (deleted)
                        ShowSuccess("Certificate deleted successfully.");
                    else
                        ShowError("Failed to delete certificate.");
                    LoadCertificates();
                }
            }
        }

        protected void btnSendEmailNow_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(ViewState["EmailCertID"]?.ToString(), out int certId))
                { ShowError("Invalid certificate."); return; }

                string email = txtEmailAddress.Text.Trim();
                if (string.IsNullOrEmpty(email))
                { ShowError("Please enter a valid email address."); return; }

                string link = Request.Url.GetLeftPart(UriPartial.Authority) + "/CertificateView.aspx?id=" + certId;

                var mail = new MailMessage();
                mail.From = new MailAddress("ecertificatefortexascollege@gmail.com");
                mail.To.Add(email);
                mail.Subject = "Your Certificate from Texas College";
                mail.Body = $"Hello,\n\nYour certificate is ready. You can view and download it here:\n\n{link}\n\nBest regards,\nTexas College of Management & IT";

                var smtp = new SmtpClient("smtp.gmail.com", 587)
                {
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential("ecertificatefortexascollege@gmail.com", "njcl ksjc vjvg wwhi")
                };

                smtp.Send(mail);
                ShowSuccess($"Email sent successfully to {email}.");
            }
            catch (Exception ex)
            {
                ShowError("Email error: " + ex.Message);
            }
        }

        private void ShowSuccess(string msg) { pnlSuccess.Visible = true; lblSuccess.Text = msg; pnlError.Visible = false; }
        private void ShowError(string msg) { pnlError.Visible = true; lblError.Text = msg; pnlSuccess.Visible = false; }
    }
}
