-- Migration: Add document categories and ordering support (Safe version)
-- Description: Extends document_type table to support categories, ordering, and metadata

-- Step 1: Add new columns to document_type table (only if they don't exist)
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'category_key') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `category_key` VARCHAR(50) NULL AFTER `name`',
    'SELECT "Column category_key already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'category_name') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `category_name` VARCHAR(100) NULL AFTER `category_key`',
    'SELECT "Column category_name already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'display_order') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `display_order` INT NOT NULL DEFAULT 0 AFTER `category_name`',
    'SELECT "Column display_order already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'is_variable') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `is_variable` TINYINT(1) NOT NULL DEFAULT 0 AFTER `display_order`',
    'SELECT "Column is_variable already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'is_active') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `is_active` TINYINT(1) NOT NULL DEFAULT 1 AFTER `is_variable`',
    'SELECT "Column is_active already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'created_at') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER `is_active`',
    'SELECT "Column created_at already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'updated_at') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`',
    'SELECT "Column updated_at already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Step 2: Update existing records with proper category and ordering information
UPDATE `document_type` SET 
    `category_key` = 'recruitment',
    `category_name` = 'Category 1 – Recruitment & Appointment Documents',
    `display_order` = CASE `name`
        WHEN 'Appointment letter' THEN 1
        WHEN 'Letter of acceptance of appointment' THEN 2
        WHEN 'Oath or affirmation' THEN 3
        WHEN 'The agreement' THEN 4
        ELSE `display_order`
    END,
    `is_active` = 1
WHERE `name` IN ('Appointment letter', 'Letter of acceptance of appointment', 'Oath or affirmation', 'The agreement');

UPDATE `document_type` SET 
    `category_key` = 'personal',
    `category_name` = 'Category 2 – Personal & Health Records',
    `display_order` = CASE `name`
        WHEN 'Medical record' THEN 5
        WHEN 'Asset declaration' THEN 6
        WHEN 'Behavior and note sheets' THEN 7
        ELSE `display_order`
    END,
    `is_active` = 1
WHERE `name` IN ('Medical record', 'Asset declaration', 'Behavior and note sheets');

-- Add more categories as needed...
-- For any unmapped documents, set default values
UPDATE `document_type` 
SET 
    `category_key` = COALESCE(`category_key`, 'other'),
    `category_name` = COALESCE(`category_name`, 'Other Documents'),
    `display_order` = CASE WHEN `display_order` = 0 THEN `id` + 100 ELSE `display_order` END,
    `is_active` = COALESCE(`is_active`, 1)
WHERE `category_key` IS NULL OR `category_name` IS NULL;

-- Step 3: Add indexes if they don't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND index_name = 'idx_category_order') = 0,
    'CREATE INDEX `idx_category_order` ON `document_type` (`category_key`, `display_order`)',
    'SELECT "Index idx_category_order already exists" AS info'
));
PREPARE createIndexIfNotExists FROM @preparedStatement;
EXECUTE createIndexIfNotExists;
DEALLOCATE PREPARE createIndexIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND index_name = 'idx_active') = 0,
    'CREATE INDEX `idx_active` ON `document_type` (`is_active`)',
    'SELECT "Index idx_active already exists" AS info'
));
PREPARE createIndexIfNotExists FROM @preparedStatement;
EXECUTE createIndexIfNotExists;
DEALLOCATE PREPARE createIndexIfNotExists;

SELECT '✅ Migration completed successfully!' AS result;
