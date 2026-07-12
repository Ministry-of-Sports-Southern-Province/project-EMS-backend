-- Migration: Add Promotion Path System
-- Date: 2026-01-11
-- Purpose: Configure department-specific promotion flows

-- Table: promotion_path
-- Stores promotion flow definitions (e.g., "Sports Sector Career Path")
CREATE TABLE IF NOT EXISTS `promotion_path` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL COMMENT 'e.g., Sports Sector Career Path',
  `department` VARCHAR(255) NOT NULL COMMENT 'e.g., Sports Department',
  `description` TEXT DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_path_name` (`name`),
  KEY `idx_department` (`department`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: promotion_path_step
-- Stores individual steps/roles in the promotion path
CREATE TABLE IF NOT EXISTS `promotion_path_step` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_promotion_path_id` INT NOT NULL,
  `step_order` INT NOT NULL COMMENT 'Sequence: 1, 2, 3...',
  `fk_job_role_id` INT NOT NULL COMMENT 'Role at this step',
  `fk_job_class_id` INT NOT NULL COMMENT 'Class at this step',
  `min_years_required` INT DEFAULT NULL COMMENT 'Minimum years in previous step',
  `requirements` TEXT DEFAULT NULL COMMENT 'Additional requirements (EB, qualifications)',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_step_in_path` (`fk_promotion_path_id`, `step_order`),
  KEY `fk_promotion_path_id` (`fk_promotion_path_id`),
  KEY `fk_job_role_id` (`fk_job_role_id`),
  KEY `fk_job_class_id` (`fk_job_class_id`),
  CONSTRAINT `fk_path_step_promotion_path` 
    FOREIGN KEY (`fk_promotion_path_id`) 
    REFERENCES `promotion_path` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT `fk_path_step_job_role` 
    FOREIGN KEY (`fk_job_role_id`) 
    REFERENCES `job_role` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT `fk_path_step_job_class` 
    FOREIGN KEY (`fk_job_class_id`) 
    REFERENCES `job_class` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Add promotion path tracking to employee_career
-- Check if columns exist before adding
SET @dbname = DATABASE();
SET @tablename = "employee_career";
SET @columnname1 = "fk_promotion_path_id";
SET @columnname2 = "current_path_step";
SET @preparedStatement1 = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE (table_name = @tablename) AND (table_schema = @dbname) AND (column_name = @columnname1)
  ) > 0,
  "SELECT 'Column fk_promotion_path_id already exists';",
  "ALTER TABLE employee_career ADD COLUMN fk_promotion_path_id INT DEFAULT NULL COMMENT 'Assigned promotion path' AFTER fk_job_role_class_id;"
));
PREPARE alterIfNotExists1 FROM @preparedStatement1;
EXECUTE alterIfNotExists1;
DEALLOCATE PREPARE alterIfNotExists1;

SET @preparedStatement2 = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE (table_name = @tablename) AND (table_schema = @dbname) AND (column_name = @columnname2)
  ) > 0,
  "SELECT 'Column current_path_step already exists';",
  "ALTER TABLE employee_career ADD COLUMN current_path_step INT DEFAULT NULL COMMENT 'Current step in promotion path' AFTER fk_promotion_path_id;"
));
PREPARE alterIfNotExists2 FROM @preparedStatement2;
EXECUTE alterIfNotExists2;
DEALLOCATE PREPARE alterIfNotExists2;

-- Add index
SET @preparedStatement3 = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
    WHERE table_schema = @dbname AND table_name = @tablename AND index_name = 'fk_career_promotion_path'
  ) > 0,
  "SELECT 'Index fk_career_promotion_path already exists';",
  "ALTER TABLE employee_career ADD KEY fk_career_promotion_path (fk_promotion_path_id);"
));
PREPARE alterIfNotExists3 FROM @preparedStatement3;
EXECUTE alterIfNotExists3;
DEALLOCATE PREPARE alterIfNotExists3;

-- Add foreign key constraint if not exists
SET @constraint_exists = (
  SELECT COUNT(*) 
  FROM information_schema.TABLE_CONSTRAINTS 
  WHERE CONSTRAINT_SCHEMA = 'project_ems' 
  AND CONSTRAINT_NAME = 'fk_employee_career_promotion_path'
);

SET @sql = IF(@constraint_exists = 0,
  'ALTER TABLE employee_career 
   ADD CONSTRAINT fk_employee_career_promotion_path 
   FOREIGN KEY (fk_promotion_path_id) 
   REFERENCES promotion_path(id) 
   ON DELETE SET NULL 
   ON UPDATE CASCADE',
  'SELECT "Constraint already exists"'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Sample Data: Sports Sector Career Path
INSERT INTO `promotion_path` (`name`, `department`, `description`, `is_active`) VALUES
('Sports Sector Career Progression', 'Sports Department', 'Standard career path for sports sector officers from field level to directorship', 1);

SET @sports_path_id = LAST_INSERT_ID();

-- Insert promotion path steps (will need actual role and class IDs)
-- Note: These are placeholders - actual IDs should be from your job_role and job_class tables
-- Example structure:
-- INSERT INTO promotion_path_step (fk_promotion_path_id, step_order, fk_job_role_id, fk_job_class_id, min_years_required, requirements) VALUES
-- (@sports_path_id, 1, [Field Sports Officer role ID], [Class III ID], NULL, 'Initial appointment'),
-- (@sports_path_id, 2, [Sports Coach role ID], [Class II ID], 3, 'EB Level I cleared, 3 years as Field Officer'),
-- (@sports_path_id, 3, [District Sports Officer role ID], [Class II ID], 5, 'EB Level II cleared, 5 years total service'),
-- (@sports_path_id, 4, [Assistant Sports Director role ID], [Class I ID], 8, 'EB Level III cleared, 8 years total service');
