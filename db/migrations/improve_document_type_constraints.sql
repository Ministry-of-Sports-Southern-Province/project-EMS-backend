-- Optional improvements for document_type table
-- Run this only if you want stricter data integrity

-- 1. Make category fields NOT NULL (ensures every document has a category)
-- Uncomment if you want to enforce this:
-- ALTER TABLE `document_type` 
--   MODIFY COLUMN `category_key` VARCHAR(50) NOT NULL,
--   MODIFY COLUMN `category_name` VARCHAR(100) NOT NULL;

-- 2. Add CHECK constraint to ensure display_order is positive
-- MySQL 8.0.16+ only:
-- ALTER TABLE `document_type` 
--   ADD CONSTRAINT `chk_display_order` CHECK (`display_order` >= 0);

-- 3. Add CHECK constraint for is_variable and is_active values
-- ALTER TABLE `document_type`
--   ADD CONSTRAINT `chk_is_variable` CHECK (`is_variable` IN (0, 1)),
--   ADD CONSTRAINT `chk_is_active` CHECK (`is_active` IN (0, 1));
