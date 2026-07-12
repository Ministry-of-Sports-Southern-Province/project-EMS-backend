-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 20, 2026 at 06:03 PM
-- Server version: 9.1.0
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project_ems`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `email`, `password_hash`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'admin@mail.com', '$2b$10$.dCu53Orh/Rxbvw.DokWiO/KZq2LysnPQkMOGoEo7aXSr/qxX1QRK', 1, '2025-12-30 05:06:52', '2026-01-18 20:52:11');

-- --------------------------------------------------------

--
-- Table structure for table `document_category`
--

DROP TABLE IF EXISTS `document_category`;
CREATE TABLE IF NOT EXISTS `document_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_order` int NOT NULL DEFAULT '0',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_display_order` (`display_order`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `document_category`
--

INSERT INTO `document_category` (`id`, `category_name`, `display_order`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(7, 'Recruitment & Appointment Documents', 1, NULL, 1, '2026-01-13 17:45:50', '2026-01-14 18:01:24'),
(8, 'Personal & Health Records', 2, NULL, 1, '2026-01-13 17:48:53', '2026-01-13 17:48:53');

-- --------------------------------------------------------

--
-- Table structure for table `document_type`
--

DROP TABLE IF EXISTS `document_type`;
CREATE TABLE IF NOT EXISTS `document_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `fk_category_id` int NOT NULL,
  `display_order` int NOT NULL DEFAULT '0',
  `is_variable` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_category_order` (`display_order`),
  KEY `idx_active` (`is_active`),
  KEY `fk_document_category` (`fk_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `document_type`
--

INSERT INTO `document_type` (`id`, `name`, `fk_category_id`, `display_order`, `is_variable`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Appointment letter', 7, 1, 1, 1, '2026-01-13 17:49:23', '2026-01-13 17:51:56'),
(2, 'Letter of acceptance of appointment', 7, 2, 1, 1, '2026-01-13 17:49:38', '2026-01-13 17:52:00'),
(3, 'Medical record', 8, 1, 1, 1, '2026-01-13 17:49:52', '2026-01-13 17:52:03'),
(4, 'Asset declaration', 8, 2, 1, 1, '2026-01-13 17:50:05', '2026-01-13 17:52:11');

-- --------------------------------------------------------

--
-- Table structure for table `efficiency_bar`
--

DROP TABLE IF EXISTS `efficiency_bar`;
CREATE TABLE IF NOT EXISTS `efficiency_bar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_employee_career_id` int NOT NULL,
  `bar_level` enum('I','II','III') NOT NULL,
  `cleared_date` date DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_employee_career_id` (`fk_employee_career_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(250) NOT NULL,
  `name_with_init` varchar(100) DEFAULT NULL,
  `nic` varchar(20) NOT NULL,
  `address` varchar(250) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `marital_status` enum('Single','Married','Other') DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone1` varchar(15) DEFAULT NULL,
  `phone2` varchar(15) DEFAULT NULL,
  `permanent_status` enum('P','C') NOT NULL,
  `career_start_date` date DEFAULT NULL,
  `retirement_date` date DEFAULT NULL,
  `photo` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transfer_status` enum('active','transferred','on_transfer') DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nic` (`nic`),
  KEY `idx_emp_nic` (`nic`),
  KEY `idx_employee_transfer_status` (`transfer_status`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`id`, `full_name`, `name_with_init`, `nic`, `address`, `dob`, `gender`, `marital_status`, `email`, `phone1`, `phone2`, `permanent_status`, `career_start_date`, `retirement_date`, `photo`, `created_at`, `transfer_status`) VALUES
(10, 'Josep Mack Donald', 'J.M. Donald', '90001000400', 'newyourk ,rode 7', '2026-01-18', 'Male', 'Single', 'jmd@gmail.comddd', '0988888888', '0983333333', 'P', '2025-12-29', '2086-01-18', 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1768765841/employees/90001000400/jo5damehti4ngedg7oqj.png', '2026-01-18 19:51:45', 'active'),
(11, 'Lorem Ipsum', 'L. Ipsum', '7654352353', 'newyourk ,rode 7', '2026-01-19', 'Male', 'Single', 'admin@mail.com', '0333333333', NULL, 'P', '2026-01-19', '2086-01-19', 'https://res.cloudinary.com/dyfzbwhcr/image/upload/v1768932061/employees/7654352353/aqxtpilbsmuywkp5fcsg.jpg', '2026-01-20 17:59:39', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `employee_career`
--

DROP TABLE IF EXISTS `employee_career`;
CREATE TABLE IF NOT EXISTS `employee_career` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_emp_id` int NOT NULL,
  `fk_job_role_class_id` int NOT NULL,
  `fk_promotion_path_id` int DEFAULT NULL COMMENT 'Assigned promotion path',
  `current_path_step` int DEFAULT NULL COMMENT 'Current step in promotion path',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `appointment_type` enum('Recruitment','Promotion','Transfer','Re-designation') NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `current_class_promotion_date` date DEFAULT NULL COMMENT 'Date when promoted to current job class',
  `fk_current_salary_phase_id` int DEFAULT NULL COMMENT 'Current salary increment phase',
  `current_salary_year_in_phase` int DEFAULT NULL COMMENT 'Year within current salary phase (1 to phase.years)',
  `eb_exam_status` enum('Not Done','EB I','EB II','EB III') DEFAULT 'Not Done' COMMENT 'Highest Efficiency Bar exam cleared',
  `eb_exam_date` date DEFAULT NULL COMMENT 'Date when EB exam was cleared',
  `has_active_inquiry` tinyint(1) DEFAULT '0' COMMENT 'Whether employee has active inquiry (blocks promotion)',
  `inquiry_reason` varchar(500) DEFAULT NULL COMMENT 'Reason/details of active inquiry',
  `hold_increment` tinyint(1) DEFAULT '0',
  `hold_salary` tinyint(1) DEFAULT '0',
  `disable_employment` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_job_role_class_id` (`fk_job_role_class_id`),
  KEY `idx_career_emp` (`fk_emp_id`),
  KEY `idx_career_active` (`fk_emp_id`,`end_date`),
  KEY `fk_career_promotion_path` (`fk_promotion_path_id`),
  KEY `idx_career_salary_phase` (`fk_current_salary_phase_id`),
  KEY `idx_career_promotion_tracking` (`fk_emp_id`,`end_date`,`current_class_promotion_date`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employee_career`
--

INSERT INTO `employee_career` (`id`, `fk_emp_id`, `fk_job_role_class_id`, `fk_promotion_path_id`, `current_path_step`, `start_date`, `end_date`, `appointment_type`, `remarks`, `created_at`, `current_class_promotion_date`, `fk_current_salary_phase_id`, `current_salary_year_in_phase`, `eb_exam_status`, `eb_exam_date`, `has_active_inquiry`, `inquiry_reason`, `hold_increment`, `hold_salary`, `disable_employment`) VALUES
(9, 10, 7, NULL, NULL, '2026-01-01', NULL, 'Recruitment', NULL, '2026-01-18 19:51:46', '2026-01-16', 10, 6, 'Not Done', NULL, 0, NULL, 0, 0, 0),
(10, 11, 8, NULL, NULL, '2026-01-20', NULL, 'Recruitment', NULL, '2026-01-20 17:59:39', '2026-01-20', 10, 0, 'Not Done', NULL, 0, NULL, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `employee_document`
--

DROP TABLE IF EXISTS `employee_document`;
CREATE TABLE IF NOT EXISTS `employee_document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_emp_id` int NOT NULL,
  `fk_document_type_id` int NOT NULL,
  `instance_index` int DEFAULT '1',
  `page_count` int NOT NULL,
  `cloudinary_url` varchar(255) DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_emp_id` (`fk_emp_id`,`fk_document_type_id`,`instance_index`),
  KEY `fk_document_type_id` (`fk_document_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employee_document`
--

INSERT INTO `employee_document` (`id`, `fk_emp_id`, `fk_document_type_id`, `instance_index`, `page_count`, `cloudinary_url`, `uploaded_at`) VALUES
(78, 10, 1, 1, 1, NULL, '2026-01-18 22:49:06'),
(79, 10, 2, 1, 2, NULL, '2026-01-18 22:49:06'),
(80, 10, 3, 1, 3, NULL, '2026-01-18 22:49:06'),
(81, 10, 4, 1, 4, NULL, '2026-01-18 22:49:06');

-- --------------------------------------------------------

--
-- Table structure for table `employee_transfer`
--

DROP TABLE IF EXISTS `employee_transfer`;
CREATE TABLE IF NOT EXISTS `employee_transfer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_emp_id` int NOT NULL COMMENT 'Employee being transferred',
  `transfer_type` enum('regular','pleasant') NOT NULL DEFAULT 'regular',
  `to_location` varchar(255) NOT NULL,
  `transfer_date` date NOT NULL,
  `reason` text,
  `requested_by` varchar(255) DEFAULT NULL,
  `approved_by` varchar(255) DEFAULT NULL,
  `approval_date` date DEFAULT NULL,
  `transfer_status` enum('pending','approved','completed','cancelled') DEFAULT 'pending',
  `remarks` text,
  `is_data_backed_up` tinyint(1) DEFAULT '0',
  `backup_date` timestamp NULL DEFAULT NULL,
  `backup_file_path` varchar(500) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `deleted_date` timestamp NULL DEFAULT NULL,
  `created_by_user_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_emp_transfer` (`fk_emp_id`,`transfer_status`),
  KEY `idx_transfer_date` (`transfer_date`),
  KEY `idx_transfer_type` (`transfer_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Employee transfer records with backup tracking';

-- --------------------------------------------------------

--
-- Table structure for table `job_class`
--

DROP TABLE IF EXISTS `job_class`;
CREATE TABLE IF NOT EXISTS `job_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_code` varchar(50) NOT NULL,
  `hierarchy_order` int NOT NULL,
  `requires_efficiency_bar` tinyint(1) DEFAULT '0',
  `eb_level` enum('I','II','III') DEFAULT NULL,
  `eb_eligible_period_years` int DEFAULT NULL COMMENT 'Years in class before eligible for EB exam',
  `eb_grace_period_years` int DEFAULT NULL COMMENT 'Grace period to pass EB exam before increment block',
  `blocks_increment_if_failed` tinyint(1) DEFAULT '0' COMMENT 'Whether failing EB blocks salary increments',
  PRIMARY KEY (`id`),
  UNIQUE KEY `hierarchy_order` (`hierarchy_order`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_class`
--

INSERT INTO `job_class` (`id`, `class_code`, `hierarchy_order`, `requires_efficiency_bar`, `eb_level`, `eb_eligible_period_years`, `eb_grace_period_years`, `blocks_increment_if_failed`) VALUES
(1, 'Class III', 1, 0, NULL, NULL, NULL, 0),
(2, 'Class II', 2, 0, NULL, NULL, NULL, 0),
(3, 'Class I', 3, 0, NULL, NULL, NULL, 0),
(4, 'Special Class', 4, 0, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `job_role`
--

DROP TABLE IF EXISTS `job_role`;
CREATE TABLE IF NOT EXISTS `job_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_role`
--

INSERT INTO `job_role` (`id`, `name`) VALUES
(3, 'Administrative Officer'),
(2, 'Assistant Sports Director'),
(5, 'Chief Management Officer'),
(6, 'Development Officer'),
(4, 'District Sports Officer'),
(9, 'Field Sports Officer'),
(7, 'Management Officer'),
(10, 'Office Work Assistant'),
(8, 'Sports Coach'),
(1, 'Sports Director');

-- --------------------------------------------------------

--
-- Table structure for table `job_role_class`
--

DROP TABLE IF EXISTS `job_role_class`;
CREATE TABLE IF NOT EXISTS `job_role_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_job_role_id` int NOT NULL,
  `fk_job_class_id` int NOT NULL,
  `fk_salary_scale_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_job_role_id` (`fk_job_role_id`,`fk_job_class_id`),
  KEY `fk_job_class_id` (`fk_job_class_id`),
  KEY `fk_salary_scale_id` (`fk_salary_scale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_role_class`
--

INSERT INTO `job_role_class` (`id`, `fk_job_role_id`, `fk_job_class_id`, `fk_salary_scale_id`) VALUES
(3, 1, 1, 2),
(4, 1, 2, 2),
(5, 1, 3, 2),
(7, 3, 1, 3),
(8, 3, 2, 3),
(9, 3, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `promotion_application`
--

DROP TABLE IF EXISTS `promotion_application`;
CREATE TABLE IF NOT EXISTS `promotion_application` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_emp_id` int NOT NULL COMMENT 'Employee applying for promotion',
  `fk_current_role_class_id` int NOT NULL COMMENT 'Current position',
  `fk_applied_role_class_id` int NOT NULL COMMENT 'Position applied for',
  `application_date` date NOT NULL DEFAULT (curdate()),
  `justification` text COMMENT 'Reason for promotion request',
  `years_in_service` decimal(4,2) DEFAULT NULL COMMENT 'Total years of service',
  `years_in_current_class` decimal(4,2) DEFAULT NULL COMMENT 'Years in current class/grade',
  `qualification_details` text COMMENT 'Educational qualifications, certifications',
  `experience_details` text COMMENT 'Relevant experience',
  `merit_score_service` int DEFAULT NULL COMMENT 'Merit marks for service (0-30)',
  `merit_score_qualifications` int DEFAULT NULL COMMENT 'Merit marks for qualifications (0-25)',
  `merit_score_competencies` int DEFAULT NULL COMMENT 'Merit marks for competencies (0-20)',
  `merit_score_experience` int DEFAULT NULL COMMENT 'Merit marks for experience (0-20)',
  `merit_score_aptitude` int DEFAULT NULL COMMENT 'Merit marks for aptitude (0-5)',
  `merit_score_total` int DEFAULT NULL COMMENT 'Total merit score (0-100)',
  `eb_exam_status` enum('Not Required','Passed','Failed','Pending') DEFAULT 'Not Required',
  `eb_exam_date` date DEFAULT NULL,
  `supporting_documents` text COMMENT 'JSON array of document URLs/paths',
  `application_status` enum('pending','under_review','approved','rejected','withdrawn') DEFAULT 'pending',
  `submitted_by_user_id` int DEFAULT NULL COMMENT 'Admin who submitted on behalf',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_current_role_class_id` (`fk_current_role_class_id`),
  KEY `fk_applied_role_class_id` (`fk_applied_role_class_id`),
  KEY `idx_employee` (`fk_emp_id`),
  KEY `idx_status` (`application_status`),
  KEY `idx_application_date` (`application_date`),
  KEY `idx_emp_status` (`fk_emp_id`,`application_status`),
  KEY `idx_pending_applications` (`application_status`,`application_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Promotion applications with merit scoring';

-- --------------------------------------------------------

--
-- Table structure for table `promotion_approval`
--

DROP TABLE IF EXISTS `promotion_approval`;
CREATE TABLE IF NOT EXISTS `promotion_approval` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_promotion_application_id` int NOT NULL,
  `action` enum('approved','rejected','returned','withdrawn') NOT NULL,
  `reviewed_by_user_id` int DEFAULT NULL COMMENT 'Admin who reviewed',
  `review_date` date NOT NULL DEFAULT (curdate()),
  `effective_date` date DEFAULT NULL COMMENT 'When promotion takes effect',
  `review_remarks` text,
  `approval_level` varchar(100) DEFAULT NULL COMMENT 'e.g., Director General, PSC, Department Head',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_application` (`fk_promotion_application_id`),
  KEY `idx_action` (`action`),
  KEY `idx_review_date` (`review_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Promotion approval history and decisions';

-- --------------------------------------------------------

--
-- Table structure for table `promotion_path`
--

DROP TABLE IF EXISTS `promotion_path`;
CREATE TABLE IF NOT EXISTS `promotion_path` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'e.g., Sports Sector Career Path',
  `department` varchar(255) NOT NULL COMMENT 'e.g., Sports Department',
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_path_name` (`name`),
  KEY `idx_department` (`department`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `promotion_path`
--

INSERT INTO `promotion_path` (`id`, `name`, `department`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Sports Sector Career Progression', 'Sports Department', 'Standard career path for sports sector officers from field level to directorship', 1, '2026-01-11 05:27:39', '2026-01-11 05:27:39');

-- --------------------------------------------------------

--
-- Table structure for table `promotion_path_step`
--

DROP TABLE IF EXISTS `promotion_path_step`;
CREATE TABLE IF NOT EXISTS `promotion_path_step` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_promotion_path_id` int NOT NULL,
  `step_order` int NOT NULL COMMENT 'Sequence: 1, 2, 3...',
  `fk_job_role_id` int NOT NULL COMMENT 'Role at this step',
  `fk_job_class_id` int NOT NULL COMMENT 'Class at this step',
  `min_years_required` int DEFAULT NULL COMMENT 'Minimum years in previous step',
  `requirements` text COMMENT 'Additional requirements (EB, qualifications)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_step_in_path` (`fk_promotion_path_id`,`step_order`),
  KEY `fk_promotion_path_id` (`fk_promotion_path_id`),
  KEY `fk_job_role_id` (`fk_job_role_id`),
  KEY `fk_job_class_id` (`fk_job_class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `salary_increment_phase`
--

DROP TABLE IF EXISTS `salary_increment_phase`;
CREATE TABLE IF NOT EXISTS `salary_increment_phase` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_salary_scale_id` int NOT NULL,
  `phase_order` int NOT NULL,
  `years` int NOT NULL,
  `annual_increment` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_salary_scale_id` (`fk_salary_scale_id`,`phase_order`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `salary_increment_phase`
--

INSERT INTO `salary_increment_phase` (`id`, `fk_salary_scale_id`, `phase_order`, `years`, `annual_increment`) VALUES
(10, 3, 1, 11, 1360.00),
(11, 3, 2, 18, 1850.00),
(12, 4, 1, 10, 800.00),
(13, 4, 2, 11, 1190.00),
(14, 4, 3, 10, 1320.00),
(15, 4, 4, 10, 1347.00),
(16, 5, 1, 10, 800.00),
(17, 5, 2, 11, 1190.00),
(18, 5, 3, 10, 1320.00),
(19, 5, 4, 10, 1350.00),
(23, 2, 1, 10, 2400.00),
(24, 2, 2, 8, 2940.00),
(25, 2, 3, 17, 3900.00),
(26, 6, 1, 10, 630.00),
(27, 6, 2, 11, 670.00),
(28, 6, 3, 10, 1010.00),
(29, 6, 4, 10, 1190.00),
(30, 7, 1, 10, 450.00),
(31, 7, 2, 10, 490.00),
(32, 7, 3, 10, 540.00),
(33, 7, 4, 12, 590.00);

-- --------------------------------------------------------

--
-- Table structure for table `salary_scale`
--

DROP TABLE IF EXISTS `salary_scale`;
CREATE TABLE IF NOT EXISTS `salary_scale` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `starting_basic` decimal(10,2) NOT NULL,
  `max_years` int NOT NULL,
  `final_basic` decimal(10,2) NOT NULL,
  `effective_from` date NOT NULL,
  `effective_to` date DEFAULT NULL,
  `has_class_progression` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `salary_scale`
--

INSERT INTO `salary_scale` (`id`, `code`, `starting_basic`, `max_years`, `final_basic`, `effective_from`, `effective_to`, `has_class_progression`) VALUES
(2, 'SL-1-2025', 82150.00, 35, 195970.00, '2024-12-29', '1899-11-28', 1),
(3, 'MN-7-2025', 71240.00, 29, 119500.00, '2025-04-01', NULL, 0),
(4, 'MN-4-2025', 53060.00, 41, 94100.00, '2025-04-01', NULL, 1),
(5, 'MN-3-2025', 52250.00, 41, 100040.00, '2025-04-01', NULL, 1),
(6, 'MT-2-2025', 50630.00, 41, 86300.00, '2025-04-01', NULL, 1),
(7, 'PL-1-2025', 40000.00, 42, 61880.00, '2025-04-01', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salary_scale_class_progression`
--

DROP TABLE IF EXISTS `salary_scale_class_progression`;
CREATE TABLE IF NOT EXISTS `salary_scale_class_progression` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_salary_scale_id` int NOT NULL,
  `fk_job_class_id` int NOT NULL,
  `from_step` int NOT NULL,
  `to_step` int NOT NULL,
  `starting_basic` decimal(10,2) NOT NULL,
  `final_basic` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_salary_scale_class_progression_scale` (`fk_salary_scale_id`),
  KEY `idx_salary_scale_class_progression_class` (`fk_job_class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `salary_scale_class_progression`
--

INSERT INTO `salary_scale_class_progression` (`id`, `fk_salary_scale_id`, `fk_job_class_id`, `from_step`, `to_step`, `starting_basic`, `final_basic`) VALUES
(1, 4, 1, 1, 10, 53060.00, 60260.00),
(2, 4, 2, 11, 31, 61060.00, 84840.00),
(3, 4, 3, 32, 41, 87350.00, 99473.00),
(4, 5, 1, 1, 10, 52250.00, 59450.00),
(5, 5, 2, 11, 31, 60250.00, 84030.00),
(6, 5, 3, 32, 41, 86540.00, 98690.00),
(8, 2, 1, 1, 10, 82150.00, 103750.00),
(9, 2, 2, 11, 18, 106150.00, 126730.00),
(10, 2, 3, 19, 35, 129670.00, 192070.00),
(11, 6, 1, 1, 10, 50630.00, 56300.00),
(12, 6, 2, 11, 21, 56930.00, 63630.00),
(13, 6, 3, 22, 41, 64300.00, 84100.00);

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE IF NOT EXISTS `system_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`),
  KEY `idx_setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `created_at`, `updated_at`) VALUES
(1, 'system_name', 'Sports EMS', '2026-01-18 22:06:25', '2026-01-18 22:23:11'),
(2, 'system_logo_url', 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1768775125/system/ujjbpzanwyrzybyyog5z.jpg', '2026-01-18 22:06:25', '2026-01-18 22:25:27'),
(3, 'system_logo_public_id', 'system/ujjbpzanwyrzybyyog5z', '2026-01-18 22:06:25', '2026-01-18 22:25:27'),
(4, 'primary_color', '#0088ff', '2026-01-18 22:06:25', '2026-01-18 22:40:23'),
(39, 'background_color', '#121212', '2026-01-18 22:35:22', '2026-01-18 23:47:47');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `document_type`
--
ALTER TABLE `document_type`
  ADD CONSTRAINT `fk_document_category` FOREIGN KEY (`fk_category_id`) REFERENCES `document_category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `efficiency_bar`
--
ALTER TABLE `efficiency_bar`
  ADD CONSTRAINT `efficiency_bar_ibfk_1` FOREIGN KEY (`fk_employee_career_id`) REFERENCES `employee_career` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `employee_career`
--
ALTER TABLE `employee_career`
  ADD CONSTRAINT `employee_career_ibfk_1` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`),
  ADD CONSTRAINT `employee_career_ibfk_2` FOREIGN KEY (`fk_job_role_class_id`) REFERENCES `job_role_class` (`id`),
  ADD CONSTRAINT `fk_career_salary_phase` FOREIGN KEY (`fk_current_salary_phase_id`) REFERENCES `salary_increment_phase` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_employee_career_promotion_path` FOREIGN KEY (`fk_promotion_path_id`) REFERENCES `promotion_path` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `employee_document`
--
ALTER TABLE `employee_document`
  ADD CONSTRAINT `employee_document_ibfk_1` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `employee_document_ibfk_2` FOREIGN KEY (`fk_document_type_id`) REFERENCES `document_type` (`id`);

--
-- Constraints for table `employee_transfer`
--
ALTER TABLE `employee_transfer`
  ADD CONSTRAINT `employee_transfer_ibfk_1` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `job_role_class`
--
ALTER TABLE `job_role_class`
  ADD CONSTRAINT `job_role_class_ibfk_1` FOREIGN KEY (`fk_job_role_id`) REFERENCES `job_role` (`id`),
  ADD CONSTRAINT `job_role_class_ibfk_2` FOREIGN KEY (`fk_job_class_id`) REFERENCES `job_class` (`id`),
  ADD CONSTRAINT `job_role_class_ibfk_3` FOREIGN KEY (`fk_salary_scale_id`) REFERENCES `salary_scale` (`id`);

--
-- Constraints for table `promotion_application`
--
ALTER TABLE `promotion_application`
  ADD CONSTRAINT `promotion_application_ibfk_1` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `promotion_application_ibfk_2` FOREIGN KEY (`fk_current_role_class_id`) REFERENCES `job_role_class` (`id`),
  ADD CONSTRAINT `promotion_application_ibfk_3` FOREIGN KEY (`fk_applied_role_class_id`) REFERENCES `job_role_class` (`id`);

--
-- Constraints for table `promotion_approval`
--
ALTER TABLE `promotion_approval`
  ADD CONSTRAINT `promotion_approval_ibfk_1` FOREIGN KEY (`fk_promotion_application_id`) REFERENCES `promotion_application` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `promotion_path_step`
--
ALTER TABLE `promotion_path_step`
  ADD CONSTRAINT `fk_path_step_job_class` FOREIGN KEY (`fk_job_class_id`) REFERENCES `job_class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_path_step_job_role` FOREIGN KEY (`fk_job_role_id`) REFERENCES `job_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_path_step_promotion_path` FOREIGN KEY (`fk_promotion_path_id`) REFERENCES `promotion_path` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `salary_increment_phase`
--
ALTER TABLE `salary_increment_phase`
  ADD CONSTRAINT `salary_increment_phase_ibfk_1` FOREIGN KEY (`fk_salary_scale_id`) REFERENCES `salary_scale` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `salary_scale_class_progression`
--
ALTER TABLE `salary_scale_class_progression`
  ADD CONSTRAINT `fk_salary_scale_class_progression_class` FOREIGN KEY (`fk_job_class_id`) REFERENCES `job_class` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_salary_scale_class_progression_scale` FOREIGN KEY (`fk_salary_scale_id`) REFERENCES `salary_scale` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
