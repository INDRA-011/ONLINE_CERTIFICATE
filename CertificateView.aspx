<%@ Page Title="Certificate" Language="C#" MasterPageFile="~/Blank.Master" AutoEventWireup="true" CodeBehind="CertificateView.aspx.cs" Inherits="CertifyApp.CertificateView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />

    <style>
        @page { size: A4 landscape; margin: 10mm; }

        @media print {
            body { background: white; }
            .no-print { display: none !important; }
            .certificate-container { width:100%; max-width:100%; margin:0; padding:0; box-shadow:none; }
            .certificate { width:100%; border:2px solid black; page-break-inside:avoid; margin-bottom:8px; padding-top:10px !important; }
            .title-wrapper { margin-top:18px !important; }
            .certificate-logo { top:5px !important; right:25px !important; width:70px !important; }
            .signature-section { display:table; width:100%; margin-top:10px; }
            .signature-box { display:table-cell; width:50%; text-align:center; }
            img { max-width:100%; height:auto; }
        }

        body { background-color:#f4f4f4; font-family:'Times New Roman', serif; }

        /* TOOLBAR */
        .cert-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 24px;
            background: #fff;
            border-bottom: 1px solid rgba(15,32,68,.08);
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 8px rgba(0,0,0,.06);
        }
        .toolbar-left  { display:flex; align-items:center; gap:10px; }
        .toolbar-right { display:flex; align-items:center; gap:10px; }

        .btn-back {
            display:inline-flex; align-items:center; gap:7px;
            background:#f8f5ef; color:#374151; padding:8px 16px;
            border-radius:7px; text-decoration:none; font-size:.83rem; font-weight:600;
            border:1px solid rgba(15,32,68,.12); transition:all .18s;
            font-family:'Source Sans Pro', sans-serif;
        }
        .btn-back:hover { background:#0f2044; color:#fff; border-color:#0f2044; }

        .btn-edit-cert {
            display:inline-flex; align-items:center; gap:7px;
            background:rgba(201,168,76,.12); color:#92651a; padding:8px 16px;
            border-radius:7px; text-decoration:none; font-size:.83rem; font-weight:600;
            border:1px solid rgba(201,168,76,.3); transition:all .18s;
            font-family:'Source Sans Pro', sans-serif;
        }
        .btn-edit-cert:hover { background:#c9a84c; color:#fff; border-color:#c9a84c; }

        .btn-print {
            display:inline-flex; align-items:center; gap:7px;
            background:#28a745; color:#fff; padding:8px 16px;
            border-radius:7px; border:none; font-size:.83rem; font-weight:600;
            cursor:pointer; transition:background .18s;
            font-family:'Source Sans Pro', sans-serif;
        }
        .btn-print:hover { background:#218838; }

        .btn-pdf {
            display:inline-flex; align-items:center; gap:7px;
            background:#0f2044; color:#fff; padding:8px 16px;
            border-radius:7px; border:none; font-size:.83rem; font-weight:600;
            cursor:pointer; transition:background .18s;
            font-family:'Source Sans Pro', sans-serif;
        }
        .btn-pdf:hover { background:#c9a84c; }

        /* CERTIFICATE STYLES (unchanged from your original) */
        .certificate-container { max-width:900px; margin:24px auto; background:white; padding:20px; border-radius:10px; box-shadow:0 0 20px rgba(0,0,0,.1); }
        .certificate { border:3px solid #2c3e50; padding:30px; position:relative; margin-bottom:8px; }
        .certificate-logo { position:absolute; top:20px; right:30px; width:80px; }
        .main-title { text-align:center; font-size:48px; font-weight:bold; border-bottom:3px solid #3498db; display:inline-block; letter-spacing:4px; }
        .title-wrapper { text-align:center; margin-top:30px; }
        .certificate-badge { text-align:center; margin:15px; }
        .certificate-badge label { font-size:28px; color:#e67e22; }
        .recipient-name label { font-size:40px; font-weight:bold; border-bottom:2px dashed #3498db; letter-spacing:2px; }
        .course-name label { font-size:28px; font-weight:bold; color:#e67e22; }
        .signature-section { display:flex; justify-content:space-between; margin-top:10px; }
        .signature-box { width:45%; text-align:center; }
        .signature-line { border-top:2px solid black; margin:2px 0; }
        .certificate-footer { display:flex; justify-content:space-between; margin-top:20px; }
        .signature-img { height:60px; display:block; margin:0 auto 0px auto; }
    </style>

    <!-- TOOLBAR -->
    <div class="cert-toolbar no-print">
        <div class="toolbar-left">
            <a href="AllCertificates.aspx" class="btn-back">
                <i class="fas fa-arrow-left"></i> Back
            </a>
            <a href='<%# "CreateCertificate.aspx?edit=" + CertificateId %>' id="btnEditLink" runat="server" class="btn-edit-cert">
                <i class="fas fa-pen"></i> Edit Certificate
            </a>
        </div>
        <div class="toolbar-right">
            <asp:Button ID="btnDownloadPdf" runat="server" Text="Download PDF"
                CssClass="btn-pdf" OnClick="btnDownloadPdf_Click"
                CausesValidation="false">
            </asp:Button>
            <button type="button" class="btn-print" onclick="window.print()">
                <i class="fas fa-print"></i> Print
            </button>
        </div>
    </div>

    <!-- CERTIFICATE -->
    <div class="certificate-container">
        <div class="certificate">

            <img src="~/image/logo.png" class="certificate-logo" alt="logo" runat="server" />

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

            <div class="signature-section">
                <div class="signature-box">
                    <img src="image/director-sign.png" class="signature-img" />
                    <div class="signature-line"></div>
                    <asp:Label ID="lblDirectorName" runat="server" /><br />
                    <asp:Label ID="lblDirectorTitle" runat="server" />
                </div>
                <div class="signature-box">
                    <img src="image/principal-sign.png" class="signature-img" />
                    <div class="signature-line"></div>
                    <asp:Label ID="lblPrincipalName" runat="server" /><br />
                    <asp:Label ID="lblPrincipalTitle" runat="server" />
                </div>
            </div>

            <div class="certificate-footer">
                <div>Certificate ID: <asp:Label ID="lblCertificateNumber" runat="server" /></div>
                <div>Date: <asp:Label ID="lblIssueDate" runat="server" /></div>
            </div>

        </div>
    </div>

</asp:Content>
