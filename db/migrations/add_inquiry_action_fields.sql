-- Migration: Add inquiry action control fields
-- Description: Adds fields to control specific actions (hold increment, hold salary, disable employment) when inquiry is active
-- Date: 2024-01-15

USE project_ems;

-- Add three new TINYINT fields for inquiry action controls
ALTER TABLE employee_career 
ADD COLUMN IF NOT EXISTS hold_increment TINYINT(1) DEFAULT 0 COMMENT 'Prevents salary increments when set to 1',
ADD COLUMN IF NOT EXISTS hold_salary TINYINT(1) DEFAULT 0 COMMENT 'Suspends salary payments when set to 1',
ADD COLUMN IF NOT EXISTS disable_employment TINYINT(1) DEFAULT 0 COMMENT 'Suspends employment status when set to 1';

-- Update existing records to default values (0 = not held)
UPDATE employee_career 
SET hold_increment = 0, 
    hold_salary = 0, 
    disable_employment = 0 
WHERE hold_increment IS NULL 
   OR hold_salary IS NULL 
   OR disable_employment IS NULL;

-- Verification query
SELECT 
    'Migration completed successfully' AS status,
    COUNT(*) AS total_records,
    SUM(CASE WHEN hold_increment = 0 THEN 1 ELSE 0 END) AS normal_increment,
    SUM(CASE WHEN hold_increment = 1 THEN 1 ELSE 0 END) AS held_increment,
    SUM(CASE WHEN hold_salary = 1 THEN 1 ELSE 0 END) AS held_salary,
    SUM(CASE WHEN disable_employment = 1 THEN 1 ELSE 0 END) AS disabled_employment
FROM employee_career;
