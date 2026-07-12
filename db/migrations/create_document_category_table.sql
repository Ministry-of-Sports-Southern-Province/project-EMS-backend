-- Create document_category table and normalize the structure
-- This migration creates a separate table for categories and establishes relationships

-- Step 1: Create document_category table
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

-- Step 2: Extract and populate unique categories from document_type
INSERT INTO `document_category` (`category_key`, `category_name`, `display_order`)
SELECT DISTINCT 
  `category_key`, 
  `category_name`,
  MIN(`display_order`) as display_order
FROM `document_type`
WHERE `category_key` IS NOT NULL
GROUP BY `category_key`, `category_name`
ORDER BY MIN(`display_order`)
ON DUPLICATE KEY UPDATE 
  `category_name` = VALUES(`category_name`),
  `display_order` = VALUES(`display_order`);

-- Step 3: Add foreign key column to document_type
ALTER TABLE `document_type`
  ADD COLUMN `fk_category_id` INT NULL AFTER `name`;

-- Step 4: Populate the foreign key relationships
UPDATE `document_type` dt
INNER JOIN `document_category` dc ON dt.category_key = dc.category_key
SET dt.fk_category_id = dc.id;

-- Step 5: Make foreign key NOT NULL and add constraint
ALTER TABLE `document_type`
  MODIFY COLUMN `fk_category_id` INT NOT NULL,
  ADD CONSTRAINT `fk_document_category` 
    FOREIGN KEY (`fk_category_id`) 
    REFERENCES `document_category`(`id`)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE;

-- Step 6: Keep old columns for backward compatibility (can be removed later after code update)
-- The old category_key and category_name columns remain but are now redundant
-- Remove them once all code is updated to use the category table

SELECT 'Migration completed successfully! Document categories normalized.' AS result;
