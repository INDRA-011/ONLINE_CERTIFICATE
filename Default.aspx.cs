using System;
using System.Web.UI;
using CertifyApp.Data;

namespace CertifyApp
{
    public partial class Default : System.Web.UI.Page
    {
        private CertificateData data = new CertificateData();

        // Properties used by JS in the view
        public int TotalCount { get; private set; }
        public int ParticipationCount { get; private set; }
        public int AchievementCount { get; private set; }
        public int AcademicCount { get; private set; }
        public int CompletionCount { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Admin"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadRecentCertificates();
            }
        }

        private void LoadStats()
        {
            TotalCount = data.GetTotalCount();
            int todayCount = data.GetTodayCount();
            ParticipationCount = data.GetCountByType("Participation");
            AchievementCount = data.GetCountByType("Achievement");
            AcademicCount = data.GetCountByType("Academic");
            CompletionCount = data.GetCountByType("Completion");

            lblTotal.Text = TotalCount.ToString();
            lblToday.Text = todayCount.ToString();
            lblParticipation.Text = ParticipationCount.ToString();
            lblAcademic.Text = AcademicCount.ToString();

            lblBarParticipation.Text = ParticipationCount.ToString();
            lblBarAchievement.Text = AchievementCount.ToString();
            lblBarAcademic.Text = AcademicCount.ToString();
            lblBarCompletion.Text = CompletionCount.ToString();
        }

        private void LoadRecentCertificates()
        {
            // Load latest 8 for the dashboard table
            var all = data.GetAllCertificates();
            var recent = all.Count > 8 ? all.GetRange(0, 8) : all;

            gvRecent.DataSource = recent;
            gvRecent.DataBind();
        }
    }
}
