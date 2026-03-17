using System;
using System.Data.SqlClient;

namespace CertifyApp
{
    public partial class Login : System.Web.UI.Page
    {

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connString = "Data Source=WIN-Q4SG2FUL6SE\\SQLEXPRESS;Initial Catalog=online_certificate_db;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                string query = "SELECT COUNT(*) FROM AdminLogin WHERE Username=@Username AND Password=@Password";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", txtUsername.Text);
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                int result = (int)cmd.ExecuteScalar();

                if (result > 0)
                {
                    Session["Admin"] = txtUsername.Text;
                    Response.Redirect("Default.aspx");
                }
                else
                {
                    lblMessage.Text = "Invalid login";
                }
            }
        }
    }
}