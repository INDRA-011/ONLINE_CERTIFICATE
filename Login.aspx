<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="CertifyApp.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Login</title>

    <style>
        body {
            margin: 0; 
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: linear-gradient(135deg,#4f46e5,#3b82f6);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background: white;
            padding: 40px;
            width: 350px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .login-title {
            text-align: center;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 25px;
            color: #333;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            font-size: 14px;
            margin-bottom: 6px;
            color: #555;
        }

        input[type=text],
        input[type=password] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        input[type=text]:focus,
        input[type=password]:focus {
            border-color: #4f46e5;
            outline: none;
        }

        .login-button {
            width: 100%;
            padding: 10px;
            background: #4f46e5;
            border: none;
            color: white;
            font-size: 15px;
            border-radius: 6px;
            cursor: pointer;
        }

        .login-button:hover {
            background: #4338ca;
        }

        .error-message {
            text-align: center;
            margin-top: 10px;
        }
    </style>

</head>

<body>

<form id="form1" runat="server">

    <div class="login-container">

        <div class="login-title">
            Admin Login
        </div>

        <div class="form-group">
            <label>Username</label>
            <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
        </div>

        <asp:Button ID="btnLogin"
            runat="server"
            Text="Login"
            CssClass="login-button"
            OnClick="btnLogin_Click" />

        <div class="error-message">
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
        </div>

    </div>

</form>

</body>
</html>