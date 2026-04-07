using System;
using System.Web.UI;

namespace CertifyApp
{
    public partial class Home : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if session expired
            if (Session["Admin"] == null && !Request.Url.AbsolutePath.ToLower().Contains("login"))
            {
                Response.Redirect("~/Login.aspx");
            }
        }

        protected void btnNavbarLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
