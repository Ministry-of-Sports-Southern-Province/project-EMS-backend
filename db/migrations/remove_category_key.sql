-- Migration: Remove category_key column from document_category and document_type tables
-- Date: 2024
-- Reason: Simplified design to use only numeric IDs instead of maintaining both key and ID

-- Step 1: Remove category_key from document_type table (if exists)
-- This column was previously used to store category keys but is now redundant with fk_category_id
SET @col_exists = (SELECT COUNT(*) 
                   FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_SCHEMA = 'project_ems' 
                   AND TABLE_NAME = 'document_type' 
                   AND COLUMN_NAME = 'category_key');

SET @sql = IF(@col_exists > 0,
    'ALTER TABLE document_type DROP COLUMN category_key;',
    'SELECT "Column category_key does not exist in document_type" as message;');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 2: Remove category_name from document_type table (if exists)
-- This column is redundant with the foreign key relationship to document_category
SET @col_exists = (SELECT COUNT(*) 
                   FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_SCHEMA = 'project_ems' 
                   AND TABLE_NAME = 'document_type' 
                   AND COLUMN_NAME = 'category_name');

SET @sql = IF(@col_exists > 0,
    'ALTER TABLE document_type DROP COLUMN category_name;',
    'SELECT "Column category_name does not exist in document_type" as message;');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 3: Remove category_key from document_category table (if exists)
-- This column was used as a unique identifier but is redundant with the numeric ID
SET @col_exists = (SELECT COUNT(*) 
                   FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_SCHEMA = 'project_ems' 
                   AND TABLE_NAME = 'document_category' 
                   AND COLUMN_NAME = 'category_key');

SET @sql = IF(@col_exists > 0,
    'ALTER TABLE document_category DROP COLUMN category_key;',
    'SELECT "Column category_key does not exist in document_category" as message;');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verify the changes
SELECT 'Migration complete. Remaining columns in document_category:' as message;
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'project_ems' 
AND TABLE_NAME = 'document_category'
ORDER BY ORDINAL_POSITION;

SELECT 'Remaining columns in document_type:' as message;
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'project_ems' 
AND TABLE_NAME = 'document_type'
ORDER BY ORDINAL_POSITION;
