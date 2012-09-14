-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 6, 2012 at 09:14 PM
-- Server version: 5.0.95
-- PHP Version: 5.3.11

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `phpnova`
--

-- --------------------------------------------------------

--
-- Table structure for table `constant_types`
--

DROP TABLE IF EXISTS `constant_types`;
CREATE TABLE IF NOT EXISTS `constant_types` (
  `title` varchar(255) NOT NULL,
  `description` text,
  `initialized` int(1) NOT NULL DEFAULT '0',
  `prefix` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `constant_types`
--

INSERT INTO `constant_types` (`title`, `description`, `initialized`, `prefix`) VALUES
('log_cookie_data', 'What sort of cookie data to log.', 0, 'LOG_COOKIE_'),
('log_error_levels', 'The error levels that can be logged.', 0, 'LOG_E_'),
('log_output_formats', 'Which output formats to use for logging (database, csv, etc).', 0, 'LOG_OUT_'),
('log_php_data', 'PHP settings/etc to log (ini values, php version, etc).', 0, 'LOG_PHP_'),
('log_server_data', 'What information pertaining to the webserver environment (but not the system host in general) to log (ip, php version, etc).', 0, 'LOG_SRV_'),
('log_session_data', 'What sort of session information to log.', 0, 'LOG_SESS_'),
('log_system_state', 'What system environment things to log (ram, cpu, etc).', 0, 'LOG_SYS_'),
('SQL', 'SQL constants.', 0, 'SQL_'),
('users', 'User status constants.', 2, 'USERS_');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
