<%@ Page Title="All Certificates" Language="C#" MasterPageFile="~/Home.Master" AutoEventWireup="true" CodeBehind="AllCertificates.aspx.cs" Inherits="CertifyApp.AllCertificates" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .filter-bar {
        background: #fff;
        border-radius: 10px;
        padding: 16px 20px;
        margin-bottom: 20px;
        border: 1px solid rgba(15,32,68,.07);
        box-shadow: 0 1px 4px rgba(15,32,68,.05);
        display: flex; flex-wrap: wrap; gap: 12px; align-items: flex-end;
    }
    .filter-group { display: flex; flex-direction: column; gap: 4px; min-width: 150px; }
    .filter-label { font-size: .72rem; text-transform: uppercase; letter-spacing: .8px; color: #6b7280; font-weight: 600; }
    .form-control-sm, .form-select-sm {
        border: 1px solid rgba(15,32,68,.15); border-radius: 7px;
        font-size: .83rem; padding: 7px 11px; color: #1e1e2e;
    }
    .form-control-sm:focus, .form-select-sm:focus {
        border-color: #c9a84c; box-shadow: 0 0 0 3px rgba(201,168,76,.12); outline: none;
    }
    .btn-filter {
        background: #0f2044; color: #fff; border: none;
        padding: 8px 20px; border-radius: 7px; font-size: .83rem;
        cursor: pointer; font-family: 'Source Sans Pro', sans-serif;
    }
    .btn-filter:hover { background: #c9a84c; }
    .btn-reset {
        background: transparent; color: #6b7280; border: 1px solid rgba(15,32,68,.15);
        padding: 8px 16px; border-radius: 7px; font-size: .83rem;
        cursor: pointer; text-decoration: none; font-family: 'Source Sans Pro', sans-serif;
    }
    .btn-reset:hover { color: #0f2044; border-color: #0f2044; }

    /* TABLE */
    .section-card { background:#fff; border-radius:12px; border:1px solid rgba(15,32,68,.07); box-shadow:0 1px 6px rgba(15,32,68,.06); overflow:hidden; }
    .section-header { padding:16px 22px; border-bottom:1px solid rgba(15,32,68,.07); display:flex; align-items:center; justify-content:space-between; }
    .section-header h3 { font-family:'Playfair Display',serif; font-size:1rem; color:#0f2044; margin:0; }

    .table-cert { width:100%; border-collapse:collapse; font-size:.84rem; }
    .table-cert thead th { background:#f8f5ef; color:#6b7280; font-size:.71rem; text-transform:uppercase; letter-spacing:.8px; font-weight:600; padding:10px 16px; border-bottom:1px solid rgba(15,32,68,.07); white-space:nowrap; }
    .table-cert tbody tr { border-bottom:1px solid rgba(15,32,68,.05); }
    .table-cert tbody tr:last-child { border-bottom:none; }
    .table-cert tbody tr:hover { background:#faf8f4; }
    .table-cert tbody td { padding:10px 16px; vertical-align:middle; }

    .type-badge { display:inline-flex; align-items:center; gap:4px; padding:3px 9px; border-radius:20px; font-size:.71rem; font-weight:600; }
    .type-badge.Participation { background:#eff6ff; color:#1d4ed8; }
    .type-badge.Achievement   { background:#fef9c3; color:#854d0e; }
    .type-badge.Academic      { background:#f0fdf4; color:#15803d; }
    .type-badge.Completion    { background:#fdf4ff; color:#7e22ce; }

    .action-btns { display:flex; gap:6px; flex-wrap:wrap; }
    .btn-act { padding:4px 11px; font-size:.76rem; border-radius:6px; border:none; cursor:pointer; text-decoration:none; font-family:'Source Sans Pro',sans-serif; transition:all .18s; }
    .btn-view  { background:#0f2044; color:#fff; }
    .btn-view:hover  { background:#1a3260; color:#fff; }
    .btn-edit  { background:rgba(201,168,76,.15); color:#92651a; border:1px solid rgba(201,168,76,.3); }
    .btn-edit:hover  { background:#c9a84c; color:#fff; }
    .btn-email { background:rgba(59,130,246,.1); color:#1d4ed8; border:1px solid rgba(59,130,246,.2); }
    .btn-email:hover { background:#3b82f6; color:#fff; }
    .btn-del   { background:rgba(220,38,38,.08); color:#dc2626; border:1px solid rgba(220,38,38,.2); }
    .btn-del:hover { background:#dc2626; color:#fff; }

    /* PAGINATION */
    .pager-row { padding:14px 20px; border-top:1px solid rgba(15,32,68,.06); display:flex; align-items:center; justify-content:space-between; }
    .pager-info { font-size:.78rem; color:#6b7280; }
    .pager-controls { display:flex; gap:4px; }
    .pager-btn { width:32px; height:32px; border-radius:6px; border:1px solid rgba(15,32,68,.12); background:#fff; color:#374151; font-size:.8rem; cursor:pointer; display:flex; align-items:center; justify-content:center; text-decoration:none; transition:all .18s; }
    .pager-btn:hover, .pager-btn.active { background:#0f2044; color:#fff; border-color:#0f2044; }

    .alert { border-radius:8px; font-size:.87rem; padding:12px 16px; margin-bottom:16px; }
    .empty-state { text-align:center; padding:48px 20px; color:#6b7280; }
    .empty-state i { font-size:2.5rem; opacity:.25; display:block; margin-bottom:12px; }
    .empty-state a { color:#c9a84c; }
</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

    <!-- Page Header -->
    <div class="page-header">
        <div class="breadcrumb-bar">
            <a href="Default.aspx"><i class="fas fa-home" style="font-size:.7rem;"></i> Dashboard</a>
            <span>/</span> <span>All Certificates</span>
        </div>
        <h1>All Certificates</h1>
        <p>Browse, filter and manage all issued certificates.</p>
    </div>

    <!-- Alerts -->
    <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success" Visible="false">
        <i class="fas fa-check-circle me-2"></i><asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger" Visible="false">
        <i class="fas fa-exclamation-circle me-2"></i><asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <!-- FILTER BAR -->
    <div class="filter-bar">
        <div class="filter-group">
            <span class="filter-label">Type</span>
            <asp:DropDownList ID="ddlFilterType" runat="server" CssClass="form-select-sm">
                <asp:ListItem Value="">All Types</asp:ListItem>
                <asp:ListItem Value="Participation">Participation</asp:ListItem>
                <asp:ListItem Value="Achievement">Achievement</asp:ListItem>
                <asp:ListItem Value="Academic">Academic</asp:ListItem>
                <asp:ListItem Value="Completion">Completion</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="filter-group">
            <span class="filter-label">Batch</span>
            <asp:DropDownList ID="ddlFilterBatch" runat="server" CssClass="form-select-sm">
                <asp:ListItem Value="">All Batches</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="filter-group">
            <span class="filter-label">From Date</span>
            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control-sm" TextMode="Date" />
        </div>
        <div class="filter-group">
            <span class="filter-label">To Date</span>
            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control-sm" TextMode="Date" />
        </div>
        <div style="display:flex; gap:8px; align-items:flex-end;">
            <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn-filter" OnClick="btnFilter_Click" CausesValidation="false" />
            <asp:Button ID="btnReset"  runat="server" Text="Reset"  CssClass="btn-reset"  OnClick="btnReset_Click"  CausesValidation="false" />
        </div>
        <div style="margin-left:auto; align-self:flex-end;">
            <a href="CreateCertificate.aspx" class="btn-filter" style="text-decoration:none; display:inline-block;">
                <i class="fas fa-plus me-1"></i> New Certificate
            </a>
        </div>
    </div>

    <!-- TABLE -->
    <div class="section-card">
        <div class="section-header">
            <h3><i class="fas fa-list-alt me-2" style="color:#c9a84c; font-size:.9rem;"></i>Certificates</h3>
            <span style="font-size:.78rem; color:#6b7280;">
                <asp:Label ID="lblCount" runat="server" Text="0" /> records found
            </span>
        </div>
        <div style="overflow-x:auto;">
            <asp:GridView
                ID="gvCertificates"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="table-cert"
                AllowPaging="True"
                PageSize="15"
                OnPageIndexChanging="gvCertificates_PageIndexChanging"
                OnRowCommand="gvCertificates_RowCommand"
                PagerSettings-Visible="false">

                <Columns>
                    <asp:BoundField DataField="CertificateNumber" HeaderText="Cert No."  />
                    <asp:BoundField DataField="PersonName"        HeaderText="Student"    />
                    <asp:BoundField DataField="WorkshopName"      HeaderText="Event"      />
                    <asp:TemplateField HeaderText="Type">
                        <ItemTemplate>
                            <span class='type-badge <%# Eval("CertificateType") %>'>
                                <%# Eval("CertificateType") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="StudentBatch" HeaderText="Batch" />
                    <asp:BoundField DataField="IssueDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" HtmlEncode="False" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="action-btns">
                                <a href='CertificateView.aspx?id=<%# Eval("CertificateID") %>' class="btn-act btn-view">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href='CreateCertificate.aspx?edit=<%# Eval("CertificateID") %>' class="btn-act btn-edit">
                                    <i class="fas fa-pen"></i> Edit
                                </a>
                                <asp:LinkButton ID="btnEmail" runat="server"
                                    CommandName="SendEmail"
                                    CommandArgument='<%# Eval("CertificateID") %>'
                                    CssClass="btn-act btn-email"
                                    CausesValidation="false">
                                    <i class="fas fa-envelope"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server"
                                    CommandName="DeleteCert"
                                    CommandArgument='<%# Eval("CertificateID") %>'
                                    CssClass="btn-act btn-del"
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Delete this certificate?');">
                                    <i class="fas fa-trash"></i>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <!-- Custom Pager -->
        <div class="pager-row">
            <div class="pager-info">
                Page <asp:Label ID="lblCurrentPage" runat="server" Text="1" />
                of <asp:Label ID="lblTotalPages" runat="server" Text="1" />
            </div>
            <div class="pager-controls">
                <asp:LinkButton ID="btnPrev" runat="server" CssClass="pager-btn" CommandName="PrevPage" OnClick="btnPrev_Click" CausesValidation="false">
                    <i class="fas fa-chevron-left"></i>
                </asp:LinkButton>
                <asp:LinkButton ID="btnNext" runat="server" CssClass="pager-btn" CommandName="NextPage" OnClick="btnNext_Click" CausesValidation="false">
                    <i class="fas fa-chevron-right"></i>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    </ContentTemplate>
    </asp:UpdatePanel>

    <!-- EMAIL MODAL -->
    <div class="modal fade" id="emailModal" tabindex="-1" ClientIDMode="Static">
        <div class="modal-dialog">
            <div class="modal-content" style="border-radius:12px; border:none; box-shadow:0 10px 40px rgba(15,32,68,.2);">
                <div class="modal-header" style="background:#0f2044; border-radius:12px 12px 0 0; padding:16px 20px;">
                    <h5 class="modal-title" style="color:#fff; font-family:'Playfair Display',serif; font-size:.95rem;">
                        <i class="fas fa-envelope me-2" style="color:#c9a84c;"></i> Send Certificate by Email
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" style="padding:20px;">
                    <label style="font-size:.82rem; font-weight:600; color:#374151; margin-bottom:5px; display:block;">Student Email Address</label>
                    <asp:TextBox ID="txtEmailAddress" runat="server" CssClass="form-control" TextMode="Email" placeholder="student@example.com" />
                </div>
                <div class="modal-footer" style="padding:14px 20px; border-top:1px solid rgba(15,32,68,.07);">
                    <button type="button" class="btn-act btn-reset" data-bs-dismiss="modal" style="border-radius:7px; padding:7px 16px;">Cancel</button>
                    <asp:Button ID="btnSendEmailNow" runat="server" Text="Send Email"
                        CssClass="btn-filter" OnClick="btnSendEmailNow_Click"
                        CausesValidation="false" UseSubmitBehavior="true" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
