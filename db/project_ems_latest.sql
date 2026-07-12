-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 08, 2026 at 09:10 PM
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `email`, `password_hash`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2b$10$ATLq.UeUS4MjWHuA7qEqr.RjvQphD1q5sKWGu98XOFAMsUZnsdwiq', '2025-12-30 05:06:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `document_type`
--

DROP TABLE IF EXISTS `document_type`;
CREATE TABLE IF NOT EXISTS `document_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `document_type`
--

INSERT INTO `document_type` (`id`, `name`) VALUES
(4, 'Appointment Letter'),
(2, 'Birth Certificate'),
(3, 'Educational Certificates'),
(6, 'Medical Reports'),
(1, 'NIC'),
(7, 'Performance Reports'),
(5, 'Service Records'),
(8, 'Training Certificates');

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `nic` (`nic`),
  KEY `idx_emp_nic` (`nic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_career`
--

DROP TABLE IF EXISTS `employee_career`;
CREATE TABLE IF NOT EXISTS `employee_career` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_emp_id` int NOT NULL,
  `fk_job_role_class_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `appointment_type` enum('Recruitment','Promotion','Transfer','Re-designation') NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_job_role_class_id` (`fk_job_role_class_id`),
  KEY `idx_career_emp` (`fk_emp_id`),
  KEY `idx_career_active` (`fk_emp_id`,`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `cloudinary_url` varchar(500) NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_emp_id` (`fk_emp_id`,`fk_document_type_id`,`instance_index`),
  KEY `fk_document_type_id` (`fk_document_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_role`
--

INSERT INTO `job_role` (`id`, `name`) VALUES
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_role_class`
--

INSERT INTO `job_role_class` (`id`, `fk_job_role_id`, `fk_job_class_id`, `fk_salary_scale_id`) VALUES
(3, 1, 1, 2),
(4, 1, 2, 2),
(5, 1, 3, 2);

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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `salary_increment_phase`
--

INSERT INTO `salary_increment_phase` (`id`, `fk_salary_scale_id`, `phase_order`, `years`, `annual_increment`) VALUES
(7, 2, 1, 10, 2400.00),
(8, 2, 2, 8, 2940.00),
(9, 2, 3, 17, 3900.00);

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `salary_scale`
--

INSERT INTO `salary_scale` (`id`, `code`, `starting_basic`, `max_years`, `final_basic`, `effective_from`, `effective_to`, `has_class_progression`) VALUES
(2, 'SL-1-2025', 82150.00, 35, 195970.00, '2024-12-31', '0000-00-00', 0);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Constraints for dumped tables
--

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
  ADD CONSTRAINT `employee_career_ibfk_2` FOREIGN KEY (`fk_job_role_class_id`) REFERENCES `job_role_class` (`id`);

--
-- Constraints for table `employee_document`
--
ALTER TABLE `employee_document`
  ADD CONSTRAINT `employee_document_ibfk_1` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `employee_document_ibfk_2` FOREIGN KEY (`fk_document_type_id`) REFERENCES `document_type` (`id`);

--
-- Constraints for table `job_role_class`
--
ALTER TABLE `job_role_class`
  ADD CONSTRAINT `job_role_class_ibfk_1` FOREIGN KEY (`fk_job_role_id`) REFERENCES `job_role` (`id`),
  ADD CONSTRAINT `job_role_class_ibfk_2` FOREIGN KEY (`fk_job_class_id`) REFERENCES `job_class` (`id`),
  ADD CONSTRAINT `job_role_class_ibfk_3` FOREIGN KEY (`fk_salary_scale_id`) REFERENCES `salary_scale` (`id`);

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
