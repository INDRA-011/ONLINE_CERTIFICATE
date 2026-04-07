<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Home.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CertifyApp.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    /* ── STAT CARDS ───────────────────────────────────────── */
    .stat-card {
        background: #fff;
        border-radius: 10px;
        padding: 22px 24px;
        display: flex;
        align-items: center;
        gap: 18px;
        box-shadow: 0 1px 6px rgba(15,32,68,.07);
        border: 1px solid rgba(15,32,68,.06);
        transition: box-shadow .2s, transform .2s;
    }
    .stat-card:hover { box-shadow: 0 4px 18px rgba(15,32,68,.12); transform: translateY(-2px); }
    .stat-icon {
        width: 52px; height: 52px;
        border-radius: 12px;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.3rem;
        flex-shrink: 0;
    }
    .stat-icon.navy    { background: rgba(15,32,68,.08);  color: #0f2044; }
    .stat-icon.gold    { background: rgba(201,168,76,.12); color: #c9a84c; }
    .stat-icon.green   { background: rgba(16,185,129,.1);  color: #059669; }
    .stat-icon.purple  { background: rgba(124,58,237,.1);  color: #7c3aed; }
    .stat-icon.orange  { background: rgba(234,88,12,.1);   color: #ea580c; }
    .stat-label { font-size: .78rem; color: #6b7280; font-weight: 600; text-transform: uppercase; letter-spacing: .8px; }
    .stat-value { font-family: 'Playfair Display', serif; font-size: 2rem; color: #0f2044; line-height: 1.1; }

    /* ── QUICK ACTION CARDS ───────────────────────────────── */
    .action-card {
        background: #fff;
        border-radius: 12px;
        padding: 28px 24px;
        text-align: center;
        border: 1px solid rgba(15,32,68,.07);
        box-shadow: 0 1px 6px rgba(15,32,68,.06);
        transition: all .22s;
        text-decoration: none;
        color: inherit;
        display: block;
        height: 100%;
    }
    .action-card:hover {
        box-shadow: 0 6px 24px rgba(15,32,68,.13);
        transform: translateY(-3px);
        border-color: #c9a84c;
        color: inherit;
    }
    .action-card-icon {
        width: 64px; height: 64px;
        border-radius: 16px;
        margin: 0 auto 14px;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.6rem;
    }
    .action-card h5 { font-family: 'Playfair Display', serif; font-size: 1rem; color: #0f2044; margin-bottom: 6px; }
    .action-card p  { font-size: .8rem; color: #6b7280; margin: 0; }
    .action-card-badge {
        display: inline-block;
        background: #c9a84c;
        color: #fff;
        font-size: .65rem;
        font-weight: 700;
        padding: 2px 9px;
        border-radius: 12px;
        margin-top: 10px;
        letter-spacing: .5px;
    }

    /* ── RECENT TABLE ─────────────────────────────────────── */
    .section-card {
        background: #fff;
        border-radius: 12px;
        border: 1px solid rgba(15,32,68,.07);
        box-shadow: 0 1px 6px rgba(15,32,68,.06);
        overflow: hidden;
    }
    .section-header {
        padding: 18px 22px;
        border-bottom: 1px solid rgba(15,32,68,.07);
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .section-header h3 {
        font-family: 'Playfair Display', serif;
        font-size: 1.05rem;
        color: #0f2044;
        margin: 0;
    }
    .section-body { padding: 0; }

    .table-cert { width: 100%; border-collapse: collapse; font-size: .85rem; }
    .table-cert thead th {
        background: #f8f5ef;
        color: #6b7280;
        font-size: .72rem;
        text-transform: uppercase;
        letter-spacing: .8px;
        font-weight: 600;
        padding: 10px 18px;
        border-bottom: 1px solid rgba(15,32,68,.07);
        white-space: nowrap;
    }
    .table-cert tbody tr { border-bottom: 1px solid rgba(15,32,68,.05); }
    .table-cert tbody tr:last-child { border-bottom: none; }
    .table-cert tbody tr:hover { background: #faf8f4; }
    .table-cert tbody td { padding: 11px 18px; vertical-align: middle; color: #1e1e2e; }

    .type-badge {
        display: inline-flex; align-items: center; gap: 5px;
        padding: 3px 10px; border-radius: 20px;
        font-size: .72rem; font-weight: 600;
    }
    .type-badge.Participation { background: #eff6ff; color: #1d4ed8; }
    .type-badge.Achievement   { background: #fef9c3; color: #854d0e; }
    .type-badge.Academic      { background: #f0fdf4; color: #15803d; }
    .type-badge.Completion    { background: #fdf4ff; color: #7e22ce; }

    .btn-view-sm {
        padding: 4px 12px;
        font-size: .78rem;
        border-radius: 6px;
        background: #0f2044;
        color: #fff;
        border: none;
        text-decoration: none;
        transition: background .18s;
    }
    .btn-view-sm:hover { background: #c9a84c; color: #fff; }

    /* ── TYPE BREAKDOWN ───────────────────────────────────── */
    .type-row { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
    .type-row:last-child { margin-bottom: 0; }
    .type-row-label { width: 110px; font-size: .83rem; color: #374151; font-weight: 600; }
    .type-bar-wrap { flex: 1; background: #f3f4f6; border-radius: 6px; height: 10px; overflow: hidden; }
    .type-bar { height: 100%; border-radius: 6px; transition: width .6s ease; }
    .bar-participation { background: #3b82f6; }
    .bar-achievement   { background: #f59e0b; }
    .bar-academic      { background: #10b981; }
    .bar-completion    { background: #8b5cf6; }
    .type-row-count { font-size: .8rem; color: #6b7280; width: 36px; text-align: right; }
</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <div class="breadcrumb-bar">
            <i class="fas fa-home" style="font-size:.7rem;"></i>
            <span>Dashboard</span>
        </div>
        <h1>Dashboard</h1>
        <p>Welcome back, Administrator — here's an overview of your certificate system.</p>
    </div>

    <!-- STAT CARDS -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon navy"><i class="fas fa-certificate"></i></div>
                <div>
                    <div class="stat-label">Total Certificates</div>
                    <div class="stat-value"><asp:Label ID="lblTotal" runat="server" Text="0" /></div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon gold"><i class="fas fa-calendar-day"></i></div>
                <div>
                    <div class="stat-label">Issued Today</div>
                    <div class="stat-value"><asp:Label ID="lblToday" runat="server" Text="0" /></div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-user-check"></i></div>
                <div>
                    <div class="stat-label">Participation</div>
                    <div class="stat-value"><asp:Label ID="lblParticipation" runat="server" Text="0" /></div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon purple"><i class="fas fa-graduation-cap"></i></div>
                <div>
                    <div class="stat-label">Academic</div>
                    <div class="stat-value"><asp:Label ID="lblAcademic" runat="server" Text="0" /></div>
                </div>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="row g-3 mb-4">
        <div class="col-12">
            <h6 style="font-size:.72rem; text-transform:uppercase; letter-spacing:1.2px; color:#6b7280; font-weight:700; margin-bottom:14px;">
                Quick Actions
            </h6>
        </div>
        <div class="col-6 col-md-3">
            <a href="CreateCertificate.aspx" class="action-card">
                <div class="action-card-icon" style="background:rgba(15,32,68,.07);">
                    <i class="fas fa-plus-circle" style="color:#0f2044;"></i>
                </div>
                <h5>Create Certificate</h5>
                <p>Issue a new certificate for a student</p>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="BulkUpload.aspx" class="action-card">
                <div class="action-card-icon" style="background:rgba(201,168,76,.1);">
                    <i class="fas fa-file-csv" style="color:#c9a84c;"></i>
                </div>
                <h5>Bulk Upload</h5>
                <p>Generate certificates from a CSV file</p>
                <span class="action-card-badge">NEW</span>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="AllCertificates.aspx" class="action-card">
                <div class="action-card-icon" style="background:rgba(16,185,129,.08);">
                    <i class="fas fa-list-alt" style="color:#059669;"></i>
                </div>
                <h5>All Certificates</h5>
                <p>View, filter and manage all records</p>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="AllCertificates.aspx?type=Academic" class="action-card">
                <div class="action-card-icon" style="background:rgba(124,58,237,.08);">
                    <i class="fas fa-graduation-cap" style="color:#7c3aed;"></i>
                </div>
                <h5>Academic Batch</h5>
                <p>Filter certificates by student batch</p>
            </a>
        </div>
    </div>

    <!-- BOTTOM GRID: Recent + Type Breakdown -->
    <div class="row g-3">

        <!-- Recent Certificates -->
        <div class="col-lg-8">
            <div class="section-card">
                <div class="section-header">
                    <h3><i class="fas fa-clock me-2" style="color:#c9a84c; font-size:.9rem;"></i>Recent Certificates</h3>
                    <a href="AllCertificates.aspx" style="font-size:.8rem; color:#c9a84c; text-decoration:none;">View all →</a>
                </div>
                <div class="section-body">
                    <asp:GridView
                        ID="gvRecent"
                        runat="server"
                        AutoGenerateColumns="False"
                        GridLines="None"
                        CssClass="table-cert"
                        ShowHeader="True">
                        <Columns>
                            <asp:BoundField DataField="CertificateNumber" HeaderText="Cert No." />
                            <asp:BoundField DataField="PersonName"        HeaderText="Student" />
                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <span class='type-badge <%# Eval("CertificateType") %>'>
                                        <%# Eval("CertificateType") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="IssueDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" HtmlEncode="False" />
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <a href='CertificateView.aspx?id=<%# Eval("CertificateID") %>' class="btn-view-sm">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div style="padding:30px; text-align:center; color:#6b7280; font-size:.85rem;">
                                <i class="fas fa-inbox" style="font-size:2rem; opacity:.3; display:block; margin-bottom:10px;"></i>
                                No certificates yet. <a href="CreateCertificate.aspx" style="color:#c9a84c;">Create your first one →</a>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Type Breakdown -->
        <div class="col-lg-4">
            <div class="section-card" style="height:100%;">
                <div class="section-header">
                    <h3><i class="fas fa-chart-bar me-2" style="color:#c9a84c; font-size:.9rem;"></i>By Type</h3>
                </div>
                <div class="section-body" style="padding:22px;">
                    <div class="type-row">
                        <div class="type-row-label">Participation</div>
                        <div class="type-bar-wrap">
                            <div class="type-bar bar-participation" id="barParticipation" style="width:0%"></div>
                        </div>
                        <div class="type-row-count"><asp:Label ID="lblBarParticipation" runat="server" Text="0" /></div>
                    </div>
                    <div class="type-row">
                        <div class="type-row-label">Achievement</div>
                        <div class="type-bar-wrap">
                            <div class="type-bar bar-achievement" id="barAchievement" style="width:0%"></div>
                        </div>
                        <div class="type-row-count"><asp:Label ID="lblBarAchievement" runat="server" Text="0" /></div>
                    </div>
                    <div class="type-row">
                        <div class="type-row-label">Academic</div>
                        <div class="type-bar-wrap">
                            <div class="type-bar bar-academic" id="barAcademic" style="width:0%"></div>
                        </div>
                        <div class="type-row-count"><asp:Label ID="lblBarAcademic" runat="server" Text="0" /></div>
                    </div>
                    <div class="type-row">
                        <div class="type-row-label">Completion</div>
                        <div class="type-bar-wrap">
                            <div class="type-bar bar-completion" id="barCompletion" style="width:0%"></div>
                        </div>
                        <div class="type-row-count"><asp:Label ID="lblBarCompletion" runat="server" Text="0" /></div>
                    </div>

                    <hr style="margin:20px 0; border-color:rgba(15,32,68,.07);" />

                    <div style="font-size:.78rem; color:#6b7280;">
                        <i class="fas fa-info-circle me-1"></i>
                        Click a type in the sidebar to filter certificates.
                    </div>
                </div>
            </div>
        </div>

    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    // Animate type bars on load
    window.addEventListener('load', function () {
        var total = parseInt('<%= TotalCount %>') || 1;
        var types = {
            barParticipation: parseInt('<%= ParticipationCount %>') || 0,
            barAchievement:   parseInt('<%= AchievementCount %>')   || 0,
            barAcademic:      parseInt('<%= AcademicCount %>')      || 0,
            barCompletion:    parseInt('<%= CompletionCount %>') || 0
        };
        Object.keys(types).forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.style.width = Math.round((types[id] / total) * 100) + '%';
        });
    });
</script>
</asp:Content>
