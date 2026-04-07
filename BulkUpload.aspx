<%@ Page Title="Bulk Upload" Language="C#" MasterPageFile="~/Home.Master" AutoEventWireup="true" CodeBehind="BulkUpload.aspx.cs" Inherits="CertifyApp.BulkUpload" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .upload-card {
        background:#fff; border-radius:12px;
        border:1px solid rgba(15,32,68,.07);
        box-shadow:0 1px 6px rgba(15,32,68,.06);
        overflow:hidden; margin-bottom:22px;
    }
    .upload-card-header {
        background:#0f2044; padding:16px 22px;
        display:flex; align-items:center; gap:12px;
    }
    .upload-card-header h4 { font-family:'Playfair Display',serif; color:#fff; margin:0; font-size:.95rem; }
    .upload-card-header i  { color:#c9a84c; }
    .upload-card-body { padding:24px; }

    /* DROP ZONE */
    .drop-zone {
        border: 2px dashed rgba(15,32,68,.2);
        border-radius:10px; padding:36px 20px;
        text-align:center; cursor:pointer;
        transition:all .2s; background:#faf8f4;
    }
    .drop-zone:hover, .drop-zone.drag-over {
        border-color:#c9a84c; background:rgba(201,168,76,.05);
    }
    .drop-zone i { font-size:2.4rem; color:#c9a84c; margin-bottom:10px; }
    .drop-zone h5 { color:#0f2044; font-family:'Playfair Display',serif; margin-bottom:4px; font-size:1rem; }
    .drop-zone p  { color:#6b7280; font-size:.82rem; margin:0; }
    .drop-zone .file-chosen { color:#0f2044; font-weight:600; font-size:.85rem; margin-top:10px; }

    /* TEMPLATE BOX */
    .template-box {
        background:#f0fdf4; border:1px solid #bbf7d0; border-radius:8px;
        padding:14px 18px; margin-top:16px;
        display:flex; align-items:flex-start; gap:12px;
    }
    .template-box i { color:#15803d; margin-top:2px; flex-shrink:0; }
    .template-box p { margin:0; font-size:.82rem; color:#15803d; }
    .template-box code { background:rgba(0,0,0,.06); padding:1px 5px; border-radius:4px; font-size:.78rem; }
    .template-link { color:#15803d; font-weight:600; text-decoration:none; }
    .template-link:hover { text-decoration:underline; }

    /* SHARED FIELDS */
    .form-label { font-size:.82rem; font-weight:600; color:#374151; margin-bottom:5px; }
    .form-control, .form-select {
        border:1px solid rgba(15,32,68,.15); border-radius:8px;
        font-size:.87rem; padding:8px 12px; color:#1e1e2e;
    }
    .form-control:focus, .form-select:focus {
        border-color:#c9a84c; box-shadow:0 0 0 3px rgba(201,168,76,.12); outline:none;
    }

    /* PREVIEW TABLE */
    .preview-table { width:100%; border-collapse:collapse; font-size:.83rem; }
    .preview-table thead th { background:#f8f5ef; color:#6b7280; font-size:.7rem; text-transform:uppercase; letter-spacing:.8px; font-weight:600; padding:9px 14px; border-bottom:1px solid rgba(15,32,68,.07); }
    .preview-table tbody tr { border-bottom:1px solid rgba(15,32,68,.05); }
    .preview-table tbody td { padding:9px 14px; vertical-align:middle; }
    .row-valid   { background:#f0fdf4; }
    .row-invalid { background:#fef2f2; }
    .badge-valid   { background:#dcfce7; color:#15803d; padding:2px 8px; border-radius:12px; font-size:.7rem; font-weight:600; }
    .badge-invalid { background:#fee2e2; color:#dc2626; padding:2px 8px; border-radius:12px; font-size:.7rem; font-weight:600; }

    /* BUTTONS */
    .btn-primary-cert { background:#0f2044; color:#fff; border:none; padding:10px 28px; border-radius:8px; font-size:.88rem; font-weight:600; cursor:pointer; font-family:'Source Sans Pro',sans-serif; }
    .btn-primary-cert:hover { background:#c9a84c; }
    .btn-outline-cert { background:transparent; color:#0f2044; border:1.5px solid rgba(15,32,68,.2); padding:10px 20px; border-radius:8px; font-size:.88rem; font-weight:600; cursor:pointer; font-family:'Source Sans Pro',sans-serif; }
    .btn-outline-cert:hover { border-color:#0f2044; background:rgba(15,32,68,.04); }

    .alert { border-radius:8px; font-size:.86rem; padding:12px 16px; margin-bottom:16px; }
</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <div class="breadcrumb-bar">
            <a href="Default.aspx"><i class="fas fa-home" style="font-size:.7rem;"></i> Dashboard</a>
            <span>/</span><span>Bulk Upload</span>
        </div>
        <h1>Bulk Certificate Generation</h1>
        <p>Upload a CSV file to generate certificates for multiple students at once.</p>
    </div>

    <!-- Alerts -->
    <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success" Visible="false">
        <i class="fas fa-check-circle me-2"></i><asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger" Visible="false">
        <i class="fas fa-exclamation-circle me-2"></i><asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <!-- STEP 1: UPLOAD -->
    <asp:Panel ID="pnlUpload" runat="server">
    <div class="upload-card">
        <div class="upload-card-header">
            <i class="fas fa-upload"></i>
            <h4>Step 1 — Upload CSV File</h4>
        </div>
        <div class="upload-card-body">

            <div class="drop-zone" onclick="document.getElementById('<%= fileUpload.ClientID %>').click();" id="dropZone">
                <i class="fas fa-file-csv"></i>
                <h5>Click to select your CSV file</h5>
                <p>or drag and drop it here</p>
                <div class="file-chosen" id="fileChosen" style="display:none;"></div>
            </div>
            <asp:FileUpload ID="fileUpload" runat="server" Style="display:none;" onchange="showFileName(this)" accept=".csv" />

            <div class="template-box mt-3">
                <i class="fas fa-info-circle"></i>
                <div>
                    <p><strong>Required CSV columns:</strong></p>
                    <p style="margin-top:4px;">
                        <code>PersonName</code>, <code>StudentEmail</code>, <code>WorkshopName</code>,
                        <code>IssueDate</code> (yyyy-MM-dd), <code>StudentBatch</code> (optional)
                    </p>
                    <p style="margin-top:6px;">
                        <asp:LinkButton ID="btnDownloadTemplate" runat="server" CssClass="template-link"
                            OnClick="btnDownloadTemplate_Click" CausesValidation="false">
                            <i class="fas fa-download me-1"></i> Download CSV Template
                        </asp:LinkButton>
                    </p>
                </div>
            </div>

            <!-- Shared settings for all certificates -->
            <hr style="margin:20px 0; border-color:rgba(15,32,68,.08);" />
            <h6 style="font-family:'Playfair Display',serif; color:#0f2044; margin-bottom:16px;">Shared Certificate Settings</h6>
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Certificate Type</label>
                    <asp:DropDownList ID="ddlCertType" runat="server" CssClass="form-select">
                        <asp:ListItem Value="Participation">Participation</asp:ListItem>
                        <asp:ListItem Value="Achievement">Achievement</asp:ListItem>
                        <asp:ListItem Value="Academic">Academic</asp:ListItem>
                        <asp:ListItem Value="Completion">Completion</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Certificate Title</label>
                    <asp:TextBox ID="txtBulkTitle" runat="server" CssClass="form-control" placeholder="e.g. Certificate of Participation" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Authorized By</label>
                    <asp:TextBox ID="txtBulkDirector" runat="server" CssClass="form-control" placeholder="DR. Suman Thapaliya" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Authorized Position</label>
                    <asp:TextBox ID="txtBulkDirectorTitle" runat="server" CssClass="form-control" Text="Director" />
                </div>
            </div>

            <div class="mt-4">
                <asp:Button ID="btnPreview" runat="server" Text="Preview CSV Data →"
                    CssClass="btn-primary-cert" OnClick="btnPreview_Click" CausesValidation="false" />
            </div>

        </div>
    </div>
    </asp:Panel>

    <!-- STEP 2: PREVIEW -->
    <asp:Panel ID="pnlPreview" runat="server" Visible="false">
    <div class="upload-card">
        <div class="upload-card-header">
            <i class="fas fa-table"></i>
            <h4>Step 2 — Review & Confirm</h4>
        </div>
        <div class="upload-card-body">

            <div class="mb-3" style="display:flex; align-items:center; justify-content:space-between;">
                <div style="font-size:.84rem; color:#374151;">
                    <strong><asp:Label ID="lblValidCount" runat="server" /></strong> valid rows |
                    <span style="color:#dc2626;"><asp:Label ID="lblInvalidCount" runat="server" /></span> invalid rows
                </div>
                <asp:Button ID="btnBackToUpload" runat="server" Text="← Back" CssClass="btn-outline-cert"
                    OnClick="btnBackToUpload_Click" CausesValidation="false" style="padding:7px 16px; font-size:.8rem;" />
            </div>

            <div style="overflow-x:auto; border-radius:8px; border:1px solid rgba(15,32,68,.07);">
                <asp:GridView ID="gvPreview" runat="server"
                    AutoGenerateColumns="False" GridLines="None" CssClass="preview-table"
                    OnRowDataBound="gvPreview_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="Row"          HeaderText="#"          />
                        <asp:BoundField DataField="PersonName"   HeaderText="Name"       />
                        <asp:BoundField DataField="StudentEmail" HeaderText="Email"      />
                        <asp:BoundField DataField="WorkshopName" HeaderText="Event"      />
                        <asp:BoundField DataField="IssueDate"    HeaderText="Date"       />
                        <asp:BoundField DataField="StudentBatch" HeaderText="Batch"      />
                        <asp:BoundField DataField="Status"       HeaderText="Status"     />
                        <asp:BoundField DataField="Notes"        HeaderText="Notes"      />
                    </Columns>
                </asp:GridView>
            </div>

            <div class="mt-4 d-flex gap-3">
                <asp:Button ID="btnGenerateAll" runat="server" Text="Generate All Valid Certificates"
                    CssClass="btn-primary-cert" OnClick="btnGenerateAll_Click" CausesValidation="false" />
            </div>

        </div>
    </div>
    </asp:Panel>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    function showFileName(input) {
        if (input.files && input.files[0]) {
            var el = document.getElementById('fileChosen');
            el.textContent = '✓ ' + input.files[0].name;
            el.style.display = 'block';
        }
    }
    var dz = document.getElementById('dropZone');
    if (dz) {
        dz.addEventListener('dragover', function(e) { e.preventDefault(); dz.classList.add('drag-over'); });
        dz.addEventListener('dragleave', function()  { dz.classList.remove('drag-over'); });
        dz.addEventListener('drop', function(e) {
            e.preventDefault(); dz.classList.remove('drag-over');
            var fileInput = document.getElementById('<%= fileUpload.ClientID %>');
            fileInput.files = e.dataTransfer.files;
            showFileName(fileInput);
        });
    }
</script>
</asp:Content>
