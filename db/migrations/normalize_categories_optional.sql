-- Normalized design with separate category table
-- Only use this if you need better category management or multi-language support

-- Step 1: Create category table
CREATE TABLE IF NOT EXISTS `document_category` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `category_key` VARCHAR(50) NOT NULL UNIQUE,
  `category_name` VARCHAR(100) NOT NULL,
  `display_order` INT NOT NULL DEFAULT 0,
  `description` TEXT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_key` (`category_key`),
  INDEX `idx_order` (`display_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Step 2: Populate category table from existing document_type data
INSERT INTO `document_category` (`category_key`, `category_name`, `display_order`)
SELECT DISTINCT 
  `category_key`, 
  `category_name`,
  MIN(`display_order`) as display_order
FROM `document_type`
WHERE `category_key` IS NOT NULL
GROUP BY `category_key`, `category_name`
ORDER BY MIN(`display_order`);

-- Step 3: Modify document_type table
ALTER TABLE `document_type`
  ADD COLUMN `fk_category_id` INT NULL AFTER `name`,
  ADD CONSTRAINT `fk_document_category` 
    FOREIGN KEY (`fk_category_id`) 
    REFERENCES `document_category`(`id`)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE;

-- Step 4: Populate foreign key relationships
UPDATE `document_type` dt
INNER JOIN `document_category` dc ON dt.category_key = dc.category_key
SET dt.fk_category_id = dc.id;

-- Step 5: (Optional) Remove redundant columns after verifying data
-- Make sure to update your backend code before running this!
-- ALTER TABLE `document_type`
--   DROP COLUMN `category_key`,
--   DROP COLUMN `category_name`,
--   MODIFY COLUMN `fk_category_id` INT NOT NULL;

-- Benefits:
-- 1. No data redundancy - category name stored once
-- 2. Easy to rename categories globally
-- 3. Can add category metadata (descriptions, icons, etc.)
-- 4. Referential integrity with foreign keys
-- 5. Better for multi-language support

-- Drawbacks:
-- 1. Requires JOIN for every category query
-- 2. More complex backend code
-- 3. Overkill for small datasets (<100 documents)
