using System;

namespace CertifyApp.Models
{
    public class Certificate
    {
        public int CertificateID { get; set; }
        public string CertificateNumber { get; set; }
        public string CertificateTitle { get; set; }
        public string PersonName { get; set; }
        public DateTime IssueDate { get; set; }
        public string WorkshopName { get; set; }
        public DateTime? WorkshopDate { get; set; }
        public int? TotalHours { get; set; }
        public string DirectorName { get; set; }
        public string DirectorTitle { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CertificateType { get; set; }  // Participation, Achievement, Academic, Completion
        public string StudentEmail { get; set; }      // NEW
        public string StudentBatch { get; set; }      // NEW e.g. "2024-2025"
    }
}
