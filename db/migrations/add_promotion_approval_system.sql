-- Migration: Add Promotion Approval System
-- Date: 2026-01-17
-- Purpose: Track promotion applications and approvals

-- Table: promotion_application
-- Stores promotion requests submitted by employees or HR
CREATE TABLE IF NOT EXISTS `promotion_application` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_emp_id` INT NOT NULL COMMENT 'Employee applying for promotion',
  `fk_current_role_class_id` INT NOT NULL COMMENT 'Current position',
  `fk_applied_role_class_id` INT NOT NULL COMMENT 'Position applied for',
  `application_date` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `justification` TEXT DEFAULT NULL COMMENT 'Reason for promotion request',
  `years_in_service` DECIMAL(4,2) DEFAULT NULL COMMENT 'Total years of service',
  `years_in_current_class` DECIMAL(4,2) DEFAULT NULL COMMENT 'Years in current class/grade',
  `qualification_details` TEXT DEFAULT NULL COMMENT 'Educational qualifications, certifications',
  `experience_details` TEXT DEFAULT NULL COMMENT 'Relevant experience',
  `merit_score_service` INT DEFAULT NULL COMMENT 'Merit marks for service (0-30)',
  `merit_score_qualifications` INT DEFAULT NULL COMMENT 'Merit marks for qualifications (0-25)',
  `merit_score_competencies` INT DEFAULT NULL COMMENT 'Merit marks for competencies (0-20)',
  `merit_score_experience` INT DEFAULT NULL COMMENT 'Merit marks for experience (0-20)',
  `merit_score_aptitude` INT DEFAULT NULL COMMENT 'Merit marks for aptitude (0-5)',
  `merit_score_total` INT DEFAULT NULL COMMENT 'Total merit score (0-100)',
  `eb_exam_status` ENUM('Not Required', 'Passed', 'Failed', 'Pending') DEFAULT 'Not Required',
  `eb_exam_date` DATE DEFAULT NULL,
  `supporting_documents` TEXT DEFAULT NULL COMMENT 'JSON array of document URLs/paths',
  `application_status` ENUM('pending', 'under_review', 'approved', 'rejected', 'withdrawn') DEFAULT 'pending',
  `submitted_by_user_id` INT DEFAULT NULL COMMENT 'Admin who submitted on behalf',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`fk_emp_id`) REFERENCES `employee`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`fk_current_role_class_id`) REFERENCES `job_role_class`(`id`),
  FOREIGN KEY (`fk_applied_role_class_id`) REFERENCES `job_role_class`(`id`),
  KEY `idx_employee` (`fk_emp_id`),
  KEY `idx_status` (`application_status`),
  KEY `idx_application_date` (`application_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Promotion applications with merit scoring';

-- Table: promotion_approval
-- Stores approval/rejection history
CREATE TABLE IF NOT EXISTS `promotion_approval` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_promotion_application_id` INT NOT NULL,
  `action` ENUM('approved', 'rejected', 'returned', 'withdrawn') NOT NULL,
  `reviewed_by_user_id` INT DEFAULT NULL COMMENT 'Admin who reviewed',
  `review_date` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `effective_date` DATE DEFAULT NULL COMMENT 'When promotion takes effect',
  `review_remarks` TEXT DEFAULT NULL,
  `approval_level` VARCHAR(100) DEFAULT NULL COMMENT 'e.g., Director General, PSC, Department Head',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`fk_promotion_application_id`) REFERENCES `promotion_application`(`id`) ON DELETE CASCADE,
  KEY `idx_application` (`fk_promotion_application_id`),
  KEY `idx_action` (`action`),
  KEY `idx_review_date` (`review_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Promotion approval history and decisions';

-- Add composite indexes for faster queries
CREATE INDEX idx_emp_status ON promotion_application(fk_emp_id, application_status);
CREATE INDEX idx_pending_applications ON promotion_application(application_status, application_date);
