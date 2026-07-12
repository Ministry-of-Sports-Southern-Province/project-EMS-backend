-- Run Promotion Approval System Migration
-- Execute this file in MySQL Workbench or command line:
-- mysql -u root -p project_ems < add_promotion_approval_system.sql

USE project_ems;

SOURCE add_promotion_approval_system.sql;

-- Verify tables were created
SHOW TABLES LIKE 'promotion_%';

-- Check table structures
DESCRIBE promotion_application;
DESCRIBE promotion_approval;
