-- =====================================================
-- Migration: Add Efficiency Bar Requirements to Job Classes
-- Description: Track EB exam requirements and eligible periods per class
-- Date: 2026-01-09
-- =====================================================

-- Add efficiency bar requirement columns to job_class table
ALTER TABLE `job_class` 
  ADD COLUMN `requires_efficiency_bar` TINYINT(1) DEFAULT 0 AFTER `hierarchy_order`,
  ADD COLUMN `eb_level` ENUM('I', 'II', 'III') DEFAULT NULL AFTER `requires_efficiency_bar`,
  ADD COLUMN `eb_eligible_period_years` INT DEFAULT NULL COMMENT 'Years in class before eligible for EB exam' AFTER `eb_level`,
  ADD COLUMN `eb_grace_period_years` INT DEFAULT NULL COMMENT 'Grace period to pass EB exam before increment block' AFTER `eb_eligible_period_years`,
  ADD COLUMN `blocks_increment_if_failed` TINYINT(1) DEFAULT 0 COMMENT 'Whether failing EB blocks salary increments' AFTER `eb_grace_period_years`;

-- =====================================================
-- Example Usage:
-- Class III: EB Level I required after 3 years of service, 3 year grace period
-- Class II:  EB Level II required after 3 years in class, 3 year grace period  
-- Class I:   EB Level III required after 3 years in class, 3 year grace period
-- =====================================================

-- Migration Complete
-- =====================================================
