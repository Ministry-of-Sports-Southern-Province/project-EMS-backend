-- Migration: Remove from_location column from employee_transfer
-- Date: 2026-01-18
-- Purpose: Simplify transfer system by removing unnecessary from_location field

ALTER TABLE `employee_transfer` DROP COLUMN IF EXISTS `from_location`;
