-- Populate document_type table with all document types from config
-- This can be run safely multiple times as it truncates first

TRUNCATE TABLE `document_type`;

-- Category 1: Recruitment & Appointment Documents
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(1, 'Appointment letter', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 1, 0, 1),
(2, 'Letter of acceptance of appointment', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 2, 0, 1),
(3, 'Oath or affirmation', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 3, 0, 1),
(4, 'The agreement', 'recruitment', 'Category 1 – Recruitment & Appointment Documents', 4, 0, 1);

-- Category 2: Personal & Health Records
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(5, 'Medical record', 'personal', 'Category 2 – Personal & Health Records', 5, 0, 1),
(6, 'Asset declaration', 'personal', 'Category 2 – Personal & Health Records', 6, 0, 1),
(7, 'Behavior and note sheets', 'personal', 'Category 2 – Personal & Health Records', 7, 0, 1);

-- Category 3: Personal Identification Documents
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(8, 'Original copy of birth certificate', 'identification', 'Category 3 – Personal Identification Documents', 8, 0, 1),
(9, 'Copy of National Identity Card', 'identification', 'Category 3 – Personal Identification Documents', 9, 0, 1);

-- Category 4: Family Information Documents
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(10, 'Widow\'s and Orphan\'s Pension Number', 'family', 'Category 4 – Family Information Documents', 10, 0, 1),
(11, 'Marriage certificate', 'family', 'Category 4 – Family Information Documents', 11, 0, 1),
(12, 'Spouse\'s birth certificate', 'family', 'Category 4 – Family Information Documents', 12, 0, 1),
(13, 'Copy of Spouse\'s National Identity Card', 'family', 'Category 4 – Family Information Documents', 13, 0, 1),
(14, 'Children\'s birth certificates', 'family', 'Category 4 – Family Information Documents', 14, 1, 1);

-- Category 5: Conduct & Recognition Records
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(15, 'Letters of Commendations and Censures', 'conduct', 'Category 5 – Conduct & Recognition Records', 15, 0, 1);

-- Category 6: Educational & Qualification Records
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(16, 'Copy of GCE O/L certificate', 'education', 'Category 6 – Educational & Qualification Records', 16, 0, 1),
(17, 'Letter of acceptance of certificate (O/L)', 'education', 'Category 6 – Educational & Qualification Records', 17, 0, 1),
(18, 'Copy of GCE A/L certificate', 'education', 'Category 6 – Educational & Qualification Records', 18, 0, 1),
(19, 'Letter of acceptance of certificate (A/L)', 'education', 'Category 6 – Educational & Qualification Records', 19, 0, 1),
(20, 'Copy of graduation certificate', 'education', 'Category 6 – Educational & Qualification Records', 20, 0, 1),
(21, 'Letter of acceptance of certificate (Graduation)', 'education', 'Category 6 – Educational & Qualification Records', 21, 0, 1);

-- Category 7: Service & Career Progression Records
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(22, 'Confirmation of appointment', 'service', 'Category 7 – Service & Career Progression Records', 22, 0, 1),
(23, 'Letter regarding efficiency barrage flax', 'service', 'Category 7 – Service & Career Progression Records', 23, 0, 1),
(24, 'Salary increment deferral letters', 'service', 'Category 7 – Service & Career Progression Records', 24, 0, 1),
(25, 'Language proficiency certificates', 'service', 'Category 7 – Service & Career Progression Records', 25, 0, 1),
(26, 'Referee licenses', 'service', 'Category 7 – Service & Career Progression Records', 26, 0, 1),
(27, 'Certificates of efficiency bar tests', 'service', 'Category 7 – Service & Career Progression Records', 27, 0, 1),
(28, 'Promotion certificates', 'service', 'Category 7 – Service & Career Progression Records', 28, 0, 1),
(29, 'Salary Promotion Letters', 'service', 'Category 7 – Service & Career Progression Records', 29, 0, 1);

-- Category 8: Leave & Disciplinary Records
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(30, 'Letters on half-pay and unpaid leave', 'leave', 'Category 8 – Leave & Disciplinary Records', 30, 0, 1),
(31, 'Leaving service or disciplinary orders', 'leave', 'Category 8 – Leave & Disciplinary Records', 31, 0, 1);

-- Category 9: Organizational & Financial Information
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(32, 'Letters of incorporation', 'organizational', 'Category 9 – Organizational & Financial Information', 32, 0, 1),
(33, 'Credit Card Information', 'organizational', 'Category 9 – Organizational & Financial Information', 33, 0, 1),
(34, 'Retirement Information', 'organizational', 'Category 9 – Organizational & Financial Information', 34, 0, 1);

-- Category 10: Efficiency Bar Exam
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(35, 'EB Level I', 'efficiency', 'Category 10 – Efficiency Bar Exam', 35, 0, 1),
(36, 'EB Level II', 'efficiency', 'Category 10 – Efficiency Bar Exam', 36, 0, 1),
(37, 'EB Level III', 'efficiency', 'Category 10 – Efficiency Bar Exam', 37, 0, 1);

-- Category 11: Promotion Class
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(38, 'Promotion Class III', 'promotion', 'Category 11 – Promotion Class', 38, 0, 1),
(39, 'Promotion Class II', 'promotion', 'Category 11 – Promotion Class', 39, 0, 1),
(40, 'Promotion Class I', 'promotion', 'Category 11 – Promotion Class', 40, 0, 1);

-- Category 12: Salary Increment
INSERT INTO `document_type` (id, name, category_key, category_name, display_order, is_variable, is_active) VALUES
(41, 'Salary Increment Class III', 'salary', 'Category 12 – Salary Increment', 41, 0, 1),
(42, 'Salary Increment Class II', 'salary', 'Category 12 – Salary Increment', 42, 0, 1),
(43, 'Salary Increment Class I', 'salary', 'Category 12 – Salary Increment', 43, 0, 1);

-- Reset auto increment
ALTER TABLE `document_type` AUTO_INCREMENT = 44;

SELECT '✅ Successfully populated document_type table with 43 entries!' AS result;
