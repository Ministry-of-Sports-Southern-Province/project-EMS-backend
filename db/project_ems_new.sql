-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 17, 2025 at 06:47 AM
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
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `class_code` enum('III','II','I','Special') NOT NULL,
  `hierarchy_order` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hierarchy_order` (`hierarchy_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
