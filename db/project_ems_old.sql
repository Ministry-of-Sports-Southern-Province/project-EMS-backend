-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 17, 2025 at 04:54 AM
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
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `PASSWORD` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `PASSWORD`) VALUES
(1, 'admin', '1234');

-- --------------------------------------------------------

--
-- Table structure for table `efficiency`
--

DROP TABLE IF EXISTS `efficiency`;
CREATE TABLE IF NOT EXISTS `efficiency` (
  `fk_emp_id` int NOT NULL,
  `level` enum('I','II','III') NOT NULL,
  `efficiency_date` date NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`fk_emp_id`,`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `efficiency`
--

INSERT INTO `efficiency` (`fk_emp_id`, `level`, `efficiency_date`, `remarks`) VALUES
(15, 'I', '2025-11-14', 'worse '),
(15, 'II', '2025-11-14', 'worse'),
(15, 'III', '2025-11-14', 'worse'),
(25, 'I', '2017-12-28', NULL),
(25, 'II', '2019-12-28', NULL),
(25, 'III', '2024-12-28', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name_with_init` varchar(255) NOT NULL,
  `nic` varchar(20) NOT NULL,
  `address` varchar(250) NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(10) NOT NULL,
  `m_status` varchar(10) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone1` varchar(15) NOT NULL,
  `phone2` varchar(15) DEFAULT NULL,
  `fk_job_role_id` int NOT NULL,
  `permanent_status` varchar(1) NOT NULL,
  `career_st_date` date DEFAULT NULL,
  `pos_st_date` date DEFAULT NULL,
  `date_of_retire` date DEFAULT NULL,
  `photo` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nic` (`nic`),
  KEY `fk_emp_jobrole` (`fk_job_role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`id`, `full_name`, `name_with_init`, `nic`, `address`, `dob`, `gender`, `m_status`, `email`, `phone1`, `phone2`, `fk_job_role_id`, `permanent_status`, `career_st_date`, `pos_st_date`, `date_of_retire`, `photo`) VALUES
(15, 'Michael Carter Johns', 'M.C. Johns', '10000000000', 'Steel Road, Neura, CA', '2000-12-28', 'Male', 'Single', 'mcjohns@mail.com', '0112223334', NULL, 3, 'P', '2022-01-13', '2023-01-13', '2045-01-13', 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1763370040/employees/x5qu5ykurjx0pqwss8g9.jpg'),
(16, 'Sara Anna', 'S. Anna', '200000000', 'newyourk ,rode 7', '2025-11-15', 'Male', 'Single', 'sara@mail.com', '055332234', NULL, 10, 'C', '1899-11-28', '1899-11-28', '1899-11-28', 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1763370161/employees/i8gb98e7ueiqqd3dluz3.jpg'),
(17, 'Sara Jonsons', 'S. Jonsons', '400000000', 'fufhwuifhihew', '2025-11-12', 'Male', 'Single', 'sara@mail.com', '3789447004', NULL, 9, 'C', '1899-11-25', '1899-11-25', '1899-11-25', NULL),
(18, 'Adel Alan', 'A. Alan', '5000000000', 'newyourk ,rode 7', '2025-11-17', 'Male', 'Married', 'alan@mail.com', '038232933', NULL, 2, 'C', '0000-00-00', '0000-00-00', '0000-00-00', 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1763370884/employees/pknzotnyjjfem0f5l9qc.jpg'),
(19, 'Lorem Ipsum', 'L. Ipsum', '195636410017', 'newyourk ,rode 7', '2025-11-24', 'Male', 'Single', 'sins@mail.com', '474648433', NULL, 5, 'C', '1899-11-29', '1899-11-29', '1899-11-29', 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1763456128/employees/iabpdb9qnj9grurihqfj.jpg'),
(20, 'John Michael Doe', 'J.M. Doe', '11111111111v', 'newyourk ,rode 7', '1900-12-31', 'Male', 'Single', 'admin@mail.com', '224289928', NULL, 8, 'P', '1899-11-29', '1899-11-29', '1899-11-29', 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1763460392/employees/c446upxgzn1pbmbrkbix.png'),
(21, 'Test case 10', 'Test', '1234567890-', 'newyourk ,rode 7', '0567-12-30', 'Female', 'Married', 'admin@mail.com', '12345678', NULL, 7, 'C', '1899-11-29', '1899-11-29', '1899-11-29', NULL),
(24, '647382', '5674893', '54783920', 'yeuwidjs', '0038-04-06', 'Female', 'Single', '467382@7jmain.com', '467839309', NULL, 1, 'C', '0000-00-00', '0000-00-00', '0000-00-00', NULL),
(25, 'Diddy Michel Jordon', 'Michel Jordon', '789730183', '4673892hfhfi', '1999-12-28', 'Male', 'Single', 'michel@mail.com', '5678330309', NULL, 6, 'C', '2015-12-28', '2017-12-28', '2065-12-28', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employee_document`
--

DROP TABLE IF EXISTS `employee_document`;
CREATE TABLE IF NOT EXISTS `employee_document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_emp_id` int NOT NULL,
  `document_type_id` int NOT NULL,
  `instance_index` int DEFAULT '1',
  `page` int NOT NULL,
  `cloudinary_url` varchar(500) NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_document_instance` (`fk_emp_id`,`document_type_id`,`instance_index`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employee_document`
--

INSERT INTO `employee_document` (`id`, `fk_emp_id`, `document_type_id`, `instance_index`, `page`, `cloudinary_url`, `uploaded_at`) VALUES
(40, 19, 1, 1, 1, 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1764130370/employees/v1gqx9cke9mn8wsm2v1k.pdf', '2025-11-26 04:13:47'),
(41, 19, 2, 1, 2, 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1764130391/employees/ajikrhsy22wdjpagxbje.jpg', '2025-11-26 04:13:47'),
(42, 19, 3, 1, 7, 'https://res.cloudinary.com/dxmb45ziy/image/upload/v1764130404/employees/u3ogt87bx5yl2hiwdfvu.jpg', '2025-11-26 04:13:47');

-- --------------------------------------------------------

--
-- Table structure for table `job_role`
--

DROP TABLE IF EXISTS `job_role`;
CREATE TABLE IF NOT EXISTS `job_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `fk_salary_code` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_jobrole_salarycode` (`fk_salary_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_role`
--

INSERT INTO `job_role` (`id`, `name`, `fk_salary_code`) VALUES
(1, 'Assistant Director(Technical)', 1),
(2, 'District Sports Officer', 2),
(3, 'Sport Coach', 3),
(4, 'Sports Officer', 4),
(5, 'Director', 1),
(6, 'Administrative Officer', 2),
(7, 'Chief Management Service Officer', 5),
(8, 'Development Officer', 6),
(9, 'Management Officer', 5),
(10, 'Office Work Assistant', 7);

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
CREATE TABLE IF NOT EXISTS `promotion` (
  `fk_emp_id` int NOT NULL,
  `level` enum('I','II','III','Special') NOT NULL,
  `promotion_date` date NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`fk_emp_id`,`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `promotion`
--

INSERT INTO `promotion` (`fk_emp_id`, `level`, `promotion_date`, `remarks`) VALUES
(15, 'I', '2025-11-20', 'good'),
(15, 'II', '2025-11-06', 'good'),
(15, 'III', '2025-11-06', 'good'),
(15, 'Special', '2025-11-19', 'not good'),
(25, 'I', '2024-12-28', NULL),
(25, 'II', '1899-11-26', NULL),
(25, 'III', '2015-12-28', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `salary_code`
--

DROP TABLE IF EXISTS `salary_code`;
CREATE TABLE IF NOT EXISTS `salary_code` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `salary_code`
--

INSERT INTO `salary_code` (`id`, `code`) VALUES
(5, 'MN-2-2025'),
(3, 'MN-3-2025'),
(6, 'MN-4-2025'),
(2, 'MN-7-2025'),
(4, 'MT-2-2025'),
(7, 'PL-1-2025'),
(1, 'SL-1-2025');

-- --------------------------------------------------------

--
-- Table structure for table `salary_scale`
--

DROP TABLE IF EXISTS `salary_scale`;
CREATE TABLE IF NOT EXISTS `salary_scale` (
  `id` int NOT NULL AUTO_INCREMENT,
  `salary_code_id` int NOT NULL,
  `start_basic` decimal(10,2) NOT NULL,
  `max_payable_year` int NOT NULL COMMENT 'salary capped year (ex: 32)',
  `max_increment_year` int NOT NULL COMMENT 'last increment year (ex: 35)',
  `effective_from` date NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_salary_scale_code` (`salary_code_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `salary_scale_amount`
--

DROP TABLE IF EXISTS `salary_scale_amount`;
CREATE TABLE IF NOT EXISTS `salary_scale_amount` (
  `id` int NOT NULL AUTO_INCREMENT,
  `scale_id` int NOT NULL,
  `year_no` int NOT NULL,
  `basic_salary` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_scale_year` (`scale_id`,`year_no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `salary_scale_step`
--

DROP TABLE IF EXISTS `salary_scale_step`;
CREATE TABLE IF NOT EXISTS `salary_scale_step` (
  `id` int NOT NULL AUTO_INCREMENT,
  `scale_id` int NOT NULL,
  `start_year` int NOT NULL,
  `end_year` int NOT NULL,
  `annual_increment` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_scale_step` (`scale_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `transfer`
--

DROP TABLE IF EXISTS `transfer`;
CREATE TABLE IF NOT EXISTS `transfer` (
  `fk_emp_id` int NOT NULL,
  `transferred_date` date NOT NULL,
  `prev_role` int DEFAULT NULL,
  `prev_workplace` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`fk_emp_id`),
  KEY `fk_job_role` (`prev_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transfer`
--

INSERT INTO `transfer` (`fk_emp_id`, `transferred_date`, `prev_role`, `prev_workplace`) VALUES
(15, '2025-11-14', NULL, ''),
(21, '2025-11-05', NULL, 'asdfghertycvb'),
(25, '2017-12-28', 6, 'Education Ministry');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `efficiency`
--
ALTER TABLE `efficiency`
  ADD CONSTRAINT `fk_emp_efficiency` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `fk_emp_jobrole` FOREIGN KEY (`fk_job_role_id`) REFERENCES `job_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `employee_document`
--
ALTER TABLE `employee_document`
  ADD CONSTRAINT `fk_emp_document` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `job_role`
--
ALTER TABLE `job_role`
  ADD CONSTRAINT `fk_jobrole_salarycode` FOREIGN KEY (`fk_salary_code`) REFERENCES `salary_code` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `promotion`
--
ALTER TABLE `promotion`
  ADD CONSTRAINT `fk_emp_promotion` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transfer`
--
ALTER TABLE `transfer`
  ADD CONSTRAINT `fk_emp_transfer` FOREIGN KEY (`fk_emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_job_role` FOREIGN KEY (`prev_role`) REFERENCES `job_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
