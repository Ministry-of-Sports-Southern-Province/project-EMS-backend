-- =====================================================
-- Position Tracking Enhancement Migration
-- =====================================================
-- Adds comprehensive position tracking fields to employee_career
-- Includes: class promotion date, salary progression, EB status, inquiry tracking

-- Add position tracking fields to employee_career table
ALTER TABLE `employee_career`
ADD COLUMN `current_class_promotion_date` DATE NULL 
  COMMENT 'Date when promoted to current job class',
ADD COLUMN `fk_current_salary_phase_id` INT NULL 
  COMMENT 'Current salary increment phase',
ADD COLUMN `current_salary_year_in_phase` INT NULL 
  COMMENT 'Year within current salary phase (1 to phase.years)',
ADD COLUMN `eb_exam_status` ENUM('Not Done', 'EB I', 'EB II', 'EB III') DEFAULT 'Not Done' 
  COMMENT 'Highest Efficiency Bar exam cleared',
ADD COLUMN `eb_exam_date` DATE NULL 
  COMMENT 'Date when EB exam was cleared',
ADD COLUMN `has_active_inquiry` BOOLEAN DEFAULT FALSE 
  COMMENT 'Whether employee has active inquiry (blocks promotion)',
ADD COLUMN `inquiry_reason` VARCHAR(500) NULL 
  COMMENT 'Reason/details of active inquiry',
ADD KEY `idx_career_salary_phase` (`fk_current_salary_phase_id`),
ADD CONSTRAINT `fk_career_salary_phase` 
  FOREIGN KEY (`fk_current_salary_phase_id`) 
  REFERENCES `salary_increment_phase` (`id`) 
  ON DELETE SET NULL;

-- Add index for promotion eligibility queries
ALTER TABLE `employee_career`
ADD INDEX `idx_career_promotion_tracking` 
  (`fk_emp_id`, `end_date`, `current_class_promotion_date`);

-- =====================================================
-- Validation and Constraints
-- =====================================================

-- EB exam date should be NULL when status is 'Not Done'
-- This will be enforced at application level

-- current_salary_year_in_phase should be between 1 and phase.years
-- This will be validated at application level

-- inquiry_reason should be NULL when has_active_inquiry is FALSE
-- This will be enforced at application level

-- =====================================================
-- Sample Data Update (if needed)
-- =====================================================
-- Update existing active career records with default values

-- UPDATE employee_career
-- SET 
--   current_class_promotion_date = start_date,
--   eb_exam_status = 'Not Done',
--   has_active_inquiry = FALSE
-- WHERE end_date IS NULL;

-- =====================================================
-- Migration Notes
-- =====================================================
-- 1. Run this migration after promotion_path system is in place
-- 2. fk_current_salary_phase_id references salary_increment_phase.id
-- 3. Phase and year determine current basic salary:
--    current_basic = scale.starting_basic + (phase_increment * (completed_years))
-- 4. Next increment date = current_class_promotion_date + total_years_to_current_point
-- 5. Inquiry blocks promotion regardless of other eligibility
-- 6. EB requirements vary by class (checked at application level)

-- =====================================================
-- Example Query: Calculate Current Basic Salary
-- =====================================================
-- SELECT 
--   e.full_name,
--   ss.starting_basic,
--   sip.annual_increment,
--   ec.current_salary_year_in_phase,
--   -- Calculate completed years up to current phase
--   (SELECT SUM(years) 
--    FROM salary_increment_phase 
--    WHERE fk_salary_scale_id = sip.fk_salary_scale_id 
--      AND phase_order < sip.phase_order) as completed_phase_years,
--   -- Calculate total completed years
--   COALESCE((SELECT SUM(years) 
--    FROM salary_increment_phase 
--    WHERE fk_salary_scale_id = sip.fk_salary_scale_id 
--      AND phase_order < sip.phase_order), 0) + (ec.current_salary_year_in_phase - 1) as total_completed_years,
--   -- Current basic salary
--   ss.starting_basic + (sip.annual_increment * 
--     (COALESCE((SELECT SUM(years) 
--      FROM salary_increment_phase 
--      WHERE fk_salary_scale_id = sip.fk_salary_scale_id 
--        AND phase_order < sip.phase_order), 0) + (ec.current_salary_year_in_phase - 1))
--   ) as current_basic_salary
-- FROM employee e
-- JOIN employee_career ec ON e.id = ec.fk_emp_id AND ec.end_date IS NULL
-- JOIN job_role_class jrc ON ec.fk_job_role_class_id = jrc.id
-- JOIN salary_scale ss ON jrc.fk_salary_scale_id = ss.id
-- LEFT JOIN salary_increment_phase sip ON ec.fk_current_salary_phase_id = sip.id
-- WHERE ec.fk_current_salary_phase_id IS NOT NULL;

COMMIT;
