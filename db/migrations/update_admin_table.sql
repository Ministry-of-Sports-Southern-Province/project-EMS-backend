-- Migration: Update admin table - rename username to email and add updated_at timestamp
-- Date: 2026-01-13

-- Rename username column to email
ALTER TABLE `admin` 
CHANGE COLUMN `username` `email` VARCHAR(50) NOT NULL;

-- Rename the unique key constraint
ALTER TABLE `admin`
DROP INDEX `username`,
ADD UNIQUE KEY `email` (`email`);

-- Add updated_at column with ON UPDATE trigger
ALTER TABLE `admin`
ADD COLUMN `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;

-- Update existing record if needed (optional - uncomment if you want to set initial email)
-- UPDATE `admin` SET `email` = 'admin@example.com' WHERE `id` = 1;
