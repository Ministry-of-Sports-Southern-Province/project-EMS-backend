-- Migration: Add document categories and ordering support
-- Description: Extends document_type table to support categories, ordering, and metadata

-- Step 1: Add new columns to document_type table
ALTER TABLE `document_type` 
ADD COLUMN `category_key` VARCHAR(50) NULL AFTER `name`,
ADD COLUMN `category_name` VARCHAR(100) NULL AFTER `category_key`,
ADD COLUMN `display_order` INT NOT NULL DEFAULT 0 AFTER `category_name`,
ADD COLUMN `is_variable` TINYINT(1) NOT NULL DEFAULT 0 AFTER `display_order`,
ADD COLUMN `is_active` TINYINT(1) NOT NULL DEFAULT 1 AFTER `is_variable`,
ADD COLUMN `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER `is_active`,
ADD COLUMN `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;

-- Step 2: Clear existing data
TRUNCATE TABLE `document_type`;

-- Step 3: Insert document types from config with proper categorization and ordering

-- Category 1: Recruitment & Appointment Documents
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(1, 'Appointment letter', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 1),
(2, 'Letter of acceptance of appointment', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 2),
(3, 'Oath or affirmation', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 3),
(4, 'The agreement', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 4);

-- Category 2: Personal & Health Records
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(5, 'Medical record', 'personal', 'Category 2 – Personal & Health Records', 5),
(6, 'Asset declaration', 'personal', 'Category 2 – Personal & Health Records', 6),
(7, 'Behavior and note sheets', 'personal', 'Category 2 – Personal & Health Records', 7);

-- Category 3: Personal Identification Documents
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(8, 'Original copy of birth certificate', 'identification', 'Category 3 – Personal Identification Documents', 8),
(9, 'Copy of National Identity Card', 'identification', 'Category 3 – Personal Identification Documents', 9);

-- Category 4: Family Information Documents
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`, `is_variable`) VALUES
(10, 'Widow\'s and Orphan\'s Pension Number', 'family', 'Category 4 – Family Information Documents', 10, 0),
(11, 'Marriage certificate', 'family', 'Category 4 – Family Information Documents', 11, 0),
(12, 'Spouse\'s birth certificate', 'family', 'Category 4 – Family Information Documents', 12, 0),
(13, 'Copy of Spouse\'s National Identity Card', 'family', 'Category 4 – Family Information Documents', 13, 0),
(14, 'Children\'s birth certificates', 'family', 'Category 4 – Family Information Documents', 14, 1);

-- Category 5: Conduct & Recognition Records
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(15, 'Letters of Commendations and Censures', 'conduct', 'Category 5 – Conduct & Recognition Records', 15);

-- Category 6: Educational & Qualification Records
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(16, 'Copy of GCE O/L certificate', 'education', 'Category 6 – Educational & Qualification Records', 16),
(17, 'Letter of acceptance of certificate (O/L)', 'education', 'Category 6 – Educational & Qualification Records', 17),
(18, 'Copy of GCE A/L certificate', 'education', 'Category 6 – Educational & Qualification Records', 18),
(19, 'Letter of acceptance of certificate (A/L)', 'education', 'Category 6 – Educational & Qualification Records', 19),
(20, 'Copy of graduation certificate', 'education', 'Category 6 – Educational & Qualification Records', 20),
(21, 'Letter of acceptance of certificate (Graduation)', 'education', 'Category 6 – Educational & Qualification Records', 21);

-- Category 7: Service & Career Progression Records
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(22, 'Confirmation of appointment', 'service', 'Category 7 – Service & Career Progression Records', 22),
(23, 'Letter regarding efficiency barrage flax', 'service', 'Category 7 – Service & Career Progression Records', 23),
(24, 'Salary increment deferral letters', 'service', 'Category 7 – Service & Career Progression Records', 24),
(25, 'Language proficiency certificates', 'service', 'Category 7 – Service & Career Progression Records', 25),
(26, 'Referee licenses', 'service', 'Category 7 – Service & Career Progression Records', 26),
(27, 'Certificates of efficiency bar tests', 'service', 'Category 7 – Service & Career Progression Records', 27),
(28, 'Promotion certificates', 'service', 'Category 7 – Service & Career Progression Records', 28),
(29, 'Salary Promotion Letters', 'service', 'Category 7 – Service & Career Progression Records', 29);

-- Category 8: Leave & Disciplinary Records
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(30, 'Letters on half-pay and unpaid leave', 'leave', 'Category 8 – Leave & Disciplinary Records', 30),
(31, 'Leaving service or disciplinary orders', 'leave', 'Category 8 – Leave & Disciplinary Records', 31);

-- Category 9: Organizational & Financial Information
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(32, 'Letters of incorporation', 'organizational', 'Category 9 – Organizational & Financial Information', 32),
(33, 'Credit Card Information', 'organizational', 'Category 9 – Organizational & Financial Information', 33),
(34, 'Retirement Information', 'organizational', 'Category 9 – Organizational & Financial Information', 34);

-- Category 10: Efficiency Bar Exam
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(35, 'EB Level I', 'efficiency', 'Category 10 – Efficiency Bar Exam', 35),
(36, 'EB Level II', 'efficiency', 'Category 10 – Efficiency Bar Exam', 36),
(37, 'EB Level III', 'efficiency', 'Category 10 – Efficiency Bar Exam', 37);

-- Category 11: Promotion Class
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(38, 'Promotion Class III', 'promotion', 'Category 11 – Promotion Class', 38),
(39, 'Promotion Class II', 'promotion', 'Category 11 – Promotion Class', 39),
(40, 'Promotion Class I', 'promotion', 'Category 11 – Promotion Class', 40);

-- Category 12: Salary Increment
INSERT INTO `document_type` (`id`, `name`, `category_key`, `category_name`, `display_order`) VALUES
(41, 'Salary Increment Class III', 'salary', 'Category 12 – Salary Increment', 41),
(42, 'Salary Increment Class II', 'salary', 'Category 12 – Salary Increment', 42),
(43, 'Salary Increment Class I', 'salary', 'Category 12 – Salary Increment', 43);

-- Step 4: Reset AUTO_INCREMENT
ALTER TABLE `document_type` AUTO_INCREMENT = 44;

-- Step 5: Add index for better query performance
CREATE INDEX `idx_category_order` ON `document_type` (`category_key`, `display_order`);
CREATE INDEX `idx_active` ON `document_type` (`is_active`);
