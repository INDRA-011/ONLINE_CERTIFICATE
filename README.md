# CertifyApp — Update Integration Guide
## Texas College of Management & IT

---

## FILES DELIVERED

| File | What it does |
|------|-------------|
| `SQL_AlterTable.sql` | Run this FIRST in SSMS to add new DB columns |
| `Certificate.cs` | Replace your Models/Certificate.cs |
| `CertificateData.cs` | Replace your Data/CertificateData.cs |
| `Home.Master` | Replace your Home.Master (new sidebar layout) |
| `Home.Master.cs` | Replace your Home.Master.cs |
| `Default.aspx` | Replace — now a proper dashboard with stats |
| `Default.aspx.cs` | Replace — loads stats and recent certs |
| `CreateCertificate.aspx` | NEW page — create + edit certificates |
| `CreateCertificate.aspx.cs` | NEW code-behind |
| `AllCertificates.aspx` | NEW page — full list with filters |
| `AllCertificates.aspx.cs` | NEW code-behind |
| `BulkUpload.aspx` | NEW page — CSV bulk generation |
| `BulkUpload.aspx.cs` | NEW code-behind |
| `CertificateView.aspx` | Updated — Edit button + PDF download |
| `CertificateView.aspx.cs` | Updated — PDF download logic |

---

## STEP 1 — Run the SQL Script

1. Open **SSMS**
2. Connect to your database
3. Open `SQL_AlterTable.sql`
4. Click **Execute (F5)**

This adds: `StudentEmail`, `StudentBatch`, and ensures `CertificateType` exists.

---

## STEP 2 — Install SelectPdf (for PDF download)

In Visual Studio:

1. Go to **Tools → NuGet Package Manager → Package Manager Console**
2. Run:
   ```
   Install-Package SelectPdf
   ```

That's it. The PDF download button on CertificateView will now work.

---

## STEP 3 — Replace Files

Copy each file from this folder into your Visual Studio project, replacing the existing ones.
For NEW files (CreateCertificate, AllCertificates, BulkUpload), add them to the root of your project.

**In Solution Explorer**, right-click the project → **Add → Existing Item** for each new file.
Make sure to add BOTH the `.aspx` AND `.aspx.cs` for each page.

---

## STEP 4 — Check Your Blank.Master

Your `CertificateView.aspx` uses `Blank.Master`. Make sure that master page still exists and has a `ContentPlaceHolder1`.
If it doesn't exist, change `MasterPageFile="~/Blank.Master"` to `MasterPageFile="~/Home.Master"` in CertificateView.aspx.

---

## STEP 5 — Build & Test

1. Build the solution (**Ctrl+Shift+B**)
2. Fix any namespace errors if they appear
3. Run the project (**F5**)

---

## NAVIGATION CHANGES

The old `Default.aspx` is now the **dashboard home**.

| Old | New |
|-----|-----|
| Default.aspx (form) | CreateCertificate.aspx |
| Default.aspx (grid) | AllCertificates.aspx |
| CertificateDetails.aspx | Not changed (keep as-is) |
| CertificateView.aspx | Updated (same URL) |

The sidebar automatically highlights the active page.

---

## HOW TO USE BULK UPLOAD

1. Go to **Bulk Upload** in the sidebar
2. Download the CSV template
3. Fill it in Excel, save as CSV
4. Upload → Preview → Generate All

CSV columns: `PersonName`, `StudentEmail`, `WorkshopName`, `IssueDate` (yyyy-MM-dd), `StudentBatch`

---

## HOW EDIT WORKS

- From **AllCertificates**, click the ✏️ Edit button next to any certificate
- This opens `CreateCertificate.aspx?edit=ID` with all fields pre-filled
- Make changes → click **Update Certificate**

---

## EMAIL (unchanged)

Your Gmail SMTP credentials are still in `AllCertificates.aspx.cs`.
The email button on the All Certificates page will pre-fill the student email if it was saved.

---

## CERTIFICATE TYPES

| Type | Used for |
|------|---------|
| Participation | Workshops, events, seminars |
| Achievement | Awards, competitions, honours |
| Academic | Degrees, diplomas — adds Batch field |
| Completion | Online courses, training programs |
