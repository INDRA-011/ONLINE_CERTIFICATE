<%@ Page Title="" Language="C#" MasterPageFile="~/Home.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CertifyApp.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

   

    <div class="main-container">
        <div class="header">
            <h1><i class="fas fa-certificate me-3"></i>Create professional certificates</h1>
        </div>

         <asp:HiddenField ID="hfCertificateId" runat="server" />

       <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success" Visible="false">
                    <i class="fas fa-check-circle me-2"></i>
                    <asp:Label ID="lblSuccess" runat="server"></asp:Label>
                </asp:Panel>

                <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger" Visible="false">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </asp:Panel>

                <div class="form-section">
                    <h3><i class="fas fa-edit me-2"></i>Certificates for Participant</h3>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Certificate Title</label>
                            <asp:TextBox ID="txtCertificateTitle" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvTitle" 
                                runat="server" 
                                ControlToValidate="txtCertificateTitle" 
                                ErrorMessage="Certificate Title is required" 
                                CssClass="text-danger small" 
                                Display="Dynamic" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Person Name</label>
                            <asp:TextBox ID="txtPersonName" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvName" 
                                runat="server" 
                                ControlToValidate="txtPersonName" 
                                ErrorMessage="Person Name is required" 
                                CssClass="text-danger small" 
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Issue Date</label>
                            <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvDate" 
                                runat="server" 
                                ControlToValidate="txtIssueDate" 
                                ErrorMessage="Issue Date is required" 
                                CssClass="text-danger small" 
                                Display="Dynamic" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Workshop Name</label>
                            <asp:TextBox ID="txtWorkshopName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Workshop Date</label>
                            <asp:TextBox ID="txtWorkshopDate" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Total Hours</label>
                            <asp:TextBox ID="txtTotalHours" runat="server" CssClass="form-control" Text="12" TextMode="Number"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Authorized Name</label>
                            <asp:TextBox ID="txtDirectorName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Authorized Position</label>
                            <asp:TextBox ID="txtDirectorTitle" runat="server" CssClass="form-control" Text="Director"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="preview-badge mt-4">
                                <i class="fas fa-info-circle me-1"></i> All fields with * are required
                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <asp:Button 
                            ID="btnSave" 
                            runat="server" 
                            Text="Save Certificate" 
                            CssClass="btn btn-action btn-save" 
                            OnClick="btnSave_Click" />
                    </div>
                </div>

                <div class="grid-section">
                    <h3><i class="fas fa-list me-2"></i>New Generated Certificates</h3>

                    <div class="table-responsive">
                        <asp:GridView 
                            ID="gvCertificates" 
                            runat="server" 
                            CssClass="table grid-custom" 
                            AutoGenerateColumns="False" 
                            GridLines="None" 
                            AllowPaging="True" 
                            PageSize="10" 
                            OnPageIndexChanging="gvCertificates_PageIndexChanging" 
                            OnRowCommand="gvCertificates_RowCommand">
                            
                            <Columns>
                                <asp:BoundField DataField="CertificateNumber" HeaderText="Certificate No." />
                                <asp:BoundField DataField="CertificateID" HeaderText="ID" Visible="false" />
                                <asp:BoundField DataField="CertificateTitle" HeaderText="Title" />
                                <asp:BoundField DataField="PersonName" HeaderText="Name" />
                                <asp:BoundField DataField="IssueDate" HeaderText="Issue Date" DataFormatString="{0:dd-MM-yyyy}" HtmlEncode="False" />

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <div class="d-flex gap-1">
                                            <asp:LinkButton 
                                                ID="btnView" 
                                                runat="server" 
                                                CommandName="ViewCertificate" 
                                                CommandArgument='<%# Eval("CertificateID") %>' 
                                                CssClass="btn btn-sm btn-info" 
                                                CausesValidation="False">
                                                <i class="fas fa-eye"></i> View
                                            </asp:LinkButton>

                                            <asp:LinkButton 
                                                ID="btnGenerateCert" 
                                                runat="server" 
                                                CommandName="GenerateCertificate" 
                                                CommandArgument='<%# Eval("CertificateID") %>' 
                                                CssClass="btn btn-sm btn-success" 
                                                CausesValidation="False">
                                                <i class="fas fa-certificate"></i> Generate
                                            </asp:LinkButton>

                                            <asp:LinkButton 
                                                ID="btnSendEmail" 
                                                runat="server" 
                                                CommandName="SendEmail" 
                                                CommandArgument='<%# Eval("CertificateID") %>' 
                                                CssClass="btn btn-sm btn-warning" 
                                                CausesValidation="False"
                                                UseSubmitBehavior="false">
                                                <i class="fas fa-envelope"></i> Send Email
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>

                            <PagerStyle CssClass="pagination-custom" />
                        </asp:GridView>
                    </div>
                </div>

               

            </ContentTemplate>

           <Triggers>
        <asp:PostBackTrigger ControlID="btnSendEmailNow" />
    </Triggers>

        </asp:UpdatePanel>
        
 <!-- EMAIL MODAL -->
 <div class="modal fade" id="emailModal" tabindex="-1" ClientIDMode="Static">
     <div class="modal-dialog">
         <div class="modal-content">
             <div class="modal-header">
                 <h5 class="modal-title">Send Certificate Email</h5>
             </div>
             <div class="modal-body">
                 <label>Student Email</label>
                 <asp:TextBox ID="txtStudentEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                
             </div>
             <div class="modal-footer">
                 <asp:Button 
    ID="btnSendEmailNow" 
    runat="server" 
    Text="Send Email" 
    CssClass="btn btn-primary"
    UseSubmitBehavior="true"
    CausesValidation="false"
    OnClick="btnSendEmailNow_Click" />
             </div>
         </div>
     </div>
 </div>
    </div>

    <script type="text/javascript">
        function showTemporaryMessage(tempPanelId, defaultMessage) {
            var tempPanel = document.getElementById(tempPanelId);
            if (!tempPanel) return;

            tempPanel.style.display = 'block';

            // Hide after 5 seconds and show default
            setTimeout(function () {
                tempPanel.style.display = 'none';

                var defaultPanel = document.getElementById('<%= pnlSuccess.ClientID %>');
            if (defaultPanel) {
                defaultPanel.style.display = 'block';
                var lbl = document.getElementById('<%= lblSuccess.ClientID %>');
                if (lbl) {
                    lbl.innerText = defaultMessage;
                }
            }

        }, 5000); // 5 seconds
        }
</script>

</asp:Content>


