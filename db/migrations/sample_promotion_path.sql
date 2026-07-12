-- Sample Data: Sports Sector Career Progression Path
-- This demonstrates a complete promotion path configuration

-- First, ensure we have the required job roles and classes
-- (Assuming they exist from previous configurations)

-- Insert sample promotion path
INSERT INTO promotion_path (name, department, description, is_active) VALUES
('Sports Sector Career Progression', 'Sports Department', 
 'Standard career path for sports officers from field level to directorship. Includes 4 progressive steps with clear requirements for each promotion.', 
 1);

SET @sports_path_id = LAST_INSERT_ID();

-- Sample data showing the career progression structure
-- Note: You'll need to replace the job_role_id and job_class_id with actual IDs from your database

-- To find your actual IDs, run:
-- SELECT id, name FROM job_role WHERE name LIKE '%Sports%';
-- SELECT id, class_code FROM job_class ORDER BY hierarchy_order;

-- Example structure (replace IDs with your actual values):

/*
-- Step 1: Field Sports Officer (Class III) - Entry Level
INSERT INTO promotion_path_step 
(fk_promotion_path_id, step_order, fk_job_role_id, fk_job_class_id, min_years_required, requirements) 
VALUES 
(@sports_path_id, 1, [Field Sports Officer ID], [Class III ID], NULL, 
 'Initial appointment - Entry level position');

-- Step 2: Sports Coach (Class II) - Mid Level
INSERT INTO promotion_path_step 
(fk_promotion_path_id, step_order, fk_job_role_id, fk_job_class_id, min_years_required, requirements) 
VALUES 
(@sports_path_id, 2, [Sports Coach ID], [Class II ID], 3, 
 'EB Level I cleared, Minimum 3 years as Field Sports Officer');

-- Step 3: District Sports Officer (Class II) - Senior Level
INSERT INTO promotion_path_step 
(fk_promotion_path_id, step_order, fk_job_role_id, fk_job_class_id, min_years_required, requirements) 
VALUES 
(@sports_path_id, 3, [District Sports Officer ID], [Class II ID], 5, 
 'EB Level II cleared, Minimum 5 years total service in department');

-- Step 4: Assistant Sports Director - Technical (Class I) - Management Level
INSERT INTO promotion_path_step 
(fk_promotion_path_id, step_order, fk_job_role_id, fk_job_class_id, min_years_required, requirements) 
VALUES 
(@sports_path_id, 4, [Asst Sports Director ID], [Class I ID], 8, 
 'EB Level III cleared, Degree in Sports Science or related field, Minimum 8 years total service');
*/

-- Query to verify the path was created
SELECT 
  pp.id,
  pp.name,
  pp.department,
  pp.is_active,
  COUNT(pps.id) as total_steps
FROM promotion_path pp
LEFT JOIN promotion_path_step pps ON pp.id = pps.fk_promotion_path_id
WHERE pp.name = 'Sports Sector Career Progression'
GROUP BY pp.id;

-- To view the complete path structure (after inserting steps):
/*
SELECT 
  pp.name as path_name,
  pps.step_order,
  jr.name as role_name,
  jc.class_code,
  pps.min_years_required,
  pps.requirements
FROM promotion_path pp
INNER JOIN promotion_path_step pps ON pp.id = pps.fk_promotion_path_id
INNER JOIN job_role jr ON pps.fk_job_role_id = jr.id
INNER JOIN job_class jc ON pps.fk_job_class_id = jc.id
WHERE pp.name = 'Sports Sector Career Progression'
ORDER BY pps.step_order;
*/

-- Visual representation of the path:
-- Step 1: Field Sports Officer (Class III)
--    ↓ (3 years + EB Level I)
-- Step 2: Sports Coach (Class II)
--    ↓ (5 years total + EB Level II)
-- Step 3: District Sports Officer (Class II)
--    ↓ (8 years total + EB Level III + Degree)
-- Step 4: Assistant Sports Director - Technical (Class I)
