-- Migration: Add Employee Transfer System
-- Date: 2026-01-18
-- Purpose: Track employee transfers with backup and delete functionality

CREATE TABLE IF NOT EXISTS `employee_transfer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_emp_id` INT NOT NULL COMMENT 'Employee being transferred',
  `transfer_type` ENUM('regular', 'pleasant') NOT NULL DEFAULT 'regular',
  `from_location` VARCHAR(255) DEFAULT NULL,
  `to_location` VARCHAR(255) NOT NULL,
  `transfer_date` DATE NOT NULL,
  `reason` TEXT DEFAULT NULL,
  `requested_by` VARCHAR(255) DEFAULT NULL,
  `approved_by` VARCHAR(255) DEFAULT NULL,
  `approval_date` DATE DEFAULT NULL,
  `transfer_status` ENUM('pending', 'approved', 'completed', 'cancelled') DEFAULT 'pending',
  `remarks` TEXT DEFAULT NULL,
  `is_data_backed_up` BOOLEAN DEFAULT FALSE,
  `backup_date` TIMESTAMP NULL DEFAULT NULL,
  `backup_file_path` VARCHAR(500) DEFAULT NULL,
  `is_deleted` BOOLEAN DEFAULT FALSE,
  `deleted_date` TIMESTAMP NULL DEFAULT NULL,
  `created_by_user_id` INT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`fk_emp_id`) REFERENCES `employee`(`id`) ON DELETE CASCADE,
  KEY `idx_emp_transfer` (`fk_emp_id`, `transfer_status`),
  KEY `idx_transfer_date` (`transfer_date`),
  KEY `idx_transfer_type` (`transfer_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Employee transfer records with backup tracking';

-- Add transfer_status column to employee table if it doesn't exist
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'employee' 
  AND COLUMN_NAME = 'transfer_status';

SET @query = IF(@col_exists = 0, 
  'ALTER TABLE `employee` ADD COLUMN `transfer_status` ENUM(''active'', ''transferred'', ''on_transfer'') DEFAULT ''active''',
  'SELECT ''Column transfer_status already exists'' AS message');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add index for transfer_status
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'employee' 
  AND INDEX_NAME = 'idx_employee_transfer_status';

SET @query = IF(@index_exists = 0,
  'CREATE INDEX idx_employee_transfer_status ON employee(transfer_status)',
  'SELECT ''Index idx_employee_transfer_status already exists'' AS message');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
