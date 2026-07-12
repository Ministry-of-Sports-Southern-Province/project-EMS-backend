-- =====================================================
-- Migration: Add Class Progression to Salary Scales
-- Description: Allows salary scales to define automatic class promotions based on step ranges
-- Date: 2025-12-30
-- Example: MT 2 has Class III (steps 1-11), Class II (steps 12-21), Class I (steps 22-40+)
-- =====================================================

-- Create table for class progression configuration
CREATE TABLE IF NOT EXISTS `salary_scale_class_progression` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_salary_scale_id` INT NOT NULL,
  `fk_job_class_id` INT NOT NULL,
  `from_step` INT NOT NULL,
  `to_step` INT NOT NULL,
  `starting_basic` DECIMAL(10,2) NOT NULL,
  `final_basic` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_salary_scale_class_progression_scale` (`fk_salary_scale_id`),
  KEY `idx_salary_scale_class_progression_class` (`fk_job_class_id`),
  CONSTRAINT `fk_salary_scale_class_progression_scale` FOREIGN KEY (`fk_salary_scale_id`) 
    REFERENCES `salary_scale` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_salary_scale_class_progression_class` FOREIGN KEY (`fk_job_class_id`) 
    REFERENCES `job_class` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add a flag to salary_scale to indicate if it has class progression
ALTER TABLE `salary_scale` 
  ADD COLUMN `has_class_progression` TINYINT(1) DEFAULT 0 AFTER `effective_to`;

-- =====================================================
-- Migration Complete
-- =====================================================
