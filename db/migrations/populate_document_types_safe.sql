-- Safe populate that updates existing records instead of truncating
-- Can be run safely even with existing employee_document records

-- First, update any existing records with their category information
-- Category 1: Recruitment & Appointment Documents
UPDATE `document_type` SET 
    category_key = 'recruitment', 
    category_name = 'Category 1 – Recruitment & Appointment Documents',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (1, 2, 3, 4);

-- Category 2: Personal & Health Records
UPDATE `document_type` SET 
    category_key = 'personal', 
    category_name = 'Category 2 – Personal & Health Records',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (5, 6, 7);

-- Category 3: Personal Identification Documents
UPDATE `document_type` SET 
    category_key = 'identification', 
    category_name = 'Category 3 – Personal Identification Documents',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (8, 9);

-- Category 4: Family Information Documents
UPDATE `document_type` SET 
    category_key = 'family', 
    category_name = 'Category 4 – Family Information Documents',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (10, 11, 12, 13);

UPDATE `document_type` SET 
    category_key = 'family', 
    category_name = 'Category 4 – Family Information Documents',
    display_order = 14,
    is_variable = 1,
    is_active = 1
WHERE id = 14;

-- Category 5: Conduct & Recognition Records
UPDATE `document_type` SET 
    category_key = 'conduct', 
    category_name = 'Category 5 – Conduct & Recognition Records',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id = 15;

-- Category 6: Educational & Qualification Records
UPDATE `document_type` SET 
    category_key = 'education', 
    category_name = 'Category 6 – Educational & Qualification Records',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (16, 17, 18, 19, 20, 21);

-- Category 7: Service & Career Progression Records
UPDATE `document_type` SET 
    category_key = 'service', 
    category_name = 'Category 7 – Service & Career Progression Records',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (22, 23, 24, 25, 26, 27, 28, 29);

-- Category 8: Leave & Disciplinary Records
UPDATE `document_type` SET 
    category_key = 'leave', 
    category_name = 'Category 8 – Leave & Disciplinary Records',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (30, 31);

-- Category 9: Organizational & Financial Information
UPDATE `document_type` SET 
    category_key = 'organizational', 
    category_name = 'Category 9 – Organizational & Financial Information',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (32, 33, 34);

-- Category 10: Efficiency Bar Exam
UPDATE `document_type` SET 
    category_key = 'efficiency', 
    category_name = 'Category 10 – Efficiency Bar Exam',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (35, 36, 37);

-- Category 11: Promotion Class
UPDATE `document_type` SET 
    category_key = 'promotion', 
    category_name = 'Category 11 – Promotion Class',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (38, 39, 40);

-- Category 12: Salary Increment
UPDATE `document_type` SET 
    category_key = 'salary', 
    category_name = 'Category 12 – Salary Increment',
    display_order = id,
    is_variable = 0,
    is_active = 1
WHERE id IN (41, 42, 43);

SELECT '✅ Successfully updated document_type table with category information!' AS result;
