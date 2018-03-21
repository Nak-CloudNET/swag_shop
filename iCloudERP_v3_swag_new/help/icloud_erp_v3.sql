/*
Navicat MySQL Data Transfer

Source Server         : CloudNET
Source Server Version : 50626
Source Host           : 127.0.0.1:3306
Source Database       : icloud_erp_v3

Target Server Type    : MYSQL
Target Server Version : 50626
File Encoding         : 65001

Date: 2016-12-27 15:25:17
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for erp_account_settings
-- ----------------------------
DROP TABLE IF EXISTS `erp_account_settings`;
CREATE TABLE `erp_account_settings` (
  `id` int(1) NOT NULL,
  `biller_id` int(11) NOT NULL DEFAULT '0',
  `default_open_balance` varchar(20) DEFAULT NULL,
  `default_sale` varchar(20) DEFAULT 'yes',
  `default_sale_discount` varchar(20) DEFAULT NULL,
  `default_sale_tax` varchar(20) DEFAULT NULL,
  `default_sale_freight` varchar(20) DEFAULT NULL,
  `default_sale_deposit` varchar(20) DEFAULT NULL,
  `default_receivable` varchar(20) DEFAULT NULL,
  `default_purchase` varchar(20) DEFAULT NULL,
  `default_purchase_discount` varchar(20) DEFAULT NULL,
  `default_purchase_tax` varchar(20) DEFAULT NULL,
  `default_purchase_freight` varchar(20) DEFAULT NULL,
  `default_purchase_deposit` varchar(20) DEFAULT NULL,
  `default_payable` varchar(20) DEFAULT NULL,
  `default_stock` varchar(20) DEFAULT NULL,
  `default_stock_adjust` varchar(20) DEFAULT NULL,
  `default_cost` varchar(20) DEFAULT NULL,
  `default_payroll` varchar(20) DEFAULT NULL,
  `default_cash` varchar(20) DEFAULT NULL,
  `default_credit_card` varchar(20) DEFAULT NULL,
  `default_gift_card` varchar(20) DEFAULT NULL,
  `default_cheque` varchar(20) DEFAULT NULL,
  `default_loan` varchar(20) DEFAULT NULL,
  `default_retained_earnings` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`,`biller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_account_settings
-- ----------------------------
INSERT INTO `erp_account_settings` VALUES ('1', '3', '300300', '410101', '410102', '201407', '601206', '201208', '100200', '100430', '500106', '100441', '601206', '100420', '201100', '100430', '500107', '500101', '201201', '100102', '100105', '201208', '100104', '100501', '300200');

-- ----------------------------
-- Table structure for erp_adjustments
-- ----------------------------
DROP TABLE IF EXISTS `erp_adjustments`;
CREATE TABLE `erp_adjustments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` int(11) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `cost` decimal(19,4) DEFAULT '0.0000',
  `total_cost` decimal(19,4) DEFAULT '0.0000',
  `biller_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_adjustments
-- ----------------------------

-- ----------------------------
-- Table structure for erp_bom
-- ----------------------------
DROP TABLE IF EXISTS `erp_bom`;
CREATE TABLE `erp_bom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `noted` varchar(200) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `reference_no` varchar(55) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_bom
-- ----------------------------

-- ----------------------------
-- Table structure for erp_bom_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_bom_items`;
CREATE TABLE `erp_bom_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bom_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` decimal(25,4) NOT NULL,
  `cost` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `transfer_id` (`bom_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_bom_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_brands
-- ----------------------------
DROP TABLE IF EXISTS `erp_brands`;
CREATE TABLE `erp_brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `image` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_brands
-- ----------------------------
INSERT INTO `erp_brands` VALUES ('1', 'zara', 'Zara', 'a9f53bdf708827368deaf095d307bf2a.jpg');
INSERT INTO `erp_brands` VALUES ('2', 'levis', 'LEVIS', '76fc0477967155556d930fcb5b5bdcf1.png');
INSERT INTO `erp_brands` VALUES ('3', 'iphone', 'iPhone', 'f625a69f187c2ae8bccd06a9b98fbdb5.png');
INSERT INTO `erp_brands` VALUES ('4', 'B0001', 'Adidas', '2a5c64544aba93d41c08e983b3857927.png');

-- ----------------------------
-- Table structure for erp_calendar
-- ----------------------------
DROP TABLE IF EXISTS `erp_calendar`;
CREATE TABLE `erp_calendar` (
  `start` datetime NOT NULL,
  `title` varchar(55) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `end` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `color` varchar(7) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_calendar
-- ----------------------------

-- ----------------------------
-- Table structure for erp_captcha
-- ----------------------------
DROP TABLE IF EXISTS `erp_captcha`;
CREATE TABLE `erp_captcha` (
  `captcha_id` bigint(13) unsigned NOT NULL AUTO_INCREMENT,
  `captcha_time` int(10) unsigned NOT NULL,
  `ip_address` varchar(16) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `word` varchar(20) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`captcha_id`),
  KEY `word` (`word`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_captcha
-- ----------------------------
INSERT INTO `erp_captcha` VALUES ('1', '1451963466', '192.168.1.122', 'N9ocX');

-- ----------------------------
-- Table structure for erp_categories
-- ----------------------------
DROP TABLE IF EXISTS `erp_categories`;
CREATE TABLE `erp_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_id` int(11) DEFAULT NULL,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  `image` varchar(55) DEFAULT NULL,
  `jobs` tinyint(1) unsigned DEFAULT '1',
  `auto_delivery` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_categories
-- ----------------------------
INSERT INTO `erp_categories` VALUES ('1', null, '1234', 'Cloth', null, '1', null);
INSERT INTO `erp_categories` VALUES ('2', null, '33333', 'Shoe', null, '1', null);
INSERT INTO `erp_categories` VALUES ('3', null, '44444', 'Jewelry', null, '1', null);
INSERT INTO `erp_categories` VALUES ('4', null, '66666', 'Watch', null, '1', null);

-- ----------------------------
-- Table structure for erp_combine_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_combine_items`;
CREATE TABLE `erp_combine_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sale_deliveries_id` bigint(20) NOT NULL,
  `sale_deliveries_id_combine` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_combine_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_combo_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_combo_items`;
CREATE TABLE `erp_combo_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `item_code` varchar(20) NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_combo_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_companies
-- ----------------------------
DROP TABLE IF EXISTS `erp_companies`;
CREATE TABLE `erp_companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned DEFAULT NULL,
  `group_name` varchar(20) NOT NULL,
  `customer_group_id` int(11) DEFAULT NULL,
  `customer_group_name` varchar(100) DEFAULT NULL,
  `name` varchar(55) NOT NULL,
  `company` varchar(255) NOT NULL,
  `vat_no` varchar(100) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(55) DEFAULT NULL,
  `state` varchar(55) DEFAULT NULL,
  `postal_code` varchar(8) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `cf1` varchar(100) DEFAULT NULL,
  `cf2` varchar(100) DEFAULT NULL,
  `cf3` varchar(100) DEFAULT NULL,
  `cf4` varchar(100) DEFAULT NULL,
  `cf5` varchar(100) DEFAULT NULL,
  `cf6` varchar(100) DEFAULT NULL,
  `invoice_footer` text,
  `payment_term` int(11) DEFAULT '0',
  `logo` varchar(255) DEFAULT 'logo.png',
  `award_points` int(11) DEFAULT '0',
  `deposit_amount` decimal(25,4) DEFAULT NULL,
  `status` char(20) DEFAULT NULL,
  `posta_card` char(50) DEFAULT NULL,
  `gender` char(10) DEFAULT NULL,
  `attachment` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `credit_limited` decimal(25,4) DEFAULT NULL,
  `business_activity` varchar(255) DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `village` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `sangkat` varchar(255) DEFAULT NULL,
  `district` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `group_id_2` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=549 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_companies
-- ----------------------------
INSERT INTO `erp_companies` VALUES ('1', '3', 'customer', '1', 'General Trade', 'Hea Mab - ហ៊ា ម៉ាប់', 'Hea Mab - ហ៊ា ម៉ាប់', '', 'St. 2011, ម្តុំផ្សារឈូក', 'Phnom Penh', '', '', 'Cambodia', '095 507 790', '', '', null, null, null, null, null, null, '0', 'logo.png', '33', '0.0000', '', null, 'male', null, '0000-00-00', '0000-00-00', '0000-00-00', null, null, null, null, null, null, null);
INSERT INTO `erp_companies` VALUES ('2', '3', 'customer', '2', 'Garage', 'ចំការព្រីង យានដ្ឋាន ផ្លូវ 2011', 'Chamkar Pring Garage', 'Sovann', '', '', '', '', '', '012 82 49 23', '', '', null, null, null, null, null, null, '0', 'logo.png', '3848', '522.0000', '', null, '', null, '0000-00-00', '0000-00-00', '0000-00-00', null, null, null, null, null, null, null);
INSERT INTO `erp_companies` VALUES ('3', '3', 'customer', '1', 'General Trade', 'A7 - ឈឹម សាមុត (Chim Samoth)', 'A7 - ឈឹម សាមុត (Chim Samoth)', '', '#135, St. 245 Mao Tsetong', '', '', '', '', '092 215 496', '', '', null, null, null, null, null, null, '0', 'logo.png', '12', null, '', null, '', null, '0000-00-00', '0000-00-00', '0000-00-00', null, null, null, null, null, null, null);
INSERT INTO `erp_companies` VALUES ('4', '3', 'customer', '1', 'General Trade', 'ជវិច្ចតា', 'Chhak Victa', 'Sovann', '', '', '', '', '', '078 313 646', '', '', null, null, null, null, null, null, '0', 'logo.png', '1979', null, '', null, '', null, '0000-00-00', '0000-00-00', '0000-00-00', null, null, null, null, null, null, null);
INSERT INTO `erp_companies` VALUES ('5', '3', 'customer', '1', 'General Trade', 'អានីតា អូតូ', 'Anita Auto', 'Sovann', '#348, St. 163, Sangkat Toul Svay Prey I, Chamka Morn,  PP', '', '', '', '', '012 34 55 55', '', '', null, null, null, null, null, null, '0', 'logo.png', '0', null, '', null, '', null, '0000-00-00', '0000-00-00', '0000-00-00', null, null, null, null, null, null, null);
INSERT INTO `erp_companies` VALUES ('546', '3', 'biller', '1', 'Dara', 'Dara', 'A-Y Collection', '', 'Phnom Penh', '', '', '', '', '012222222', 'dara@yahoo.com', '', '', '', '', '1', '', '', '0', 'Kimgan_Logo1.jpg', '0', null, null, null, null, null, null, null, null, null, '', '', '', '', '', '');
INSERT INTO `erp_companies` VALUES ('547', '4', 'supplier', '1', 'Veasna', 'Veasnana', 'Big Collection', 'ddd', 'Phnom Penh', 'Phnom Penh', '', '', '', '01234555555', 'tony@gmail.com', '', '', '', '', '', '', null, '0', 'logo.png', '0', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
INSERT INTO `erp_companies` VALUES ('548', '4', 'driver', '1', 'Vutha', 'Vuthatha', 'Smal Collectio', 'sdf', 'Phnom Penh', 'Phnom Penh', '', '', '', '01234555555', 'veasna@gmail.com', '', '', '', '', '', '', '', '0', 'logo.png', '0', '0.0000', '', '', '', '', '0000-00-00', '0000-00-00', '0000-00-00', '0.0000', '', '', '', '', '', '');

-- ----------------------------
-- Table structure for erp_condition_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_condition_tax`;
CREATE TABLE `erp_condition_tax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(55) NOT NULL,
  `rate` decimal(12,4) NOT NULL,
  `min_salary` double(19,0) DEFAULT NULL,
  `max_salary` double(19,0) DEFAULT NULL,
  `reduct_tax` double(19,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_condition_tax
-- ----------------------------

-- ----------------------------
-- Table structure for erp_convert
-- ----------------------------
DROP TABLE IF EXISTS `erp_convert`;
CREATE TABLE `erp_convert` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(55) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `noted` varchar(200) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bom_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_convert
-- ----------------------------

-- ----------------------------
-- Table structure for erp_convert_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_convert_items`;
CREATE TABLE `erp_convert_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `convert_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` decimal(25,4) NOT NULL,
  `cost` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `transfer_id` (`convert_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_convert_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_costing
-- ----------------------------
DROP TABLE IF EXISTS `erp_costing`;
CREATE TABLE `erp_costing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `sale_item_id` int(11) NOT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `purchase_item_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `purchase_net_unit_cost` decimal(25,4) DEFAULT NULL,
  `purchase_unit_cost` decimal(25,4) DEFAULT NULL,
  `sale_net_unit_price` decimal(25,4) NOT NULL,
  `sale_unit_price` decimal(25,4) NOT NULL,
  `quantity_balance` decimal(15,4) DEFAULT NULL,
  `inventory` tinyint(1) DEFAULT '0',
  `overselling` tinyint(1) DEFAULT '0',
  `option_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_costing
-- ----------------------------

-- ----------------------------
-- Table structure for erp_currencies
-- ----------------------------
DROP TABLE IF EXISTS `erp_currencies`;
CREATE TABLE `erp_currencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(5) NOT NULL,
  `name` varchar(55) NOT NULL,
  `in_out` tinyint(1) DEFAULT NULL,
  `rate` decimal(12,4) NOT NULL,
  `auto_update` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_currencies
-- ----------------------------
INSERT INTO `erp_currencies` VALUES ('1', 'USD', 'US Dollar', '1', '1.0000', '0');
INSERT INTO `erp_currencies` VALUES ('4', 'KHM', 'Riel', '1', '4050.0000', '0');
INSERT INTO `erp_currencies` VALUES ('6', 'BAHT', 'Baht', '1', '30.0000', '0');
INSERT INTO `erp_currencies` VALUES ('7', 'KHM_o', 'Riel', '0', '4000.0000', '0');
INSERT INTO `erp_currencies` VALUES ('8', 'BAHT_', 'Baht', '0', '30.0000', '0');

-- ----------------------------
-- Table structure for erp_customer_groups
-- ----------------------------
DROP TABLE IF EXISTS `erp_customer_groups`;
CREATE TABLE `erp_customer_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `percent` int(11) NOT NULL,
  `makeup_cost` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_customer_groups
-- ----------------------------
INSERT INTO `erp_customer_groups` VALUES ('1', 'General Trade', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('2', 'Garage', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('3', 'End User', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('4', 'Motor Shop', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('5', 'Modern Trade', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('6', 'Whole Seller', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('7', 'Distributor', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('8', 'Other Customer', '0', '0');
INSERT INTO `erp_customer_groups` VALUES ('13', 'General', '0', '0');

-- ----------------------------
-- Table structure for erp_date_format
-- ----------------------------
DROP TABLE IF EXISTS `erp_date_format`;
CREATE TABLE `erp_date_format` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `js` varchar(20) NOT NULL,
  `php` varchar(20) NOT NULL,
  `sql` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_date_format
-- ----------------------------
INSERT INTO `erp_date_format` VALUES ('1', 'mm-dd-yyyy', 'm-d-Y', '%m-%d-%Y');
INSERT INTO `erp_date_format` VALUES ('2', 'mm/dd/yyyy', 'm/d/Y', '%m/%d/%Y');
INSERT INTO `erp_date_format` VALUES ('3', 'mm.dd.yyyy', 'm.d.Y', '%m.%d.%Y');
INSERT INTO `erp_date_format` VALUES ('4', 'dd-mm-yyyy', 'd-m-Y', '%d-%m-%Y');
INSERT INTO `erp_date_format` VALUES ('5', 'dd/mm/yyyy', 'd/m/Y', '%d/%m/%Y');
INSERT INTO `erp_date_format` VALUES ('6', 'dd.mm.yyyy', 'd.m.Y', '%d.%m.%Y');
INSERT INTO `erp_date_format` VALUES ('7', 'yyyy-mm-dd', 'Y-m-d', '%Y-%m-%d');

-- ----------------------------
-- Table structure for erp_deliveries
-- ----------------------------
DROP TABLE IF EXISTS `erp_deliveries`;
CREATE TABLE `erp_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_id` int(11) NOT NULL,
  `do_reference_no` varchar(50) NOT NULL,
  `sale_reference_no` varchar(50) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `address` varchar(1000) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `delivery_by` int(11) DEFAULT NULL,
  `delivery_status` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_deliveries
-- ----------------------------

-- ----------------------------
-- Table structure for erp_delivery_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_delivery_items`;
CREATE TABLE `erp_delivery_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `delivery_id` int(11) NOT NULL,
  `do_reference_no` varchar(50) NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `category_name` varchar(255) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `begining_balance` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) NOT NULL,
  `ending_balance` decimal(25,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`do_reference_no`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`do_reference_no`),
  KEY `sale_id_2` (`do_reference_no`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_delivery_items
-- ----------------------------
INSERT INTO `erp_delivery_items` VALUES ('1', '5', '', '135', '50', 'standard', 'Teeccino Chicory Herbal `Coffee` Ground Vanilla Nut', '1322', '', '1', null, null, '4.0000', '-4.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('2', '6', '', '135', '50', 'standard', 'Teeccino Chicory Herbal `Coffee` Ground Vanilla Nut', '1322', '', '1', null, null, '5.0000', '-5.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('3', '7', '', '533', '49', 'standard', 'Hublot', '1264', '', '1', null, null, '2.0000', null, null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('4', '8', '', '533', '49', 'standard', 'Hublot', '1264', '', '1', null, null, '2.0000', null, null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('5', '9', '', '533', '49', 'standard', 'Hublot', '1264', '', '1', null, null, '4.0000', '-4.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('6', '35', 'DO23453453', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', '0.0000', '20.0000', '2.0000', '18.0000', null, '0000-00-00 00:00:00', null, '0000-00-00 00:00:00');
INSERT INTO `erp_delivery_items` VALUES ('7', '35', 'DO23453453', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', '0.0000', '18.0000', '4.0000', '14.0000', null, '0000-00-00 00:00:00', null, '0000-00-00 00:00:00');
INSERT INTO `erp_delivery_items` VALUES ('9', '38', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('10', '39', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('11', '40', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('12', '41', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('13', '42', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('14', '43', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('15', '44', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('16', '45', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);
INSERT INTO `erp_delivery_items` VALUES ('17', '46', '', '6', '37', 'standard', 'Nike - Shoe', '0', '', '1', null, '14.0000', '2.0000', '12.0000', null, null, null, null);

-- ----------------------------
-- Table structure for erp_deposits
-- ----------------------------
DROP TABLE IF EXISTS `erp_deposits`;
CREATE TABLE `erp_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `company_id` int(11) NOT NULL,
  `amount` decimal(25,4) NOT NULL,
  `paid_by` varchar(50) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `bank_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_deposits
-- ----------------------------
INSERT INTO `erp_deposits` VALUES ('1', '2016-12-09 13:42:00', '2', '500.0000', 'cash', null, '1', null, null, null, null, '546');
INSERT INTO `erp_deposits` VALUES ('2', '2016-12-09 23:28:00', '1', '0.0000', 'cash', 'Hea Mab - ហ៊ា ម៉ាប់', '1', null, null, null, null, '546');
INSERT INTO `erp_deposits` VALUES ('3', '2016-12-10 08:29:00', '2', '22.0000', 'cash', null, '1', null, null, null, null, '546');

-- ----------------------------
-- Table structure for erp_documents
-- ----------------------------
DROP TABLE IF EXISTS `erp_documents`;
CREATE TABLE `erp_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `description` text,
  `brand_id` varchar(50) DEFAULT NULL,
  `category_id` varchar(50) DEFAULT NULL,
  `subcategory_id` varchar(50) DEFAULT NULL,
  `cost` decimal(50,0) DEFAULT NULL,
  `price` decimal(8,4) DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `image` varchar(150) DEFAULT NULL,
  `serial` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_documents
-- ----------------------------

-- ----------------------------
-- Table structure for erp_document_photos
-- ----------------------------
DROP TABLE IF EXISTS `erp_document_photos`;
CREATE TABLE `erp_document_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `photo` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_document_photos
-- ----------------------------

-- ----------------------------
-- Table structure for erp_employee_salary_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax`;
CREATE TABLE `erp_employee_salary_tax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL DEFAULT '0',
  `basic_salary` decimal(24,4) DEFAULT NULL,
  `amount_usd` decimal(24,4) DEFAULT NULL,
  `spouse` int(10) DEFAULT NULL,
  `minor_children` int(20) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `date_insert` date DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `location` varchar(300) DEFAULT NULL,
  `date_print` date NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `trigger_id` int(11) DEFAULT NULL,
  `tax_rate` double DEFAULT NULL,
  `salary_tax` double DEFAULT NULL,
  `salary_tobe_paid` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `trigger_id` (`trigger_id`),
  KEY `date_insert` (`date_insert`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_employee_salary_tax
-- ----------------------------

-- ----------------------------
-- Table structure for erp_employee_salary_tax_small_taxpayers
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax_small_taxpayers`;
CREATE TABLE `erp_employee_salary_tax_small_taxpayers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL DEFAULT '0',
  `basic_salary` decimal(24,4) DEFAULT NULL,
  `amount_usd` decimal(24,4) DEFAULT NULL,
  `spouse` int(10) DEFAULT NULL,
  `minor_children` int(20) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `date_insert` date DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `location` varchar(300) DEFAULT NULL,
  `date_print` date NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `trigger_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_employee_salary_tax_small_taxpayers
-- ----------------------------

-- ----------------------------
-- Table structure for erp_employee_salary_tax_small_taxpayers_trigger
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax_small_taxpayers_trigger`;
CREATE TABLE `erp_employee_salary_tax_small_taxpayers_trigger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL,
  `year_month` date NOT NULL,
  `isCompany` tinyint(1) unsigned NOT NULL,
  `updated_by` int(11) unsigned DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  `total_salary_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_cal_base_riel` decimal(24,2) DEFAULT NULL,
  `total_salary_tax_riel` decimal(24,2) DEFAULT NULL,
  `date_print` date DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `trigger_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_employee_salary_tax_small_taxpayers_trigger
-- ----------------------------

-- ----------------------------
-- Table structure for erp_employee_salary_tax_trigger
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax_trigger`;
CREATE TABLE `erp_employee_salary_tax_trigger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL,
  `year_month` varchar(15) NOT NULL,
  `isCompany` tinyint(1) unsigned NOT NULL,
  `updated_by` int(11) unsigned DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  `total_salary_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_cal_base_riel` decimal(24,2) DEFAULT NULL,
  `total_salary_tax_riel` decimal(24,2) DEFAULT NULL,
  `date_print` date DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `reference` (`reference_no`),
  KEY `year_month` (`year_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_employee_salary_tax_trigger
-- ----------------------------

-- ----------------------------
-- Table structure for erp_enter_using_stock
-- ----------------------------
DROP TABLE IF EXISTS `erp_enter_using_stock`;
CREATE TABLE `erp_enter_using_stock` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `warehouse_id` int(5) DEFAULT NULL,
  `authorize_id` int(10) DEFAULT NULL,
  `employee_id` int(10) DEFAULT NULL,
  `shop` int(10) DEFAULT NULL,
  `account` int(20) DEFAULT NULL,
  `note` text,
  `create_by` int(10) DEFAULT NULL,
  `reference_no` varchar(255) DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL,
  `total_cost` decimal(25,4) DEFAULT NULL,
  `using_reference_no` varchar(255) DEFAULT NULL,
  `total_using_cost` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_enter_using_stock
-- ----------------------------

-- ----------------------------
-- Table structure for erp_enter_using_stock_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_enter_using_stock_items`;
CREATE TABLE `erp_enter_using_stock_items` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `description` text,
  `reason` text,
  `qty_use` decimal(25,4) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `reference_no` varchar(255) DEFAULT NULL,
  `warehouse_id` int(10) DEFAULT NULL,
  `qty_by_unit` int(25) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_enter_using_stock_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_expenses
-- ----------------------------
DROP TABLE IF EXISTS `erp_expenses`;
CREATE TABLE `erp_expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference` varchar(55) NOT NULL,
  `amount` decimal(25,6) NOT NULL,
  `note` varchar(1000) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `bank_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `tax` tinyint(3) DEFAULT '0',
  `status` varchar(55) DEFAULT '',
  `warehouse_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_expenses
-- ----------------------------

-- ----------------------------
-- Table structure for erp_expense_categories
-- ----------------------------
DROP TABLE IF EXISTS `erp_expense_categories`;
CREATE TABLE `erp_expense_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_expense_categories
-- ----------------------------

-- ----------------------------
-- Table structure for erp_gift_cards
-- ----------------------------
DROP TABLE IF EXISTS `erp_gift_cards`;
CREATE TABLE `erp_gift_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `card_no` varchar(20) NOT NULL,
  `value` decimal(25,4) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(255) DEFAULT NULL,
  `balance` decimal(25,4) NOT NULL,
  `expiry` date DEFAULT NULL,
  `created_by` varchar(55) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `card_no` (`card_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_gift_cards
-- ----------------------------

-- ----------------------------
-- Table structure for erp_gl_charts
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_charts`;
CREATE TABLE `erp_gl_charts` (
  `accountcode` int(11) NOT NULL DEFAULT '0',
  `accountname` varchar(200) DEFAULT '',
  `parent_acc` int(11) DEFAULT '0',
  `sectionid` int(11) DEFAULT '0',
  `account_tax_id` int(11) DEFAULT '0',
  `acc_level` int(11) DEFAULT '0',
  `lineage` varchar(500) NOT NULL,
  `bank` tinyint(1) DEFAULT NULL,
  `value` decimal(55,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`accountcode`),
  KEY `AccountCode` (`accountcode`) USING BTREE,
  KEY `AccountName` (`accountname`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_gl_charts
-- ----------------------------
INSERT INTO `erp_gl_charts` VALUES ('100100', 'Cash', '0', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100101', 'Petty Cash', '100100', '10', '0', '0', '', '1', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100102', 'Cash on Hand', '100100', '10', '0', '0', '', '1', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100103', 'ANZ Bank', '100100', '10', '0', '0', '', '1', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100104', 'CAMPU Bank', '100100', '10', '0', '0', '', '1', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100105', 'Visa', '100100', '10', '0', '0', '', '1', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100106', 'Chequing Bank Account', '100100', '10', '0', '0', '', '1', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100200', 'Account Receivable', '0', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100400', 'Other Current Assets', '0', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100410', 'Prepaid Expense', '100400', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100420', 'Supplier Deposit', '100400', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100430', 'Inventory', '100400', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100440', 'Deferred Tax Asset', '100400', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100441', 'VAT Input', '100440', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100442', 'VAT Credit Carried Forward', '100440', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100500', 'Cash Advance', '100400', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100501', 'Loan to Related Parties', '100400', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('100502', 'Staff Advance Cash', '100400', '10', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('101005', 'Own Invest', '0', '80', '0', '0', '', '1', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110200', 'Property, Plant and Equipment', '0', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110201', 'Furniture', '110200', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110202', 'Office Equipment', '110200', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110203', 'Machineries', '110200', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110204', 'Leasehold Improvement', '110200', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110205', 'IT Equipment & Computer', '110200', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110206', 'Vehicle', '110200', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110250', 'Less Total Accumulated Depreciation', '110200', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110251', 'Less Acc. Dep. of Furniture', '110250', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110252', 'Less Acc. Dep. of Office Equipment', '110250', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110253', 'Less Acc. Dep. of Machineries', '110250', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110254', 'Less Acc. Dep. of Leasehold Improvement', '110250', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110255', 'Less Acc. Dep. of IT Equipment & Computer', '110250', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('110256', 'Less Acc. Dep of Vehicle', '110250', '11', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201100', 'Accounts Payable', '0', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201200', 'Other Current Liabilities', '0', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201201', 'Salary Payable', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201202', 'OT Payable', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201203', 'Allowance Payable', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201204', 'Bonus Payable', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201205', 'Commission Payable', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201206', 'Interest Payable', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201207', 'Loan from Related Parties', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201208', 'Customer Deposit', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201209', 'Accrued Expense', '201200', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201400', 'Deferred Tax Liabilities', '0', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201401', 'Salary Tax Payable', '201400', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201402', 'Withholding Tax Payable', '201400', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201403', 'VAT Payable', '201400', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201404', 'Profit Tax Payable', '201400', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201405', 'Prepayment Profit Tax Payable', '201400', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201406', 'Fringe Benefit Tax Payable', '201400', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('201407', 'VAT Output', '201400', '20', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('300000', 'Capital Stock', '0', '30', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('300100', 'Paid-in Capital', '300000', '30', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('300101', 'Additional Paid-in Capital', '300000', '30', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('300200', 'Retained Earnings', '0', '30', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('300300', 'Opening Balance', '0', '30', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('400000', 'Sale Revenue', '0', '40', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('400001', 'Utilities', '0', '60', '0', '0', '6790', '0', '0.00');
INSERT INTO `erp_gl_charts` VALUES ('410101', 'Income', '400000', '40', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('410102', 'Sale Discount', '400000', '40', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('410107', 'Other Income', '400000', '40', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('500000', 'Cost of Goods Sold', '0', '50', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('500101', 'COMS', '500000', '50', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('500102', 'Freight Expense', '500000', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('500103', 'Wages & Salaries', '500000', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('500106', 'Purchase Discount', '500000', '50', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('500107', 'Inventory Adjustment', '500000', '50', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('500108', 'Cost of Variance', '500000', '50', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('600000', 'Expenses', '0', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601100', 'Staff Cost', '600000', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601101', 'Salary Expense', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601102', 'OT', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601103', 'Allowance ', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601104', 'Bonus', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601105', 'Commission', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601106', 'Training/Education', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601107', 'Compensation', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601108', 'Other Staff Relation', '601100', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601200', 'Administration Cost', '600000', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601201', 'Rental Expense', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601202', 'Utilities', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601203', 'Marketing & Advertising', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601204', 'Repair & Maintenance', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601205', 'Customer Relation', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601206', 'Transportation', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601207', 'Communication', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601208', 'Insurance Expense', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601209', 'Professional Fee', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601210', 'Depreciation Expense', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601211', 'Amortization Expense', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601212', 'Stationery', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601213', 'Office Supplies', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601214', 'Donation', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601215', 'Entertainment Expense', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601216', 'Travelling & Accomodation', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601217', 'Service Computer Expenses', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601218', 'Interest Expense', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601219', 'Bank Charge', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601220', 'Miscellaneous Expense', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601221', 'Canteen Supplies', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('601222', 'Registration Expenses', '601200', '60', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('710300', 'Other Income', '0', '70', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('710301', 'Interest Income', '710300', '70', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('710302', 'Other Revenue & Gain', '710300', '70', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('801300', 'Other Expenses', '0', '80', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('801301', 'Other Expense & Loss', '801300', '80', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('801302', 'Bad Dept Expense', '801300', '80', '0', '0', '', null, '0.00');
INSERT INTO `erp_gl_charts` VALUES ('801303', 'Tax & Duties Expense', '801300', '80', '0', '0', '', null, '0.00');

-- ----------------------------
-- Table structure for erp_gl_charts_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_charts_tax`;
CREATE TABLE `erp_gl_charts_tax` (
  `account_tax_id` int(11) NOT NULL AUTO_INCREMENT,
  `accountcode` varchar(19) DEFAULT '0',
  `accountname` varchar(200) DEFAULT '',
  `accountname_kh` varchar(250) DEFAULT '0',
  `sectionid` int(11) DEFAULT '0',
  PRIMARY KEY (`account_tax_id`),
  KEY `AccountCode` (`accountcode`) USING BTREE,
  KEY `AccountName` (`accountname`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of erp_gl_charts_tax
-- ----------------------------
INSERT INTO `erp_gl_charts_tax` VALUES ('1', 'B1', 'Sales of manufactured products', 'ការលក់ផលិតផល', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('2', 'B2', 'Sales of goods', 'ការលក់ទំនិញ', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('3', 'B3', 'Sales/Supply of services', 'ការផ្គត់ផ្គង់សេវា', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('4', 'A2', 'Freehold Land', 'ដីធ្លីរបស់សហគ្រាស', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('5', 'A3', 'Improvements and preparation of land', 'ការរៀបចំតុបតែងលំអរដីរបស់សហគ្រាស', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('6', 'A4', 'Freehold buildings', 'សំណង់ងគាររបស់សហគ្រាស', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('7', 'B4', 'Costs of pruducts sold of production enterprises(TOP 01/V)', 'ថៃ្លដើមផលិតផលបានលក់របស់សហគ្រាសផលិតកម្ម​(TOP 01/V)', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('8', 'A5', 'Freehold buildings on leasehold land', 'សំណង់អាគារលើដីធ្លីក្រោមភតិសន្យា', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('9', 'B5', 'Costs of goods sold of​​​​ non- production enterprises (TOP 01/VI)', 'ថៃ្លដើម ទំនិញបានលក់របស់សហគ្រាសក្រៅពីផលិតកម្ម(TOP 0', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('10', 'A6', 'Non-current assets in progress', 'ទ្រព្យសកម្មរយះពេលវែងកំពុងដំណើរការ', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('11', 'A7', 'Plant and equipemt', 'រោងចក្រ​​​(ក្រៅពីអគារ)និងបរិក្ខារ', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('12', 'B5a', 'Costs of services supplied', 'ថៃ្លដើមសេវាបានផ្គត់ផ្គង់', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('13', 'A8', 'Goodwill', 'កេរ្តិ៍ឈ្មោះ/មូលនិធិពាណិជ្ជកម្ម', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('14', 'A9', 'Preliminary and formation expenses', 'ចំណាយបង្កើតសហគ្រាសដំបូង', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('15', 'B8', 'Grant/subsidy', 'ឧបត្ថម្ភកធន', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('16', 'A10', 'Leasehold assets and lease premiums', 'ទ្រព្យសកម្មក្រោមភតិសន្យា​​ និង​បុព្វលាភនៃការប្រើប្', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('17', 'A11', 'Investment in other enterprise', 'វិនិយោគក្នុងសហគ្រាសដទៃ', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('18', 'B9', 'Dividend received or receivable', 'ចំណូលពីភាគលាភបានទទួល​ ឬ ត្រូវទទួល', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('19', 'B10', 'Interest received or receivable', 'ចំំណូលពីការប្រាក់បានទទួល ឬ ត្រូវទទួល', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('20', 'A29', 'Capital/ Share capital', 'មូលធន/ មូលធនភាគហ៊ុន', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('21', 'A12', 'Other non-current assets', 'ទ្រព្យសកម្មរយ:ពេលវែងផ្សេងៗ', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('22', 'B11', 'Royalty received or receivable', 'ចំណូលពីសួយសារបានទទួល ឬ ត្រូវទទួល', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('23', 'A30', 'Share premium', 'តម្លៃលើសនៃការលក់ប័ណ្ណភាគហ៊ុន', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('24', 'B12', 'Rental received or receivable', 'ចំណូលពីការជួលបានទទួល ឬ ត្រូវទទួល', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('25', 'A31', 'Legal capital reserves', 'មូលធនបំរុងច្បាប់', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('26', 'A14', 'Stock of raw materials and supplies', 'ស្តូកវត្ធុធាតុដើម និងសំភារ:ផ្គត់ផ្គង់', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('27', 'A32', 'Reserves revaluation surplus of assets', 'លំអៀងលើសការវាយតំលៃឡើងវិញនូវទ្រព្យសកម្ម', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('28', 'A33', 'Other capital reserves', 'មូលធនបំរុងផ្សេងៗ', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('29', 'A15', 'Stock of goods', 'ស្តុកទំនិញ', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('30', 'B13', 'Gain from disposal of fixed assets (captital gain)', 'ផលចំណេញ/តំលៃលើសពីការលក់ទ្រព្យសកម្មរយះពេលវែង', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('31', 'A34', 'Profit and loss brought forward', 'លទ្ធផលចំណេញ/ ខាត យោងពីមុន', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('32', 'A16', 'Stock of finished goods', 'ស្តុកផលិតផលសម្រាច', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('33', 'A35', 'Profit and loss for the period', 'លទ្ធផងចំណេញ/ ខាត នៃកាលបរិច្ឆេត', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('34', 'B14', 'Gain from disposal of securities', 'ផលចំណេញពីការលក់មូលប័ត្រ/សញ្ញាប័ណ្ណ', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('35', 'A37', 'Loan from related parties', 'បំណុលភាគីជាប់ទាក់ទិន', '21');
INSERT INTO `erp_gl_charts_tax` VALUES ('36', 'A38', 'Loan from banks and other external parties', 'បំណុលធនាគារ និងបំណុលភាគីមិនជាប់ទាក់ទិនផ្សេងៗ', '21');
INSERT INTO `erp_gl_charts_tax` VALUES ('37', 'B15', 'Share of profit from joint venture', 'ភាគចំណេញពីប្រតិបត្តិការរួមគ្នា', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('38', 'A17', 'Products in progress', 'ផលិតផលកំពុងផលិត', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('39', 'A39', 'Provision for charges and contigencies', 'សវិធានធនសំរាប់បន្ទុក និង​ហានិភ័យ', '21');
INSERT INTO `erp_gl_charts_tax` VALUES ('40', 'B16', 'Realised exchange gain', 'ផលចំណេញពីការប្តូរប្រាក់សំរេចបាន', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('41', 'A40', 'Other non-current liabilities', 'បំណុលរយៈពេលវែងផ្សេងៗ', '21');
INSERT INTO `erp_gl_charts_tax` VALUES ('42', 'A18', 'Account receivevable/trade debtors', 'គណនីត្រូវទទួល​ /អតិថិជន', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('43', 'B17', 'Unrealised exchange gain', 'ផលចំណេញពីការប្តូរប្រាក់មិនទាន់សំរេចបាន', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('44', 'A42', 'Bank overdraft', 'សាច់ប្រាក់ដកពីធនាគារលើសប្រាក់បញ្ជី (ឥណទានរិបារូប៍រ', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('45', 'A19', 'Other account receivables', 'គណនីទទួលផ្សេងៗ', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('46', 'B18', 'Other revenues', 'ចំណូលដ៏ទៃទៀត', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('47', 'A43', 'Short-term borrowing-current portion of interest bearing borrowing', 'ចំណែកចរន្តនៃបំណុលមានការប្រាក់', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('48', 'A20', 'Prepaid expenses', 'ចំណាយបានកត់ត្រាមុន', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('49', 'B20', 'Salaries expenses', 'ចំណាយបៀវត្ស', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('50', 'A44', 'Accounts payble to relate parties', 'គណនីត្រូវសងបុគ្គលជាប់ទាក់ទិន (ភាគីសម្ព័ន្ធញាត្តិ)', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('51', 'A45', 'Other accounts payable', 'គណនីត្រូវសងផ្សេងៗ', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('52', 'A21', 'Cash on hand and at banks', 'សាច់ប្រាក់នៅក្នុងបេឡា និងនៅធនាគា', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('53', 'B21', 'Fuel, gas,electricity and water expenses', 'ចំណាយប្រេង ឧស្មន័ អគ្គីសនី និងទឹក', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('54', 'A46', 'Unearned revenue, accruals and other current liabilities', 'ចំណូលកត់មុន គណនីចំណាយបង្ករ និងបំណុលរយោៈពេលខ្លីផ្សេ', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('55', 'A47', 'Provision for changes and contigencies', 'សវិធានធនសំរាប់បន្ទុក និង​ហានិភ័យ', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('56', 'B22', 'Travelling and accommodation expenses', 'ចំណាយធើ្វដំណើរ និងចំណាយស្នាក់នៅ', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('57', 'A48', 'Profit tax payable', 'ពន្ធលើប្រាក់ចំណេញត្រូវបង់', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('58', 'A49', 'Other taxes payable', 'ពន្ទ-អាករផ្សេងៗត្រូវបង់', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('59', 'B23', 'Transporttation expenses', 'ចំណាយដឹកជញ្ជូន', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('60', 'A50', 'Differences arissing from currency translation in liabilities', 'លំអៀងពីការប្តូរប្រាក់នៃទ្រព្យសកម្ម', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('61', 'B24', 'Rental expenses', 'ចំណាយលើការជួល', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('62', 'B25', 'Repair anmaintenance expenses', 'ចំណាយលើការថែទាំ និងជួសជុល', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('63', 'B26', 'Entertament expenses', 'ចំណាយលើការកំសាន្តសប្យាយ', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('64', 'A22', 'Prepayment of profit tax credit', 'ឥណទានប្រាក់រំដោះពន្ធលើប្រាក់ចំណេញ', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('65', 'B27', 'Commission, advertising, and selling expenses', 'ចំណាយកំរៃជើងសារ ផ្សាយពាណិ្ជកម្ម និងចំណាយការលក់', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('66', 'A23', 'Value added tax credit', 'ឥណទានអាករលើតម្លៃបន្ថែម', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('67', 'B28', 'Other taxes expenses', 'ចំណាយបង់ពន្ធ និងអាករផេ្សងៗ', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('68', 'B29', 'Donation expenses', 'ចំណាយលើអំណោយ', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('69', 'A24', 'Other taxes credit', 'ឥណទានពន្ធ-អាករដដៃទៀត', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('70', 'B30', 'Management, consultant, other technical, and other similar services expenses', 'ចំណាយសេវាគ្រប់គ្រង ពិគ្រោះយោបល់ បចេ្វកទេស និងសេវាប', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('71', 'A25', 'Other current assets', 'ទ្រព្យសកម្មពេលខ្លីផ្សេងៗ', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('72', 'B31', 'Royalty expenses', 'ចំណាយលើសួយសារ', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('73', 'B32', 'Bad debts written off expenses', 'ចំណាយលើបំណុលទារមិនបាន', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('74', 'A26', 'Diffference arising from currency translation in assets', 'លំអៀងពីការប្តូរទ្រព្យសកម្ម', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('75', 'B33', 'Armortisation/depletion and depreciation expenses', 'ចំណាយរំលស់', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('76', 'B34', 'Increase /(decrease) in expenses', 'ការកើនឡើង /​ (ថយចុះ) សំវិធានធន', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('77', 'B35', 'Loss on siposal of fixed assets', 'ខាតពីការលក់ទ្រព្យសកម្មរយះពេលវែង', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('78', 'B36', 'Realised exchange loss', 'ខាតពីការប្តូរប្រាក់សំរេចបាន', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('79', 'B37', 'Unrealised exchange loss', 'ខាតពីការប្តូរប្រាក់មិនទាន់សំរេចបាន', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('80', 'B38', 'Other expenses', 'ចំណាយផេ្សងៗ', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('81', 'B40', 'Interest expenses paid to residents', 'ចំណាយការប្រាក់បង់អោយនិវាសនជន', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('82', 'B41', 'Interest expenses paid to non-residents', 'ចំណាយការប្រាក់បង់អោយអនិវាសនជន', '60');
INSERT INTO `erp_gl_charts_tax` VALUES ('83', 'A1', 'Non-current assets/ fixed assets', 'ទ្រព្យសកម្មរយៈពេលេវែង', '10');
INSERT INTO `erp_gl_charts_tax` VALUES ('84', 'A13', 'Current assets', 'ទ្រព្យសកម្មរយៈពេលខ្លី', '11');
INSERT INTO `erp_gl_charts_tax` VALUES ('85', 'A28', 'Equity', 'មូលនិធិ/ ទុនម្ចាស់ទ្រព្យ ', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('86', 'A36', 'Non-current liabilities', 'បំណុលរយៈពេលវែង', '21');
INSERT INTO `erp_gl_charts_tax` VALUES ('87', 'A41', 'Current liabilities', 'បំណុលរយៈពេលខ្លី', '20');
INSERT INTO `erp_gl_charts_tax` VALUES ('88', 'B0', 'Operating revenue', 'ចំណូលប្រតិបត្តិការ', '30');
INSERT INTO `erp_gl_charts_tax` VALUES ('89', 'B7', 'Other revenue', 'ចំណូលផ្សេងៗ', '70');
INSERT INTO `erp_gl_charts_tax` VALUES ('90', 'B19', 'Operating expenses', 'ចំណាយប្រតិបតិ្តការ', '60');

-- ----------------------------
-- Table structure for erp_gl_sections
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_sections`;
CREATE TABLE `erp_gl_sections` (
  `sectionid` int(11) NOT NULL DEFAULT '0',
  `sectionname` text,
  `sectionname_kh` text,
  `AccountType` char(2) DEFAULT NULL,
  `description` text,
  `pandl` int(11) DEFAULT '0',
  `order_stat` int(11) DEFAULT '0',
  PRIMARY KEY (`sectionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_gl_sections
-- ----------------------------
INSERT INTO `erp_gl_sections` VALUES ('10', 'CURRENT ASSETS', 'ទ្រព្យសកម្មរយះពេលខ្លី', 'AS', 'CURRENT ASSETS', '0', '10');
INSERT INTO `erp_gl_sections` VALUES ('11', 'FIXED ASSETS', 'ទ្រព្យសកម្មរយះពេលវែង', 'AS', 'FIXED ASSETS', '0', '11');
INSERT INTO `erp_gl_sections` VALUES ('20', 'CURRENT LIABILITIES', 'បំណុលរយះពេលខ្លី', 'LI', 'CURRENT LIABILITIES', '0', '20');
INSERT INTO `erp_gl_sections` VALUES ('21', 'NON-CURRENT LIABILITIES', 'បំណុលរយះពេលវែង', 'LI', 'NON-CURRENT LIABILITIES', '0', '21');
INSERT INTO `erp_gl_sections` VALUES ('30', 'EQUITY AND RETAINED EARNING', 'មូលនិធិ/ទុនម្ចាស់ទ្រព្យ', 'EQ', 'EQUITY AND RETAINED EARNING', '0', '30');
INSERT INTO `erp_gl_sections` VALUES ('40', 'INCOME', 'ចំណូលប្រតិបត្តិការ', 'RE', 'INCOME', '1', '40');
INSERT INTO `erp_gl_sections` VALUES ('50', 'COST OF GOODS SOLD', null, 'CO', 'COST OF GOODS SOLD', '1', '50');
INSERT INTO `erp_gl_sections` VALUES ('60', 'OPERATING EXPENSES', 'ចំណាយប្រតិបត្តិការ', 'EX', 'OPERATING EXPENSES', '1', '60');
INSERT INTO `erp_gl_sections` VALUES ('70', 'OTHER INCOME', 'ចំណូលផ្សេងៗ', 'OI', 'OTHER INCOME', '1', '70');
INSERT INTO `erp_gl_sections` VALUES ('80', 'OTHER EXPENSE', null, 'OX', 'OTHER EXPENSE', '1', '80');
INSERT INTO `erp_gl_sections` VALUES ('90', 'GAIN & LOSS', null, 'GL', 'GAIN & LOSS', '1', '90');

-- ----------------------------
-- Table structure for erp_gl_trans
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_trans`;
CREATE TABLE `erp_gl_trans` (
  `tran_id` int(11) NOT NULL AUTO_INCREMENT,
  `tran_type` varchar(20) DEFAULT '0',
  `tran_no` bigint(20) NOT NULL DEFAULT '1',
  `tran_date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `sectionid` int(11) DEFAULT '0',
  `account_code` int(19) DEFAULT '0',
  `narrative` varchar(100) DEFAULT '',
  `amount` decimal(25,4) DEFAULT '0.0000',
  `reference_no` varchar(55) DEFAULT '',
  `description` varchar(250) DEFAULT '',
  `biller_id` int(11) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bank` tinyint(3) DEFAULT '0',
  `gov_tax` tinyint(3) DEFAULT '0',
  `reference_gov_tax` varchar(55) DEFAULT '',
  `people_id` int(11) DEFAULT NULL,
  `invoice_ref` varchar(55) DEFAULT NULL,
  `ref_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`tran_id`),
  KEY `Account` (`account_code`) USING BTREE,
  KEY `TranDate` (`tran_date`) USING BTREE,
  KEY `TypeNo` (`tran_no`) USING BTREE,
  KEY `Type_and_Number` (`tran_type`,`tran_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_gl_trans
-- ----------------------------

-- ----------------------------
-- Table structure for erp_gl_trans_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_trans_audit`;
CREATE TABLE `erp_gl_trans_audit` (
  `auit_gl_trans_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_save_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tran_id` int(11) NOT NULL,
  `tran_type` varchar(20) DEFAULT '0',
  `tran_no` bigint(20) NOT NULL DEFAULT '1',
  `tran_date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `sectionid` int(11) DEFAULT '0',
  `account_code` int(19) DEFAULT '0',
  `narrative` varchar(100) DEFAULT '',
  `amount` decimal(25,2) DEFAULT '0.00',
  `reference_no` varchar(55) DEFAULT '',
  `description` varchar(250) DEFAULT '',
  `biller_id` int(11) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bank` tinyint(3) DEFAULT '0',
  `gov_tax` tinyint(3) DEFAULT '0',
  `reference_gov_tax` varchar(55) DEFAULT '',
  `people_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`auit_gl_trans_id`),
  KEY `Account` (`account_code`) USING BTREE,
  KEY `TranDate` (`tran_date`) USING BTREE,
  KEY `TypeNo` (`tran_no`) USING BTREE,
  KEY `Type_and_Number` (`tran_type`,`tran_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_gl_trans_audit
-- ----------------------------

-- ----------------------------
-- Table structure for erp_groups
-- ----------------------------
DROP TABLE IF EXISTS `erp_groups`;
CREATE TABLE `erp_groups` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_groups
-- ----------------------------
INSERT INTO `erp_groups` VALUES ('1', 'owner', 'Owner');
INSERT INTO `erp_groups` VALUES ('2', 'admin', 'Administrator');
INSERT INTO `erp_groups` VALUES ('3', 'customer', 'Customer');
INSERT INTO `erp_groups` VALUES ('4', 'supplier', 'Supplier');
INSERT INTO `erp_groups` VALUES ('5', 'sales', 'Saller');
INSERT INTO `erp_groups` VALUES ('6', 'stock', 'Stock Manager');
INSERT INTO `erp_groups` VALUES ('7', 'manager', 'Manager');
INSERT INTO `erp_groups` VALUES ('10', 'visitor', 'Visitor');
INSERT INTO `erp_groups` VALUES ('11', 'cashier', 'Cashier');
INSERT INTO `erp_groups` VALUES ('12', 'member', 'Member card');
INSERT INTO `erp_groups` VALUES ('13', 'computer', 'computer user');
INSERT INTO `erp_groups` VALUES ('14', 'photomaker', 'photomaker');
INSERT INTO `erp_groups` VALUES ('15', 'decor', 'decor');
INSERT INTO `erp_groups` VALUES ('16', 'photographer', 'photographer');
INSERT INTO `erp_groups` VALUES ('17', 'photocreater', 'photocreater');
INSERT INTO `erp_groups` VALUES ('18', 'accounting', 'Accoiunting');
INSERT INTO `erp_groups` VALUES ('19', 'aaaa', 'aaaa');
INSERT INTO `erp_groups` VALUES ('20', 'stock', 'Stock');
INSERT INTO `erp_groups` VALUES ('21', 'ddd', 'dddd');
INSERT INTO `erp_groups` VALUES ('22', 'purchase', 'purchase');

-- ----------------------------
-- Table structure for erp_group_areas
-- ----------------------------
DROP TABLE IF EXISTS `erp_group_areas`;
CREATE TABLE `erp_group_areas` (
  `areas_g_code` int(3) NOT NULL AUTO_INCREMENT,
  `areas_group` varchar(100) DEFAULT '',
  PRIMARY KEY (`areas_g_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_group_areas
-- ----------------------------

-- ----------------------------
-- Table structure for erp_loans
-- ----------------------------
DROP TABLE IF EXISTS `erp_loans`;
CREATE TABLE `erp_loans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period` smallint(6) NOT NULL,
  `dateline` date NOT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `reference_no` varchar(50) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `rated` varchar(255) DEFAULT NULL,
  `payment` decimal(25,10) NOT NULL,
  `principle` decimal(25,10) NOT NULL,
  `interest` decimal(25,10) NOT NULL,
  `balance` decimal(25,10) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `paid_by` varchar(50) DEFAULT NULL,
  `paid_amount` decimal(25,4) NOT NULL,
  `paid_date` datetime DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `bank_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `updated_by` varchar(55) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_loans
-- ----------------------------

-- ----------------------------
-- Table structure for erp_login_attempts
-- ----------------------------
DROP TABLE IF EXISTS `erp_login_attempts`;
CREATE TABLE `erp_login_attempts` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varbinary(16) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_login_attempts
-- ----------------------------

-- ----------------------------
-- Table structure for erp_marchine
-- ----------------------------
DROP TABLE IF EXISTS `erp_marchine`;
CREATE TABLE `erp_marchine` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `type` varchar(20) DEFAULT '0',
  `biller_id` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `13` int(11) DEFAULT '0',
  `15` int(11) DEFAULT '0',
  `25` int(11) DEFAULT '0',
  `30` int(11) DEFAULT '0',
  `50` int(11) DEFAULT '0',
  `60` int(11) DEFAULT '0',
  `76` int(11) DEFAULT '0',
  `80` int(11) DEFAULT '0',
  `100` int(11) DEFAULT '0',
  `120` int(11) DEFAULT '0',
  `150` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_marchine
-- ----------------------------

-- ----------------------------
-- Table structure for erp_marchine_logs
-- ----------------------------
DROP TABLE IF EXISTS `erp_marchine_logs`;
CREATE TABLE `erp_marchine_logs` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `marchine_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `old_number` int(11) DEFAULT NULL,
  `new_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_marchine_logs
-- ----------------------------

-- ----------------------------
-- Table structure for erp_migrations
-- ----------------------------
DROP TABLE IF EXISTS `erp_migrations`;
CREATE TABLE `erp_migrations` (
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_migrations
-- ----------------------------
INSERT INTO `erp_migrations` VALUES ('312');

-- ----------------------------
-- Table structure for erp_notifications
-- ----------------------------
DROP TABLE IF EXISTS `erp_notifications`;
CREATE TABLE `erp_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `from_date` datetime DEFAULT NULL,
  `till_date` datetime DEFAULT NULL,
  `scope` tinyint(1) NOT NULL DEFAULT '3',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_notifications
-- ----------------------------
INSERT INTO `erp_notifications` VALUES ('1', '<p>Thank you for using iCloudERP - POS. If you find any error/bug, please email to support@cloudnet.com.kh with details. You can send us your valued suggestions/feedback too.</p>', '2014-08-15 19:00:57', '2015-01-01 00:00:00', '2017-01-01 00:00:00', '3');

-- ----------------------------
-- Table structure for erp_order_ref
-- ----------------------------
DROP TABLE IF EXISTS `erp_order_ref`;
CREATE TABLE `erp_order_ref` (
  `ref_id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `so` int(11) NOT NULL DEFAULT '1' COMMENT 'sale order',
  `qu` int(11) NOT NULL DEFAULT '1' COMMENT 'quote',
  `po` int(11) NOT NULL DEFAULT '1' COMMENT 'purchase order',
  `to` int(11) NOT NULL DEFAULT '1' COMMENT 'transfer to',
  `pos` int(11) NOT NULL DEFAULT '1' COMMENT 'pos',
  `do` int(11) NOT NULL DEFAULT '1' COMMENT 'delivery order',
  `pay` int(11) NOT NULL DEFAULT '1' COMMENT 'expense payment',
  `re` int(11) NOT NULL DEFAULT '1' COMMENT 'sale return',
  `ex` int(11) NOT NULL DEFAULT '1' COMMENT 'expense',
  `sp` int(11) NOT NULL DEFAULT '1' COMMENT 'sale payement',
  `pp` int(11) NOT NULL DEFAULT '1' COMMENT 'purchase payment',
  `sl` int(11) NOT NULL DEFAULT '1' COMMENT 'sale loan',
  `tr` int(11) NOT NULL DEFAULT '1' COMMENT 'transfer',
  `rep` int(11) NOT NULL DEFAULT '1' COMMENT 'purchase return',
  `con` int(11) NOT NULL DEFAULT '1' COMMENT 'convert product',
  `pj` int(11) NOT NULL DEFAULT '1' COMMENT 'prouduct job',
  `sao` int(11) NOT NULL,
  PRIMARY KEY (`ref_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_order_ref
-- ----------------------------
INSERT INTO `erp_order_ref` VALUES ('1', '1', '2016-02-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('2', '1', '2016-03-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('3', '1', '2016-04-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('4', '1', '2016-05-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('5', '1', '2016-06-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('6', '1', '2016-07-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('7', '1', '2016-08-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('8', '1', '2016-09-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('9', '1', '2016-10-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('10', '1', '2016-11-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('11', '1', '2016-12-01', '40', '1', '34', '1', '3', '39', '1', '4', '1', '21', '12', '1', '87', '5', '2', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('12', '1', '2017-01-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('13', '1', '2017-02-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('14', '1', '2017-03-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('15', '1', '2017-04-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('16', '1', '2017-05-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('17', '1', '2017-06-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('18', '1', '2017-07-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('19', '1', '2017-08-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('21', '1', '2017-09-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('22', '1', '2017-10-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('23', '1', '2017-11-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('24', '1', '2017-12-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('25', '1', '2018-01-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('26', '1', '2018-02-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('27', '1', '2018-03-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('28', '1', '2018-04-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('29', '1', '2018-05-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('30', '1', '2018-06-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('31', '1', '2018-07-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('32', '1', '2018-08-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
INSERT INTO `erp_order_ref` VALUES ('33', '1', '2018-09-01', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');

-- ----------------------------
-- Table structure for erp_pack_lists
-- ----------------------------
DROP TABLE IF EXISTS `erp_pack_lists`;
CREATE TABLE `erp_pack_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pack_code` varchar(20) DEFAULT NULL,
  `name` varchar(55) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `parent` int(11) DEFAULT '0',
  `level` int(11) DEFAULT '0',
  `status` tinyint(3) DEFAULT '0',
  `cf1` varchar(255) DEFAULT NULL,
  `cf2` varchar(255) DEFAULT NULL,
  `cf3` varchar(255) DEFAULT NULL,
  `cf4` varchar(255) DEFAULT NULL,
  `cf5` varchar(255) DEFAULT NULL,
  `cf6` varchar(255) DEFAULT NULL,
  `cf7` varchar(255) DEFAULT NULL,
  `cf8` varchar(255) DEFAULT NULL,
  `cf9` varchar(255) DEFAULT NULL,
  `cf10` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_pack_lists
-- ----------------------------
INSERT INTO `erp_pack_lists` VALUES ('1', 'department', 'Director', 'Director', 'HR', '0', '0', '0', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `erp_pack_lists` VALUES ('2', 'department', 'Finance', 'Finance', 'HR', '0', '0', '0', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `erp_pack_lists` VALUES ('3', 'department', 'Human Resource', 'Human Resource', 'HR', '0', '0', '0', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `erp_pack_lists` VALUES ('4', 'department', 'Information Technology', 'Information Technology', 'HR', '0', '0', '0', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `erp_pack_lists` VALUES ('5', 'position', 'General Manager', 'ប្រធានគ្រប់គ្រង', 'HR', '0', '0', '0', null, null, null, null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for erp_payments
-- ----------------------------
DROP TABLE IF EXISTS `erp_payments`;
CREATE TABLE `erp_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_id` int(11) DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `deposit_id` int(11) DEFAULT NULL,
  `purchase_deposit_id` int(11) DEFAULT NULL,
  `loan_id` int(11) DEFAULT NULL,
  `expense_id` int(11) DEFAULT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `reference_no` varchar(50) NOT NULL,
  `paid_by` varchar(20) NOT NULL,
  `cheque_no` varchar(20) DEFAULT NULL,
  `cc_no` varchar(20) DEFAULT NULL,
  `cc_holder` varchar(25) DEFAULT NULL,
  `cc_month` varchar(2) DEFAULT NULL,
  `cc_year` varchar(4) DEFAULT NULL,
  `cc_type` varchar(20) DEFAULT NULL,
  `amount` decimal(25,4) NOT NULL,
  `pos_paid` decimal(25,4) DEFAULT '0.0000',
  `currency` varchar(3) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `pos_balance` decimal(25,4) DEFAULT '0.0000',
  `pos_paid_other` decimal(25,4) DEFAULT NULL,
  `pos_paid_other_rate` decimal(25,4) DEFAULT NULL,
  `approval_code` varchar(50) DEFAULT NULL,
  `purchase_return_id` int(11) DEFAULT NULL,
  `return_deposit_id` int(11) DEFAULT NULL,
  `extra_paid` decimal(25,4) DEFAULT NULL,
  `deposit_quote_id` int(11) DEFAULT NULL,
  `add_payment` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_payments
-- ----------------------------

-- ----------------------------
-- Table structure for erp_payment_term
-- ----------------------------
DROP TABLE IF EXISTS `erp_payment_term`;
CREATE TABLE `erp_payment_term` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(55) DEFAULT NULL,
  `due_day` int(11) DEFAULT '0',
  `due_day_for_discount` int(11) DEFAULT '0',
  `discount` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_payment_term
-- ----------------------------
INSERT INTO `erp_payment_term` VALUES ('1', 'Net 20 Days', '20', '5', '10%');
INSERT INTO `erp_payment_term` VALUES ('2', 'Net 1 Month', '30', '0', '2%');
INSERT INTO `erp_payment_term` VALUES ('3', 'Net 7 Days', '7', '7', '5%');

-- ----------------------------
-- Table structure for erp_paypal
-- ----------------------------
DROP TABLE IF EXISTS `erp_paypal`;
CREATE TABLE `erp_paypal` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL,
  `paypal_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '2.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '3.9000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '4.4000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_paypal
-- ----------------------------
INSERT INTO `erp_paypal` VALUES ('1', '0', 'mypaypal@paypal.com', 'USD', '0.0000', '0.0000', '0.0000');

-- ----------------------------
-- Table structure for erp_permissions
-- ----------------------------
DROP TABLE IF EXISTS `erp_permissions`;
CREATE TABLE `erp_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `products-index` tinyint(1) DEFAULT '0',
  `products-add` tinyint(1) DEFAULT '0',
  `products-edit` tinyint(1) DEFAULT '0',
  `products-delete` tinyint(1) DEFAULT '0',
  `products-cost` tinyint(1) DEFAULT '0',
  `products-price` tinyint(1) DEFAULT '0',
  `products-import` tinyint(1) DEFAULT '0',
  `products-export` tinyint(1) DEFAULT '0',
  `quotes-index` tinyint(1) DEFAULT '0',
  `quotes-add` tinyint(1) DEFAULT '0',
  `quotes-edit` tinyint(1) DEFAULT '0',
  `quotes-email` tinyint(1) DEFAULT '0',
  `quotes-delete` tinyint(1) DEFAULT '0',
  `quotes-pdf` tinyint(1) DEFAULT '0',
  `quotes-export` tinyint(1) DEFAULT '0',
  `quotes-import` tinyint(1) DEFAULT '0',
  `sales-index` tinyint(1) DEFAULT '0',
  `sales-add` tinyint(1) DEFAULT '0',
  `sales-edit` tinyint(1) DEFAULT '0',
  `sales-email` tinyint(1) DEFAULT '0',
  `sales-pdf` tinyint(1) DEFAULT '0',
  `sales-delete` tinyint(1) DEFAULT '0',
  `sales-export` tinyint(1) DEFAULT '0',
  `sales-import` tinyint(1) DEFAULT '0',
  `purchases-index` tinyint(1) DEFAULT '0',
  `purchases-add` tinyint(1) DEFAULT '0',
  `purchases-edit` tinyint(1) DEFAULT '0',
  `purchases-email` tinyint(1) DEFAULT '0',
  `purchases-pdf` tinyint(1) DEFAULT '0',
  `purchases-delete` tinyint(1) DEFAULT '0',
  `purchases-export` tinyint(1) DEFAULT '0',
  `purchases-import` tinyint(1) DEFAULT '0',
  `transfers-index` tinyint(1) DEFAULT '0',
  `transfers-add` tinyint(1) DEFAULT '0',
  `transfers-edit` tinyint(1) DEFAULT '0',
  `transfers-email` tinyint(1) DEFAULT '0',
  `transfers-delete` tinyint(1) DEFAULT '0',
  `transfers-pdf` tinyint(1) DEFAULT '0',
  `transfers-export` tinyint(1) DEFAULT '0',
  `transfers-import` tinyint(1) DEFAULT '0',
  `customers-index` tinyint(1) DEFAULT '0',
  `customers-add` tinyint(1) DEFAULT '0',
  `customers-edit` tinyint(1) DEFAULT '0',
  `customers-delete` tinyint(1) DEFAULT '0',
  `customers-export` tinyint(1) DEFAULT '0',
  `customers-import` tinyint(1) DEFAULT '0',
  `suppliers-index` tinyint(1) DEFAULT '0',
  `suppliers-add` tinyint(1) DEFAULT '0',
  `suppliers-edit` tinyint(1) DEFAULT '0',
  `suppliers-delete` tinyint(1) DEFAULT '0',
  `suppliers-import` tinyint(1) DEFAULT '0',
  `suppliers-export` tinyint(1) DEFAULT '0',
  `sales-deliveries` tinyint(1) DEFAULT '0',
  `sales-add_delivery` tinyint(1) DEFAULT '0',
  `sales-edit_delivery` tinyint(1) DEFAULT '0',
  `sales-delete_delivery` tinyint(1) DEFAULT '0',
  `sales-pdf_delivery` tinyint(1) DEFAULT '0',
  `sales-email_delivery` tinyint(1) DEFAULT '0',
  `sales-export_delivery` tinyint(1) DEFAULT '0',
  `sales-import_delivery` tinyint(1) DEFAULT '0',
  `sales-gift_cards` tinyint(1) DEFAULT '0',
  `sales-add_gift_card` tinyint(1) DEFAULT '0',
  `sales-edit_gift_card` tinyint(1) DEFAULT '0',
  `sales-delete_gift_card` tinyint(1) DEFAULT '0',
  `sales-import_gift_card` tinyint(1) DEFAULT '0',
  `sales-export_gift_card` tinyint(1) DEFAULT '0',
  `pos-index` tinyint(1) DEFAULT '0',
  `sales-return_sales` tinyint(1) DEFAULT '0',
  `reports-index` tinyint(1) DEFAULT '0',
  `reports-warehouse_stock` tinyint(1) DEFAULT '0',
  `reports-quantity_alerts` tinyint(1) DEFAULT '0',
  `reports-expiry_alerts` tinyint(1) DEFAULT '0',
  `reports-products` tinyint(1) DEFAULT '0',
  `reports-daily_sales` tinyint(1) DEFAULT '0',
  `reports-monthly_sales` tinyint(1) DEFAULT '0',
  `reports-sales` tinyint(1) DEFAULT '0',
  `reports-payments` tinyint(1) DEFAULT '0',
  `reports-purchases` tinyint(1) DEFAULT '0',
  `reports-profit_loss` tinyint(1) DEFAULT '0',
  `reports-customers` tinyint(1) DEFAULT '0',
  `reports-suppliers` tinyint(1) DEFAULT '0',
  `reports-staff` tinyint(1) DEFAULT '0',
  `reports-register` tinyint(1) DEFAULT '0',
  `reports-account` tinyint(1) DEFAULT '0',
  `sales-payments` tinyint(1) DEFAULT '0',
  `purchases-payments` tinyint(1) DEFAULT '0',
  `purchases-expenses` tinyint(1) DEFAULT '0',
  `bulk_actions` tinyint(1) DEFAULT '0',
  `customers-deposits` tinyint(1) DEFAULT '0',
  `customers-delete_deposit` tinyint(1) DEFAULT '0',
  `products-adjustments` tinyint(1) DEFAULT '0',
  `accounts-index` tinyint(1) DEFAULT '0',
  `accounts-add` tinyint(1) DEFAULT '0',
  `accounts-edit` tinyint(1) DEFAULT '0',
  `accounts-delete` tinyint(1) DEFAULT '0',
  `accounts-import` tinyint(1) DEFAULT '0',
  `accounts-export` tinyint(1) DEFAULT '0',
  `sales-discount` tinyint(1) DEFAULT '0',
  `sales-price` tinyint(1) DEFAULT '0',
  `sales-loan` tinyint(1) DEFAULT '0',
  `reports-daily_purchases` tinyint(1) DEFAULT '0',
  `reports-monthly_purchases` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_permissions
-- ----------------------------
INSERT INTO `erp_permissions` VALUES ('1', '5', '1', '1', '1', '1', '1', '1', null, null, '1', '1', '1', '1', '1', null, null, null, '1', '1', '1', '1', null, '1', null, null, '1', '1', '1', '1', null, '1', null, null, '1', '1', '1', '1', '1', null, null, null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, null, null, '1', '1', '1', '1', null, null, '1', '1', null, '0', null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, '1', '1', '1', null, null, null, '1', '1', '1', '1', '1', null, null, '0', '0', '1', '0', '0');
INSERT INTO `erp_permissions` VALUES ('2', '6', '1', null, null, null, '1', '1', null, null, '1', '1', '1', '1', '1', null, null, '0', '1', '1', '1', '1', null, '1', '0', null, '1', '1', '1', '1', null, '1', '0', null, '1', '1', '1', '1', '1', null, '0', '0', '1', '1', '1', '1', '0', null, '1', '1', '1', '1', '0', null, '1', '1', '1', '1', null, null, '0', null, '1', '1', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', null, null, null, '1', '1', '1', '1', '1', null, null, '0', '0', '1', '0', '0');
INSERT INTO `erp_permissions` VALUES ('3', '7', '1', '1', '1', '1', '1', '1', null, null, '1', '1', '1', '1', '1', null, null, null, '1', '1', '1', '1', null, '1', null, null, '1', '1', '1', '1', null, '1', null, null, '1', '1', '1', '1', '1', null, null, null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, null, null, '1', '1', '1', '1', null, null, '1', '1', null, '0', null, null, '1', null, null, null, null, '1', null, null, null, '0', '0', null, '1', '1', '1', null, null, null, null, null, null, null, null, null, null, '1', null, null, '0', '0');
INSERT INTO `erp_permissions` VALUES ('4', '8', '1', '1', null, null, null, null, null, null, '1', null, null, null, null, null, null, '0', '1', null, null, null, null, null, '0', null, '1', null, null, null, null, null, '0', null, '1', null, null, null, null, null, '0', '0', '1', null, null, null, '0', null, null, null, null, null, '0', null, '1', null, null, null, null, null, '0', null, '1', null, null, null, '0', '0', null, null, '0', '0', null, null, null, null, null, '0', null, null, '0', null, null, '0', '0', '0', null, null, null, '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('5', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('6', '10', '1', null, null, null, null, null, null, null, '1', null, null, null, null, null, null, '0', '1', null, null, null, null, null, '0', null, '1', null, null, null, null, null, '0', null, '1', null, null, null, null, null, '0', '0', '1', null, null, null, '0', null, '1', null, null, null, '0', null, '1', null, null, null, null, null, '0', null, '1', null, null, null, '0', '0', null, null, '0', '0', null, null, null, null, null, '0', null, null, '0', null, null, '0', '0', '0', null, null, null, '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('7', '11', '1', '1', '1', '1', null, '1', null, '1', '1', '1', '1', '1', '1', null, null, '1', '1', '1', '1', '1', null, '1', '1', '1', '1', '1', '1', '1', null, '1', '1', null, '1', '1', '1', '1', '1', null, '1', null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, '1', null, '1', '1', '1', '1', '1', '1', '1', '1', null, '0', null, null, null, null, null, null, null, null, null, null, null, '0', '0', '1', '1', '1', '1', null, null, null, '1', '1', '1', '1', '1', '1', '1', null, null, null, '0', '0');
INSERT INTO `erp_permissions` VALUES ('8', '11', '1', '1', '1', '1', null, '1', null, '1', '1', '1', '1', '1', '1', null, null, '1', '1', '1', '1', '1', null, '1', '1', '1', '1', '1', '1', '1', null, '1', '1', null, '1', '1', '1', '1', '1', null, '1', null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, '1', '1', '1', '1', null, null, '1', null, '1', '1', '1', '1', '1', '1', '1', '1', null, '0', null, null, null, null, null, null, null, null, null, null, null, '0', '0', '1', '1', '1', '1', null, null, null, '1', '1', '1', '1', '1', '1', '1', null, null, null, '0', '0');
INSERT INTO `erp_permissions` VALUES ('9', '12', '1', '1', '1', '1', '1', '1', null, null, '1', '1', '1', null, '1', null, null, '0', '1', '1', '1', null, null, '1', '0', null, '1', '1', '1', null, null, '1', '0', null, '1', '1', '1', null, '1', null, '0', '0', '1', '1', '1', '1', '0', null, '1', '1', '1', '1', '0', null, '1', '1', '1', '1', null, null, '0', null, '1', '1', '1', '1', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '0', '1', '1', '1', null, null, null, '1', '1', '1', '1', '1', null, null, '0', '0', null, '0', '0');
INSERT INTO `erp_permissions` VALUES ('10', '13', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('11', '14', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('12', '15', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('13', '16', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('14', '17', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('15', '18', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('16', '19', '1', '1', '1', '1', '1', null, null, null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', '0', null, null, null, null, '0', null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', null, null, null, null, null, '0', '0', null, null, '0', '0', null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, null, null, null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, '0', '0');
INSERT INTO `erp_permissions` VALUES ('17', '19', '1', '1', '1', '1', '1', null, null, null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', '0', null, null, null, null, '0', null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', null, null, null, null, null, '0', '0', null, null, '0', '0', null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, null, null, null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, '0', '0');
INSERT INTO `erp_permissions` VALUES ('18', '20', '1', '1', '1', '1', '1', '1', null, null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', '0', null, null, null, null, '0', null, null, null, null, null, '0', null, null, null, null, null, null, null, '0', null, null, null, null, null, '0', '0', null, null, '0', '0', null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, null, null, null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, '0', '0');
INSERT INTO `erp_permissions` VALUES ('19', '21', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', '0', '0', null, '0', '0', '0', '0', '0', null, '0', '0', '0', '0', null, '0', '0', null, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', null, null, '0', '0', '0', '0', '0');
INSERT INTO `erp_permissions` VALUES ('20', '22', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '1', '1', '1', null, null, '1', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '0', null, null, null, null, null, null, null, null, null, null, null, '0', '0', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '0', '0');

-- ----------------------------
-- Table structure for erp_pos_register
-- ----------------------------
DROP TABLE IF EXISTS `erp_pos_register`;
CREATE TABLE `erp_pos_register` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `cash_in_hand` decimal(25,4) NOT NULL,
  `status` varchar(10) NOT NULL,
  `total_cash` decimal(25,4) DEFAULT NULL,
  `total_cheques` int(11) DEFAULT NULL,
  `total_cc_slips` int(11) DEFAULT NULL,
  `total_cash_submitted` decimal(25,4) DEFAULT NULL,
  `total_cheques_submitted` int(11) DEFAULT NULL,
  `total_cc_slips_submitted` int(11) DEFAULT NULL,
  `note` text,
  `closed_at` timestamp NULL DEFAULT NULL,
  `transfer_opened_bills` varchar(50) DEFAULT NULL,
  `closed_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_pos_register
-- ----------------------------
INSERT INTO `erp_pos_register` VALUES ('1', '2016-12-09 16:33:46', '1', '100.0000', 'open', null, null, null, null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for erp_pos_settings
-- ----------------------------
DROP TABLE IF EXISTS `erp_pos_settings`;
CREATE TABLE `erp_pos_settings` (
  `pos_id` int(1) NOT NULL,
  `cat_limit` int(11) NOT NULL,
  `pro_limit` int(11) NOT NULL,
  `default_category` int(11) NOT NULL,
  `default_customer` int(11) NOT NULL,
  `default_biller` int(11) NOT NULL,
  `display_time` varchar(3) NOT NULL DEFAULT 'yes',
  `cf_title1` varchar(255) DEFAULT NULL,
  `cf_title2` varchar(255) DEFAULT NULL,
  `cf_value1` varchar(255) DEFAULT NULL,
  `cf_value2` varchar(255) DEFAULT NULL,
  `receipt_printer` varchar(55) DEFAULT NULL,
  `cash_drawer_codes` varchar(55) DEFAULT NULL,
  `focus_add_item` varchar(55) DEFAULT NULL,
  `add_manual_product` varchar(55) DEFAULT NULL,
  `customer_selection` varchar(55) DEFAULT NULL,
  `add_customer` varchar(55) DEFAULT NULL,
  `toggle_category_slider` varchar(55) DEFAULT NULL,
  `toggle_subcategory_slider` varchar(55) DEFAULT NULL,
  `show_search_item` varchar(55) DEFAULT NULL,
  `product_unit` varchar(55) DEFAULT NULL,
  `cancel_sale` varchar(55) DEFAULT NULL,
  `suspend_sale` varchar(55) DEFAULT NULL,
  `print_items_list` varchar(55) DEFAULT NULL,
  `finalize_sale` varchar(55) DEFAULT NULL,
  `today_sale` varchar(55) DEFAULT NULL,
  `open_hold_bills` varchar(55) DEFAULT NULL,
  `close_register` varchar(55) DEFAULT NULL,
  `keyboard` tinyint(1) NOT NULL,
  `pos_printers` varchar(255) DEFAULT NULL,
  `java_applet` tinyint(1) NOT NULL,
  `product_button_color` varchar(20) NOT NULL DEFAULT 'default',
  `tooltips` tinyint(1) DEFAULT '1',
  `paypal_pro` tinyint(1) DEFAULT '0',
  `stripe` tinyint(1) DEFAULT '0',
  `rounding` tinyint(1) DEFAULT '0',
  `char_per_line` tinyint(4) DEFAULT '42',
  `pin_code` varchar(20) DEFAULT NULL,
  `purchase_code` varchar(100) DEFAULT 'purchase_code',
  `envato_username` varchar(50) DEFAULT 'envato_username',
  `version` varchar(10) DEFAULT '3.0.1.21',
  `show_item_img` tinyint(1) DEFAULT NULL,
  `pos_layout` tinyint(1) DEFAULT NULL,
  `display_qrcode` tinyint(1) DEFAULT NULL,
  `show_suspend_bar` tinyint(1) DEFAULT NULL,
  `show_payment_noted` tinyint(1) DEFAULT NULL,
  `payment_balance` tinyint(1) DEFAULT NULL,
  `authorize` tinyint(1) DEFAULT '0',
  `show_product_code` tinyint(1) unsigned DEFAULT '1',
  `auto_delivery` tinyint(1) unsigned DEFAULT '1',
  `in_out_rate` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`pos_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_pos_settings
-- ----------------------------
INSERT INTO `erp_pos_settings` VALUES ('1', '22', '18', '1', '4', '1', '1', 'GST Reg', 'VAT Reg', '123456789', '987654321', 'BIXOLON SRP-350II', 'x1C', 'Ctrl+F3', 'Ctrl+Shift+M', 'Ctrl+Shift+C', 'Ctrl+Shift+A', 'Ctrl+F11', 'Ctrl+F12', 'F1', 'F2', 'F4', 'F7', 'F9', 'F8', 'Ctrl+F1', 'Ctrl+F2', 'Ctrl+F10', '1', 'BIXOLON SRP-350II, BIXOLON SRP-350II', '0', 'warning', '0', '0', '0', '0', '42', null, 'purchase_code', 'envato_username', '3.0.1.21', '1', '3', '0', '1', '1', '1', '0', '1', '1', '0');

-- ----------------------------
-- Table structure for erp_price_groups
-- ----------------------------
DROP TABLE IF EXISTS `erp_price_groups`;
CREATE TABLE `erp_price_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_price_groups
-- ----------------------------
INSERT INTO `erp_price_groups` VALUES ('1', 'Price A');
INSERT INTO `erp_price_groups` VALUES ('2', 'Price B');
INSERT INTO `erp_price_groups` VALUES ('3', 'Price C');

-- ----------------------------
-- Table structure for erp_products
-- ----------------------------
DROP TABLE IF EXISTS `erp_products`;
CREATE TABLE `erp_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` char(255) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  `price` decimal(25,4) NOT NULL,
  `alert_quantity` decimal(15,4) DEFAULT '20.0000',
  `image` varchar(255) DEFAULT 'no_image.png',
  `category_id` int(11) NOT NULL,
  `subcategory_id` int(11) DEFAULT NULL,
  `cf1` varchar(255) DEFAULT NULL,
  `cf2` varchar(255) DEFAULT NULL,
  `cf3` varchar(255) DEFAULT NULL,
  `cf4` varchar(255) DEFAULT NULL,
  `cf5` varchar(255) DEFAULT NULL,
  `cf6` varchar(255) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `tax_rate` int(11) DEFAULT NULL,
  `track_quantity` tinyint(1) DEFAULT '1',
  `details` varchar(1000) DEFAULT NULL,
  `warehouse` int(11) DEFAULT NULL,
  `barcode_symbology` varchar(55) NOT NULL DEFAULT 'code128',
  `file` varchar(100) DEFAULT NULL,
  `product_details` text,
  `tax_method` tinyint(1) DEFAULT '0',
  `type` varchar(55) NOT NULL DEFAULT 'standard',
  `supplier1` int(11) DEFAULT NULL,
  `supplier1price` decimal(25,4) DEFAULT NULL,
  `supplier2` int(11) DEFAULT NULL,
  `supplier2price` decimal(25,4) DEFAULT NULL,
  `supplier3` int(11) DEFAULT NULL,
  `supplier3price` decimal(25,4) DEFAULT NULL,
  `supplier4` int(11) DEFAULT NULL,
  `supplier4price` decimal(25,4) DEFAULT NULL,
  `supplier5` int(11) DEFAULT NULL,
  `supplier5price` decimal(25,4) DEFAULT NULL,
  `no` int(11) DEFAULT NULL,
  `promotion` tinyint(1) DEFAULT '0',
  `promo_price` decimal(25,4) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `supplier1_part_no` varchar(50) DEFAULT NULL,
  `supplier2_part_no` varchar(50) DEFAULT NULL,
  `supplier3_part_no` varchar(50) DEFAULT NULL,
  `supplier4_part_no` varchar(50) DEFAULT NULL,
  `supplier5_part_no` varchar(50) DEFAULT NULL,
  `currentcy_code` varchar(10) DEFAULT NULL,
  `inactived` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `brand_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `category_id` (`category_id`),
  KEY `id` (`id`),
  KEY `id_2` (`id`),
  KEY `category_id_2` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_products
-- ----------------------------

-- ----------------------------
-- Table structure for erp_product_photos
-- ----------------------------
DROP TABLE IF EXISTS `erp_product_photos`;
CREATE TABLE `erp_product_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `photo` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_product_photos
-- ----------------------------

-- ----------------------------
-- Table structure for erp_product_prices
-- ----------------------------
DROP TABLE IF EXISTS `erp_product_prices`;
CREATE TABLE `erp_product_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `price_group_id` int(11) NOT NULL,
  `price` decimal(25,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `price_group_id` (`price_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_product_prices
-- ----------------------------

-- ----------------------------
-- Table structure for erp_product_variants
-- ----------------------------
DROP TABLE IF EXISTS `erp_product_variants`;
CREATE TABLE `erp_product_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `name` varchar(55) NOT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  `price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `qty_unit` decimal(15,4) DEFAULT NULL,
  `currentcy_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_product_variants
-- ----------------------------

-- ----------------------------
-- Table structure for erp_purchases
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchases`;
CREATE TABLE `erp_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) NOT NULL,
  `reference_no` varchar(55) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) NOT NULL,
  `supplier` varchar(55) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `note` varchar(1000) NOT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `paid` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `suspend_note` varchar(100) DEFAULT NULL,
  `reference_no_tax` varchar(100) NOT NULL,
  `tax_status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_purchases
-- ----------------------------

-- ----------------------------
-- Table structure for erp_purchases_order
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchases_order`;
CREATE TABLE `erp_purchases_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) NOT NULL,
  `reference_no` varchar(55) NOT NULL,
  `purchase_ref` varchar(255) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) NOT NULL,
  `supplier` varchar(55) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `note` varchar(1000) NOT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `paid` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `suspend_note` varchar(100) DEFAULT NULL,
  `reference_no_tax` varchar(100) NOT NULL,
  `tax_status` varchar(100) DEFAULT NULL,
  `purchase_type` int(1) DEFAULT NULL,
  `purchase_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_purchases_order
-- ----------------------------

-- ----------------------------
-- Table structure for erp_purchase_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_items`;
CREATE TABLE `erp_purchase_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `delivery_id` int(11) NOT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(50) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(20) DEFAULT NULL,
  `discount` varchar(20) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `quantity_balance` decimal(15,4) DEFAULT '0.0000',
  `date` date NOT NULL,
  `status` varchar(50) NOT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `supplier_part_no` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `convert_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_purchase_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_purchase_order_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_order_items`;
CREATE TABLE `erp_purchase_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(50) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(20) DEFAULT NULL,
  `discount` varchar(20) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `quantity_balance` decimal(15,4) DEFAULT '0.0000',
  `date` date NOT NULL,
  `status` varchar(50) NOT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `supplier_part_no` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `price` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_purchase_order_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_purchase_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_tax`;
CREATE TABLE `erp_purchase_tax` (
  `vat_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(100) DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `purchase_id` varchar(10) DEFAULT NULL,
  `purchase_ref` varchar(100) DEFAULT NULL,
  `supplier_id` varchar(100) DEFAULT NULL,
  `issuedate` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `qty` double(25,4) DEFAULT NULL,
  `vatin` varchar(100) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `amount_tax` double DEFAULT NULL,
  `amount_declear` double DEFAULT NULL,
  `non_tax_pur` double(25,4) DEFAULT NULL,
  `tax_value` double(25,4) DEFAULT NULL,
  `vat` double(25,4) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_location` varchar(255) DEFAULT NULL,
  `journal_date` date DEFAULT NULL,
  PRIMARY KEY (`vat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_purchase_tax
-- ----------------------------

-- ----------------------------
-- Table structure for erp_purchasing_taxes
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchasing_taxes`;
CREATE TABLE `erp_purchasing_taxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_id` int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `reference_no` varchar(255) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(150) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` varchar(150) DEFAULT NULL,
  `amount` decimal(24,4) DEFAULT NULL,
  `vat_id` int(11) DEFAULT NULL,
  `vat` decimal(24,4) DEFAULT NULL,
  `balance` decimal(24,4) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `status_tax` varchar(100) DEFAULT NULL,
  `remark_id` int(1) DEFAULT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `tax_type` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_purchasing_taxes
-- ----------------------------

-- ----------------------------
-- Table structure for erp_quotes
-- ----------------------------
DROP TABLE IF EXISTS `erp_quotes`;
CREATE TABLE `erp_quotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `internal_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT NULL,
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_quotes
-- ----------------------------

-- ----------------------------
-- Table structure for erp_quote_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_quote_items`;
CREATE TABLE `erp_quote_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quote_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quote_id` (`quote_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_quote_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_related_products
-- ----------------------------
DROP TABLE IF EXISTS `erp_related_products`;
CREATE TABLE `erp_related_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(50) DEFAULT NULL,
  `related_product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_related_products
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_items`;
CREATE TABLE `erp_return_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) unsigned NOT NULL,
  `return_id` int(11) unsigned NOT NULL,
  `sale_item_id` int(11) DEFAULT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`sale_id`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`sale_id`),
  KEY `sale_id_2` (`sale_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_purchases
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_purchases`;
CREATE TABLE `erp_return_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL,
  `supplier` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_purchases
-- ----------------------------
INSERT INTO `erp_return_purchases` VALUES ('1', '32', '2016-12-10 10:37:00', 'PRE/1612/00001', '546', '547', 'Big Collection', '1', '', '14.7150', '0.0000', '0', '0.0000', '0.0000', '0.0000', '2', '1.4720', '1.4720', '0.0000', '16.1870', '1', null, null, null);
INSERT INTO `erp_return_purchases` VALUES ('2', '33', '2016-12-10 11:06:00', 'PRE/1612/00002', '546', '547', 'Big Collection', '1', '', '0.0000', '0.0000', '0', '0.0000', '0.0000', '0.0000', '2', '1.4060', '1.4060', '0.0000', '0.0000', '1', null, null, null);
INSERT INTO `erp_return_purchases` VALUES ('3', '30', '2016-12-10 13:43:00', 'PRE/1612/00003', '546', '547', 'Big Collection', '1', '', '116.0200', '0.0000', '0', '0.0000', '0.0000', '0.0000', '2', '11.6020', '11.6020', '0.0000', '127.6220', '1', null, null, null);
INSERT INTO `erp_return_purchases` VALUES ('4', '29', '2016-12-12 09:28:00', 'PRE/1612/00004', '546', '547', 'Big Collection', '1', '', '75.0000', '0.0000', '0', '0.0000', '0.0000', '0.0000', '1', '0.0000', '0.0000', '0.0000', '75.0000', '1', null, null, null);

-- ----------------------------
-- Table structure for erp_return_purchase_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_purchase_items`;
CREATE TABLE `erp_return_purchase_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) unsigned NOT NULL,
  `return_id` int(11) unsigned NOT NULL,
  `purchase_item_id` int(11) DEFAULT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`purchase_id`),
  KEY `purchase_id_2` (`purchase_id`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_purchase_items
-- ----------------------------
INSERT INTO `erp_return_purchase_items` VALUES ('1', '0', '1', '91', '5', '999999', 'Shoe-Adidas', 'standard', null, '14.7150', '1.0000', '1', '0.0000', '1', '0.0000', '0', '0.0000', '14.7150', '14.7150');
INSERT INTO `erp_return_purchase_items` VALUES ('2', '0', '2', '87', '5', '999999', 'Shoe-Adidas', 'standard', null, '14.0630', '1.0000', '1', '0.0000', '1', '0.0000', '0', '0.0000', '0.0000', '14.0630');
INSERT INTO `erp_return_purchase_items` VALUES ('3', '0', '3', '83', '3', '55555', 'POLO-Jean', 'standard', null, '5.8010', '20.0000', '1', '0.0000', '1', '0.0000', '0', '0.0000', '116.0200', '5.8010');
INSERT INTO `erp_return_purchase_items` VALUES ('4', '0', '4', '70', '6', '8888', 'Nike - Shoe', 'standard', null, '3.7500', '20.0000', '1', '0.0000', '1', '0.0000', '0', '0.0000', '75.0000', '3.7500');

-- ----------------------------
-- Table structure for erp_return_sales
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_sales`;
CREATE TABLE `erp_return_sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_sales
-- ----------------------------
INSERT INTO `erp_return_sales` VALUES ('1', '7', '2016-12-09 13:42:00', 'RE/1612/00001', '2', 'Chamkar Pring Garage', '546', 'A-Y Collection', '1', '', '110.0000', '0.0000', null, '0.0000', null, '0.0000', '1', '0.0000', '0.0000', null, '0.0000', '110.0000', '1', null, null, null);
INSERT INTO `erp_return_sales` VALUES ('2', '35', '2016-12-09 19:04:00', 'RE/1612/00002', '2', 'Chamkar Pring Garage', '546', 'A-Y Collection', '1', '', '0.0000', '0.0000', null, '0.0000', null, '0.0000', '2', '0.0000', '0.0000', null, '0.0000', '0.0000', '1', null, null, null);
INSERT INTO `erp_return_sales` VALUES ('3', '30', '2016-12-10 08:29:00', 'RE/1612/00003', '2', 'Chamkar Pring Garage', '546', 'A-Y Collection', '1', '', '121.0000', '0.0000', null, '0.0000', null, '0.0000', '2', '12.1000', '12.1000', null, '0.0000', '121.0000', '1', null, null, null);

-- ----------------------------
-- Table structure for erp_return_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_tax_back`;
CREATE TABLE `erp_return_tax_back` (
  `orderlineno` int(11) DEFAULT NULL,
  `tax_return_id` int(11) DEFAULT NULL,
  `itemcode` varchar(50) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `specific_tax` double DEFAULT NULL,
  `amount_tax` double DEFAULT NULL,
  `inv_num` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_tax_back
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_tax_front
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_tax_front`;
CREATE TABLE `erp_return_tax_front` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `credit_lmonth04` double DEFAULT '0',
  `precaba_month05` double DEFAULT '0',
  `premonth_rate06` double DEFAULT '0',
  `crecarry_forward07` double DEFAULT '0',
  `preprofit_taxdue08` double DEFAULT '0',
  `sptax_calbase09` double DEFAULT '0',
  `sptax_duerate10` double DEFAULT '0',
  `sptax_calbase11` double DEFAULT '0',
  `sptax_duerate12` double DEFAULT '0',
  `taxacc_calbase13` double DEFAULT '0',
  `taxacc_duerate14` double DEFAULT '0',
  `taxpuli_calbase15` double DEFAULT '0',
  `specify` varchar(100) DEFAULT '',
  `taxpuli_duerate16` double DEFAULT '0',
  `tax_calbase17` double DEFAULT '0',
  `tax_duerate18` double DEFAULT '0',
  `total_taxdue19` double DEFAULT '0',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` int(11) DEFAULT '0',
  `month` int(11) DEFAULT '0',
  `filed_in_kh` varchar(100) DEFAULT NULL,
  `filed_in_en` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_tax_front
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_value_added_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_value_added_tax`;
CREATE TABLE `erp_return_value_added_tax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `pusa_act04` varchar(100) DEFAULT '',
  `tax_credit_premonth05` varchar(100) DEFAULT '',
  `ncredit_purch06` varchar(100) DEFAULT '',
  `strate_purch07` varchar(100) DEFAULT '',
  `strate_purch08` varchar(100) DEFAULT '',
  `strate_imports09` varchar(100) DEFAULT '',
  `strate_imports10` varchar(100) DEFAULT '',
  `total_intax11` varchar(100) DEFAULT '',
  `ntaxa_sales12` varchar(100) DEFAULT '',
  `exports13` varchar(100) DEFAULT '',
  `strate_sales14` varchar(100) DEFAULT '',
  `strate_sales15` varchar(100) DEFAULT '',
  `pay_difference16` varchar(100) DEFAULT '',
  `refund17` varchar(100) DEFAULT '',
  `credit_forward18` varchar(100) DEFAULT '',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` int(11) DEFAULT '0',
  `month` int(11) DEFAULT '0',
  `field_in_kh` varchar(100) DEFAULT NULL,
  `field_in_en` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_value_added_tax
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_value_added_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_value_added_tax_back`;
CREATE TABLE `erp_return_value_added_tax_back` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value_id` int(11) DEFAULT '0',
  `productid` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `inv_cust_desc` varchar(255) DEFAULT NULL,
  `supp_exp_inn` varchar(255) DEFAULT NULL,
  `val_vat` varchar(255) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `val_vat_g` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_value_added_tax_back
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_withholding_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_withholding_tax`;
CREATE TABLE `erp_return_withholding_tax` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  `month` int(11) DEFAULT '0',
  `taxref` varchar(255) DEFAULT NULL,
  `field_in_kh` varchar(255) DEFAULT NULL,
  `field_in_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_withholding_tax
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_withholding_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_withholding_tax_back`;
CREATE TABLE `erp_return_withholding_tax_back` (
  `withholding_id` varchar(10) DEFAULT NULL,
  `emp_code` varchar(100) DEFAULT NULL,
  `object_of_payment` varchar(255) DEFAULT NULL,
  `invoice_paynote` varchar(255) DEFAULT NULL,
  `amount_paid` double DEFAULT NULL,
  `tax_rate` double DEFAULT NULL,
  `withholding_tax` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_withholding_tax_back
-- ----------------------------

-- ----------------------------
-- Table structure for erp_return_withholding_tax_front
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_withholding_tax_front`;
CREATE TABLE `erp_return_withholding_tax_front` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `withholding_id` int(11) DEFAULT '0',
  `amount_paid` double DEFAULT '0',
  `tax_rate` double DEFAULT '1',
  `withholding_tax` double DEFAULT '0',
  `remarks` text,
  `type` varchar(10) DEFAULT NULL,
  `type_of_oop` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_return_withholding_tax_front
-- ----------------------------

-- ----------------------------
-- Table structure for erp_revenues
-- ----------------------------
DROP TABLE IF EXISTS `erp_revenues`;
CREATE TABLE `erp_revenues` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `tax_type` varchar(255) NOT NULL,
  `revenue` varchar(255) NOT NULL,
  `goods_and_service` varchar(255) DEFAULT NULL,
  `description` text,
  `created_by` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_revenues
-- ----------------------------
INSERT INTO `erp_revenues` VALUES ('1', 'small_taxpayers', 'ចំណូលភោជនីដ្ឋាន', 'Good', '<p>លក់ម្ហូប និងគ្រឿងក្លែម</p>', '1', '2016-12-06 08:55:21');
INSERT INTO `erp_revenues` VALUES ('2', 'small_taxpayers', 'ចំណូលផ្ទះសំណាក់', 'Service', '<p>សេវាជួលបន្ទប់</p>', '1', '2016-12-06 08:52:22');

-- ----------------------------
-- Table structure for erp_salary_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_salary_tax`;
CREATE TABLE `erp_salary_tax` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` int(11) DEFAULT '0',
  `month` int(11) DEFAULT '0',
  `filed_in_kh` varchar(255) DEFAULT '0',
  `filed_in_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_salary_tax
-- ----------------------------

-- ----------------------------
-- Table structure for erp_salary_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_salary_tax_back`;
CREATE TABLE `erp_salary_tax_back` (
  `orderno` int(11) NOT NULL AUTO_INCREMENT,
  `salary_tax_id` int(11) NOT NULL,
  `empcode` varchar(50) DEFAULT '0',
  `salary_paid` double(25,8) DEFAULT NULL,
  `spouse` int(10) DEFAULT NULL,
  `minor_children` int(5) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `date_insert` date DEFAULT NULL,
  `tax_type` varchar(50) NOT NULL,
  `tax_rate` double(25,8) DEFAULT NULL,
  `tax_salary` double(25,8) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`orderno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_salary_tax_back
-- ----------------------------

-- ----------------------------
-- Table structure for erp_salary_tax_front
-- ----------------------------
DROP TABLE IF EXISTS `erp_salary_tax_front`;
CREATE TABLE `erp_salary_tax_front` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `salary_tax_id` int(11) DEFAULT '0',
  `emp_num` int(11) DEFAULT '0',
  `salary_paid` double DEFAULT '0',
  `spouse_num` int(11) DEFAULT '0',
  `children_num` int(11) DEFAULT '0',
  `tax_salcalbase` double DEFAULT '0',
  `tax_rate` double DEFAULT '1',
  `tax_salary` double DEFAULT '0',
  `tax_type` char(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_salary_tax_front
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sales
-- ----------------------------
DROP TABLE IF EXISTS `erp_sales`;
CREATE TABLE `erp_sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `delivery_status` varchar(50) DEFAULT NULL,
  `delivery_by` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_items` tinyint(4) DEFAULT NULL,
  `total_cost` decimal(25,4) NOT NULL,
  `pos` tinyint(1) NOT NULL DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `suspend_note` varchar(20) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) DEFAULT NULL,
  `other_cur_paid_rate` decimal(25,0) DEFAULT '1',
  `other_cur_paid1` decimal(25,4) DEFAULT NULL,
  `other_cur_paid_rate1` decimal(25,4) DEFAULT NULL,
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) NOT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) DEFAULT '0',
  `sale_type` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sales
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sales_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_sales_audit`;
CREATE TABLE `erp_sales_audit` (
  `auit_sales_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_save_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_items` tinyint(4) DEFAULT NULL,
  `total_cost` decimal(25,4) NOT NULL,
  `pos` tinyint(1) NOT NULL DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `suspend_note` varchar(20) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) DEFAULT NULL,
  `other_cur_paid_rate` decimal(25,0) DEFAULT '1',
  `other_cur_paid1` decimal(25,4) DEFAULT NULL,
  `other_cur_paid_rate1` decimal(25,4) DEFAULT NULL,
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) NOT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) DEFAULT '0',
  `delivery_by` int(11) DEFAULT NULL,
  `sale_type` int(1) DEFAULT NULL,
  PRIMARY KEY (`auit_sales_id`),
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sales_audit
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sales_types
-- ----------------------------
DROP TABLE IF EXISTS `erp_sales_types`;
CREATE TABLE `erp_sales_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_code` varchar(20) DEFAULT '',
  `type_name` varchar(100) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `Sales_Type` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sales_types
-- ----------------------------
INSERT INTO `erp_sales_types` VALUES ('1', 'Pr', 'Price');
INSERT INTO `erp_sales_types` VALUES ('2', 'Ws', 'Whole Sale');
INSERT INTO `erp_sales_types` VALUES ('3', 'Sp', 'Special (VIP)');

-- ----------------------------
-- Table structure for erp_sale_areas
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_areas`;
CREATE TABLE `erp_sale_areas` (
  `areacode` int(3) NOT NULL AUTO_INCREMENT,
  `areadescription` varchar(100) DEFAULT '',
  `areas_g_code` varchar(100) DEFAULT '',
  PRIMARY KEY (`areacode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sale_areas
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sale_dev_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_dev_items`;
CREATE TABLE `erp_sale_dev_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `category_name` varchar(255) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `machine_name` varchar(50) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `grand_total` decimal(25,4) DEFAULT NULL,
  `quantity_break` decimal(25,4) DEFAULT NULL,
  `quantity_index` decimal(25,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_1` int(11) DEFAULT NULL,
  `user_2` int(11) DEFAULT NULL,
  `user_3` int(11) DEFAULT NULL,
  `user_4` int(11) DEFAULT NULL,
  `user_5` int(11) DEFAULT NULL,
  `user_6` int(11) DEFAULT NULL,
  `user_7` int(11) DEFAULT NULL,
  `user_8` int(11) DEFAULT NULL,
  `user_9` int(11) DEFAULT NULL,
  `cf1` varchar(20) DEFAULT NULL,
  `cf2` varchar(20) DEFAULT NULL,
  `cf3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`sale_id`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`sale_id`),
  KEY `sale_id_2` (`sale_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sale_dev_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sale_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_items`;
CREATE TABLE `erp_sale_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`sale_id`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`sale_id`),
  KEY `sale_id_2` (`sale_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sale_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sale_items_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_items_audit`;
CREATE TABLE `erp_sale_items_audit` (
  `audit_sale_items_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_save_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL,
  `sale_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`audit_sale_items_id`),
  KEY `sale_id` (`sale_id`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`sale_id`),
  KEY `sale_id_2` (`sale_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sale_items_audit
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sale_order
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_order`;
CREATE TABLE `erp_sale_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_items` tinyint(4) DEFAULT NULL,
  `total_cost` decimal(25,4) NOT NULL,
  `pos` tinyint(1) NOT NULL DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `suspend_note` varchar(20) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) DEFAULT NULL,
  `other_cur_paid_rate` decimal(25,0) DEFAULT '1',
  `other_cur_paid1` decimal(25,4) DEFAULT NULL,
  `other_cur_paid_rate1` decimal(25,4) DEFAULT NULL,
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) NOT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) DEFAULT '0',
  `delivery_by` int(11) DEFAULT NULL,
  `sale_type` tinyint(1) DEFAULT NULL,
  `delivery_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sale_order
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sale_order_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_order_items`;
CREATE TABLE `erp_sale_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_order_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  `group_price_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`sale_order_id`),
  KEY `product_id` (`product_id`),
  KEY `product_id_2` (`product_id`,`sale_order_id`),
  KEY `sale_id_2` (`sale_order_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sale_order_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sale_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_tax`;
CREATE TABLE `erp_sale_tax` (
  `vat_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(100) DEFAULT '',
  `sale_id` varchar(100) DEFAULT '',
  `customer_id` varchar(100) DEFAULT '',
  `issuedate` datetime DEFAULT NULL,
  `vatin` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `qty` double(8,4) DEFAULT NULL,
  `non_tax_sale` double(8,4) DEFAULT NULL,
  `value_export` double(8,4) DEFAULT NULL,
  `amound` double DEFAULT NULL,
  `amound_tax` double DEFAULT '0',
  `amound_declare` double(8,4) DEFAULT NULL,
  `tax_value` double(8,4) DEFAULT NULL,
  `vat` double(8,4) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_date` date DEFAULT NULL,
  `journal_location` varchar(100) DEFAULT NULL,
  `referent_no` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`vat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sale_tax
-- ----------------------------

-- ----------------------------
-- Table structure for erp_serial
-- ----------------------------
DROP TABLE IF EXISTS `erp_serial`;
CREATE TABLE `erp_serial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `serial_number` varchar(150) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `warehouse` int(11) DEFAULT NULL,
  `serial_status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_serial
-- ----------------------------

-- ----------------------------
-- Table structure for erp_sessions
-- ----------------------------
DROP TABLE IF EXISTS `erp_sessions`;
CREATE TABLE `erp_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_sessions
-- ----------------------------

-- ----------------------------
-- Table structure for erp_settings
-- ----------------------------
DROP TABLE IF EXISTS `erp_settings`;
CREATE TABLE `erp_settings` (
  `setting_id` int(1) NOT NULL,
  `logo` varchar(255) NOT NULL,
  `logo2` varchar(255) NOT NULL,
  `site_name` varchar(55) NOT NULL,
  `language` varchar(20) NOT NULL,
  `default_warehouse` int(2) NOT NULL,
  `accounting_method` tinyint(4) NOT NULL DEFAULT '0',
  `default_currency` varchar(3) NOT NULL,
  `default_tax_rate` int(2) NOT NULL,
  `rows_per_page` int(2) NOT NULL,
  `version` varchar(10) NOT NULL DEFAULT '1.0',
  `default_tax_rate2` int(11) NOT NULL DEFAULT '0',
  `dateformat` int(11) NOT NULL,
  `sales_prefix` varchar(20) DEFAULT NULL,
  `quote_prefix` varchar(20) DEFAULT NULL,
  `purchase_prefix` varchar(20) DEFAULT NULL,
  `transfer_prefix` varchar(20) DEFAULT NULL,
  `delivery_prefix` varchar(20) DEFAULT NULL,
  `payment_prefix` varchar(20) DEFAULT NULL,
  `return_prefix` varchar(20) DEFAULT NULL,
  `expense_prefix` varchar(20) DEFAULT NULL,
  `transaction_prefix` varchar(10) DEFAULT NULL,
  `item_addition` tinyint(1) NOT NULL DEFAULT '0',
  `theme` varchar(20) NOT NULL,
  `product_serial` tinyint(4) NOT NULL,
  `default_discount` int(11) NOT NULL,
  `product_discount` tinyint(1) NOT NULL DEFAULT '0',
  `discount_method` tinyint(4) NOT NULL,
  `tax1` tinyint(4) NOT NULL,
  `tax2` tinyint(4) NOT NULL,
  `overselling` tinyint(1) NOT NULL DEFAULT '0',
  `restrict_user` tinyint(4) NOT NULL DEFAULT '0',
  `restrict_calendar` tinyint(4) NOT NULL DEFAULT '0',
  `timezone` varchar(100) DEFAULT NULL,
  `iwidth` int(11) NOT NULL DEFAULT '0',
  `iheight` int(11) NOT NULL,
  `twidth` int(11) NOT NULL,
  `theight` int(11) NOT NULL,
  `watermark` tinyint(1) DEFAULT NULL,
  `reg_ver` tinyint(1) DEFAULT NULL,
  `allow_reg` tinyint(1) DEFAULT NULL,
  `reg_notification` tinyint(1) DEFAULT NULL,
  `auto_reg` tinyint(1) DEFAULT NULL,
  `protocol` varchar(20) NOT NULL DEFAULT 'mail',
  `mailpath` varchar(55) DEFAULT '/usr/sbin/sendmail',
  `smtp_host` varchar(100) DEFAULT NULL,
  `smtp_user` varchar(100) DEFAULT NULL,
  `smtp_pass` varchar(255) DEFAULT NULL,
  `smtp_port` varchar(10) DEFAULT '25',
  `smtp_crypto` varchar(10) DEFAULT NULL,
  `corn` datetime DEFAULT NULL,
  `customer_group` int(11) NOT NULL,
  `default_email` varchar(100) NOT NULL,
  `mmode` tinyint(1) NOT NULL,
  `bc_fix` tinyint(4) NOT NULL DEFAULT '0',
  `auto_detect_barcode` tinyint(1) NOT NULL DEFAULT '0',
  `captcha` tinyint(1) NOT NULL DEFAULT '1',
  `reference_format` tinyint(1) NOT NULL DEFAULT '1',
  `racks` tinyint(1) DEFAULT '0',
  `attributes` tinyint(1) NOT NULL DEFAULT '0',
  `product_expiry` tinyint(1) NOT NULL DEFAULT '0',
  `purchase_decimals` tinyint(2) NOT NULL DEFAULT '2',
  `decimals` tinyint(2) NOT NULL DEFAULT '2',
  `qty_decimals` tinyint(2) NOT NULL DEFAULT '2',
  `decimals_sep` varchar(2) NOT NULL DEFAULT '.',
  `thousands_sep` varchar(2) NOT NULL DEFAULT ',',
  `invoice_view` tinyint(1) DEFAULT '0',
  `default_biller` int(11) DEFAULT NULL,
  `envato_username` varchar(50) DEFAULT NULL,
  `purchase_code` varchar(100) DEFAULT NULL,
  `rtl` tinyint(1) DEFAULT '0',
  `each_spent` decimal(15,4) DEFAULT NULL,
  `ca_point` tinyint(4) DEFAULT NULL,
  `each_sale` decimal(15,4) DEFAULT NULL,
  `sa_point` tinyint(4) DEFAULT NULL,
  `update` tinyint(1) DEFAULT '0',
  `sac` tinyint(1) DEFAULT '0',
  `display_all_products` tinyint(1) DEFAULT '0',
  `display_symbol` tinyint(1) DEFAULT NULL,
  `symbol` varchar(50) DEFAULT NULL,
  `item_slideshow` tinyint(1) DEFAULT NULL,
  `barcode_separator` varchar(2) NOT NULL DEFAULT '_',
  `remove_expired` tinyint(1) DEFAULT '0',
  `sale_payment_prefix` varchar(20) DEFAULT NULL,
  `purchase_payment_prefix` varchar(20) DEFAULT NULL,
  `sale_loan_prefix` varchar(20) DEFAULT NULL,
  `auto_print` tinyint(1) DEFAULT '1',
  `returnp_prefix` varchar(20) DEFAULT NULL,
  `alert_day` tinyint(3) NOT NULL DEFAULT '0',
  `convert_prefix` varchar(20) DEFAULT NULL,
  `purchase_serial` tinyint(4) NOT NULL,
  `sale_order_prefix` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_settings
-- ----------------------------
INSERT INTO `erp_settings` VALUES ('1', 'logo2.png', 'Kimgan_Logo1.jpg', 'A-Y Collection', 'english', '1', '2', 'USD', '1', '10', '3.0.2', '1', '5', 'SALE', 'QUOTE', 'PO', 'TR', 'DO', 'IPAY', 'RE', 'EX', 'J', '0', 'default', '0', '1', '1', '1', '1', '1', '1', '1', '0', 'Asia/Phnom_Penh', '800', '800', '60', '60', '0', '0', '0', '0', null, 'mail', '/usr/sbin/sendmail', 'pop.gmail.com', 'iclouderp@gmail.com', 'jEFTM4T63AiQ9dsidxhPKt9CIg4HQjCN58n/RW9vmdC/UDXCzRLR469ziZ0jjpFlbOg43LyoSmpJLBkcAHh0Yw==', '25', null, null, '1', 'iclouderp@gmail.com', '0', '4', '0', '0', '1', '1', '1', '0', '2', '2', '2', '.', ',', '0', '546', 'cloud-net', '53d35644-a36e-45cd-b7ee-8dde3a08f83d', '0', '10.0000', '1', '100.0000', '1', '0', '0', '0', '0', '$', '0', '_', '0', 'RV', 'PV', 'LOAN', '0', 'PRE', '7', 'CON', '0', 'SAO');

-- ----------------------------
-- Table structure for erp_skrill
-- ----------------------------
DROP TABLE IF EXISTS `erp_skrill`;
CREATE TABLE `erp_skrill` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL DEFAULT 'testaccount2@moneybookers.com',
  `secret_word` varchar(20) NOT NULL DEFAULT 'mbtest',
  `skrill_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_skrill
-- ----------------------------
INSERT INTO `erp_skrill` VALUES ('1', '0', 'laykiry@yahoo.com', 'mbtest', 'USD', '0.0000', '0.0000', '0.0000');

-- ----------------------------
-- Table structure for erp_subcategories
-- ----------------------------
DROP TABLE IF EXISTS `erp_subcategories`;
CREATE TABLE `erp_subcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  `image` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_subcategories
-- ----------------------------

-- ----------------------------
-- Table structure for erp_suspended
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspended`;
CREATE TABLE `erp_suspended` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `floor` varchar(20) DEFAULT '0',
  `ppl_number` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_suspended
-- ----------------------------

-- ----------------------------
-- Table structure for erp_suspended_bills
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspended_bills`;
CREATE TABLE `erp_suspended_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `end_date` datetime DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `count` int(11) NOT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `suspend_id` int(11) NOT NULL DEFAULT '0',
  `suspend_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_suspended_bills
-- ----------------------------

-- ----------------------------
-- Table structure for erp_suspended_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspended_items`;
CREATE TABLE `erp_suspended_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suspend_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `net_unit_price` decimal(25,4) NOT NULL,
  `unit_price` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_suspended_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_suspend_layout
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspend_layout`;
CREATE TABLE `erp_suspend_layout` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `suspend_id` int(20) NOT NULL,
  `order` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_suspend_layout
-- ----------------------------

-- ----------------------------
-- Table structure for erp_systype
-- ----------------------------
DROP TABLE IF EXISTS `erp_systype`;
CREATE TABLE `erp_systype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_systype
-- ----------------------------
INSERT INTO `erp_systype` VALUES ('1', 'po', 'Purchase');
INSERT INTO `erp_systype` VALUES ('2', 'dv', 'Delivery');
INSERT INTO `erp_systype` VALUES ('3', 'tf', 'Transfer');
INSERT INTO `erp_systype` VALUES ('4', 'ad', 'Adjustment');

-- ----------------------------
-- Table structure for erp_taxation_type_of_account
-- ----------------------------
DROP TABLE IF EXISTS `erp_taxation_type_of_account`;
CREATE TABLE `erp_taxation_type_of_account` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `account_code` int(10) NOT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` varchar(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` varchar(10) DEFAULT NULL,
  `account_tax_code` varchar(10) DEFAULT NULL,
  `deductible_expenses` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_taxation_type_of_account
-- ----------------------------

-- ----------------------------
-- Table structure for erp_taxation_type_of_product
-- ----------------------------
DROP TABLE IF EXISTS `erp_taxation_type_of_product`;
CREATE TABLE `erp_taxation_type_of_product` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `product_id` int(10) NOT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` varchar(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` varchar(10) DEFAULT NULL,
  `payment_of_profit_tax` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_taxation_type_of_product
-- ----------------------------

-- ----------------------------
-- Table structure for erp_tax_exchange_rate
-- ----------------------------
DROP TABLE IF EXISTS `erp_tax_exchange_rate`;
CREATE TABLE `erp_tax_exchange_rate` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `usd` int(10) DEFAULT NULL,
  `salary_khm` int(50) DEFAULT NULL,
  `average_khm` varchar(50) DEFAULT NULL,
  `month` int(2) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_tax_exchange_rate
-- ----------------------------

-- ----------------------------
-- Table structure for erp_tax_purchase_vat
-- ----------------------------
DROP TABLE IF EXISTS `erp_tax_purchase_vat`;
CREATE TABLE `erp_tax_purchase_vat` (
  `vat_id` int(11) NOT NULL,
  `bill_num` varchar(100) DEFAULT NULL,
  `debtorno` varchar(100) DEFAULT NULL,
  `locationname` varchar(100) DEFAULT NULL,
  `issuedate` date DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `amount_tax` double DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_location` varchar(255) DEFAULT NULL,
  `journal_date` date DEFAULT NULL,
  PRIMARY KEY (`vat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of erp_tax_purchase_vat
-- ----------------------------

-- ----------------------------
-- Table structure for erp_tax_rates
-- ----------------------------
DROP TABLE IF EXISTS `erp_tax_rates`;
CREATE TABLE `erp_tax_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `rate` decimal(12,4) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_tax_rates
-- ----------------------------
INSERT INTO `erp_tax_rates` VALUES ('1', 'No Tax', 'NT', '0.0000', '2');
INSERT INTO `erp_tax_rates` VALUES ('2', 'VAT @10%', 'VAT10', '10.0000', '1');
INSERT INTO `erp_tax_rates` VALUES ('3', 'GST @6%', 'GST', '6.0000', '1');
INSERT INTO `erp_tax_rates` VALUES ('4', 'VAT @20%', 'VT20', '20.0000', '1');
INSERT INTO `erp_tax_rates` VALUES ('5', 'TAX @10%', 'TAX', '10.0000', '1');

-- ----------------------------
-- Table structure for erp_transfers
-- ----------------------------
DROP TABLE IF EXISTS `erp_transfers`;
CREATE TABLE `erp_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_no` varchar(55) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `from_warehouse_id` int(11) NOT NULL,
  `from_warehouse_code` varchar(55) NOT NULL,
  `from_warehouse_name` varchar(55) NOT NULL,
  `to_warehouse_id` int(11) NOT NULL,
  `to_warehouse_code` varchar(55) NOT NULL,
  `to_warehouse_name` varchar(55) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT NULL,
  `grand_total` decimal(25,4) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `status` varchar(55) NOT NULL DEFAULT 'pending',
  `shipping` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_transfers
-- ----------------------------

-- ----------------------------
-- Table structure for erp_transfer_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_transfer_items`;
CREATE TABLE `erp_transfer_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `quantity_balance` decimal(15,4) NOT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transfer_id` (`transfer_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_transfer_items
-- ----------------------------

-- ----------------------------
-- Table structure for erp_units
-- ----------------------------
DROP TABLE IF EXISTS `erp_units`;
CREATE TABLE `erp_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(55) NOT NULL,
  `base_unit` int(11) DEFAULT NULL,
  `operator` varchar(1) DEFAULT NULL,
  `unit_value` varchar(55) DEFAULT NULL,
  `operation_value` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `base_unit` (`base_unit`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_units
-- ----------------------------
INSERT INTO `erp_units` VALUES ('1', '111111', 'Eacch', null, null, null, null);

-- ----------------------------
-- Table structure for erp_users
-- ----------------------------
DROP TABLE IF EXISTS `erp_users`;
CREATE TABLE `erp_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `last_ip_address` varbinary(45) DEFAULT NULL,
  `ip_address` varbinary(45) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(40) NOT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `forgotten_password_code` varchar(40) DEFAULT NULL,
  `forgotten_password_time` int(11) unsigned DEFAULT NULL,
  `remember_code` varchar(40) DEFAULT NULL,
  `created_on` int(11) unsigned NOT NULL,
  `last_login` int(11) unsigned DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `avatar` varchar(55) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned DEFAULT NULL,
  `biller_id` int(10) unsigned DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `show_cost` tinyint(1) DEFAULT '0',
  `show_price` tinyint(1) DEFAULT '0',
  `award_points` int(11) DEFAULT '0',
  `view_right` tinyint(1) NOT NULL DEFAULT '0',
  `edit_right` tinyint(1) NOT NULL DEFAULT '0',
  `allow_discount` tinyint(1) DEFAULT '0',
  `annualLeave` int(11) DEFAULT '0',
  `sickday` int(11) DEFAULT '0',
  `speacialLeave` int(11) DEFAULT NULL,
  `othersLeave` int(11) DEFAULT NULL,
  `first_name_kh` varchar(50) DEFAULT NULL,
  `last_name_kh` varchar(50) DEFAULT NULL,
  `nationality_kh` varchar(50) DEFAULT NULL,
  `race_kh` varchar(20) NOT NULL,
  `pos_layout` tinyint(1) DEFAULT NULL,
  `pack_id` varchar(50) DEFAULT NULL,
  `sales_standard` tinyint(1) DEFAULT NULL,
  `sales_combo` tinyint(1) DEFAULT NULL,
  `sales_digital` tinyint(1) DEFAULT NULL,
  `sales_service` tinyint(1) DEFAULT NULL,
  `sales_category` varchar(150) DEFAULT NULL,
  `purchase_standard` tinyint(1) DEFAULT NULL,
  `purchase_combo` tinyint(1) DEFAULT NULL,
  `purchase_digital` tinyint(1) DEFAULT NULL,
  `purchase_service` tinyint(1) DEFAULT NULL,
  `purchase_category` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`,`warehouse_id`,`biller_id`),
  KEY `group_id_2` (`group_id`,`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_users
-- ----------------------------
INSERT INTO `erp_users` VALUES ('1', 0x3139322E3136382E312E3336, 0x0000, 'owner', 'f536eef28fd507c1fe24273c65171af8d4299d14', null, 'owner@cloudnet.com.kh', null, null, null, '8a5d98b76e7cad45a8efc6c8c4eda7cdd1ab04a5', '1351661704', '1481508706', '1', 'Owner', 'Owner', 'ABC Shop', '012345678', null, 'male', '1', '0', '0', null, '0', '0', '3790', '1', '0', '0', '0', '0', null, null, null, null, null, '', null, null, null, null, null, null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for erp_user_logins
-- ----------------------------
DROP TABLE IF EXISTS `erp_user_logins`;
CREATE TABLE `erp_user_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `ip_address` varbinary(16) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_user_logins
-- ----------------------------

-- ----------------------------
-- Table structure for erp_variants
-- ----------------------------
DROP TABLE IF EXISTS `erp_variants`;
CREATE TABLE `erp_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_variants
-- ----------------------------

-- ----------------------------
-- Table structure for erp_warehouses
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouses`;
CREATE TABLE `erp_warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `map` varchar(255) DEFAULT NULL,
  `phone` varchar(55) DEFAULT NULL,
  `email` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_warehouses
-- ----------------------------
INSERT INTO `erp_warehouses` VALUES ('1', 'WH1', 'Warehouse 1', '<p>Phnom Penh</p>', null, '089333255', 'iclouderp@gmail.com');
INSERT INTO `erp_warehouses` VALUES ('2', 'WH2', 'Warehouse 2', '<p>hello</p>', null, '012369852', 'iclouderp@gmail.com');

-- ----------------------------
-- Table structure for erp_warehouses_products
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouses_products`;
CREATE TABLE `erp_warehouses_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `rack` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_warehouses_products
-- ----------------------------

-- ----------------------------
-- Table structure for erp_warehouses_products_variants
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouses_products_variants`;
CREATE TABLE `erp_warehouses_products_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `option_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `rack` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `option_id` (`option_id`),
  KEY `product_id` (`product_id`),
  KEY `warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of erp_warehouses_products_variants
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_adjustment_insert`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_adjustment_insert` AFTER INSERT ON `erp_adjustments` FOR EACH ROW BEGIN

DECLARE v_tran_no INTEGER;
DECLARE v_default_stock_adjust INTEGER;
DECLARE v_default_stock INTEGER;


SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

UPDATE erp_order_ref
SET tr = v_tran_no
WHERE
DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

/*

SET v_default_stock_adjust = (SELECT default_stock_adjust FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_stock = (SELECT default_stock FROM erp_account_settings WHERE biller_id = NEW.biller_id);

*/


SET v_default_stock_adjust = (SELECT default_stock_adjust FROM erp_account_settings);
SET v_default_stock = (SELECT default_stock FROM erp_account_settings);


/* ==== Addition =====*/

	IF NEW.type = 'addition' THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1)* abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock_adjust
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock_adjust;


	ELSE

  		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1)*abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock;


		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock_adjust
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock_adjust;
	END IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_adjustment_update`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_adjustment_update` AFTER UPDATE ON `erp_adjustments` FOR EACH ROW BEGIN

DECLARE v_tran_no INTEGER;
DECLARE v_default_stock_adjust INTEGER;
DECLARE v_default_stock INTEGER;

SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='STOCK_ADJUST' AND reference_no = NEW.id LIMIT 0,1); 


DELETE FROM erp_gl_trans WHERE tran_type='STOCK_ADJUST' AND reference_no = NEW.id;

/*

SET v_default_stock_adjust = (SELECT default_stock_adjust FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_stock = (SELECT default_stock FROM erp_account_settings WHERE biller_id = NEW.biller_id);

*/


SET v_default_stock_adjust = (SELECT default_stock_adjust FROM erp_account_settings);
SET v_default_stock = (SELECT default_stock FROM erp_account_settings);


/* ==== Addition =====*/

	IF NEW.type = 'addition' THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1)* abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock_adjust
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock_adjust;


	ELSE

  		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1)*abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			)
			SELECT
			'STOCK_ADJUST',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.total_cost),
			NEW.id,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_stock_adjust
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_stock_adjust;
	END IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_adjustment_delete`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_adjustment_delete` AFTER DELETE ON `erp_adjustments` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE tran_type='STOCK_ADJUST' AND reference_no = OLD.id;

END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_tran_salary_tax_insert_small`;
DELIMITER ;;
CREATE TRIGGER `gl_tran_salary_tax_insert_small` AFTER INSERT ON `erp_employee_salary_tax_small_taxpayers_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;
DECLARE v_date DATE;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);


IF v_tran_date = DATE_FORMAT(NEW.year_month, '%Y-%m') THEN

SET v_tran_no = (
	SELECT
		MAX(tran_no)
	FROM
		erp_gl_trans
);

ELSE

SET v_tran_no = (
	SELECT
		COALESCE (MAX(tran_no), 0) + 1
	FROM
		erp_gl_trans
);


UPDATE erp_order_ref
SET tr = v_tran_no
WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
END
IF;

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);

SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);


/* ==== Employee Salary Tax =====*/
IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;


ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAY(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END
IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_tran_salary_tax_update_small`;
DELIMITER ;;
CREATE TRIGGER `gl_tran_salary_tax_update_small` AFTER UPDATE ON `erp_employee_salary_tax_small_taxpayers_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;

SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no LIMIT 0,1); 

DELETE FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);

SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);

/* ==== Employee Salary Tax =====*/
IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;


ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END
IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_tran_salary_tax_insert`;
DELIMITER ;;
CREATE TRIGGER `gl_tran_salary_tax_insert` AFTER INSERT ON `erp_employee_salary_tax_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;
DECLARE v_date DATE;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);


IF v_tran_date = DATE_FORMAT(NEW.year_month, '%Y-%m') THEN

SET v_tran_no = (
	SELECT
		MAX(tran_no)
	FROM
		erp_gl_trans
);

ELSE

SET v_tran_no = (
	SELECT
		COALESCE (MAX(tran_no), 0) + 1
	FROM
		erp_gl_trans
);


UPDATE erp_order_ref
SET tr = v_tran_no
WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
END
IF;

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);

SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);


/* ==== Employee Salary Tax =====*/
IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
                                     NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;


ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
                                     (- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	 (- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END
IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_tran_salary_tax_update`;
DELIMITER ;;
CREATE TRIGGER `gl_tran_salary_tax_update` AFTER UPDATE ON `erp_employee_salary_tax_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;

SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no LIMIT 0,1); 

DELETE FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);

SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);

/* ==== Employee Salary Tax =====*/
IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;


ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
                                     (- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll 
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END
IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_tran_enter_using_stock_insert`;
DELIMITER ;;
CREATE TRIGGER `gl_tran_enter_using_stock_insert` AFTER INSERT ON `erp_enter_using_stock` FOR EACH ROW BEGIN
	DECLARE
		e_tran_type VARCHAR (50);

DECLARE
	e_tran_date DATETIME;

DECLARE
	e_account_code INTEGER;

DECLARE
	e_narrative VARCHAR (255);

DECLARE
	v_tran_no INTEGER;


DECLARE inv_account_code INTEGER;

DECLARE inv_narrative VARCHAR (255);

DECLARE cost_variant_account_code INTEGER;

DECLARE cost_variant_narrative VARCHAR (255);

SET v_tran_no = (
	SELECT
		COALESCE (MAX(tran_no), 0) + 1
	FROM
		erp_gl_trans
);

UPDATE erp_order_ref
SET tr = v_tran_no
WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


SET e_narrative = (
	SELECT
		erp_gl_charts.accountname
	FROM
		erp_gl_charts
	WHERE
		erp_gl_charts.accountcode = NEW.account
);

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by
)
VALUES
	(
		'USING STOCK',
		v_tran_no,
		NEW.date,
		NEW.account,
		e_narrative,
		NEW.total_cost,
		NEW.reference_no,
		NEW.note,
		NEW.shop,
		NEW.create_by
	);








SET inv_account_code = (
	SELECT
		erp_account_settings.default_stock
	FROM
		erp_account_settings
);
SET inv_narrative = (
	SELECT
		erp_gl_charts.accountname
	FROM
		erp_gl_charts
	WHERE
		erp_gl_charts.accountcode = inv_account_code 
);

SET cost_variant_account_code = (
	SELECT
		erp_account_settings.default_cost_variant
	FROM
		erp_account_settings
);
SET cost_variant_narrative = (
	SELECT
		erp_gl_charts.accountname
	FROM
		erp_gl_charts
	WHERE
		erp_gl_charts.accountcode = cost_variant_account_code 
);

IF NEW.type = 'use' THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by
	)
	VALUES
		(
			'USING STOCK',
			v_tran_no,
			NEW.date,
			inv_account_code ,
			inv_narrative ,
			(- 1) * (NEW.total_cost),
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.create_by
		);
END IF;


IF NEW.type = 'return' THEN
       IF NEW.total_cost <> NEW.total_using_cost THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by
	)
	VALUES
		(
			'USING STOCK',
			v_tran_no,
			NEW.date,
			cost_variant_account_code ,
			cost_variant_narrative ,
			(NEW.total_using_cost)-(NEW.total_cost),
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.create_by
		);
         END IF;
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by
	)
	VALUES
		(
			'USING STOCK',
			v_tran_no,
			NEW.date,
			inv_account_code ,
			inv_narrative ,
			(- 1) * (NEW.total_using_cost),
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.create_by
		);
END IF;








END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_tran_enter_using_stock_update`;
DELIMITER ;;
CREATE TRIGGER `gl_tran_enter_using_stock_update` AFTER UPDATE ON `erp_enter_using_stock` FOR EACH ROW BEGIN
	DECLARE
		e_tran_type VARCHAR (50);

DECLARE
	e_tran_date DATETIME;

DECLARE
	e_account_code INTEGER;

DECLARE
	e_narrative VARCHAR (255);

DECLARE
	v_tran_no INTEGER;


DECLARE inv_account_code INTEGER;

DECLARE inv_narrative VARCHAR (255);

DECLARE cost_variant_account_code INTEGER;

DECLARE cost_variant_narrative VARCHAR (255);

DECLARE inv_created_by VARCHAR (255);
SET  inv_created_by=(
                                     SELECT created_by from erp_gl_trans where reference_no = NEW.reference_no
                                      LIMIT 1
                                   );

SET v_tran_no = (
	SELECT
		COALESCE (MAX(tran_no), 0) + 1
	FROM
		erp_gl_trans
);

UPDATE erp_order_ref
SET tr = v_tran_no
WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


SET e_narrative = (
	SELECT
		erp_gl_charts.accountname
	FROM
		erp_gl_charts
	WHERE
		erp_gl_charts.accountcode = NEW.account
);

DELETE FROM erp_gl_trans WHERE tran_type='USING STOCK' AND bank=0 AND reference_no = NEW.reference_no;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
                   updated_by
)
VALUES
	(
		'USING STOCK',
		v_tran_no,
		NEW.date,
		NEW.account,
		e_narrative,
		NEW.total_cost,
		NEW.reference_no,
		NEW.note,
		NEW.shop,
		inv_created_by,
                                     NEW.create_by
	);








SET inv_account_code = (
	SELECT
		erp_account_settings.default_stock
	FROM
		erp_account_settings
);
SET inv_narrative = (
	SELECT
		erp_gl_charts.accountname
	FROM
		erp_gl_charts
	WHERE
		erp_gl_charts.accountcode = inv_account_code 
);

SET cost_variant_account_code = (
	SELECT
		erp_account_settings.default_cost_variant
	FROM
		erp_account_settings
);
SET cost_variant_narrative = (
	SELECT
		erp_gl_charts.accountname
	FROM
		erp_gl_charts
	WHERE
		erp_gl_charts.accountcode = cost_variant_account_code 
);



IF NEW.type = 'use' THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by
	)
	VALUES
		(
			'USING STOCK',
			v_tran_no,
			NEW.date,
			inv_account_code ,
			inv_narrative ,
			(- 1) * (NEW.total_cost),
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.create_by
		);
END IF;


IF NEW.type = 'return' THEN
      IF NEW.total_cost <> NEW.total_using_cost THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by
	)
	VALUES
		(
			'USING STOCK',
			v_tran_no,
			NEW.date,
			cost_variant_account_code ,
			cost_variant_narrative ,
			(NEW.total_using_cost)-(NEW.total_cost),
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.create_by
		);
    END IF;
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by
	)
	VALUES
		(
			'USING STOCK',
			v_tran_no,
			NEW.date,
			inv_account_code ,
			inv_narrative ,
			(- 1) * (NEW.total_using_cost),
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.create_by
		);
END IF;







END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_expense_insert`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_expense_insert` AFTER INSERT ON `erp_expenses` FOR EACH ROW BEGIN

DECLARE v_tran_no INTEGER;
DECLARE v_tran_date DATETIME;


IF NEW.created_by THEN

	SET v_tran_date = (SELECT erp_expenses.date 
		FROM erp_payments 
		INNER JOIN erp_expenses ON erp_expenses.id = erp_payments.expense_id
		WHERE erp_expenses.id = NEW.id LIMIT 0,1);

	IF v_tran_date = NEW.date THEN
		SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
	ELSE
		SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);
	
		UPDATE erp_order_ref
		SET tr = v_tran_no
		WHERE
		DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
	END IF;


	INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'JOURNAL',
			v_tran_no,
			NEW.date,
			erp_gl_charts.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			NEW.reference,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_gl_charts
			WHERE
				erp_gl_charts.accountcode = NEW.account_code;

	INSERT INTO erp_gl_trans (
			tran_type,

			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'JOURNAL',
			v_tran_no,
			NEW.date,
			erp_gl_charts.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1)*NEW.amount,
			NEW.reference,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_gl_charts
			WHERE
				erp_gl_charts.accountcode = NEW.bank_code;
	

END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_expense_update`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_expense_update` AFTER UPDATE ON `erp_expenses` FOR EACH ROW BEGIN

DECLARE v_tran_no INTEGER;


	SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE reference_no = NEW.reference LIMIT 0,1);
	IF v_tran_no < 1  THEN
		SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);
	                
		UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
	ELSE
	                SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
	END IF;

IF NEW.updated_by THEN

   	
	DELETE FROM erp_gl_trans WHERE reference_no = NEW.reference;
	
	INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'JOURNAL',
			v_tran_no,
			NEW.date,
			erp_gl_charts.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			NEW.reference,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_gl_charts
			WHERE
				erp_gl_charts.accountcode = NEW.account_code;

	INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'JOURNAL',
			v_tran_no,
			NEW.date,
			erp_gl_charts.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1)*NEW.amount,
			NEW.reference,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_gl_charts
			WHERE
				erp_gl_charts.accountcode = NEW.bank_code;
		

END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_expense_delete`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_expense_delete` AFTER DELETE ON `erp_expenses` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_loan_delete`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_loan_delete` AFTER DELETE ON `erp_loans` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;

END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_payment_insert`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_payment_insert` AFTER INSERT ON `erp_payments` FOR EACH ROW BEGIN

DECLARE v_tran_no INTEGER;
DECLARE v_default_cash INTEGER;
DECLARE v_default_credit_card INTEGER;
DECLARE v_default_gift_card INTEGER;
DECLARE v_default_cheque INTEGER;
DECLARE v_default_sale_deposit INTEGER;

DECLARE v_default_purchase_deposit INTEGER;
DECLARE v_default_loan INTEGER;
DECLARE v_default_receivable INTEGER;
DECLARE v_default_payable INTEGER;
DECLARE v_bank_code INTEGER;
DECLARE v_account_code INTEGER;
DECLARE v_tran_date DATETIME;

SET v_tran_date = (SELECT erp_sales.date 
		FROM erp_payments 
		INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
		WHERE erp_sales.id = NEW.sale_id LIMIT 0,1);

IF v_tran_date = NEW.date THEN
	SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
ELSE
	SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);


	UPDATE erp_order_ref
	SET tr = v_tran_no
	WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
END IF;

/*
SET v_default_cash = (SELECT default_cash FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_credit_card = (SELECT default_credit_card FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_gift_card = (SELECT default_gift_card FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_cheque = (SELECT default_cheque FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_sale_deposit = (SELECT default_sale_deposit FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_purchase_deposit = (SELECT default_purchase_deposit FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_loan = (SELECT default_loan FROM erp_account_settings WHERE biller_id = NEW.biller_id);

SET v_default_receivable = (SELECT default_receivable FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_payable = (SELECT default_payable FROM erp_account_settings WHERE biller_id = NEW.biller_id);
*/

SET v_default_cash = (SELECT default_cash FROM erp_account_settings);
SET v_default_credit_card = (SELECT default_credit_card FROM erp_account_settings);
SET v_default_gift_card = (SELECT default_gift_card FROM erp_account_settings);
SET v_default_cheque = (SELECT default_cheque FROM erp_account_settings);
SET v_default_sale_deposit = (SELECT default_sale_deposit FROM erp_account_settings);
SET v_default_purchase_deposit = (SELECT default_purchase_deposit FROM erp_account_settings);

SET v_default_loan = (SELECT default_loan FROM erp_account_settings);

SET v_default_receivable = (SELECT default_receivable FROM erp_account_settings);
SET v_default_payable = (SELECT default_payable FROM erp_account_settings);

IF NEW.paid_by = 'cash' THEN 
SET v_bank_code = v_default_cash;          
END IF;

IF NEW.paid_by = 'credit_card' THEN
SET v_bank_code = v_default_credit_card;
END IF;

IF NEW.paid_by = 'gift_card' THEN
SET v_bank_code = v_default_gift_card ;
END IF;

IF NEW.paid_by = 'cheque' THEN
SET v_bank_code = v_default_cheque;
END IF;

IF NEW.paid_by = 'deposit' THEN
SET v_bank_code = v_default_sale_deposit;
END IF;

IF NEW.paid_by = 'loan' THEN
SET v_bank_code = v_default_loan;
END IF;

/* ==== SALE GL =====*/
	IF NEW.sale_id>0 THEN
		IF NEW.return_id>0 AND NEW.type = 'returned' AND NEW.amount>0 THEN
			IF NEW.add_payment = 1 THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					bank,
					updated_by
					)
					SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					NEW.amount,
					(
						SELECT reference_no FROM erp_sales WHERE id = NEW.sale_id
					),
					(
						SELECT customer FROM erp_sales WHERE id = NEW.sale_id
					),
					NEW.biller_id,
					NEW.created_by,
					'1',
					(
						SELECT updated_by FROM erp_sales WHERE id = NEW.sale_id
					)
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = v_default_receivable
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = v_default_receivable;
			END IF;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				bank,
				updated_by) 
				SELECT
				'SALES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1)*(NEW.amount),
				(
					SELECT reference_no FROM erp_sales WHERE id = NEW.sale_id
				),
				(
					SELECT customer FROM erp_sales WHERE id = NEW.sale_id
				),
				NEW.biller_id,
				NEW.created_by,
				'1',
				(
					SELECT updated_by FROM erp_sales WHERE id = NEW.sale_id
				)
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = v_bank_code
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = v_bank_code;


  		ELSE
			IF NEW.add_payment = 1 THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					bank,
					updated_by)
					SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1)*(NEW.amount),
					(
						SELECT reference_no FROM erp_sales WHERE id = NEW.sale_id
					),
					(
						SELECT customer FROM erp_sales WHERE id = NEW.sale_id
					),
					NEW.biller_id,
					'1',
					NEW.created_by,
					(
						SELECT updated_by FROM erp_sales WHERE id = NEW.sale_id
					)
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = v_default_receivable
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = v_default_receivable;
			END IF;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				bank,
				updated_by) 
				SELECT
				'SALES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.amount,
				(
					SELECT reference_no FROM erp_sales WHERE id = NEW.sale_id
				),
				(
					SELECT customer FROM erp_sales WHERE id = NEW.sale_id
				),
				NEW.biller_id,
				NEW.created_by,
				'1',
				(
					SELECT updated_by FROM erp_sales WHERE id = NEW.sale_id
				)
				FROM
				erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = v_bank_code
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = v_bank_code;
		END IF;
     END IF;


/* ==== OTHER GL =====
	IF NEW.transaction_id THEN

        INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by) 
			SELECT
			'EXPENSES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			(
				SELECT reference FROM erp_expenses WHERE id = NEW.transaction_id
			),
			(
				SELECT note FROM erp_expenses WHERE id = NEW.transaction_id
			),
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_expenses WHERE id = NEW.transaction_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payable
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_payable;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'EXPENSES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(NEW.amount),
			(
				SELECT reference FROM erp_expenses WHERE id = NEW.transaction_id
			),
			(
				SELECT note FROM erp_expenses WHERE id = NEW.transaction_id
			),
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_expenses WHERE id = NEW.transaction_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_bank_code
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_bank_code;
	END IF;
*/

/* ==== SALE DEPOSIT GL =====*/
	IF NEW.deposit_id THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(NEW.amount),
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits	WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_sale_deposit
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_sale_deposit;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_bank_code
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_bank_code;
	END IF;

 /* ==== SALE RETURN DEPOSIT GL =====*/
				IF NEW.return_deposit_id THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						created_by,
						bank,
						updated_by
					) SELECT
						'DEPOSIT-RETURN',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.amount,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.created_by,
						'1',
						(
							SELECT
								updated_by
							FROM
								erp_deposits
							WHERE
								id = NEW.deposit_id
						)
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_sale_deposit
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = v_default_sale_deposit ; INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							created_by,
							bank,
							updated_by
						) SELECT
							'DEPOSITS',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,

							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(- 1) * abs(NEW.amount),
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.created_by,
							'1',
							(
								SELECT
									updated_by
								FROM
									erp_deposits
								WHERE
									id = NEW.deposit_id
							)
						FROM
							erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_bank_code
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = v_bank_code ;
						END IF;

/* ==== PURCHASE DEPOSIT GL =====*/
	IF NEW.purchase_deposit_id THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits	WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_purchase_deposit
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_purchase_deposit;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(NEW.amount),
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_bank_code
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_bank_code;
	END IF;
/* ==== SALE LOAN GL =====*/
	IF NEW.loan_id > 0 THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'LOANS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(NEW.amount),
			(
				SELECT reference_no FROM erp_loans WHERE id = NEW.loan_id
			),
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_loans WHERE id = NEW.loan_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_loan
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_loan;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'LOANS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			(
				SELECT reference_no FROM erp_loans WHERE id = NEW.loan_id
			),
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_loans WHERE id = NEW.loan_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_bank_code
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_bank_code;
	END IF;

/* ==== PURCHASE GL =====*/
	IF NEW.purchase_id>0 THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			(
				SELECT reference_no FROM erp_purchases WHERE id = NEW.purchase_id
			),
			(
				SELECT supplier FROM erp_purchases WHERE id = NEW.purchase_id
			),
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_purchases WHERE id = NEW.purchase_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_default_payable
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_payable;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1)*abs(NEW.amount),
			(
				SELECT reference_no FROM erp_purchases WHERE id = NEW.purchase_id
			),
			(
				SELECT supplier FROM erp_purchases WHERE id = NEW.purchase_id
			),
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_purchases WHERE id = NEW.purchase_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = v_bank_code
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_bank_code;
	END IF;
     
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_payment_update`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_payment_update` AFTER UPDATE ON `erp_payments` FOR EACH ROW BEGIN

DECLARE v_tran_no INTEGER;
DECLARE v_default_cash INTEGER;
DECLARE v_default_credit_card INTEGER;
DECLARE v_default_gift_card INTEGER;
DECLARE v_default_cheque INTEGER;
DECLARE v_default_sale_deposit INTEGER;
DECLARE v_default_purchase_deposit INTEGER;
DECLARE v_default_loan INTEGER;
DECLARE v_default_receivable INTEGER;
DECLARE v_default_payable INTEGER;
DECLARE v_bank_code INTEGER;
DECLARE v_account_code INTEGER;
DECLARE v_tran_date DATETIME;

SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='DEPOSITS' AND reference_no = NEW.reference_no LIMIT 0,1); 

DELETE FROM erp_gl_trans WHERE tran_type='DEPOSITS' AND reference_no = NEW.reference_no;

/*
SET v_default_cash = (SELECT default_cash FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_credit_card = (SELECT default_credit_card FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_gift_card = (SELECT default_gift_card FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_cheque = (SELECT default_cheque FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_sale_deposit = (SELECT default_sale_deposit FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_purchase_deposit = (SELECT default_purchase_deposit FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_loan = (SELECT default_loan FROM erp_account_settings WHERE biller_id = NEW.biller_id);

SET v_default_receivable = (SELECT default_receivable FROM erp_account_settings WHERE biller_id = NEW.biller_id);
SET v_default_payable = (SELECT default_payable FROM erp_account_settings WHERE biller_id = NEW.biller_id);
*/

SET v_default_cash = (SELECT default_cash FROM erp_account_settings);
SET v_default_credit_card = (SELECT default_credit_card FROM erp_account_settings);
SET v_default_gift_card = (SELECT default_gift_card FROM erp_account_settings);
SET v_default_cheque = (SELECT default_cheque FROM erp_account_settings);
SET v_default_sale_deposit = (SELECT default_sale_deposit FROM erp_account_settings);
SET v_default_purchase_deposit = (SELECT default_purchase_deposit FROM erp_account_settings);

SET v_default_loan = (SELECT default_loan FROM erp_account_settings);

SET v_default_receivable = (SELECT default_receivable FROM erp_account_settings);
SET v_default_payable = (SELECT default_payable FROM erp_account_settings);

IF NEW.paid_by = 'cash' THEN 
SET v_bank_code = v_default_cash;          
END IF;

IF NEW.paid_by = 'credit_card' THEN
SET v_bank_code = v_default_credit_card;
END IF;

IF NEW.paid_by = 'gift_card' THEN
SET v_bank_code = v_default_gift_card ;
END IF;

IF NEW.paid_by = 'cheque' THEN
SET v_bank_code = v_default_cheque;
END IF;

IF NEW.paid_by = 'deposit' THEN
SET v_bank_code = v_default_sale_deposit;
END IF;

IF NEW.paid_by = 'loan' THEN
SET v_bank_code = v_default_loan;
END IF;

/* ==== SALE DEPOSIT GL =====*/
	IF NEW.deposit_id THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits	WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_sale_deposit
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_sale_deposit;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(NEW.amount),
			NEW.reference_no,
			NEW.note,

			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_bank_code
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_bank_code;
	END IF;

/* ==== PURCHASE DEPOSIT GL =====*/
	IF NEW.purchase_deposit_id THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(NEW.amount),
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits	WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_purchase_deposit
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_default_purchase_deposit;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,

			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			bank,
			updated_by)
			SELECT
			'DEPOSITS',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.amount,
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.created_by,
			'1',
			(
				SELECT updated_by FROM erp_deposits WHERE id = NEW.deposit_id
			)
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_bank_code
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = v_bank_code;
	END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_purchase_insert`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_purchase_insert` AFTER INSERT ON `erp_purchases` FOR EACH ROW BEGIN
DECLARE v_tran_no INTEGER;
DECLARE v_tran_date DATETIME;

IF NEW.status="received" AND NEW.total > 0 THEN

SET v_tran_date = (SELECT erp_purchases.date 
		FROM erp_payments 
		INNER JOIN erp_purchases ON erp_purchases.id = erp_payments.purchase_id
		WHERE erp_purchases.id = NEW.id LIMIT 0,1);

IF v_tran_date = NEW.date THEN
	SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
ELSE
	SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);
	
	UPDATE erp_order_ref
	SET tr = v_tran_no
	WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
END IF;

	INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
                                                NEW.total +NEW.product_discount,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * abs(NEW.grand_total),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_payable
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_payable;

	IF NEW.total_discount THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * abs(NEW.total_discount),

			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount;
	END IF;

	IF NEW.total_tax THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.total_tax,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax;
	END IF;

	IF NEW.shipping THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.shipping,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_freight
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_freight;
	END IF;
	
END IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_purchase_update`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_purchase_update` AFTER UPDATE ON `erp_purchases` FOR EACH ROW BEGIN
DECLARE v_tran_no INTEGER;
DECLARE v_tran_date DATETIME;

IF NEW.status="returned"  AND  NEW.return_id > 0 THEN

/*
	SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);	
	UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m'); 
*/

SET v_tran_date = (SELECT erp_purchases.date 
		FROM erp_payments 
		INNER JOIN erp_purchases ON erp_purchases.id = erp_payments.purchase_id
		WHERE erp_purchases.id = NEW.id LIMIT 0,1);

IF v_tran_date = NEW.date THEN
	SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
ELSE
	SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);
	

	UPDATE erp_order_ref
	SET tr = v_tran_no
	WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
END IF; 

	INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'PURCHASES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) *(NEW.total+NEW.product_discount),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			 abs(NEW.grand_total),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_payable
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_payable;

	IF NEW.total_discount THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			 abs(NEW.total_discount),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount;
	END IF;

	IF NEW.total_tax THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) *NEW.total_tax,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax;
	END IF;

	IF NEW.shipping THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,

			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) *NEW.shipping,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_freight
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_freight;
	END IF;

END IF;



IF NEW.status="received" AND NEW.total > 0 AND NEW.updated_by>0  AND NEW.return_id IS NULL THEN

SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='PURCHASES' AND reference_no = NEW.reference_no LIMIT 0,1);

	IF v_tran_no < 1  THEN
		SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);	                
		UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
	END IF;



DELETE FROM erp_gl_trans WHERE tran_type='PURCHASES' AND bank=0 AND reference_no = NEW.reference_no;

	INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.total,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * abs(NEW.grand_total),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_payable
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_payable;

	IF NEW.total_discount THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * abs(NEW.total_discount),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount;
	END IF;

	IF NEW.total_tax THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.total_tax,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax;
	END IF;

	IF NEW.shipping THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'PURCHASES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.shipping,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_freight
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_purchase_freight;
	END IF;

END IF;


END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_purchase_delete`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_purchase_delete` AFTER DELETE ON `erp_purchases` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_sale_insert`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_sale_insert` AFTER INSERT ON `erp_sales` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;

	IF NEW.opening_ar != 2 THEN
		IF NEW.sale_status = "completed" AND NEW.total > 0 || NEW.total_discount THEN
			SET v_tran_date = (
				SELECT
					erp_sales.date
				FROM
					erp_payments
				INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
				WHERE
					erp_sales.id = NEW.id
				LIMIT 0,
				1
			);

			IF v_tran_date = NEW.date THEN
				SET v_tran_no = (
					SELECT
						MAX(tran_no)
					FROM
						erp_gl_trans
				);
			ELSE
				SET v_tran_no = (
					SELECT
						COALESCE (MAX(tran_no), 0) + 1
					FROM
						erp_gl_trans
				);
				UPDATE erp_order_ref
				SET tr = v_tran_no
				WHERE
					DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


			END IF;

			IF NEW.grand_total > NEW.paid THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(NEW.grand_total - NEW.paid),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_receivable;
			END IF;

			IF NEW.opening_ar = 1 THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(- 1) * abs(
						NEW.total + NEW.product_discount
					),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_open_balance;

			ELSE

				INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * abs(
							NEW.total + NEW.product_discount
						),
						NEW.reference_no,
						NEW.customer,
						NEW.biller_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale;

					
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					NEW.total_cost,
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_cost;


				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(- 1) * abs(NEW.total_cost),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;


				IF NEW.total_discount THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.total_discount,
						NEW.reference_no,
						NEW.customer,
						NEW.biller_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_discount
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_discount;

				END IF;

				IF NEW.shipping THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * abs(NEW.shipping),
						NEW.reference_no,
						NEW.customer,
						NEW.biller_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_freight
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_freight;
						
				END IF;

				IF NEW.total_tax THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * abs(NEW.total_tax),
						NEW.reference_no,
						NEW.customer,
						NEW.biller_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;


				END IF;

			END IF;
		END IF;

	END IF;

	IF NEW.opening_ar = 2 THEN
		SET v_tran_date = (
			SELECT
				erp_sales.date
			FROM
				erp_payments
			INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
			WHERE
				erp_sales.id = NEW.id
			LIMIT 0,
			1
		);
		
		IF v_tran_date = NEW.date THEN
			SET v_tran_no = (
				SELECT
					MAX(tran_no)
				FROM
					erp_gl_trans
			);
		ELSE
			SET v_tran_no = (
				SELECT
					COALESCE (MAX(tran_no), 0) + 1
				FROM
					erp_gl_trans
			);
			
			UPDATE erp_order_ref
			SET tr = v_tran_no
			WHERE
				DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


		END IF;
		
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'SALES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(
				NEW.total + NEW.product_discount
			),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
		FROM
			erp_account_settings
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
		INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = erp_account_settings.default_open_balance;
			
        IF NEW.paid <= 0 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				   ) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.grand_total,
						NEW.reference_no,
						NEW.customer,
						NEW.biller_id,
						NEW.created_by,
						NEW.updated_by
					FROM
					erp_account_settings
					   INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
					   INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					   WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_receivable;
		END IF;
		
	END IF;

END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_sale_update`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_sale_update` AFTER UPDATE ON `erp_sales` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;

	IF NEW.opening_ar != 2 THEN
		IF NEW.sale_status="returned"  AND  NEW.return_id > 0 THEN
			SET v_tran_date = (SELECT erp_sales.date 
					FROM erp_payments 
					INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
					WHERE erp_sales.id = NEW.id LIMIT 0,1);

			IF v_tran_date = NEW.date THEN
				SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
			ELSE
				SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);
				
				UPDATE erp_order_ref
				SET tr = v_tran_no
				WHERE
				DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
			END IF;

			IF NEW.grand_total > NEW.paid THEN

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES-RETURN',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * (NEW.grand_total - NEW.paid),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_receivable;
					
			END IF;
			
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
			) SELECT
				'SALES-RETURN',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.total+NEW.product_discount),
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,

				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_sale;
			
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * NEW.total_cost,
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_cost
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_cost;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.total_cost),
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;


			IF NEW.total_discount THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES-RETURN',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * NEW.total_discount,
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_sale_discount
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_discount;
			END IF;

			IF NEW.total_tax THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES-RETURN',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					abs(NEW.total_tax),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;
			END IF;

			IF NEW.shipping THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES-RETURN',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					abs(NEW.shipping),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_sale_freight
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_freight;
			END IF;
	
		END IF;

		IF NEW.sale_status="completed" AND NEW.total > 0 AND NEW.updated_by>0  AND NEW.return_id IS NULL THEN

			SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='SALES' AND reference_no = NEW.reference_no LIMIT 0,1);

			IF v_tran_no < 1  THEN
				SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);	                
				UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
			END IF;

			DELETE FROM erp_gl_trans WHERE tran_type='SALES' AND bank=0 AND reference_no = NEW.reference_no;

			IF NEW.grand_total > NEW.paid THEN

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(NEW.grand_total - NEW.paid),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_receivable;
					
			END IF;
			
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
			) SELECT
				'SALES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * abs(NEW.total+NEW.product_discount),
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,

				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_sale;
			
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.total_cost,
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_cost
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_cost;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * abs(NEW.total_cost),
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;


			IF NEW.total_discount THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					NEW.total_discount,
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_sale_discount
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_discount;
			END IF;

			IF NEW.total_tax THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * abs(NEW.total_tax),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;
			END IF;

			IF NEW.shipping THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
					) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * abs(NEW.shipping),
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_sale_freight
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_freight;
			END IF;
	
		END IF;

	END IF;

	IF NEW.opening_ar = 2 THEN

		SET v_tran_date = (
			SELECT
				erp_sales.date
			FROM
				erp_payments
			INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
			WHERE
				erp_sales.id = NEW.id
			LIMIT 0,
			1
		);

		IF v_tran_date = NEW.date THEN

			SET v_tran_no = (
				SELECT
					MAX(tran_no)
				FROM
					erp_gl_trans
			);

		ELSE

			SET v_tran_no = (
				SELECT
					COALESCE (MAX(tran_no), 0) + 1
				FROM
					erp_gl_trans
			);

			UPDATE erp_order_ref
			SET tr = v_tran_no
			WHERE
				DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


		END IF;
		
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'SALES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(
				NEW.total + NEW.product_discount
			),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
		FROM
			erp_account_settings
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
		INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = erp_account_settings.default_open_balance;
			
        IF NEW.paid <= 0 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				   ) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.grand_total,
						NEW.reference_no,
						NEW.customer,
						NEW.biller_id,
						NEW.created_by,
						NEW.updated_by
					FROM
					erp_account_settings
					   INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
					   INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					   WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_receivable;
		END IF;
		
	END IF;

END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_sale_delete`;
DELIMITER ;;
CREATE TRIGGER `gl_trans_sale_delete` AFTER DELETE ON `erp_sales` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `sale_items_audit_copy`;
DELIMITER ;;
CREATE TRIGGER `sale_items_audit_copy` BEFORE UPDATE ON `erp_sale_order_items` FOR EACH ROW BEGIN
	INSERT INTO erp_sale_items_audit (
		id,
		sale_id,
		product_id,
		product_code,
		product_name,
		product_type,
		option_id,
		net_unit_price,
		unit_price,
		quantity,
		warehouse_id,
		item_tax,
		tax_rate_id,
		tax,
		discount,
		item_discount,
		subtotal,
		serial_no,
		real_unit_price,
		product_noted
	) SELECT
		id,
		sale_id,
		product_id,
		product_code,
		product_name,
		product_type,
		option_id,
		net_unit_price,
		unit_price,
		quantity,
		warehouse_id,
		item_tax,
		tax_rate_id,
		tax,
		discount,
		item_discount,
		subtotal,
		serial_no,
		real_unit_price,
		product_noted
	FROM
		erp_sale_items
	WHERE
		erp_sale_items.id = OLD.id;


END
;;
DELIMITER ;
