-- =============================================
-- CertifyApp Database Updates
-- Run this script in SSMS against your database
-- =============================================

-- 1. Add StudentEmail column
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Certificates' AND COLUMN_NAME = 'StudentEmail'
)
BEGIN
    ALTER TABLE Certificates ADD StudentEmail NVARCHAR(255) NULL;
    PRINT 'StudentEmail column added.';
END
ELSE
    PRINT 'StudentEmail column already exists.';

-- 2. Add StudentBatch column (e.g. "2024-2025", "Spring 2025")
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Certificates' AND COLUMN_NAME = 'StudentBatch'
)
BEGIN
    ALTER TABLE Certificates ADD StudentBatch NVARCHAR(50) NULL;
    PRINT 'StudentBatch column added.';
END
ELSE
    PRINT 'StudentBatch column already exists.';

-- 3. Ensure CertificateType column exists (you may already have it)
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Certificates' AND COLUMN_NAME = 'CertificateType'
)
BEGIN
    ALTER TABLE Certificates ADD CertificateType NVARCHAR(50) NOT NULL DEFAULT 'Participation';
    PRINT 'CertificateType column added.';
END
ELSE
    PRINT 'CertificateType column already exists.';

-- 4. Verify final table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Certificates'
ORDER BY ORDINAL_POSITION;
