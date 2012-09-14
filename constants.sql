-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 6, 2012 at 09:17 PM
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
-- Table structure for table `constants`
--

DROP TABLE IF EXISTS `constants`;
CREATE TABLE IF NOT EXISTS `constants` (
  `constant` varchar(255) NOT NULL,
  `cpkey` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `type` varchar(255) NOT NULL DEFAULT 'int',
  `value` longtext,
  `corder` int(11) DEFAULT NULL,
  PRIMARY KEY (`cpkey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;

--
-- Dumping data for table `constants`
--

INSERT INTO `constants` (`constant`, `cpkey`, `title`, `description`, `type`, `value`, `corder`) VALUES
('ARRAY', 1, 'log_cookie_data', 'Log the PHP _COOKIE array.', 'int', NULL, 1),
('CONST', 2, 'log_php_data', 'Log all PHP constants.', 'int', NULL, 4),
('CSV', 3, 'log_output_formats', 'Output logs to CSV.', 'int', NULL, 2),
('ERROR', 4, 'log_error_levels', 'Include ERROR errors in the log.', 'int', NULL, 3),
('EXT', 5, 'log_php_data', 'Log the PHP extensions that are loaded.', 'int', NULL, 3),
('GET', 6, 'log_php_data', 'Log the contents of the PHP _GET array.', 'int', NULL, 5),
('INI', 7, 'log_php_data', 'Log the php.ini settings.', 'int', NULL, 2),
('NOTICE', 8, 'log_error_levels', 'Include notice errors in the log.', 'int', NULL, 1),
('POST', 9, 'log_php_data', 'Log the contents of the PHP _POST array.', 'int', NULL, 6),
('RAM', 10, 'log_php_data', 'Log PHP''s RAM usage.', 'int', NULL, 7),
('SQL', 11, 'log_output_formats', 'Output logs to SQL.', 'int', NULL, 1),
('VER', 12, 'log_php_data', 'Log the PHP version.', 'int', NULL, 1),
('WARNING', 13, 'log_error_levels', 'Include warning errors in the log.', 'int', NULL, 2),
('CPU', 14, 'log_system_state', 'The system CPU usage.', 'int', NULL, 1),
('RAM', 15, 'log_system_state', 'The available RAM / total.', 'int', NULL, 2),
('HDD', 16, 'log_system_state', 'Log the HDD info.', 'int', NULL, 3),
('PENDING', 17, 'users', 'User has not yet been activated/approved.', 'int', '0', NULL),
('ACTIVE', 18, 'users', 'User is active on the site.', 'int', '1', NULL),
('MODERATOR', 19, 'users', 'User has level access privileges necessary for basic moderation tasks.', 'int', '2', NULL),
('ADMIN', 20, 'users', 'User has admin privileges and can access all features of the site (except editing other admins).', 'int', '4', NULL),
('SUPERUSER', 21, 'users', 'Privilege to edit admin users (requires ADMIN permission as well to access the edit page itself).  Users with this privilege can NOT be edited via the UI (except by that user via profile edit), so it is recommended that no more than 1 SUPERUSER exist at any one time.', 'int', '8', NULL),
('ROOT', 22, 'users', 'This privilege allows the user to edit ALL user accounts (including SUPERUSER and ROOT).  This is considered unsafe for production.  Therefore, it is recommended that this either not be used or that it be assigned to the site''s code developer and/or database admin for use in emergencies only.', 'int', '16', NULL),
('BANNED', 23, 'users', 'User account is banned and cannot login to the site.  If user is already logged-in, authentication will fail and user will be automatically logged-out.', 'int', '-1', NULL),

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
