using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

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
        public string CertificateType { get; set; }
    }
}