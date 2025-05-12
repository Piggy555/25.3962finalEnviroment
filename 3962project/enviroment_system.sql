-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： 127.0.0.1:3306
-- 生成日期： 2025-05-11 10:50:13
-- 服务器版本： 8.0.40
-- PHP 版本： 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `enviroment_system`
--

-- --------------------------------------------------------

--
-- 表的结构 `alert`
--

DROP TABLE IF EXISTS `alert`;
CREATE TABLE IF NOT EXISTS `alert` (
  `alert_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the alert record',
  `sensor_id` int UNSIGNED NOT NULL COMMENT 'Foreign key referencing the sensors table, indicating the sensor related to the alert',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the alert occurred',
  `severity` enum('Info','Warning','Critical') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Info' COMMENT 'Severity level of the alert',
  `message` text NOT NULL COMMENT 'Detailed message describing the alert',
  `user_id` int UNSIGNED NOT NULL,
  PRIMARY KEY (`alert_id`),
  KEY `sensor_id` (`sensor_id`),
  KEY `timestamp` (`timestamp`),
  KEY `severity` (`severity`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `configuration`
--

DROP TABLE IF EXISTS `configuration`;
CREATE TABLE IF NOT EXISTS `configuration` (
  `config_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Type of configuration',
  `parameter_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name of the configuration parameter',
  `parameter_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Value of the configuration parameter',
  PRIMARY KEY (`config_id`),
  KEY `config_type` (`config_type`),
  KEY `parameter_name` (`parameter_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `report`
--

DROP TABLE IF EXISTS `report`;
CREATE TABLE IF NOT EXISTS `report` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int UNSIGNED NOT NULL COMMENT 'Foreign key referencing the users table, indicating the user who generated the report',
  `timetamp` timestamp NOT NULL COMMENT 'Timestamp when the report was generated',
  `content_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Path or identifier to the generated report content file',
  `filter_criteria` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Criteria used to filter information',
  PRIMARY KEY (`report_id`),
  KEY `user_id` (`user_id`),
  KEY `timetamp` (`timetamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `sensor`
--

DROP TABLE IF EXISTS `sensor`;
CREATE TABLE IF NOT EXISTS `sensor` (
  `sensor_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_id` int UNSIGNED NOT NULL COMMENT 'Related config',
  `model_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Number or code for the sensor model',
  `can_light` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this model can measure light',
  `can_noise` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this model can measure noise',
  `can_pressure` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this model can measure pressure',
  `can_PM25` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this model can measure PM25',
  `can_humidity` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this model can measure humidity',
  `can_CO2` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this model can measure CO2',
  PRIMARY KEY (`sensor_id`),
  UNIQUE KEY `model_number` (`model_number`),
  KEY `config_id` (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Sensor';

-- --------------------------------------------------------

--
-- 表的结构 `sensordata`
--

DROP TABLE IF EXISTS `sensordata`;
CREATE TABLE IF NOT EXISTS `sensordata` (
  `data_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the sensor data point',
  `sensor_id` int UNSIGNED NOT NULL,
  `timestamp` timestamp NOT NULL COMMENT 'Timestamp when the data was recorded',
  `temperature` float DEFAULT NULL COMMENT 'Temperature reading in Celsius',
  `pressure` float DEFAULT NULL COMMENT 'Atmospheric pressure reading',
  `light` float DEFAULT NULL COMMENT 'Light intensity reading in Lux',
  `pm25` float DEFAULT NULL COMMENT 'PM2.5 concentration in ug/m³',
  `noise` float DEFAULT NULL COMMENT 'Noise level in decibels',
  `co2` float DEFAULT NULL COMMENT 'Carbon dioxide concentration in ppm',
  PRIMARY KEY (`data_id`),
  KEY `sensor_id` (`sensor_id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `sensormaintenanceschedule`
--

DROP TABLE IF EXISTS `sensormaintenanceschedule`;
CREATE TABLE IF NOT EXISTS `sensormaintenanceschedule` (
  `schedule_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the maintenance schedule',
  `sensor_id` int UNSIGNED NOT NULL COMMENT 'Foreign key referencing the sensors table this schedule is for',
  `scheduled_time` timestamp NOT NULL COMMENT 'Planned date and time for maintenance',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Description of the maintenance task',
  `status` enum('Planned','InProgress','Completed','Cancelled','Failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Cancelled' COMMENT 'Current status of the maintenance schedule',
  `completion_time` timestamp NULL DEFAULT NULL COMMENT 'Actual timestamp when the maintenance was completed',
  PRIMARY KEY (`schedule_id`),
  KEY `sensor_id` (`sensor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` int UNSIGNED NOT NULL COMMENT 'related role',
  `password_hash` varchar(255) NOT NULL COMMENT 'Hashed password',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'User''s name',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  KEY `idx_` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User';

-- --------------------------------------------------------

--
-- 表的结构 `userrole`
--

DROP TABLE IF EXISTS `userrole`;
CREATE TABLE IF NOT EXISTS `userrole` (
  `role_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` int NOT NULL COMMENT 'Name of the user role',
  `descripition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Description of the role',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 限制导出的表
--

--
-- 限制表 `alert`
--
ALTER TABLE `alert`
  ADD CONSTRAINT `fk_alert_sensor` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_alert_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `fk_report_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- 限制表 `sensor`
--
ALTER TABLE `sensor`
  ADD CONSTRAINT `fk_sensor_config` FOREIGN KEY (`config_id`) REFERENCES `configuration` (`config_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- 限制表 `sensordata`
--
ALTER TABLE `sensordata`
  ADD CONSTRAINT `fk_data_sensor` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- 限制表 `sensormaintenanceschedule`
--
ALTER TABLE `sensormaintenanceschedule`
  ADD CONSTRAINT `fk_shcedule_sensor` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- 限制表 `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_userrole` FOREIGN KEY (`role_id`) REFERENCES `userrole` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
