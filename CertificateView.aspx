<%@ Page Title="" Language="C#" MasterPageFile="~/Blank.Master" AutoEventWireup="true" CodeBehind="CertificateView.aspx.cs" Inherits="CertifyApp.CertificateView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

  

       
        
        <!-- Navigation Buttons (Outside Certificate) -->
        <a href="Default.aspx" class="btn btn-back">
            <i class="fas fa-arrow-left"></i> Back to Form
        </a>
        
        <div class="action-buttons">
            <button type="button" class="btn btn-print" onclick="window.print()">
                <i class="fas fa-print"></i> Print Certificate
            </button>
        </div>
        
        <!-- Certificate Container -->

        <div class="certificate-container">
            <div class="certificate">
                <!-- Certificate Header -->
                <div class="certificate-header">
                    <div class="main-title">CERTIFICATE</div>
                </div>
                
                <!-- OF PARTICIPATION Badge -->
                <div class="certificate-badge">
                    <asp:Label ID="lblCertificateTitle" runat="server" Text="OF PARTICIPATION"></asp:Label>
                </div>
                
                <!-- Certify Text -->
                <div class="certify-text">This is to Certify that</div>
                
                <!-- Recipient Name -->
                <div class="recipient-name">
                    <asp:Label ID="lblPersonName" runat="server" Text="JOHN DOE"></asp:Label>
                </div>
                
                <!-- Course Details Container -->
                <div class="course-details">
                    <div class="description-text">
                        has successfully completed a 30-hour Professional Course on
                    </div>
                    
                    <!-- Course Name (DevOps) -->
                    <div class="course-name">
                        <asp:Label ID="lblWorkshopName" runat="server" Text="DEVOPS"></asp:Label>
                    </div>
                    
                    <!-- Institution Name -->
                    <div class="institution-name">
                        conducted by <asp:Label ID="lblCompanyName" runat="server" Text="Texas College of Management and IT"></asp:Label>, from
                    </div>
                    
                    <!-- Date Range -->
                    <div class="date-range">
                        <asp:Label ID="lblWorkshopDate" runat="server" Text="13th July 2025 to 25 July 2025"></asp:Label>
                    </div>
                    
                    <!-- Recognition Text -->
                    <div class="recognition-text">
                        in recognition of their dedication, active participation, and successful completion of the program.
                    </div>
                </div>
                
                <!-- Signature Section (Two Signatures) -->
                <div class="signature-section">
                    <!-- First Signature (Left) -->
                    <div class="signature-box">
                        <div class="signature-line"></div>
                        <div class="signature-name">
                            <asp:Label ID="lblDirectorName" runat="server" Text="DR. SUMAN THAPALIYA"></asp:Label>
                        </div>
                        <div class="signature-title">
                            <asp:Label ID="lblDirectorTitle" runat="server" Text="Director of IT"></asp:Label>
                        </div>
                    </div>
                    
                    <!-- Second Signature (Right) - Static as per image -->
                    <div class="signature-box">
                        <div class="signature-line"></div>
                        <div class="signature-name">Shyam Sundar Shrestha</div>
                        <div class="signature-title">Principal</div>
                    </div>
                </div>
                
                <!-- Certificate Footer with ID and Date -->
                <div class="certificate-footer">
                    <div class="footer-left">
                        <i class="fas fa-certificate"></i>
                        Certificate ID: <asp:Label ID="lblCertificateNumber" runat="server" Text="CERT-2025-001"></asp:Label>
                    </div>
                    <div class="footer-right">
                        <i class="fas fa-calendar-alt"></i>
                        Issuing Date: <asp:Label ID="lblIssueDate" runat="server" Text="15-07-2025"></asp:Label>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div class="contact-info">
                    <span><i class="fas fa-phone"></i> 01-4583955</span>
                    <span><i class="fas fa-phone"></i> 4574966</span>
                </div>
                
                <!-- Decorative Seal -->
                <div class="seal">
                    <i class="fas fa-certificate"></i>
                </div>
            </div>
        </div>

   


</asp:Content>
