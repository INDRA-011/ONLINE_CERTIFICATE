<%@ Page Title="" Language="C#" MasterPageFile="~/Blank.Master" AutoEventWireup="true" CodeBehind="CertificateView.aspx.cs" Inherits="CertifyApp.CertificateView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />

<style>

    @media print {
        body {
            background: white;
        }

        .btn-back,
        .btn-print {
            display: none !important;
        }

        .certificate-container {
            box-shadow: none;
            margin: 0;
            padding: 0;
            width: 100%;
        }

        .certificate {
            border: 2px solid black;
            page-break-inside: avoid;
            margin-bottom: 8px;
            padding-top: 10px !important; /* balanced spacing */
        }

        .title-wrapper {
            margin-top: 18px !important; /* FIXED: proper gap (not too big) */
        }

        .certificate img {
            top: 5px !important;   /* slightly higher */
            right: 25px !important;
            width: 70px !important;
        }
    }

    body {
        background-color: #f4f4f4;
        font-family: 'Times New Roman', serif;
    }

    .btn-back {
        background-color: #6c757d;
        color: white;
        padding: 8px 20px;
        border-radius: 5px;
        text-decoration: none;
    }

    .btn-print {
        background-color: #28a745;
        color: white;
        border: none;
        padding: 8px 20px;
        border-radius: 5px;
        float: right;
    }

    .certificate-container {
        max-width: 900px;
        margin: 0 auto;
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 0 20px rgba(0,0,0,0.1);
    }

    .certificate {
        border: 3px solid #2c3e50;
        padding: 30px;
        position: relative;
        margin-bottom: 8px;
    }

    .certificate img {
        position: absolute;
        top: 20px;
        right: 30px;
        width: 80px;
    }

    .main-title {
        text-align: center;
        font-size: 48px;
        font-weight: bold;
        border-bottom: 3px solid #3498db;
        display: inline-block;
        letter-spacing: 4px;
    }

    .title-wrapper {
        text-align: center;
        margin-top: 30px;
    }

    .certificate-badge {
        text-align: center;
        margin: 15px;
    }

    .certificate-badge label {
        font-size: 28px;
        color: #e67e22;
    }

    .recipient-name label {
        font-size: 40px;
        font-weight: bold;
        border-bottom: 2px dashed #3498db;
        letter-spacing: 2px;
    }

    .course-name label {
        font-size: 28px;
        font-weight: bold;
        color: #e67e22;
    }

    .signature-section {
        display: flex;
        justify-content: space-between;
        margin-top: 40px;
    }

    .signature-box {
        width: 45%;
        text-align: center;
    }

    .signature-line {
        border-top: 2px solid black;
        margin: 10px 0;
    }

    .certificate-footer {
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
    }

</style>

<div class="container">

    <!-- Back Button -->
    <a href="Default.aspx" class="btn-back">
        <i class="fas fa-arrow-left"></i> Back to Form
    </a>

    <!-- Print Button -->
    <button type="button" class="btn-print" onclick="window.print()">
        <i class="fas fa-print"></i> Print
    </button>

    <!-- Certificate -->
    <div class="certificate-container">
        <div class="certificate">

           <img src="~/image/logo.png" alt="logo" runat="server" />

            <div class="title-wrapper">
                <div class="main-title">CERTIFICATE</div>
            </div>

            <div class="certificate-badge">
                <asp:Label ID="lblCertificateTitle" runat="server" />
            </div>

            <div style="text-align:center;">This is to certify that</div>

            <div class="recipient-name" style="text-align:center;">
                <asp:Label ID="lblPersonName" runat="server" />
            </div>

            <div style="text-align:center;">has successfully completed</div>

            <div class="course-name" style="text-align:center;">
                <asp:Label ID="lblWorkshopName" runat="server" />
            </div>

            <div style="text-align:center;">
                conducted by <asp:Label ID="lblCompanyName" runat="server" />
            </div>

            <div style="text-align:center;">
                <asp:Label ID="lblWorkshopDate" runat="server" />
            </div>

            <!-- Signatures -->
            <div class="signature-section">

                <div class="signature-box">
                    <div class="signature-line"></div>
                    <asp:Label ID="lblDirectorName" runat="server" /><br />
                    <asp:Label ID="lblDirectorTitle" runat="server" />
                </div>

                <div class="signature-box">
                    <div class="signature-line"></div>
                    <asp:Label ID="lblPrincipalName" runat="server" /><br />
                    <asp:Label ID="lblPrincipalTitle" runat="server" />
                </div>

            </div>

            <!-- Footer -->
            <div class="certificate-footer">
                <div>
                    Certificate ID:
                    <asp:Label ID="lblCertificateNumber" runat="server" />
                </div>

                <div>
                    Date:
                    <asp:Label ID="lblIssueDate" runat="server" />
                </div>
            </div>

        </div>
    </div>

</div>

</asp:Content>