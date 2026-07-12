-- Safe migration: Create document_category table with existence checks
-- This version checks for existing structures before creating

-- Step 1: Create document_category table if it doesn't exist
CREATE TABLE IF NOT EXISTS `document_category` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `category_key` VARCHAR(50) NOT NULL UNIQUE,
  `category_name` VARCHAR(100) NOT NULL,
  `display_order` INT NOT NULL DEFAULT 0,
  `description` TEXT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_category_key` (`category_key`),
  INDEX `idx_display_order` (`display_order`),
  INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Step 2: Populate categories from document_type if category table is empty
INSERT IGNORE INTO `document_category` (`category_key`, `category_name`, `display_order`)
SELECT DISTINCT 
  `category_key` COLLATE utf8mb4_0900_ai_ci, 
  `category_name` COLLATE utf8mb4_0900_ai_ci,
  MIN(`display_order`) as display_order
FROM `document_type`
WHERE `category_key` IS NOT NULL
GROUP BY `category_key`, `category_name`
ORDER BY MIN(`display_order`);

-- Step 3: Add foreign key column if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND column_name = 'fk_category_id') = 0,
    'ALTER TABLE `document_type` ADD COLUMN `fk_category_id` INT NULL AFTER `name`',
    'SELECT "Column fk_category_id already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Step 4: Populate foreign key relationships where null
UPDATE `document_type` dt
INNER JOIN `document_category` dc ON dt.category_key COLLATE utf8mb4_0900_ai_ci = dc.category_key
SET dt.fk_category_id = dc.id
WHERE dt.fk_category_id IS NULL;

-- Step 5: Add foreign key constraint if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
     WHERE table_schema = DATABASE()
       AND table_name = 'document_type'
       AND constraint_name = 'fk_document_category') = 0,
    'ALTER TABLE `document_type` 
     MODIFY COLUMN `fk_category_id` INT NOT NULL,
     ADD CONSTRAINT `fk_document_category` 
       FOREIGN KEY (`fk_category_id`) 
       REFERENCES `document_category`(`id`)
       ON DELETE RESTRICT 
       ON UPDATE CASCADE',
    'SELECT "Foreign key constraint already exists" AS info'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SELECT '✅ Document category table created and relationships established!' AS result;
