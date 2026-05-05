-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: library_auth
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accountlockouts`
--

DROP TABLE IF EXISTS `accountlockouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountlockouts` (
  `lockout_id` int(11) NOT NULL AUTO_INCREMENT,
  `actor_id` int(11) NOT NULL,
  `actor_type` enum('member','staff') NOT NULL,
  `locked_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `unlock_at` datetime NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `unlocked_by_staff` int(11) DEFAULT NULL,
  PRIMARY KEY (`lockout_id`),
  KEY `fk_lock_admin` (`unlocked_by_staff`),
  CONSTRAINT `fk_lock_admin` FOREIGN KEY (`unlocked_by_staff`) REFERENCES `staff` (`staff_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountlockouts`
--

LOCK TABLES `accountlockouts` WRITE;
/*!40000 ALTER TABLE `accountlockouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accountlockouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditlog`
--

DROP TABLE IF EXISTS `auditlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auditlog` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `actor_id` int(11) DEFAULT NULL,
  `actor_type` enum('member','staff') DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `table_affected` varchar(100) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditlog`
--

LOCK TABLES `auditlog` WRITE;
/*!40000 ALTER TABLE `auditlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailverifications`
--

DROP TABLE IF EXISTS `emailverifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emailverifications` (
  `verification_id` int(11) NOT NULL AUTO_INCREMENT,
  `actor_id` int(11) NOT NULL,
  `actor_type` enum('member','staff') NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `verified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`verification_id`),
  UNIQUE KEY `token_hash` (`token_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailverifications`
--

LOCK TABLES `emailverifications` WRITE;
/*!40000 ALTER TABLE `emailverifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `emailverifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loginattempts`
--

DROP TABLE IF EXISTS `loginattempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loginattempts` (
  `attempt_id` int(11) NOT NULL AUTO_INCREMENT,
  `actor_id` int(11) DEFAULT NULL,
  `actor_type` enum('member','staff') DEFAULT NULL,
  `email_tried` varchar(100) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `status` enum('success','failed','locked') NOT NULL,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`attempt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loginattempts`
--

LOCK TABLES `loginattempts` WRITE;
/*!40000 ALTER TABLE `loginattempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `loginattempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role_id` int(11) NOT NULL DEFAULT 1,
  `date_registered` date NOT NULL,
  `membership_expiry` date DEFAULT NULL,
  `status` enum('Active','Suspended','Expired') DEFAULT 'Active',
  `password_hash` varchar(255) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `membership_no` varchar(20) DEFAULT NULL,
  `library_card_no` varchar(30) DEFAULT NULL,
  `university_id` varchar(50) DEFAULT NULL,
  `max_books_allowed` int(11) NOT NULL DEFAULT 3,
  `salt` varchar(64) NOT NULL DEFAULT '',
  `is_email_verified` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `membership_no` (`membership_no`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `members_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (6,'Aisha','Mukwatanzi','2025bcs055@std.must.ac.ug','+256772345678',NULL,3,'2025-08-01','2026-07-31','Active','hashed_Aisha@2025','amukwatanzi','MUST-STD-055','LIB-MUST-055','2025/BCS/055',3,'salt004',1),(7,'Brian','Ssentamu','2025bit032@std.must.ac.ug','+256701987654',NULL,3,'2025-08-01','2026-07-31','Active','hashed_Brian@2025','bssentamu','MUST-STD-032','LIB-MUST-032','2025/BIT/032',3,'salt005',1),(8,'Catherine','Mugisha','2024bse019@std.must.ac.ug','+256789456123',NULL,3,'2024-08-01','2025-07-31','Active','hashed_Cathy@2025','cmugisha','MUST-STD-019','LIB-MUST-019','2024/BSE/019',3,'salt006',0),(9,'Ronald','Opolot','2025bcv041@std.must.ac.ug','+256775612309',NULL,3,'2025-08-01','2026-07-31','Active','hashed_Opolot@2025','opolot','MUST-STD-041','LIB-MUST-041','2025/BCV/041',3,'salt007',1),(10,'Walk-in','Guest','guest@library.must.ac.ug',NULL,NULL,4,'2025-01-01','2025-12-31','Active','hashed_Guest@2025','guest_user','MUST-GST-001','LIB-MUST-G01',NULL,1,'salt008',1);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passwordresets`
--

DROP TABLE IF EXISTS `passwordresets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passwordresets` (
  `reset_id` int(11) NOT NULL AUTO_INCREMENT,
  `actor_id` int(11) NOT NULL,
  `actor_type` enum('member','staff') NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`reset_id`),
  UNIQUE KEY `token_hash` (`token_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passwordresets`
--

LOCK TABLES `passwordresets` WRITE;
/*!40000 ALTER TABLE `passwordresets` DISABLE KEYS */;
/*!40000 ALTER TABLE `passwordresets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `permission_id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(100) NOT NULL,
  `module` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `permission_name` (`permission_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolepermissions`
--

DROP TABLE IF EXISTS `rolepermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolepermissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_rp_perm` (`permission_id`),
  CONSTRAINT `fk_rp_perm` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolepermissions`
--

LOCK TABLES `rolepermissions` WRITE;
/*!40000 ALTER TABLE `rolepermissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolepermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(30) NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'superadmin','Full system access'),(2,'librarian','Manages books and loans'),(3,'student','Registered student borrower'),(4,'guest','Walk-in visitor, read only');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `session_id` varchar(128) NOT NULL,
  `actor_id` int(11) NOT NULL,
  `actor_type` enum('member','staff') NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL,
  `is_revoked` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`session_id`),
  KEY `idx_sess_actor` (`actor_id`,`actor_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff` (
  `staff_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role_id` int(11) NOT NULL,
  `date_hired` date NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `salt` varchar(64) NOT NULL DEFAULT '',
  `is_email_verified` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-05 16:37:51
