-- Allow NULL values for cloudinary_url since file upload is optional
-- Only page_count is required

ALTER TABLE employee_document 
MODIFY COLUMN cloudinary_url VARCHAR(255) NULL;
