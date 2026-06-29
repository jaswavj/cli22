-- MySQL dump 10.13  Distrib 8.4.7, for Win64 (x86_64)
--
-- Host: localhost    Database: gold
-- ------------------------------------------------------
-- Server version	8.4.7

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `company_details`
--

DROP TABLE IF EXISTS `company_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` text,
  `gstin` varchar(255) DEFAULT NULL,
  `print_type` int NOT NULL DEFAULT '0',
  `printer_name` varchar(255) DEFAULT NULL,
  `bank_details` varchar(255) DEFAULT NULL,
  `barcode_printer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_details`
--

LOCK TABLES `company_details` WRITE;
/*!40000 ALTER TABLE `company_details` DISABLE KEYS */;
INSERT INTO `company_details` VALUES (2,'THIRUMALA GOLD BUYERS','HONEST VALUE !!! INSTANT CASH !!! THIRUMALA GOLD PROMISE\r\n\r\n#119/71, GOPAL NAGAR, M.T.H ROAD, PADI, CH-50 PH - 8778630760','33AAZFT0635P1ZF',2,'','Bank Details','AP4909');
/*!40000 ALTER TABLE `company_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configure_bank_details`
--

DROP TABLE IF EXISTS `configure_bank_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configure_bank_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_blocked` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configure_bank_details`
--

LOCK TABLES `configure_bank_details` WRITE;
/*!40000 ALTER TABLE `configure_bank_details` DISABLE KEYS */;
INSERT INTO `configure_bank_details` VALUES (1,'SBI BANK',0),(2,'CANARA BANK',0),(3,'AXIS BANK',0),(4,'IOB BANK',0);
/*!40000 ALTER TABLE `configure_bank_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configure_payment_type`
--

DROP TABLE IF EXISTS `configure_payment_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configure_payment_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_blocked` int unsigned NOT NULL DEFAULT '0',
  `type_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configure_payment_type`
--

LOCK TABLES `configure_payment_type` WRITE;
/*!40000 ALTER TABLE `configure_payment_type` DISABLE KEYS */;
INSERT INTO `configure_payment_type` VALUES (1,'Cash',0,1),(2,'BANK',0,2);
/*!40000 ALTER TABLE `configure_payment_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_account`
--

DROP TABLE IF EXISTS `customer_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `advance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_account`
--

LOCK TABLES `customer_account` WRITE;
/*!40000 ALTER TABLE `customer_account` DISABLE KEYS */;
INSERT INTO `customer_account` VALUES (1,1,0.00,200.00),(2,2,0.00,100.00),(3,3,0.00,0.00);
/*!40000 ALTER TABLE `customer_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `is_eligible_for_commission` tinyint DEFAULT '1',
  `is_active` int DEFAULT '1',
  `gstin` varchar(255) DEFAULT NULL,
  `is_gst` int DEFAULT '0',
  `salesman` int DEFAULT NULL,
  `area` int DEFAULT NULL,
  `credit_limit` double(10,2) NOT NULL DEFAULT '0.00',
  `local` int DEFAULT '1',
  `exchange_point` double(10,3) DEFAULT '0.000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'JASWA VIJAY','9597451419','assaaaaaaaaaaaa\r\n sdddddddddddddddddddddddddddd dsds','2026-06-10','21:47:48',0,1,'',0,NULL,NULL,0.00,1,0.000),(2,'jeb','9898989898','no 10, Joseph colony, Thittuvaila,kanyakumari dist, Tamilnadi','2026-06-10','22:20:38',0,1,'',0,NULL,NULL,0.00,1,0.000),(3,'assasas','23232332232332','wdsssssssss\r\nsfsfsfsf','2026-06-20','13:52:27',0,1,'',0,NULL,NULL,0.00,1,0.000);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_entry`
--

DROP TABLE IF EXISTS `expense_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_entry` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `exp_type` int NOT NULL,
  `content` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text,
  `exc_date_time` datetime DEFAULT NULL,
  `entry_date_time` datetime DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`exp_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_entry`
--

LOCK TABLES `expense_entry` WRITE;
/*!40000 ALTER TABLE `expense_entry` DISABLE KEYS */;
INSERT INTO `expense_entry` VALUES (1,1,'d',15.00,'dd','2026-06-20 15:41:00','2026-06-20 15:42:00',1,1);
/*!40000 ALTER TABLE `expense_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_type`
--

DROP TABLE IF EXISTS `expense_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_type`
--

LOCK TABLES `expense_type` WRITE;
/*!40000 ALTER TABLE `expense_type` DISABLE KEYS */;
INSERT INTO `expense_type` VALUES (1,'TEA',1);
/*!40000 ALTER TABLE `expense_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gold_bill`
--

DROP TABLE IF EXISTS `gold_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gold_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_no` int unsigned NOT NULL DEFAULT '0' COMMENT 'display bill id, set in application code',
  `customer_id` int DEFAULT NULL COMMENT 'NULL for walk-in',
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `id_proof_no` varchar(100) DEFAULT NULL,
  `addr_proof_no` varchar(100) DEFAULT NULL,
  `gold_rate` decimal(10,2) NOT NULL,
  `gross_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `margin` decimal(12,2) NOT NULL DEFAULT '0.00',
  `net_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `release_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `amount_paid` decimal(12,2) NOT NULL DEFAULT '0.00',
  `bill_date` date NOT NULL,
  `bill_time` time NOT NULL,
  `entered_by` int NOT NULL COMMENT 'user id',
  `entered_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_cancelled` tinyint NOT NULL DEFAULT '0',
  `cancelled_by` int DEFAULT NULL,
  `cancelled_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gold_bill`
--

LOCK TABLES `gold_bill` WRITE;
/*!40000 ALTER TABLE `gold_bill` DISABLE KEYS */;
INSERT INTO `gold_bill` VALUES (1,1,1,'JASWA VIJAY','9597451419','11111111111111','222222222222222',5980.00,212230.00,100.00,212130.00,100.00,212030.00,'2026-06-20','15:36:00',1,'2026-06-20 15:37:22',0,NULL,NULL),(2,2,NULL,'NOOR MOHAMED A','9087208017','12345678910','MTG ROAD PADI',14160.00,13659.00,159.00,13500.00,0.00,13500.00,'2026-06-22','12:32:23',25,'2026-06-22 12:32:24',0,NULL,NULL),(3,3,NULL,'S.SUGUMARAN','9791026615','544666166551','7224 TNHB AYAPPAKKAM 600077',14120.00,377144.00,144.00,377000.00,0.00,377000.00,'2026-06-23','18:23:21',25,'2026-06-23 18:23:21',0,NULL,NULL),(4,4,NULL,'MOHIDEEN S','9789872408','535142614845','NO 4/3 MOSQUE 2 NS ST VILLIVAKKAM CH 49',14000.00,88536.00,36.00,88500.00,68500.00,20000.00,'2026-06-26','13:21:30',25,'2026-06-26 13:21:30',0,NULL,NULL),(5,5,NULL,'MOHIDEEN S','9789872408','535142614845','NO 4/3 MOSQUE 2 NS ST VILLIVAKKAM CH 49',14000.00,25620.00,20.00,25600.00,0.00,25600.00,'2026-06-26','13:24:10',25,'2026-06-26 13:24:11',0,NULL,NULL),(6,6,NULL,'ZAHIDMIRZA','9600038253','960932558677','74/34 9TH CROSS ST,TRUSTPURAM KODAMBAKKAM',13840.00,423656.00,56.00,423600.00,0.00,423600.00,'2026-06-26','14:00:41',25,'2026-06-26 14:00:41',0,NULL,NULL),(7,7,NULL,'MOHIDEEN S','9789872408','535142614845','NO 4/3 MOSQUE 2 NS ST VILLIVAKKAM CH 49',13960.00,64712.00,12.00,64700.00,47200.00,17500.00,'2026-06-27','12:16:22',1,'2026-06-27 12:16:23',0,NULL,NULL),(8,8,NULL,'MOHIDEEN S','9789872408','535142614845','NO 4/3 MOSQUE 2 NS ST VILLIVAKKAM CH 49',13960.00,65221.00,21.00,65200.00,47200.00,18000.00,'2026-06-27','12:17:01',1,'2026-06-27 12:17:02',0,NULL,NULL),(9,9,NULL,'V BHUVANESHWARI','9094002240','781475899015','74, SATHIYA NAGAR 1ST ST ,VILLIVAKKAM',13960.00,488238.00,238.00,488000.00,0.00,488000.00,'2026-06-27','17:18:35',25,'2026-06-27 17:18:36',0,NULL,NULL),(10,10,NULL,'SASIKALA','8825797752','216133742459 AADHAR','6 G FLR, PDAVATTAMMAN KOIL ST PADI',13860.00,74844.00,44.00,74800.00,0.00,74800.00,'2026-06-29','12:06:29',1,'2026-06-29 12:06:29',0,NULL,NULL),(11,11,NULL,'GOWRI GOVINDAN','9003176216','AADHAR - 503639666606','27/40 7TH ST, VANCHI NAGAR, KORATTUR, CH-80',13860.00,101012.00,12.00,101000.00,0.00,101000.00,'2026-06-29','13:12:29',25,'2026-06-29 13:12:29',0,NULL,NULL),(12,12,NULL,'BHARATHI P','9486482064','AADHAR - 730097759076','6C,TOWER-3B, VIJAYASHANTHI PARK AVN APT, VENGADAMANGALAM MAIN RD,  600127',13860.00,29513.00,13.00,29500.00,0.00,29500.00,'2026-06-29','13:26:06',25,'2026-06-29 13:26:06',0,NULL,NULL),(13,13,NULL,'V BHUVANESHWARI','9094002240','781475899015 - AADHAR','74 SATHYA NAGAR 1ST ST,VILLIVAKKAM,CH-49',13860.00,496054.00,54.00,496000.00,0.00,496000.00,'2026-06-29','15:46:34',1,'2026-06-29 15:46:35',0,NULL,NULL);
/*!40000 ALTER TABLE `gold_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gold_bill_item`
--

DROP TABLE IF EXISTS `gold_bill_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gold_bill_item` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int unsigned NOT NULL,
  `ornament_type` varchar(255) NOT NULL,
  `gross_wt` decimal(10,3) NOT NULL DEFAULT '0.000',
  `stone_wax` decimal(10,3) NOT NULL DEFAULT '0.000',
  `net_wt` decimal(10,3) NOT NULL DEFAULT '0.000',
  `purity` decimal(6,2) NOT NULL DEFAULT '0.00',
  `gross_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `bill_id` (`bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gold_bill_item`
--

LOCK TABLES `gold_bill_item` WRITE;
/*!40000 ALTER TABLE `gold_bill_item` DISABLE KEYS */;
INSERT INTO `gold_bill_item` VALUES (1,1,'neck',21.000,0.000,21.000,91.00,114278.00),(2,1,'coi',20.000,1.000,19.000,78.00,97952.00),(3,2,'RING',1.060,0.000,1.060,91.00,13659.00),(4,3,'RING 2',7.980,0.000,7.980,73.00,82255.00),(5,3,'STUD 2,RING 5',23.250,0.300,22.950,91.00,294889.00),(6,4,'COIN  2',4.000,0.000,4.000,91.50,51240.00),(7,4,'STUD 2',3.210,0.250,2.960,90.00,37296.00),(8,5,'COIN 2',2.000,0.000,2.000,91.50,25620.00),(9,6,'BANGLE 2,COIN 2',33.620,0.000,33.620,91.05,423656.00),(10,7,'CHAIN 1',6.500,0.150,6.350,73.00,64712.00),(11,8,'CHAIN 1',6.500,0.100,6.400,73.00,65221.00),(12,9,'NECKLACE 1,',15.160,0.000,15.160,91.00,192587.00),(13,9,'BANGLE 2',24.000,0.650,23.350,90.70,295651.00),(14,10,'BROKEN CHAIN (1)',7.900,0.400,7.500,72.00,74844.00),(15,11,'STUD (2)',8.000,0.000,8.000,91.10,101012.00),(16,12,'SMALL GOLD PIECES 2',2.340,0.000,2.340,91.00,29513.00),(17,13,'CHAIN(1)',39.500,0.170,39.330,91.00,496054.00);
/*!40000 ALTER TABLE `gold_bill_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gold_ledger`
--

DROP TABLE IF EXISTS `gold_ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gold_ledger` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `customer_name` varchar(255) NOT NULL,
  `bill_id` int unsigned DEFAULT NULL,
  `txn_type` enum('BILL','PAYMENT','OPENING') NOT NULL DEFAULT 'BILL',
  `opening_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `closing_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `description` varchar(255) DEFAULT NULL,
  `txn_date` date NOT NULL,
  `txn_time` time NOT NULL,
  `entered_by` int NOT NULL,
  `entered_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_open_balance_entry` tinyint(1) NOT NULL DEFAULT '0',
  `is_expense` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `bill_id` (`bill_id`),
  KEY `idx_is_open_balance_entry` (`is_open_balance_entry`,`txn_date`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gold_ledger`
--

LOCK TABLES `gold_ledger` WRITE;
/*!40000 ALTER TABLE `gold_ledger` DISABLE KEYS */;
INSERT INTO `gold_ledger` VALUES (1,NULL,'OPENING BALANCE',NULL,'OPENING',0.00,500000.00,0.00,'Opening Balance','2026-06-20','15:36:42',1,'2026-06-20 15:36:42',1,0),(2,1,'JASWA VIJAY',1,'BILL',0.00,212030.00,212030.00,'Gold Bill #1','2026-06-20','15:36:48',1,'2026-06-20 15:37:22',0,0),(3,NULL,'EXPENSE',NULL,'PAYMENT',0.00,15.00,0.00,'d','2026-06-20','15:41:00',1,'2026-06-20 15:42:00',0,0),(4,NULL,'OPENING BALANCE',NULL,'OPENING',0.00,1000000.00,0.00,'Opening Balance','2026-06-22','12:29:02',25,'2026-06-22 12:29:02',1,0),(5,NULL,'NOOR MOHAMED A',2,'BILL',0.00,13500.00,13500.00,'Gold Bill #2','2026-06-22','12:32:23',25,'2026-06-22 12:32:24',0,0),(6,NULL,'OPENING BALANCE',NULL,'OPENING',0.00,10000.00,0.00,'Opening Balance','2026-06-22','15:10:26',1,'2026-06-22 15:10:26',1,0),(7,NULL,'OPENING BALANCE',NULL,'OPENING',0.00,1100000.00,0.00,'Opening Balance','2026-06-23','18:16:44',25,'2026-06-23 18:16:44',1,0),(8,NULL,'S.SUGUMARAN',3,'BILL',0.00,377000.00,377000.00,'Gold Bill #3','2026-06-23','18:23:21',25,'2026-06-23 18:23:21',0,0),(9,NULL,'MOHIDEEN S',4,'BILL',0.00,20000.00,20000.00,'Gold Bill #4','2026-06-26','13:21:30',25,'2026-06-26 13:21:30',0,0),(10,NULL,'MOHIDEEN S',5,'BILL',0.00,25600.00,25600.00,'Gold Bill #5','2026-06-26','13:24:10',25,'2026-06-26 13:24:11',0,0),(11,NULL,'ZAHIDMIRZA',6,'BILL',0.00,423600.00,423600.00,'Gold Bill #6','2026-06-26','14:00:41',25,'2026-06-26 14:00:41',0,0),(12,NULL,'OPENING BALANCE',NULL,'OPENING',0.00,1000000.00,0.00,'Opening Balance','2026-06-27','10:15:18',25,'2026-06-27 10:15:18',1,0),(13,NULL,'MOHIDEEN S',7,'BILL',0.00,17500.00,17500.00,'Gold Bill #7','2026-06-27','12:16:22',1,'2026-06-27 12:16:23',0,0),(14,NULL,'MOHIDEEN S',8,'BILL',0.00,18000.00,18000.00,'Gold Bill #8','2026-06-27','12:17:01',1,'2026-06-27 12:17:02',0,0),(15,NULL,'V BHUVANESHWARI',9,'BILL',0.00,488000.00,488000.00,'Gold Bill #9','2026-06-27','17:18:35',25,'2026-06-27 17:18:36',0,0),(16,NULL,'OPENING BALANCE',NULL,'OPENING',0.00,1150000.00,0.00,'Opening Balance','2026-06-29','09:54:17',25,'2026-06-29 09:54:17',1,0),(17,NULL,'SASIKALA',10,'BILL',0.00,74800.00,74800.00,'Gold Bill #10','2026-06-29','12:06:29',1,'2026-06-29 12:06:29',0,0),(18,NULL,'GOWRI GOVINDAN',11,'BILL',0.00,101000.00,101000.00,'Gold Bill #11','2026-06-29','13:12:29',25,'2026-06-29 13:12:29',0,0),(19,NULL,'BHARATHI P',12,'BILL',0.00,29500.00,29500.00,'Gold Bill #12','2026-06-29','13:26:06',25,'2026-06-29 13:26:06',0,0),(20,NULL,'V BHUVANESHWARI',13,'BILL',0.00,496000.00,496000.00,'Gold Bill #13','2026-06-29','15:46:34',1,'2026-06-29 15:46:35',0,0);
/*!40000 ALTER TABLE `gold_ledger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gold_rate`
--

DROP TABLE IF EXISTS `gold_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gold_rate` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rate` decimal(10,2) NOT NULL,
  `entered_by` int NOT NULL COMMENT 'user id',
  `entered_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gold_rate`
--

LOCK TABLES `gold_rate` WRITE;
/*!40000 ALTER TABLE `gold_rate` DISABLE KEYS */;
INSERT INTO `gold_rate` VALUES (1,5980.00,1,'2026-06-20 15:24:08'),(2,14160.00,25,'2026-06-22 12:29:40'),(3,14150.00,25,'2026-06-23 18:18:11'),(4,14120.00,25,'2026-06-23 18:22:21'),(5,14000.00,25,'2026-06-24 10:20:55'),(6,13840.00,25,'2026-06-26 13:54:16'),(7,13960.00,25,'2026-06-27 10:15:47'),(8,13860.00,25,'2026-06-29 09:54:41'),(9,13800.00,1,'2026-06-29 15:47:00');
/*!40000 ALTER TABLE `gold_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gstin`
--

DROP TABLE IF EXISTS `gstin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gstin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gstin` varchar(255) NOT NULL,
  `shop_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gstin`
--

LOCK TABLES `gstin` WRITE;
/*!40000 ALTER TABLE `gstin` DISABLE KEYS */;
/*!40000 ALTER TABLE `gstin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `heading`
--

DROP TABLE IF EXISTS `heading`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `heading` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `head1` varchar(255) DEFAULT NULL,
  `head2` varchar(255) DEFAULT NULL,
  `head3` varchar(255) DEFAULT NULL,
  `active` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `heading`
--

LOCK TABLES `heading` WRITE;
/*!40000 ALTER TABLE `heading` DISABLE KEYS */;
INSERT INTO `heading` VALUES (1,'Category','Brand','Product',200);
/*!40000 ALTER TABLE `heading` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_batch`
--

DROP TABLE IF EXISTS `prod_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_batch` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `product_id` int NOT NULL,
  `cost` double(10,3) DEFAULT '0.000',
  `mrp` double(10,3) DEFAULT '0.000',
  `commission` double(10,3) DEFAULT '0.000',
  `stock` decimal(10,2) NOT NULL,
  `disc_type` int DEFAULT '0' COMMENT '1=rs 2=%',
  `discount` double(10,3) DEFAULT '0.000',
  `date` date DEFAULT NULL,
  `time` time DEFAULT '00:00:00',
  `added_stock` decimal(10,2) NOT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `disc` (`disc_type`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_batch`
--

LOCK TABLES `prod_batch` WRITE;
/*!40000 ALTER TABLE `prod_batch` DISABLE KEYS */;
INSERT INTO `prod_batch` VALUES (1,'Z101',1,160.000,360.000,0.000,4.00,0,0.000,'2026-06-10','21:46:59',0.00,1);
/*!40000 ALTER TABLE `prod_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_units`
--

DROP TABLE IF EXISTS `prod_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_units` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `convertion_unit` varchar(255) DEFAULT NULL,
  `convertion_calculation` decimal(10,2) DEFAULT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_units`
--

LOCK TABLES `prod_units` WRITE;
/*!40000 ALTER TABLE `prod_units` DISABLE KEYS */;
INSERT INTO `prod_units` VALUES (1,'NOS',NULL,NULL,1),(2,'Gram',NULL,NULL,1),(3,'KG',NULL,NULL,1),(4,'Meter',NULL,NULL,1),(5,'length','Feet',20.00,1);
/*!40000 ALTER TABLE `prod_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_modules`
--

DROP TABLE IF EXISTS `user_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_modules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_modules`
--

LOCK TABLES `user_modules` WRITE;
/*!40000 ALTER TABLE `user_modules` DISABLE KEYS */;
INSERT INTO `user_modules` VALUES (1,'Gold buy entry'),(2,'Gold buy report'),(3,'Ledger'),(4,'Customer'),(5,'Expense'),(6,'Admin');
/*!40000 ALTER TABLE `user_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permission`
--

DROP TABLE IF EXISTS `user_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_id` int NOT NULL,
  `uid` int NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mod` (`module_id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permission`
--

LOCK TABLES `user_permission` WRITE;
/*!40000 ALTER TABLE `user_permission` DISABLE KEYS */;
INSERT INTO `user_permission` VALUES (70,1,1,'2025-09-19','11:43:23'),(71,2,1,'2025-09-19','11:43:23'),(72,3,1,'2025-09-19','11:43:23'),(73,4,1,'2025-09-19','11:43:23'),(74,5,1,'2025-09-19','11:43:23'),(75,6,1,'2025-09-19','11:43:23'),(121,1,25,'2026-06-22','12:08:29'),(122,2,25,'2026-06-22','12:08:29'),(123,3,25,'2026-06-22','12:08:29'),(124,4,25,'2026-06-22','12:08:29'),(125,5,25,'2026-06-22','12:08:29'),(126,6,25,'2026-06-22','12:08:29');
/*!40000 ALTER TABLE `user_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_special_permission`
--

DROP TABLE IF EXISTS `user_special_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_special_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `content_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_special_permission`
--

LOCK TABLES `user_special_permission` WRITE;
/*!40000 ALTER TABLE `user_special_permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_special_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  `fullName` varchar(255) DEFAULT NULL,
  `disc_per` int DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','aecbf9a63cec1e93327dfc212f31acdb31c4f5d10bedccf8fbb8b042a6f0f39155797bdd04517905ae5d98b69fdc452cdb61b018e10939740ec96f36e133d639',1,'admin',50),(25,'thirumala','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'thirumala',100);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-29 16:15:41
