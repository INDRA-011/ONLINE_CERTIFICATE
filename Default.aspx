<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Home.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CertifyApp.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    /* ── OVERVIEW STAT CARDS (top row) ───────────────────── */
    .stat-grid-top {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
        margin-bottom: 12px;
    }
    .stat-grid-types {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 12px;
        margin-bottom: 28px;
    }
    .stat-card {
    background: #fff;
    border: 1px solid rgba(15,32,68,.14);
    border-radius: 12px;
    padding: 18px 20px;
    display: flex;
    align-items: flex-start;
    gap: 14px;
    transition: box-shadow .2s, transform .2s;
}
.stat-card:hover { box-shadow: 0 6px 22px rgba(15,32,68,.10); transform: translateY(-2px); }
.stat-card.navy  { background: #f6f8fc; }
.stat-card.gold  { background: #fdf9f0; }
.stat-card.teal  { background: #f0faf6; }
    .stat-card:hover {
        box-shadow: 0 4px 18px rgba(15,32,68,.10);
        transform: translateY(-2px);
    }
    .stat-icon {
        width: 44px; height: 44px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.2rem;
        flex-shrink: 0;
    }
    .stat-icon.navy   { background: rgba(15,32,68,.08);   color: #0f2044; }
    .stat-icon.gold   { background: rgba(201,168,76,.13); color: #c9a84c; }
    .stat-icon.teal   { background: rgba(15,110,86,.09);  color: #0f6e56; }
    .stat-label { font-size: .72rem; color: #6b7280; font-weight: 600; text-transform: uppercase; letter-spacing: .7px; margin-bottom: 6px; }
.stat-value { font-family: 'Playfair Display', serif; font-size: 2rem; color: #0f2044; line-height: 1; margin-bottom: 4px; }
.stat-sub   { font-size: .72rem; color: #9ca3af; margin-top: 0; }

    /* ── TYPE CARDS (2x2 grid) ────────────────────────────── */
    .type-card {
    background: #fff;
    border: 1px solid rgba(15,32,68,.14);
    border-radius: 12px;
    padding: 18px 20px;
    transition: box-shadow .2s, transform .2s;
}
.type-card:hover { box-shadow: 0 6px 22px rgba(15,32,68,.10); transform: translateY(-2px); }
.type-card.blue   { background: #f5f9ff; }
.type-card.green  { background: #f0fdf8; }
.type-card.amber  { background: #fffbf0; }
.type-card.purple { background: #faf8ff; }
    .type-card:hover {
        box-shadow: 0 4px 16px rgba(15,32,68,.09);
        transform: translateY(-2px);
    }
    .type-card-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 10px;
    }
    .type-card-name {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: .83rem;
        font-weight: 600;
        color: #374151;
    }
    .type-dot {
        width: 9px; height: 9px;
        border-radius: 50%;
        flex-shrink: 0;
    }
    .type-card-count {
        font-family: 'Playfair Display', serif;
        font-size: 1.5rem;
        color: #0f2044;
        line-height: 1;
    }
    .type-bar-wrap {
        background: #f3f4f6;
        border-radius: 4px;
        height: 7px;
        overflow: hidden;
    }
    .type-bar {
        height: 100%;
        border-radius: 4px;
        transition: width .7s cubic-bezier(.4,0,.2,1);
    }
    .bar-participation { background: #3b82f6; }
    .bar-completion    { background: #10b981; }
    .bar-achievement   { background: #f59e0b; }
    .bar-academic      { background: #7c3aed; }

    .section-eyebrow {
        font-size: .7rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: #9ca3af;
        font-weight: 600;
        margin-bottom: 10px;
        margin-top: 0;
    }

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
        <p>Welcome back, Administrator &mdash; here&rsquo;s an overview of your certificate system.</p>
    </div>

    <!-- OVERVIEW STAT CARDS -->
    <p class="section-eyebrow">Overview</p>
    <div class="stat-grid-top mb-1">

        <div class="stat-card">
            <div class="stat-icon navy"><i class="fas fa-certificate"></i></div>
            <div>
                <div class="stat-label">Total Certificates</div>
                <div class="stat-value"><asp:Label ID="lblTotal" runat="server" Text="0" /></div>
                <div class="stat-sub">all time</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon gold"><i class="fas fa-calendar-day"></i></div>
            <div>
                <div class="stat-label">Issued Today</div>
                <div class="stat-value"><asp:Label ID="lblToday" runat="server" Text="0" /></div>
                <div class="stat-sub">as of today</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon teal"><i class="fas fa-users"></i></div>
            <div>
                <div class="stat-label">Recipients</div>
                <div class="stat-value"><asp:Label ID="lblRecipients" runat="server" Text="0" /></div>
                <div class="stat-sub">unique students</div>
            </div>
        </div>

    </div>

    <!-- TYPE BREAKDOWN CARDS (2x2) -->
    <p class="section-eyebrow mt-3">By Certificate Type</p>
    <div class="stat-grid-types">

        <div class="type-card">
            <div class="type-card-top">
                <div class="type-card-name">
                    <span class="type-dot" style="background:#3b82f6;"></span>
                    Participation
                </div>
                <div class="type-card-count">
                    <asp:Label ID="lblParticipation" runat="server" Text="0" />
                </div>
            </div>
            <div class="type-bar-wrap">
                <div class="type-bar bar-participation" id="barParticipation" style="width:0%"></div>
            </div>
        </div>

        <div class="type-card">
            <div class="type-card-top">
                <div class="type-card-name">
                    <span class="type-dot" style="background:#10b981;"></span>
                    Completion
                </div>
                <div class="type-card-count">
                    <asp:Label ID="lblCompletion" runat="server" Text="0" />
                </div>
            </div>
            <div class="type-bar-wrap">
                <div class="type-bar bar-completion" id="barCompletion" style="width:0%"></div>
            </div>
        </div>

        <div class="type-card">
            <div class="type-card-top">
                <div class="type-card-name">
                    <span class="type-dot" style="background:#f59e0b;"></span>
                    Achievement
                </div>
                <div class="type-card-count">
                    <asp:Label ID="lblAchievement" runat="server" Text="0" />
                </div>
            </div>
            <div class="type-bar-wrap">
                <div class="type-bar bar-achievement" id="barAchievement" style="width:0%"></div>
            </div>
        </div>

        <div class="type-card">
            <div class="type-card-top">
                <div class="type-card-name">
                    <span class="type-dot" style="background:#7c3aed;"></span>
                    Academic
                </div>
                <div class="type-card-count">
                    <asp:Label ID="lblAcademic" runat="server" Text="0" />
                </div>
            </div>
            <div class="type-bar-wrap">
                <div class="type-bar bar-academic" id="barAcademic" style="width:0%"></div>
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

    <!-- BOTTOM GRID: Recent Certificates (full width) -->
    <div class="row g-3">
        <div class="col-12">
            <div class="section-card">
                <div class="section-header">
                    <h3><i class="fas fa-clock me-2" style="color:#c9a84c; font-size:.9rem;"></i>Recent Certificates</h3>
                    <a href="AllCertificates.aspx" style="font-size:.8rem; color:#c9a84c; text-decoration:none;">View all &rsaquo;</a>
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
                                No certificates yet. <a href="CreateCertificate.aspx" style="color:#c9a84c;">Create your first one &rarr;</a>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    window.addEventListener('load', function () {
        var total = parseInt('<%= TotalCount %>') || 1;
        var bars = {
            barParticipation: parseInt('<%= ParticipationCount %>') || 0,
            barCompletion:    parseInt('<%= CompletionCount %>')    || 0,
            barAchievement:   parseInt('<%= AchievementCount %>')   || 0,
            barAcademic:      parseInt('<%= AcademicCount %>') || 0
        };
        Object.keys(bars).forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.style.width = Math.round((bars[id] / total) * 100) + '%';
        });
    });
</script>
</asp:Content>
