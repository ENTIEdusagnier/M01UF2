-- MariaDB dump 10.19  Distrib 10.11.4-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: fary_adventure
-- ------------------------------------------------------
-- Server version	10.11.4-MariaDB-1~deb12u1

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
-- Current Database: `fary_adventure`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fary_adventure` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `fary_adventure`;

--
-- Table structure for table `characters`
--

DROP TABLE IF EXISTS `characters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characters` (
  `id_character` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` char(1) NOT NULL,
  `level` int(11) NOT NULL,
  `health` float NOT NULL,
  `height` float NOT NULL,
  `weight` int(11) NOT NULL,
  `origin` char(2) NOT NULL,
  PRIMARY KEY (`id_character`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters`
--

LOCK TABLES `characters` WRITE;
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` VALUES
(1,'El Fary',86,'N',200,70,1.2,47,'GY'),
(2,'El Cigala',540,'M',200,80,2.4,150,'RU'),
(3,'El Churumbel',33,'M',33,33,3.3,333,'AS'),
(4,'El Kiko',-1,'F',69,100,1.1,420,'RE'),
(5,'El Escalona',18,'N',22,60,1.8,80,'AN');
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `characters_items`
--

DROP TABLE IF EXISTS `characters_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characters_items` (
  `id_character_item` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_character` int(10) unsigned NOT NULL,
  `id_item` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_character_item`),
  KEY `id_character` (`id_character`),
  KEY `id_item` (`id_item`),
  CONSTRAINT `characters_items_ibfk_1` FOREIGN KEY (`id_character`) REFERENCES `characters` (`id_character`),
  CONSTRAINT `characters_items_ibfk_2` FOREIGN KEY (`id_item`) REFERENCES `items` (`id_item`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters_items`
--

LOCK TABLES `characters_items` WRITE;
/*!40000 ALTER TABLE `characters_items` DISABLE KEYS */;
INSERT INTO `characters_items` VALUES
(1,1,2),
(2,2,1),
(3,1,3),
(4,4,2),
(5,2,3),
(6,5,1),
(7,5,2),
(8,3,3);
/*!40000 ALTER TABLE `characters_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `characters_weapons`
--

DROP TABLE IF EXISTS `characters_weapons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characters_weapons` (
  `id_character_weapon` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_character` int(10) unsigned NOT NULL,
  `id_weapon` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_character_weapon`),
  KEY `id_character` (`id_character`),
  KEY `id_weapon` (`id_weapon`),
  CONSTRAINT `characters_weapons_ibfk_1` FOREIGN KEY (`id_character`) REFERENCES `characters` (`id_character`),
  CONSTRAINT `characters_weapons_ibfk_2` FOREIGN KEY (`id_weapon`) REFERENCES `weapons` (`id_weapon`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters_weapons`
--

LOCK TABLES `characters_weapons` WRITE;
/*!40000 ALTER TABLE `characters_weapons` DISABLE KEYS */;
INSERT INTO `characters_weapons` VALUES
(1,1,4),
(2,2,5),
(3,3,1),
(4,4,4),
(5,2,1),
(6,4,1),
(7,5,2);
/*!40000 ALTER TABLE `characters_weapons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `items` (
  `id_item` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item` varchar(32) DEFAULT NULL,
  `shape` int(11) DEFAULT NULL,
  `type` text DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `eqquipable` tinyint(1) DEFAULT NULL,
  `rareness` int(11) DEFAULT NULL,
  `uses` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `atack` int(11) DEFAULT NULL,
  `consumable` tinyint(1) DEFAULT NULL,
  `color` char(7) DEFAULT NULL,
  `protection` int(11) DEFAULT NULL,
  `tradeable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_item`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES
(1,'Backpack',123,'wearable',0.5,1,10,600,123,0,0,'#69c6cb',1,1),
(2,'Bread',123,'food',0.25,0,5,1,123,1,1,'#e4e24a',0,1),
(3,'pen',123,'Object',0.1,0,10,300,123,1,0,'#336fc6',0,1);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `id_stats` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reputation` int(11) NOT NULL,
  `addiction` int(11) NOT NULL,
  `skill` int(11) DEFAULT NULL,
  `depression` int(11) NOT NULL,
  `id_character` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_stats`),
  KEY `id_character` (`id_character`),
  CONSTRAINT `stats_ibfk_1` FOREIGN KEY (`id_character`) REFERENCES `characters` (`id_character`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stats`
--

LOCK TABLES `stats` WRITE;
/*!40000 ALTER TABLE `stats` DISABLE KEYS */;
INSERT INTO `stats` VALUES
(1,40,0,40,10,1),
(2,50,30,50,5,2),
(3,33,33,33,33,3),
(4,15,100,10,80,4);
/*!40000 ALTER TABLE `stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weapons`
--

DROP TABLE IF EXISTS `weapons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weapons` (
  `id_weapon` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `weapon` varchar(32) NOT NULL,
  `level` int(11) DEFAULT NULL,
  `damage` int(11) DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `critical` int(11) DEFAULT NULL,
  `durability` int(11) DEFAULT NULL,
  `range` int(11) DEFAULT NULL,
  `color` char(7) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `id_weapon_type` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_weapon`),
  KEY `id_weapon_type` (`id_weapon_type`),
  CONSTRAINT `weapons_ibfk_1` FOREIGN KEY (`id_weapon_type`) REFERENCES `weapons_types` (`id_weapon_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weapons`
--

LOCK TABLES `weapons` WRITE;
/*!40000 ALTER TABLE `weapons` DISABLE KEYS */;
INSERT INTO `weapons` VALUES
(1,'puños',3,15,0,123,8,2,'#CD5C5C',0,2),
(2,'SPAS-21',10,39,1,123,9,200,'#F08080',1199.99,1),
(3,'Extensible',7,25,0.4,123,9,5,'#FA8072',100,2),
(4,'Taser',8,50,0.75,123,8,10,'#E9967A',350,1),
(5,'Tornabis',6,30,0.15,123,6,3,'#FFA07A',10,2);
/*!40000 ALTER TABLE `weapons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weapons_types`
--

DROP TABLE IF EXISTS `weapons_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weapons_types` (
  `id_weapon_type` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` text NOT NULL,
  PRIMARY KEY (`id_weapon_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weapons_types`
--

LOCK TABLES `weapons_types` WRITE;
/*!40000 ALTER TABLE `weapons_types` DISABLE KEYS */;
INSERT INTO `weapons_types` VALUES
(1,'proyectil'),
(2,'melee');
/*!40000 ALTER TABLE `weapons_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-11 10:21:30
