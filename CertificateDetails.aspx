<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CertificateDetails.aspx.cs" Inherits="CertifyApp.CertificateDetails" %>

<!DOCTYPE html>
<head runat="server">
    <title>Certificate Details</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .header-actions {
            margin-top: 10px;
        }

        .back-btn {
            text-decoration: none;
            color: #667eea;
            font-size: 16px;
        }

        .back-btn:hover {
            color: #764ba2;
        }

        .certificate-details-panel {
            max-width: 900px;
            margin: 0 auto;
        }

        .certificate-preview-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .certificate-border {
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: inset 0 0 30px rgba(102, 126, 234, 0.1);
            border: 2px solid #f0f0f0;
        }

        .certificate-content {
            text-align: center;
        }

        .certificate-header {
            border-bottom: 2px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 20px;
            position: relative;
        }

        .certificate-header h2 {
            color: #333;
            font-size: 32px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .certificate-seal {
            position: absolute;
            top: 0;
            right: 0;
            font-size: 48px;
            color: #667eea;
            opacity: 0.3;
        }

        .certificate-presented {
            font-size: 18px;
            color: #666;
            margin-bottom: 10px;
        }

        .certificate-name {
            font-size: 36px;
            color: #667eea;
            font-weight: 700;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .certificate-number {
            font-size: 16px;
            color: #999;
            margin-bottom: 20px;
            font-weight: 600;
            background: #f0f0f0;
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
        }

        .certificate-workshop-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }

        .workshop-name {
            font-size: 24px;
            color: #333;
            font-weight: 600;
            margin: 10px 0;
        }

        .certificate-issued {
            font-size: 14px;
            color: #999;
            margin-top: 20px;
        }

        .certificate-footer {
            margin-top: 40px;
            display: flex;
            justify-content: center;
        }

        .signature-area {
            text-align: center;
            width: 250px;
        }

        .signature-line {
            border-bottom: 2px solid #333;
            margin-bottom: 10px;
            width: 100%;
        }

        .signature-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .signature-title {
            font-size: 14px;
            color: #666;
        }

        .details-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .details-section h3 {
            color: #667eea;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .detail-item label {
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .detail-value {
            font-size: 16px;
            color: #333;
        }

        .action-buttons {
            margin-top: 30px;
            text-align: center;
        }

        .btn-action {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 0 5px;
            text-decoration: none;
            display: inline-block;
        }

        .btn-generate {
            background: #28a745;
            color: white;
        }

        .btn-generate:hover {
            background: #218838;
            color: white;
        }

        .btn-save {
            background: #667eea;
            color: white;
        }

        .btn-save:hover {
            background: #5a67d8;
            color: white;
        }

        .btn-edit {
            background: #ffc107;
            border-color: #ffc107;
            color: white;
        }

        .btn-edit:hover {
            background: #e0a800;
            border-color: #e0a800;
            color: white;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @media print {
            .header, .details-section, .action-buttons, .btn-action, .header-actions {
                display: none !important;
            }
            
            .certificate-preview-card {
                background: none;
                padding: 0;
            }
            
            .certificate-border {
                border: 2px solid #000;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="main-container">
            <div class="header">
                <h1><i class="fas fa-certificate me-3"></i>Certificate Details</h1>
                <div class="header-actions">
                    <asp:HyperLink ID="hlBackToHome" runat="server" 
                        NavigateUrl="~/Default.aspx" 
                        CssClass="back-btn">
                        <i class="fas fa-arrow-left me-2"></i>Back to Home
                    </asp:HyperLink>
                </div>
            </div>

            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger" Visible="false">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <asp:Label ID="lblError" runat="server"></asp:Label>
                    </asp:Panel>

                    <asp:Panel ID="pnlCertificateDetails" runat="server" CssClass="certificate-details-panel" Visible="false">
                        <!-- Certificate Preview Card -->
                        <div class="certificate-preview-card mb-4">
                            <div class="certificate-border">
                                <div class="certificate-content">
                                    <div class="certificate-header">
                                        <h2><asp:Label ID="lblCertificateTitle" runat="server"></asp:Label></h2>
                                        <div class="certificate-seal">
                                            <i class="fas fa-certificate"></i>
                                        </div>
                                    </div>
                                    
                                    <div class="certificate-body">
                                        <p class="certificate-presented">This is to certify that</p>
                                        <h3 class="certificate-name"><asp:Label ID="lblPersonName" runat="server"></asp:Label></h3>
                                        
                                        <!-- Certificate Number Display -->
                                        <div class="certificate-number">
                                            <asp:Label ID="lblCertNumber" runat="server"></asp:Label>
                                        </div>
                                        
                                        <div class="certificate-workshop-info">
                                            <p>has successfully completed the</p>
                                            <h4 class="workshop-name"><asp:Label ID="lblWorkshopName" runat="server"></asp:Label></h4>
                                            
                                            <asp:Panel ID="pnlWorkshopDate" runat="server" Visible="false">
                                                <p>held on <asp:Label ID="lblWorkshopDate" runat="server"></asp:Label></p>
                                            </asp:Panel>
                                            
                                            <asp:Panel ID="pnlTotalHours" runat="server" Visible="false">
                                                <p>Total Hours: <asp:Label ID="lblTotalHours" runat="server"></asp:Label></p>
                                            </asp:Panel>
                                        </div>
                                        
                                        <p class="certificate-issued">
                                            Issued on: <asp:Label ID="lblIssueDate" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                    
                                    <div class="certificate-footer">
                                        <div class="signature-area">
                                            <div class="signature-line"></div>
                                            <p class="signature-name"><asp:Label ID="lblDirectorName" runat="server"></asp:Label></p>
                                            <p class="signature-title"><asp:Label ID="lblDirectorTitle" runat="server"></asp:Label></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Detailed Information Section -->
                        <div class="details-section">
                            <h3><i class="fas fa-info-circle me-2"></i>Detailed Information</h3>
                            
                            <div class="details-grid">
                                <div class="detail-item">
                                    <label>Certificate Number:</label>
                                    <asp:Label ID="lblDetailCertNumber" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Certificate ID:</label>
                                    <asp:Label ID="lblCertificateID" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Certificate Title:</label>
                                    <asp:Label ID="lblDetailCertificateTitle" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Person Name:</label>
                                    <asp:Label ID="lblDetailPersonName" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Issue Date:</label>
                                    <asp:Label ID="lblDetailIssueDate" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Workshop Name:</label>
                                    <asp:Label ID="lblDetailWorkshopName" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Workshop Date:</label>
                                    <asp:Label ID="lblDetailWorkshopDate" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Total Hours:</label>
                                    <asp:Label ID="lblDetailTotalHours" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Director Name:</label>
                                    <asp:Label ID="lblDetailDirectorName" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Director Title:</label>
                                    <asp:Label ID="lblDetailDirectorTitle" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                                
                                <div class="detail-item">
                                    <label>Created Date:</label>
                                    <asp:Label ID="lblDetailCreatedDate" runat="server" CssClass="detail-value"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <asp:Button ID="btnGeneratePDF" runat="server" 
                                Text="Generate PDF Certificate" 
                                CssClass="btn-action btn-generate" 
                                OnClick="btnGeneratePDF_Click" />
                            <asp:Button ID="btnPrintCertificate" runat="server" 
                                Text="Print Certificate" 
                                CssClass="btn-action btn-save" 
                                OnClientClick="window.print(); return false;" />
                            <asp:HyperLink ID="hlEditCertificate" runat="server" 
                                CssClass="btn-action btn-edit">
                                <i class="fas fa-edit me-2"></i>Edit Certificate
                            </asp:HyperLink>
                        </div>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
