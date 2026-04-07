<%@ Page Title="Create Certificate" Language="C#" MasterPageFile="~/Home.Master" AutoEventWireup="true" CodeBehind="CreateCertificate.aspx.cs" Inherits="CertifyApp.CreateCertificate" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .form-card {
        background: #fff;
        border-radius: 12px;
        border: 1px solid rgba(15,32,68,.07);
        box-shadow: 0 1px 6px rgba(15,32,68,.06);
        overflow: hidden;
        margin-bottom: 24px;
    }
    .form-card-header {
        background: #0f2044;
        padding: 18px 24px;
        display: flex; align-items: center; gap: 12px;
    }
    .form-card-header h4 {
        font-family: 'Playfair Display', serif;
        color: #fff;
        margin: 0; font-size: 1rem;
    }
    .form-card-header i { color: #c9a84c; }
    .form-card-body { padding: 24px; }

    /* TYPE SELECTOR */
    .type-selector { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 24px; }
    .type-option { display: none; }
    .type-option + label {
        flex: 1; min-width: 130px;
        border: 2px solid rgba(15,32,68,.1);
        border-radius: 10px;
        padding: 14px 12px;
        text-align: center;
        cursor: pointer;
        transition: all .2s;
        background: #f8f5ef;
    }
    .type-option + label i { display: block; font-size: 1.4rem; margin-bottom: 6px; }
    .type-option + label span { font-size: .8rem; font-weight: 600; color: #374151; display: block; }
    .type-option + label small { font-size: .7rem; color: #6b7280; }
    .type-option:checked + label {
        border-color: #c9a84c;
        background: rgba(201,168,76,.08);
    }
    .type-option:checked + label span { color: #0f2044; }
    #typeParticipation:checked + label i { color: #3b82f6; }
    #typeAchievement:checked   + label i { color: #f59e0b; }
    #typeAcademic:checked      + label i { color: #10b981; }
    #typeCompletion:checked    + label i { color: #8b5cf6; }

    /* FORM STYLES */
    .form-label { font-size: .82rem; font-weight: 600; color: #374151; margin-bottom: 5px; }
    .form-label .req { color: #dc2626; margin-left: 2px; }
    .form-control, .form-select {
        border: 1px solid rgba(15,32,68,.15);
        border-radius: 8px;
        font-size: .88rem;
        padding: 9px 13px;
        color: #1e1e2e;
        transition: border-color .18s, box-shadow .18s;
    }
    .form-control:focus, .form-select:focus {
        border-color: #c9a84c;
        box-shadow: 0 0 0 3px rgba(201,168,76,.15);
        outline: none;
    }
    .text-danger.small { font-size: .75rem; margin-top: 3px; }

    /* ACADEMIC-ONLY FIELDS */
    #academicFields { display: none; }

    /* BUTTONS */
    .btn-primary-cert {
        background: #0f2044; color: #fff;
        border: none; padding: 11px 32px;
        border-radius: 8px; font-size: .9rem; font-weight: 600;
        cursor: pointer; transition: background .2s;
        font-family: 'Source Sans Pro', sans-serif;
    }
    .btn-primary-cert:hover { background: #c9a84c; }
    .btn-outline-cert {
        background: transparent; color: #0f2044;
        border: 1.5px solid rgba(15,32,68,.2);
        padding: 11px 24px; border-radius: 8px;
        font-size: .9rem; font-weight: 600;
        cursor: pointer; transition: all .2s;
        font-family: 'Source Sans Pro', sans-serif;
        text-decoration: none; display: inline-block;
    }
    .btn-outline-cert:hover { border-color: #0f2044; background: rgba(15,32,68,.04); color: #0f2044; }

    .alert { border-radius: 8px; font-size: .87rem; padding: 12px 16px; }
    .edit-badge {
        display: inline-flex; align-items: center; gap: 8px;
        background: rgba(201,168,76,.12);
        border: 1px solid rgba(201,168,76,.3);
        color: #92651a;
        padding: 6px 14px; border-radius: 20px;
        font-size: .8rem; font-weight: 600;
        margin-bottom: 18px;
    }
</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

    <asp:HiddenField ID="hfCertificateId" runat="server" Value="0" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="breadcrumb-bar">
            <a href="Default.aspx"><i class="fas fa-home" style="font-size:.7rem;"></i> Dashboard</a>
            <span>/</span>
            <span><asp:Label ID="lblPageBreadcrumb" runat="server" Text="Create Certificate" /></span>
        </div>
        <h1><asp:Label ID="lblPageTitle" runat="server" Text="Create Certificate" /></h1>
        <p>Fill in the details below to generate a new certificate.</p>
    </div>

    <!-- Edit mode badge -->
    <asp:Panel ID="pnlEditBadge" runat="server" Visible="false">
        <div class="edit-badge">
            <i class="fas fa-pen"></i>
            Editing existing certificate — <asp:Label ID="lblEditCertNumber" runat="server" />
        </div>
    </asp:Panel>

    <!-- Alerts -->
    <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success mb-3" Visible="false">
        <i class="fas fa-check-circle me-2"></i>
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger mb-3" Visible="false">
        <i class="fas fa-exclamation-circle me-2"></i>
        <asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <!-- CERTIFICATE TYPE SELECTOR -->
    <div class="form-card">
        <div class="form-card-header">
            <i class="fas fa-layer-group"></i>
            <h4>Step 1 — Select Certificate Type</h4>
        </div>
        <div class="form-card-body">
            <div class="type-selector">
                <asp:HiddenField ID="hfCertType" runat="server" Value="Participation" />

                <input type="radio" name="certType" id="typeParticipation" class="type-option" value="Participation" checked="checked" onchange="setCertType(this.value)" />
                <label for="typeParticipation">
                    <i class="fas fa-user-check" style="color:#3b82f6;"></i>
                    <span>Participation</span>
                    <small>Workshops &amp; events</small>
                </label>

                <input type="radio" name="certType" id="typeAchievement" class="type-option" value="Achievement" onchange="setCertType(this.value)" />
                <label for="typeAchievement">
                    <i class="fas fa-trophy" style="color:#f59e0b;"></i>
                    <span>Achievement</span>
                    <small>Awards &amp; honours</small>
                </label>

                <input type="radio" name="certType" id="typeAcademic" class="type-option" value="Academic" onchange="setCertType(this.value); toggleAcademic(true)" />
                <label for="typeAcademic">
                    <i class="fas fa-graduation-cap" style="color:#10b981;"></i>
                    <span>Academic</span>
                    <small>Degrees &amp; batches</small>
                </label>

                <input type="radio" name="certType" id="typeCompletion" class="type-option" value="Completion" onchange="setCertType(this.value); toggleAcademic(false)" />
                <label for="typeCompletion">
                    <i class="fas fa-check-double" style="color:#8b5cf6;"></i>
                    <span>Completion</span>
                    <small>Courses &amp; training</small>
                </label>
            </div>
        </div>
    </div>

    <!-- CERTIFICATE DETAILS -->
    <div class="form-card">
        <div class="form-card-header">
            <i class="fas fa-edit"></i>
            <h4>Step 2 — Certificate Details</h4>
        </div>
        <div class="form-card-body">
            <div class="row g-3">

                <div class="col-md-6">
                    <label class="form-label">Certificate Title <span class="req">*</span></label>
                    <asp:TextBox ID="txtCertificateTitle" runat="server" CssClass="form-control" placeholder="e.g. Certificate of Participation" />
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtCertificateTitle"
                        ErrorMessage="Certificate Title is required" CssClass="text-danger small" Display="Dynamic" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Student Name <span class="req">*</span></label>
                    <asp:TextBox ID="txtPersonName" runat="server" CssClass="form-control" placeholder="Full name" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtPersonName"
                        ErrorMessage="Student Name is required" CssClass="text-danger small" Display="Dynamic" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Student Email</label>
                    <asp:TextBox ID="txtStudentEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="student@example.com" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Issue Date <span class="req">*</span></label>
                    <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control" TextMode="Date" />
                    <asp:RequiredFieldValidator ID="rfvDate" runat="server" ControlToValidate="txtIssueDate"
                        ErrorMessage="Issue Date is required" CssClass="text-danger small" Display="Dynamic" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Workshop / Event Name</label>
                    <asp:TextBox ID="txtWorkshopName" runat="server" CssClass="form-control" placeholder="e.g. Sci-Research Workshop" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Workshop / Event Date</label>
                    <asp:TextBox ID="txtWorkshopDate" runat="server" CssClass="form-control" placeholder="e.g. 02-04 April 2025" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Total Hours</label>
                    <asp:TextBox ID="txtTotalHours" runat="server" CssClass="form-control" TextMode="Number" Text="12" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Authorized Name</label>
                    <asp:TextBox ID="txtDirectorName" runat="server" CssClass="form-control" placeholder="e.g. DR. Suman Thapaliya" />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Authorized Position</label>
                    <asp:TextBox ID="txtDirectorTitle" runat="server" CssClass="form-control" Text="Director" />
                </div>

                <!-- ACADEMIC-ONLY FIELDS -->
                <div class="col-12" id="academicFields">
                    <hr style="border-color:rgba(15,32,68,.08); margin:8px 0 16px;" />
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Student Batch <i class="fas fa-graduation-cap ms-1" style="color:#10b981; font-size:.8rem;"></i></label>
                            <asp:TextBox ID="txtStudentBatch" runat="server" CssClass="form-control" placeholder="e.g. 2024-2025" />
                        </div>
                    </div>
                </div>

            </div>

            <!-- Actions -->
            <div class="d-flex align-items-center gap-3 mt-4 pt-3" style="border-top:1px solid rgba(15,32,68,.07);">
                <asp:Button ID="btnSave" runat="server" Text="Save Certificate"
                    CssClass="btn-primary-cert" OnClick="btnSave_Click" />
                <a href="AllCertificates.aspx" class="btn-outline-cert">Cancel</a>
                <asp:Panel ID="pnlCancelEdit" runat="server" Visible="false" style="display:inline;">
                    <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel Edit"
                        CssClass="btn-outline-cert" OnClick="btnCancelEdit_Click"
                        CausesValidation="false" style="color:#dc2626; border-color:#dc2626;" />
                </asp:Panel>
            </div>
        </div>
    </div>

    </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    function setCertType(val) {
        document.getElementById('<%= hfCertType.ClientID %>').value = val;
        toggleAcademic(val === 'Academic');
    }
    function toggleAcademic(show) {
        document.getElementById('academicFields').style.display = show ? 'block' : 'none';
    }

    // On page load: restore selected type (for edit mode)
    window.addEventListener('load', function () {
        var stored = document.getElementById('<%= hfCertType.ClientID %>').value;
        if (stored) {
            var map = { 'Participation': 'typeParticipation', 'Achievement': 'typeAchievement', 'Academic': 'typeAcademic', 'Completion': 'typeCompletion' };
            var radioId = map[stored];
            if (radioId) {
                var radio = document.getElementById(radioId);
                if (radio) { radio.checked = true; toggleAcademic(stored === 'Academic'); }
            }
        }
    });
</script>
</asp:Content>
