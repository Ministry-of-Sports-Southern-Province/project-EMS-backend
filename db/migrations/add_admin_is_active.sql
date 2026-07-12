-- Migration: Add is_active column to admin table for enable/disable functionality

ALTER TABLE `admin` 
ADD COLUMN `is_active` TINYINT(1) NOT NULL DEFAULT 1 AFTER `password_hash`;

-- Update existing admins to be active
UPDATE `admin` SET `is_active` = 1 WHERE `is_active` IS NULL;
