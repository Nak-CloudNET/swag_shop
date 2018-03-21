-- phpMyAdmin SQL Dump
-- version 4.3.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 18, 2016 at 01:23 AM
-- Server version: 5.5.42-37.1-log
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `iclouder_th1da`
--

-- --------------------------------------------------------

--
-- Table structure for table `erp_account_settings`
--

DROP TABLE IF EXISTS `erp_account_settings`;
CREATE TABLE IF NOT EXISTS `erp_account_settings` (
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
  `default_retained_earnings` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_account_settings`
--

INSERT INTO `erp_account_settings` (`id`, `biller_id`, `default_open_balance`, `default_sale`, `default_sale_discount`, `default_sale_tax`, `default_sale_freight`, `default_sale_deposit`, `default_receivable`, `default_purchase`, `default_purchase_discount`, `default_purchase_tax`, `default_purchase_freight`, `default_purchase_deposit`, `default_payable`, `default_stock`, `default_stock_adjust`, `default_cost`, `default_payroll`, `default_cash`, `default_credit_card`, `default_gift_card`, `default_cheque`, `default_loan`, `default_retained_earnings`) VALUES(1, 3, '300300', '410101', '410102', '201407', '410107', '201208', '100200', '100430', '500106', '100441', '500102', '100420', '201100', '100430', '500107', '500101', '201201', '100102', '100105', '201208', '100104', '100501', '');

-- --------------------------------------------------------

--
-- Table structure for table `erp_adjustments`
--

DROP TABLE IF EXISTS `erp_adjustments`;
CREATE TABLE IF NOT EXISTS `erp_adjustments` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` int(11) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `cost` decimal(19,4) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `total_cost` decimal(19,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `erp_adjustments`
--
DROP TRIGGER IF EXISTS `gl_trans_adjustment_delete`;
DELIMITER $$
CREATE TRIGGER `gl_trans_adjustment_delete` AFTER DELETE ON `erp_adjustments`
 FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE tran_type='STOCK_ADJUST' AND reference_no = OLD.id;

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_adjustment_insert`;
DELIMITER $$
CREATE TRIGGER `gl_trans_adjustment_insert` AFTER INSERT ON `erp_adjustments`
 FOR EACH ROW BEGIN

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
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_adjustment_update`;
DELIMITER $$
CREATE TRIGGER `gl_trans_adjustment_update` AFTER UPDATE ON `erp_adjustments`
 FOR EACH ROW BEGIN

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
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `erp_bom`
--

DROP TABLE IF EXISTS `erp_bom`;
CREATE TABLE IF NOT EXISTS `erp_bom` (
  `id` int(11) NOT NULL,
  `name` varchar(55) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `noted` varchar(200) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `reference_no` varchar(55) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_bom_items`
--

DROP TABLE IF EXISTS `erp_bom_items`;
CREATE TABLE IF NOT EXISTS `erp_bom_items` (
  `id` int(11) NOT NULL,
  `bom_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` decimal(25,4) NOT NULL,
  `cost` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_calendar`
--

DROP TABLE IF EXISTS `erp_calendar`;
CREATE TABLE IF NOT EXISTS `erp_calendar` (
  `start` datetime NOT NULL,
  `title` varchar(55) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `end` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `color` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_captcha`
--

DROP TABLE IF EXISTS `erp_captcha`;
CREATE TABLE IF NOT EXISTS `erp_captcha` (
  `captcha_id` bigint(13) unsigned NOT NULL,
  `captcha_time` int(10) unsigned NOT NULL,
  `ip_address` varchar(16) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `word` varchar(20) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_captcha`
--

INSERT INTO `erp_captcha` (`captcha_id`, `captcha_time`, `ip_address`, `word`) VALUES(1, 1451963466, '192.168.1.122', 'N9ocX');

-- --------------------------------------------------------

--
-- Table structure for table `erp_categories`
--

DROP TABLE IF EXISTS `erp_categories`;
CREATE TABLE IF NOT EXISTS `erp_categories` (
  `id` int(11) NOT NULL,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  `image` varchar(55) DEFAULT NULL,
  `jobs` tinyint(1) unsigned DEFAULT '1',
  `auto_delivery` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_combine_items`
--

DROP TABLE IF EXISTS `erp_combine_items`;
CREATE TABLE IF NOT EXISTS `erp_combine_items` (
  `id` bigint(20) unsigned NOT NULL,
  `sale_deliveries_id` bigint(20) NOT NULL,
  `sale_deliveries_id_combine` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_combo_items`
--

DROP TABLE IF EXISTS `erp_combo_items`;
CREATE TABLE IF NOT EXISTS `erp_combo_items` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `item_code` varchar(20) NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_companies`
--

DROP TABLE IF EXISTS `erp_companies`;
CREATE TABLE IF NOT EXISTS `erp_companies` (
  `id` int(11) NOT NULL,
  `group_id` int(10) unsigned DEFAULT NULL,
  `group_name` varchar(20) NOT NULL,
  `customer_group_id` int(11) DEFAULT NULL,
  `customer_group_name` varchar(100) DEFAULT NULL,
  `name` varchar(55) NOT NULL,
  `company` varchar(255) NOT NULL,
  `vat_no` varchar(100) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(55) NOT NULL,
  `state` varchar(55) DEFAULT NULL,
  `postal_code` varchar(8) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
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
  `district` varchar(255) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_companies`
--

INSERT INTO `erp_companies` (`id`, `group_id`, `group_name`, `customer_group_id`, `customer_group_name`, `name`, `company`, `vat_no`, `address`, `city`, `state`, `postal_code`, `country`, `phone`, `email`, `cf1`, `cf2`, `cf3`, `cf4`, `cf5`, `cf6`, `invoice_footer`, `payment_term`, `logo`, `award_points`, `deposit_amount`, `status`, `posta_card`, `gender`, `attachment`, `date_of_birth`, `start_date`, `end_date`, `credit_limited`) VALUES(1, NULL, 'biller', NULL, NULL, 'owner', 'CloudNET', '', 'Biller adddress', 'Phnom Penh', 'Kondal', '12345', 'Cambodia', '012345678', 'iclouderp@gmail.com', '', '', '', '', '1,2', '100%', ' Thank you for shopping with us. Please come again', 0, '16.png', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `erp_companies` (`id`, `group_id`, `group_name`, `customer_group_id`, `customer_group_name`, `name`, `company`, `vat_no`, `address`, `city`, `state`, `postal_code`, `country`, `phone`, `email`, `cf1`, `cf2`, `cf3`, `cf4`, `cf5`, `cf6`, `invoice_footer`, `payment_term`, `logo`, `award_points`, `deposit_amount`, `status`, `posta_card`, `gender`, `attachment`, `date_of_birth`, `start_date`, `end_date`, `credit_limited`) VALUES(2, 4, 'supplier', NULL, NULL, 'General Supplier', 'Supplier Company Name', NULL, 'Supplier Address', 'Phnom Penh', 'Kondal', '12345', 'Cambodia', '012345678', 'iclouderp@gmail.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, NULL, NULL, NULL, NULL, NULL, '1990-06-14', NULL, NULL, NULL);
INSERT INTO `erp_companies` (`id`, `group_id`, `group_name`, `customer_group_id`, `customer_group_name`, `name`, `company`, `vat_no`, `address`, `city`, `state`, `postal_code`, `country`, `phone`, `email`, `cf1`, `cf2`, `cf3`, `cf4`, `cf5`, `cf6`, `invoice_footer`, `payment_term`, `logo`, `award_points`, `deposit_amount`, `status`, `posta_card`, `gender`, `attachment`, `date_of_birth`, `start_date`, `end_date`, `credit_limited`) VALUES(3, 3, 'customer', 4, 'New Customer (+10)', 'Walk-in Customer', 'Walk-in Customer', '', 'Customer Address', 'Phnom Penh', 'Kondal', '12345', 'Cambodia', '012345678', 'iclouderp@gmail.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, '0.0000', '', NULL, '', NULL, '2016-04-27', '0000-00-00', '2016-05-10', NULL);
INSERT INTO `erp_companies` (`id`, `group_id`, `group_name`, `customer_group_id`, `customer_group_name`, `name`, `company`, `vat_no`, `address`, `city`, `state`, `postal_code`, `country`, `phone`, `email`, `cf1`, `cf2`, `cf3`, `cf4`, `cf5`, `cf6`, `invoice_footer`, `payment_term`, `logo`, `award_points`, `deposit_amount`, `status`, `posta_card`, `gender`, `attachment`, `date_of_birth`, `start_date`, `end_date`, `credit_limited`) VALUES(4, 3, 'customer', 1, 'General', 'General', 'General', '', 'All', 'Phnom Penh', 'Kondal', '', 'Cambodia', '012345678', 'iclouderp@gmail.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, '0.0000', '', NULL, '', '', '1970-01-01', '2016-05-01', '2016-06-04', NULL);
INSERT INTO `erp_companies` (`id`, `group_id`, `group_name`, `customer_group_id`, `customer_group_name`, `name`, `company`, `vat_no`, `address`, `city`, `state`, `postal_code`, `country`, `phone`, `email`, `cf1`, `cf2`, `cf3`, `cf4`, `cf5`, `cf6`, `invoice_footer`, `payment_term`, `logo`, `award_points`, `deposit_amount`, `status`, `posta_card`, `gender`, `attachment`, `date_of_birth`, `start_date`, `end_date`, `credit_limited`) VALUES(5, 3, 'customer', 2, 'Reseller', 'Reseller', 'Reseller', '', 'Monivong Blvd', 'Phnom Penh', 'Kondal', '', 'Cambodia', '012345678', 'iclouderp@gmail.com', '', '', '', '', '', '', NULL, 0, 'logo.png', 0, '0.0000', '', NULL, '', NULL, '0000-00-00', '0000-00-00', '2016-05-07', NULL);

-- --------------------------------------------------------

-- ----------------------------
-- Table structure for erp_tax_exchange_rate
-- ----------------------------
DROP TABLE IF EXISTS `erp_tax_exchange_rate`;
CREATE TABLE `erp_tax_exchange_rate` (
  `id` int(11) NOT NULL DEFAULT '0',
  `tax_type` varchar(100) DEFAULT '',
  `usd_curency` double DEFAULT NULL,
  `kh_curency` double DEFAULT '0',
  `month` varchar(10) DEFAULT NULL,
  `year` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=468 DEFAULT CHARSET=utf8;



--
-- Table structure for table `erp_condition_tax`
--

DROP TABLE IF EXISTS `erp_condition_tax`;
CREATE TABLE IF NOT EXISTS `erp_condition_tax` (
  `id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(55) NOT NULL,
  `rate` decimal(12,4) NOT NULL,
  `min_salary` double(19,0) DEFAULT NULL,
  `max_salary` double(19,0) DEFAULT NULL,
  `reduct_tax` double(19,0) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_condition_tax`
--

INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(1, 'KHM', 'RIAL', '4050.0000', NULL, NULL, 0);
INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(2, 'Allowance', 'SPOUSE', '75000.0000', NULL, NULL, 0);
INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(3, 'Allowance', 'CHILD', '75000.0000', NULL, NULL, 0);
INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(4, 'Salary', 'S1', '0.0000', 0, 800000, 0);
INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(5, 'Salary', 'S2', '5.0000', 800001, 1250000, 25000);
INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(6, 'Salary', 'S3', '10.0000', 1250001, 8500000, 87500);
INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(7, 'Salary', 'S4', '15.0000', 8500001, 12500000, 512500);
INSERT INTO `erp_condition_tax` (`id`, `code`, `name`, `rate`, `min_salary`, `max_salary`, `reduct_tax`) VALUES(8, 'Salary', 'S5', '20.0000', 12500001, 10000000000000000000, 1137500);

-- --------------------------------------------------------

--
-- Table structure for table `erp_convert`
--

DROP TABLE IF EXISTS `erp_convert`;
CREATE TABLE IF NOT EXISTS `erp_convert` (
  `id` int(11) NOT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `noted` varchar(200) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bom_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_convert_items`
--

DROP TABLE IF EXISTS `erp_convert_items`;
CREATE TABLE IF NOT EXISTS `erp_convert_items` (
  `id` int(11) NOT NULL,
  `convert_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` decimal(25,4) NOT NULL,
  `cost` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_costing`
--

DROP TABLE IF EXISTS `erp_costing`;
CREATE TABLE IF NOT EXISTS `erp_costing` (
  `id` int(11) NOT NULL,
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
  `option_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_currencies`
--

DROP TABLE IF EXISTS `erp_currencies`;
CREATE TABLE IF NOT EXISTS `erp_currencies` (
  `id` int(11) NOT NULL,
  `code` varchar(5) NOT NULL,
  `name` varchar(55) NOT NULL,
  `rate` decimal(12,4) NOT NULL,
  `auto_update` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_currencies`
--

INSERT INTO `erp_currencies` (`id`, `code`, `name`, `rate`, `auto_update`) VALUES(1, 'USD', 'US Dollar', '1.0000', 0);
INSERT INTO `erp_currencies` (`id`, `code`, `name`, `rate`, `auto_update`) VALUES(2, 'KHM', 'RIAL', '4050.0000', 0);

-- --------------------------------------------------------

--
-- Table structure for table `erp_customer_groups`
--

DROP TABLE IF EXISTS `erp_customer_groups`;
CREATE TABLE IF NOT EXISTS `erp_customer_groups` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `percent` int(11) NOT NULL,
  `makeup_cost` tinyint(3) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_customer_groups`
--

INSERT INTO `erp_customer_groups` (`id`, `name`, `percent`, `makeup_cost`) VALUES(1, 'General', 0, 0);
INSERT INTO `erp_customer_groups` (`id`, `name`, `percent`, `makeup_cost`) VALUES(2, 'Reseller', -5, 0);
INSERT INTO `erp_customer_groups` (`id`, `name`, `percent`, `makeup_cost`) VALUES(3, 'Distributor', -15, 0);
INSERT INTO `erp_customer_groups` (`id`, `name`, `percent`, `makeup_cost`) VALUES(4, 'New Customer (+10)', 10, 0);
INSERT INTO `erp_customer_groups` (`id`, `name`, `percent`, `makeup_cost`) VALUES(5, 'Makeup (+10)', 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `erp_date_format`
--

DROP TABLE IF EXISTS `erp_date_format`;
CREATE TABLE IF NOT EXISTS `erp_date_format` (
  `id` int(11) NOT NULL,
  `js` varchar(20) NOT NULL,
  `php` varchar(20) NOT NULL,
  `sql` varchar(20) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_date_format`
--

INSERT INTO `erp_date_format` (`id`, `js`, `php`, `sql`) VALUES(1, 'mm-dd-yyyy', 'm-d-Y', '%m-%d-%Y');
INSERT INTO `erp_date_format` (`id`, `js`, `php`, `sql`) VALUES(2, 'mm/dd/yyyy', 'm/d/Y', '%m/%d/%Y');
INSERT INTO `erp_date_format` (`id`, `js`, `php`, `sql`) VALUES(3, 'mm.dd.yyyy', 'm.d.Y', '%m.%d.%Y');
INSERT INTO `erp_date_format` (`id`, `js`, `php`, `sql`) VALUES(4, 'dd-mm-yyyy', 'd-m-Y', '%d-%m-%Y');
INSERT INTO `erp_date_format` (`id`, `js`, `php`, `sql`) VALUES(5, 'dd/mm/yyyy', 'd/m/Y', '%d/%m/%Y');
INSERT INTO `erp_date_format` (`id`, `js`, `php`, `sql`) VALUES(6, 'dd.mm.yyyy', 'd.m.Y', '%d.%m.%Y');

-- --------------------------------------------------------

--
-- Table structure for table `erp_deliveries`
--

DROP TABLE IF EXISTS `erp_deliveries`;
CREATE TABLE IF NOT EXISTS `erp_deliveries` (
  `id` int(11) NOT NULL,
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
  `delivery_status` varchar(20) DEFAULT NULL,
  `delivery_by` int(11) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_deposits`
--

DROP TABLE IF EXISTS `erp_deposits`;
CREATE TABLE IF NOT EXISTS `erp_deposits` (
  `id` int(11) NOT NULL,
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
  `biller_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_expenses`
--

DROP TABLE IF EXISTS `erp_expenses`;
CREATE TABLE IF NOT EXISTS `erp_expenses` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference` varchar(55) NOT NULL,
  `amount` decimal(25,4) NOT NULL,
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
  `warehouse_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `erp_expenses`
--
DROP TRIGGER IF EXISTS `gl_trans_expense_delete`;
DELIMITER $$
CREATE TRIGGER `gl_trans_expense_delete` AFTER DELETE ON `erp_expenses`
 FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_expense_insert`;
DELIMITER $$
CREATE TRIGGER `gl_trans_expense_insert` AFTER INSERT ON `erp_expenses`
 FOR EACH ROW BEGIN

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
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_expense_update`;
DELIMITER $$
CREATE TRIGGER `gl_trans_expense_update` AFTER UPDATE ON `erp_expenses`
 FOR EACH ROW BEGIN

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
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `erp_gift_cards`
--

DROP TABLE IF EXISTS `erp_gift_cards`;
CREATE TABLE IF NOT EXISTS `erp_gift_cards` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `card_no` varchar(20) NOT NULL,
  `value` decimal(25,4) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(255) DEFAULT NULL,
  `balance` decimal(25,4) NOT NULL,
  `expiry` date DEFAULT NULL,
  `created_by` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_gl_charts`
--

DROP TABLE IF EXISTS `erp_gl_charts`;
CREATE TABLE IF NOT EXISTS `erp_gl_charts` (
  `accountcode` int(11) NOT NULL DEFAULT '0',
  `accountname` varchar(200) DEFAULT '',
  `parent_acc` int(11) DEFAULT '0',
  `sectionid` int(11) DEFAULT '0',
  `account_tax_id` int(11) DEFAULT '0',
  `acc_level` int(11) DEFAULT '0',
  `lineage` varchar(500) NOT NULL,
  `bank` tinyint(1) DEFAULT NULL,
  `value` decimal(55,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_gl_charts`
--

INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100100, 'Cash', 0, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100101, 'Petty Cash', 100100, 10, 0, 0, '', 1, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100102, 'Cash on Hand', 100100, 10, 0, 0, '', 1, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100103, 'ANZ Bank', 100100, 10, 0, 0, '', 1, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100104, 'CAMPU Bank', 100100, 10, 0, 0, '', 1, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100105, 'Visa', 100100, 10, 0, 0, '', 1, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100106, 'Chequing Bank Account', 100100, 10, 0, 0, '', 1, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100200, 'Account Receivable', 0, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100400, 'Other Current Assets', 0, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100410, 'Prepaid Expense', 100400, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100420, 'Supplier Deposit', 100400, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100430, 'Inventory', 100400, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100440, 'Deferred Tax Asset', 100400, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100441, 'VAT Input', 100440, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100442, 'VAT Credit Carried Forward', 100440, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100500, 'Cash Advance', 100400, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100501, 'Loan to Related Parties', 100400, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(100502, 'Staff Advance Cash', 100400, 10, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(101005, 'Own Invest', 0, 80, 0, 0, '', 1, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110200, 'Property, Plant and Equipment', 0, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110201, 'Furniture', 110200, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110202, 'Office Equipment', 110200, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110203, 'Machineries', 110200, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110204, 'Leasehold Improvement', 110200, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110205, 'IT Equipment & Computer', 110200, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110206, 'Vehicle', 110200, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110250, 'Less Total Accumulated Depreciation', 110200, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110251, 'Less Acc. Dep. of Furniture', 110250, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110252, 'Less Acc. Dep. of Office Equipment', 110250, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110253, 'Less Acc. Dep. of Machineries', 110250, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110254, 'Less Acc. Dep. of Leasehold Improvement', 110250, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110255, 'Less Acc. Dep. of IT Equipment & Computer', 110250, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(110256, 'Less Acc. Dep of Vehicle', 110250, 11, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201100, 'Accounts Payable', 0, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201200, 'Other Current Liabilities', 0, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201201, 'Salary Payable', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201202, 'OT Payable', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201203, 'Allowance Payable', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201204, 'Bonus Payable', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201205, 'Commission Payable', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201206, 'Interest Payable', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201207, 'Loan from Related Parties', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201208, 'Customer Deposit', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201209, 'Accrued Expense', 201200, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201400, 'Deferred Tax Liabilities', 0, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201401, 'Salary Tax Payable', 201400, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201402, 'Withholding Tax Payable', 201400, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201403, 'VAT Payable', 201400, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201404, 'Profit Tax Payable', 201400, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201405, 'Prepayment Profit Tax Payable', 201400, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201406, 'Fringe Benefit Tax Payable', 201400, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(201407, 'VAT Output', 201400, 20, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(300000, 'Capital Stock', 0, 30, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(300100, 'Paid-in Capital', 300000, 30, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(300101, 'Additional Paid-in Capital', 300000, 30, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(300200, 'Retained Earnings', 0, 30, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(300300, 'Opening Balance', 0, 30, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(400000, 'Sale Revenue', 0, 40, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(410101, 'Products', 400000, 40, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(410102, 'Sale Discount', 400000, 40, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(410107, 'Other Income', 400000, 40, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(500000, 'Cost of Goods Sold', 0, 50, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(500101, 'Products', 500000, 50, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(500102, 'Freight Expense', 500000, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(500103, 'Wages & Salaries', 500000, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(500106, 'Purchase Discount', 500000, 50, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(500107, 'Inventory Adjustment', 500000, 50, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(500108, 'Cost of Variance', 500000, 50, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(600000, 'Expenses', 0, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601100, 'Staff Cost', 600000, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601101, 'Salary Expense', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601102, 'OT', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601103, 'Allowance ', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601104, 'Bonus', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601105, 'Commission', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601106, 'Training/Education', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601107, 'Compensation', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601108, 'Other Staff Relation', 601100, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601200, 'Administration Cost', 600000, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601201, 'Rental Expense', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601202, 'Utilities', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601203, 'Marketing & Advertising', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601204, 'Repair & Maintenance', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601205, 'Customer Relation', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601206, 'Transportation', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601207, 'Communication', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601208, 'Insurance Expense', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601209, 'Professional Fee', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601210, 'Depreciation Expense', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601211, 'Amortization Expense', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601212, 'Stationery', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601213, 'Office Supplies', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601214, 'Donation', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601215, 'Entertainment Expense', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601216, 'Travelling & Accomodation', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601217, 'Service Computer Expenses', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601218, 'Interest Expense', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601219, 'Bank Charge', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601220, 'Miscellaneous Expense', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601221, 'Canteen Supplies', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(601222, 'Registration Expenses', 601200, 60, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(710300, 'Other Income', 0, 70, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(710301, 'Interest Income', 710300, 70, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(710302, 'Other Revenue & Gain', 710300, 70, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(801300, 'Other Expenses', 0, 80, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(801301, 'Other Expense & Loss', 801300, 80, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(801302, 'Bad Dept Expense', 801300, 80, 0, 0, '', NULL, '0.00');
INSERT INTO `erp_gl_charts` (`accountcode`, `accountname`, `parent_acc`, `sectionid`, `account_tax_id`, `acc_level`, `lineage`, `bank`, `value`) VALUES(801303, 'Tax & Duties Expense', 801300, 80, 0, 0, '', NULL, '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `erp_gl_charts_tax`
--

DROP TABLE IF EXISTS `erp_gl_charts_tax`;
CREATE TABLE IF NOT EXISTS `erp_gl_charts_tax` (
  `account_tax_id` int(11) NOT NULL,
  `accountcode` varchar(19) DEFAULT '0',
  `accountname` varchar(200) DEFAULT '',
  `accountname_kh` varchar(250) DEFAULT '0',
  `sectionid` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `erp_gl_charts_tax`
--

INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(1, 'B1', 'Sales of manufactured products', 'ការលក់ផលិតផល', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(2, 'B2', 'Sales of goods', 'ការលក់ទំនិញ', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(3, 'B3', 'Sales/Supply of services', 'ការផ្គត់ផ្គង់សេវា', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(4, 'A2', 'Freehold Land', 'ដីធ្លីរបស់សហគ្រាស', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(5, 'A3', 'Improvements and preparation of land', 'ការរៀបចំតុបតែងលំអរដីរបស់សហគ្រាស', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(6, 'A4', 'Freehold buildings', 'សំណង់ងគាររបស់សហគ្រាស', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(7, 'B4', 'Costs of pruducts sold of production enterprises(TOP 01/V)', 'ថៃ្លដើមផលិតផលបានលក់របស់សហគ្រាសផលិតកម្ម​(TOP 01/V)', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(8, 'A5', 'Freehold buildings on leasehold land', 'សំណង់អាគារលើដីធ្លីក្រោមភតិសន្យា', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(9, 'B5', 'Costs of goods sold of​​​​ non- production enterprises (TOP 01/VI)', 'ថៃ្លដើម ទំនិញបានលក់របស់សហគ្រាសក្រៅពីផលិតកម្ម(TOP 0', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(10, 'A6', 'Non-current assets in progress', 'ទ្រព្យសកម្មរយះពេលវែងកំពុងដំណើរការ', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(11, 'A7', 'Plant and equipemt', 'រោងចក្រ​​​(ក្រៅពីអគារ)និងបរិក្ខារ', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(12, 'B5a', 'Costs of services supplied', 'ថៃ្លដើមសេវាបានផ្គត់ផ្គង់', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(13, 'A8', 'Goodwill', 'កេរ្តិ៍ឈ្មោះ/មូលនិធិពាណិជ្ជកម្ម', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(14, 'A9', 'Preliminary and formation expenses', 'ចំណាយបង្កើតសហគ្រាសដំបូង', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(15, 'B8', 'Grant/subsidy', 'ឧបត្ថម្ភកធន', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(16, 'A10', 'Leasehold assets and lease premiums', 'ទ្រព្យសកម្មក្រោមភតិសន្យា​​ និង​បុព្វលាភនៃការប្រើប្', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(17, 'A11', 'Investment in other enterprise', 'វិនិយោគក្នុងសហគ្រាសដទៃ', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(18, 'B9', 'Dividend received or receivable', 'ចំណូលពីភាគលាភបានទទួល​ ឬ ត្រូវទទួល', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(19, 'B10', 'Interest received or receivable', 'ចំំណូលពីការប្រាក់បានទទួល ឬ ត្រូវទទួល', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(20, 'A29', 'Capital/ Share capital', 'មូលធន/ មូលធនភាគហ៊ុន', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(21, 'A12', 'Other non-current assets', 'ទ្រព្យសកម្មរយ:ពេលវែងផ្សេងៗ', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(22, 'B11', 'Royalty received or receivable', 'ចំណូលពីសួយសារបានទទួល ឬ ត្រូវទទួល', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(23, 'A30', 'Share premium', 'តម្លៃលើសនៃការលក់ប័ណ្ណភាគហ៊ុន', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(24, 'B12', 'Rental received or receivable', 'ចំណូលពីការជួលបានទទួល ឬ ត្រូវទទួល', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(25, 'A31', 'Legal capital reserves', 'មូលធនបំរុងច្បាប់', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(26, 'A14', 'Stock of raw materials and supplies', 'ស្តូកវត្ធុធាតុដើម និងសំភារ:ផ្គត់ផ្គង់', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(27, 'A32', 'Reserves revaluation surplus of assets', 'លំអៀងលើសការវាយតំលៃឡើងវិញនូវទ្រព្យសកម្ម', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(28, 'A33', 'Other capital reserves', 'មូលធនបំរុងផ្សេងៗ', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(29, 'A15', 'Stock of goods', 'ស្តុកទំនិញ', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(30, 'B13', 'Gain from disposal of fixed assets (captital gain)', 'ផលចំណេញ/តំលៃលើសពីការលក់ទ្រព្យសកម្មរយះពេលវែង', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(31, 'A34', 'Profit and loss brought forward', 'លទ្ធផលចំណេញ/ ខាត យោងពីមុន', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(32, 'A16', 'Stock of finished goods', 'ស្តុកផលិតផលសម្រាច', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(33, 'A35', 'Profit and loss for the period', 'លទ្ធផងចំណេញ/ ខាត នៃកាលបរិច្ឆេត', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(34, 'B14', 'Gain from disposal of securities', 'ផលចំណេញពីការលក់មូលប័ត្រ/សញ្ញាប័ណ្ណ', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(35, 'A37', 'Loan from related parties', 'បំណុលភាគីជាប់ទាក់ទិន', 21);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(36, 'A38', 'Loan from banks and other external parties', 'បំណុលធនាគារ និងបំណុលភាគីមិនជាប់ទាក់ទិនផ្សេងៗ', 21);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(37, 'B15', 'Share of profit from joint venture', 'ភាគចំណេញពីប្រតិបត្តិការរួមគ្នា', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(38, 'A17', 'Products in progress', 'ផលិតផលកំពុងផលិត', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(39, 'A39', 'Provision for charges and contigencies', 'សវិធានធនសំរាប់បន្ទុក និង​ហានិភ័យ', 21);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(40, 'B16', 'Realised exchange gain', 'ផលចំណេញពីការប្តូរប្រាក់សំរេចបាន', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(41, 'A40', 'Other non-current liabilities', 'បំណុលរយៈពេលវែងផ្សេងៗ', 21);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(42, 'A18', 'Account receivevable/trade debtors', 'គណនីត្រូវទទួល​ /អតិថិជន', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(43, 'B17', 'Unrealised exchange gain', 'ផលចំណេញពីការប្តូរប្រាក់មិនទាន់សំរេចបាន', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(44, 'A42', 'Bank overdraft', 'សាច់ប្រាក់ដកពីធនាគារលើសប្រាក់បញ្ជី (ឥណទានរិបារូប៍រ', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(45, 'A19', 'Other account receivables', 'គណនីទទួលផ្សេងៗ', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(46, 'B18', 'Other revenues', 'ចំណូលដ៏ទៃទៀត', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(47, 'A43', 'Short-term borrowing-current portion of interest bearing borrowing', 'ចំណែកចរន្តនៃបំណុលមានការប្រាក់', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(48, 'A20', 'Prepaid expenses', 'ចំណាយបានកត់ត្រាមុន', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(49, 'B20', 'Salaries expenses', 'ចំណាយបៀវត្ស', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(50, 'A44', 'Accounts payble to relate parties', 'គណនីត្រូវសងបុគ្គលជាប់ទាក់ទិន (ភាគីសម្ព័ន្ធញាត្តិ)', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(51, 'A45', 'Other accounts payable', 'គណនីត្រូវសងផ្សេងៗ', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(52, 'A21', 'Cash on hand and at banks', 'សាច់ប្រាក់នៅក្នុងបេឡា និងនៅធនាគា', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(53, 'B21', 'Fuel, gas,electricity and water expenses', 'ចំណាយប្រេង ឧស្មន័ អគ្គីសនី និងទឹក', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(54, 'A46', 'Unearned revenue, accruals and other current liabilities', 'ចំណូលកត់មុន គណនីចំណាយបង្ករ និងបំណុលរយោៈពេលខ្លីផ្សេ', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(55, 'A47', 'Provision for changes and contigencies', 'សវិធានធនសំរាប់បន្ទុក និង​ហានិភ័យ', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(56, 'B22', 'Travelling and accommodation expenses', 'ចំណាយធើ្វដំណើរ និងចំណាយស្នាក់នៅ', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(57, 'A48', 'Profit tax payable', 'ពន្ធលើប្រាក់ចំណេញត្រូវបង់', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(58, 'A49', 'Other taxes payable', 'ពន្ទ-អាករផ្សេងៗត្រូវបង់', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(59, 'B23', 'Transporttation expenses', 'ចំណាយដឹកជញ្ជូន', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(60, 'A50', 'Differences arissing from currency translation in liabilities', 'លំអៀងពីការប្តូរប្រាក់នៃទ្រព្យសកម្ម', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(61, 'B24', 'Rental expenses', 'ចំណាយលើការជួល', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(62, 'B25', 'Repair anmaintenance expenses', 'ចំណាយលើការថែទាំ និងជួសជុល', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(63, 'B26', 'Entertament expenses', 'ចំណាយលើការកំសាន្តសប្យាយ', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(64, 'A22', 'Prepayment of profit tax credit', 'ឥណទានប្រាក់រំដោះពន្ធលើប្រាក់ចំណេញ', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(65, 'B27', 'Commission, advertising, and selling expenses', 'ចំណាយកំរៃជើងសារ ផ្សាយពាណិ្ជកម្ម និងចំណាយការលក់', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(66, 'A23', 'Value added tax credit', 'ឥណទានអាករលើតម្លៃបន្ថែម', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(67, 'B28', 'Other taxes expenses', 'ចំណាយបង់ពន្ធ និងអាករផេ្សងៗ', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(68, 'B29', 'Donation expenses', 'ចំណាយលើអំណោយ', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(69, 'A24', 'Other taxes credit', 'ឥណទានពន្ធ-អាករដដៃទៀត', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(70, 'B30', 'Management, consultant, other technical, and other similar services expenses', 'ចំណាយសេវាគ្រប់គ្រង ពិគ្រោះយោបល់ បចេ្វកទេស និងសេវាប', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(71, 'A25', 'Other current assets', 'ទ្រព្យសកម្មពេលខ្លីផ្សេងៗ', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(72, 'B31', 'Royalty expenses', 'ចំណាយលើសួយសារ', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(73, 'B32', 'Bad debts written off expenses', 'ចំណាយលើបំណុលទារមិនបាន', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(74, 'A26', 'Diffference arising from currency translation in assets', 'លំអៀងពីការប្តូរទ្រព្យសកម្ម', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(75, 'B33', 'Armortisation/depletion and depreciation expenses', 'ចំណាយរំលស់', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(76, 'B34', 'Increase /(decrease) in expenses', 'ការកើនឡើង /​ (ថយចុះ) សំវិធានធន', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(77, 'B35', 'Loss on siposal of fixed assets', 'ខាតពីការលក់ទ្រព្យសកម្មរយះពេលវែង', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(78, 'B36', 'Realised exchange loss', 'ខាតពីការប្តូរប្រាក់សំរេចបាន', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(79, 'B37', 'Unrealised exchange loss', 'ខាតពីការប្តូរប្រាក់មិនទាន់សំរេចបាន', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(80, 'B38', 'Other expenses', 'ចំណាយផេ្សងៗ', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(81, 'B40', 'Interest expenses paid to residents', 'ចំណាយការប្រាក់បង់អោយនិវាសនជន', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(82, 'B41', 'Interest expenses paid to non-residents', 'ចំណាយការប្រាក់បង់អោយអនិវាសនជន', 60);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(83, 'A1', 'Non-current assets/ fixed assets', 'ទ្រព្យសកម្មរយៈពេលេវែង', 10);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(84, 'A13', 'Current assets', 'ទ្រព្យសកម្មរយៈពេលខ្លី', 11);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(85, 'A28', 'Equity', 'មូលនិធិ/ ទុនម្ចាស់ទ្រព្យ ', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(86, 'A36', 'Non-current liabilities', 'បំណុលរយៈពេលវែង', 21);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(87, 'A41', 'Current liabilities', 'បំណុលរយៈពេលខ្លី', 20);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(88, 'B0', 'Operating revenue', 'ចំណូលប្រតិបត្តិការ', 30);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(89, 'B7', 'Other revenue', 'ចំណូលផ្សេងៗ', 70);
INSERT INTO `erp_gl_charts_tax` (`account_tax_id`, `accountcode`, `accountname`, `accountname_kh`, `sectionid`) VALUES(90, 'B19', 'Operating expenses', 'ចំណាយប្រតិបតិ្តការ', 60);

-- --------------------------------------------------------

--
-- Table structure for table `erp_gl_sections`
--

DROP TABLE IF EXISTS `erp_gl_sections`;
CREATE TABLE IF NOT EXISTS `erp_gl_sections` (
  `sectionid` int(11) NOT NULL DEFAULT '0',
  `sectionname` text,
  `sectionname_kh` text,
  `AccountType` char(2) DEFAULT NULL,
  `description` text,
  `pandl` int(11) DEFAULT '0',
  `order_stat` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_gl_sections`
--

INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(10, 'CURRENT ASSETS', 'ទ្រព្យសកម្មរយះពេលខ្លី', 'AS', 'CURRENT ASSETS', 0, 10);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(11, 'FIXED ASSETS', 'ទ្រព្យសកម្មរយះពេលវែង', 'AS', 'FIXED ASSETS', 0, 11);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(20, 'CURRENT LIABILITIES', 'បំណុលរយះពេលខ្លី', 'LI', 'CURRENT LIABILITIES', 0, 20);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(21, 'NON-CURRENT LIABILITIES', 'បំណុលរយះពេលវែង', 'LI', 'NON-CURRENT LIABILITIES', 0, 21);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(30, 'EQUITY AND RETAINED EARNING', 'មូលនិធិ/ទុនម្ចាស់ទ្រព្យ', 'EQ', 'EQUITY AND RETAINED EARNING', 0, 30);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(40, 'INCOME', 'ចំណូលប្រតិបត្តិការ', 'RE', 'INCOME', 1, 40);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(50, 'COST OF GOODS SOLD', NULL, 'CO', 'COST OF GOODS SOLD', 1, 50);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(60, 'OPERATING EXPENSES', 'ចំណាយប្រតិបត្តិការ', 'EX', 'OPERATING EXPENSES', 1, 60);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(70, 'OTHER INCOME', 'ចំណូលផ្សេងៗ', 'OI', 'OTHER INCOME', 1, 70);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(80, 'OTHER EXPENSE', NULL, 'OX', 'OTHER EXPENSE', 1, 80);
INSERT INTO `erp_gl_sections` (`sectionid`, `sectionname`, `sectionname_kh`, `AccountType`, `description`, `pandl`, `order_stat`) VALUES(90, 'GAIN & LOSS', NULL, 'GL', 'GAIN & LOSS', 1, 90);

-- --------------------------------------------------------

--
-- Table structure for table `erp_gl_trans`
--

DROP TABLE IF EXISTS `erp_gl_trans`;
CREATE TABLE IF NOT EXISTS `erp_gl_trans` (
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
  `biller_id` int(11) DEFAULT '0',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bank` tinyint(3) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_groups`
--

DROP TABLE IF EXISTS `erp_groups`;
CREATE TABLE IF NOT EXISTS `erp_groups` (
  `id` mediumint(8) unsigned NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` varchar(100) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_groups`
--

INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(1, 'owner', 'Owner');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(2, 'admin', 'Administrator');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(3, 'customer', 'Customer');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(4, 'supplier', 'Supplier');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(5, 'sales', 'Saller');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(6, 'stock', 'Stock Manager');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(7, 'manager', 'Manager');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(10, 'visitor', 'Visitor');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(11, 'cashier', 'Cashier');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(12, 'member', 'Member card');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(13, 'computer', 'computer user');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(14, 'photomaker', 'photomaker');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(15, 'decor', 'decor');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(16, 'photographer', 'photographer');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(17, 'photocreater', 'photocreater');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(18, 'accounting', 'Accoiunting');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(19, 'aaaa', 'aaaa');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(20, 'stock', 'Stock');
INSERT INTO `erp_groups` (`id`, `name`, `description`) VALUES(21, 'ddd', 'dddd');

-- --------------------------------------------------------

--
-- Table structure for table `erp_loans`
--

DROP TABLE IF EXISTS `erp_loans`;
CREATE TABLE IF NOT EXISTS `erp_loans` (
  `id` int(11) NOT NULL,
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
  `updated_by` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `erp_loans`
--
DROP TRIGGER IF EXISTS `gl_trans_loan_delete`;
DELIMITER $$
CREATE TRIGGER `gl_trans_loan_delete` AFTER DELETE ON `erp_loans`
 FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `erp_login_attempts`
--

DROP TABLE IF EXISTS `erp_login_attempts`;
CREATE TABLE IF NOT EXISTS `erp_login_attempts` (
  `id` mediumint(8) unsigned NOT NULL,
  `ip_address` varbinary(16) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_marchine`
--

DROP TABLE IF EXISTS `erp_marchine`;
CREATE TABLE IF NOT EXISTS `erp_marchine` (
  `id` mediumint(8) unsigned NOT NULL,
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
  `150` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_marchine`
--

INSERT INTO `erp_marchine` (`id`, `name`, `description`, `type`, `biller_id`, `status`, `13`, `15`, `25`, `30`, `50`, `60`, `76`, `80`, `100`, `120`, `150`) VALUES(1, 'AAA', 'Test', 'Marchine Print', 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_marchine` (`id`, `name`, `description`, `type`, `biller_id`, `status`, `13`, `15`, `25`, `30`, `50`, `60`, `76`, `80`, `100`, `120`, `150`) VALUES(2, 'AAB', 'wwe', 'Marchine Copy', 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_marchine` (`id`, `name`, `description`, `type`, `biller_id`, `status`, `13`, `15`, `25`, `30`, `50`, `60`, `76`, `80`, `100`, `120`, `150`) VALUES(3, 'ABB', '123', 'Marchine Copy', 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `erp_marchine_logs`
--

DROP TABLE IF EXISTS `erp_marchine_logs`;
CREATE TABLE IF NOT EXISTS `erp_marchine_logs` (
  `id` mediumint(8) unsigned NOT NULL,
  `marchine_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `old_number` int(11) DEFAULT NULL,
  `new_number` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_migrations`
--

DROP TABLE IF EXISTS `erp_migrations`;
CREATE TABLE IF NOT EXISTS `erp_migrations` (
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_migrations`
--

INSERT INTO `erp_migrations` (`version`) VALUES(312);

-- --------------------------------------------------------

--
-- Table structure for table `erp_notifications`
--

DROP TABLE IF EXISTS `erp_notifications`;
CREATE TABLE IF NOT EXISTS `erp_notifications` (
  `id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `from_date` datetime DEFAULT NULL,
  `till_date` datetime DEFAULT NULL,
  `scope` tinyint(1) NOT NULL DEFAULT '3'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_notifications`
--

INSERT INTO `erp_notifications` (`id`, `comment`, `date`, `from_date`, `till_date`, `scope`) VALUES(1, '<p>Thank you for using iCloudERP - POS. If you find any error/bug, please email to support@cloudnet.com.kh with details. You can send us your valued suggestions/feedback too.</p>', '2014-08-15 12:00:57', '2015-01-01 00:00:00', '2017-01-01 00:00:00', 3);

-- --------------------------------------------------------

--
-- Table structure for table `erp_order_ref`
--

DROP TABLE IF EXISTS `erp_order_ref`;
CREATE TABLE IF NOT EXISTS `erp_order_ref` (
  `ref_id` int(11) NOT NULL,
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
  `pj` int(11) NOT NULL DEFAULT '1' COMMENT 'prouduct job'
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_order_ref`
--

INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(1, 3, '2016-02-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(2, 3, '2016-03-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(3, 3, '2016-04-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(4, 3, '2016-05-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(5, 3, '2016-06-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(6, 3, '2016-07-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(7, 3, '2016-08-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(8, 3, '2016-09-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(9, 3, '2016-10-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(10, 3, '2016-11-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(11, 3, '2016-12-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(12, 3, '2017-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(13, 3, '2017-02-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(14, 3, '2017-03-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(15, 3, '2017-04-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(16, 3, '2017-05-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(17, 3, '2017-06-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(18, 3, '2017-07-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(19, 3, '2017-08-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(21, 3, '2017-09-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(22, 3, '2017-10-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(23, 3, '2017-11-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(24, 3, '2017-12-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(25, 3, '2018-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(26, 3, '2018-02-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(27, 3, '2018-03-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(28, 3, '2018-04-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(29, 3, '2018-05-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(30, 3, '2018-06-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(31, 3, '2018-07-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(32, 3, '2018-08-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `erp_order_ref` (`ref_id`, `biller_id`, `date`, `so`, `qu`, `po`, `to`, `pos`, `do`, `pay`, `re`, `ex`, `sp`, `pp`, `sl`, `tr`, `rep`, `con`, `pj`) VALUES(33, 3, '2018-09-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `erp_pack_lists`
--

DROP TABLE IF EXISTS `erp_pack_lists`;
CREATE TABLE IF NOT EXISTS `erp_pack_lists` (
  `id` int(11) NOT NULL,
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
  `cf10` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_payments`
--

DROP TABLE IF EXISTS `erp_payments`;
CREATE TABLE IF NOT EXISTS `erp_payments` (
  `id` int(11) NOT NULL,
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
  `extra_paid` decimal(25,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `erp_payments`
--
DROP TRIGGER IF EXISTS `gl_trans_payment_insert`;
DELIMITER $$
CREATE TRIGGER `gl_trans_payment_insert` AFTER INSERT ON `erp_payments`
 FOR EACH ROW BEGIN

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
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_payment_update`;
DELIMITER $$
CREATE TRIGGER `gl_trans_payment_update` AFTER UPDATE ON `erp_payments`
 FOR EACH ROW BEGIN

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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `erp_paypal`
--

DROP TABLE IF EXISTS `erp_paypal`;
CREATE TABLE IF NOT EXISTS `erp_paypal` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL,
  `paypal_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '2.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '3.9000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '4.4000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_paypal`
--

INSERT INTO `erp_paypal` (`id`, `active`, `account_email`, `paypal_currency`, `fixed_charges`, `extra_charges_my`, `extra_charges_other`) VALUES(1, 0, 'mypaypal@paypal.com', 'USD', '0.0000', '0.0000', '0.0000');

-- --------------------------------------------------------

--
-- Table structure for table `erp_permissions`
--

DROP TABLE IF EXISTS `erp_permissions`;
CREATE TABLE IF NOT EXISTS `erp_permissions` (
  `id` int(11) NOT NULL,
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
  `quotes-pdf` tinyint(1) DEFAULT '0',
  `quotes-email` tinyint(1) DEFAULT '0',
  `quotes-import` tinyint(1) DEFAULT '0',
  `quotes-export` tinyint(1) DEFAULT '0',
  `quotes-delete` tinyint(1) DEFAULT '0',
  `sales-index` tinyint(1) DEFAULT '0',
  `sales-add` tinyint(1) DEFAULT '0',
  `sales-edit` tinyint(1) DEFAULT '0',
  `sales-pdf` tinyint(1) DEFAULT '0',
  `sales-email` tinyint(1) DEFAULT '0',
  `sales-import` tinyint(1) DEFAULT '0',
  `sales-export` tinyint(1) DEFAULT '0',
  `sales-delete` tinyint(1) DEFAULT '0',
  `purchases-index` tinyint(1) DEFAULT '0',
  `purchases-add` tinyint(1) DEFAULT '0',
  `purchases-edit` tinyint(1) DEFAULT '0',
  `purchases-pdf` tinyint(1) DEFAULT '0',
  `purchases-email` tinyint(1) DEFAULT '0',
  `purchases-import` tinyint(1) DEFAULT '0',
  `purchases-export` tinyint(1) DEFAULT '0',
  `purchases-delete` tinyint(1) DEFAULT '0',
  `transfers-index` tinyint(1) DEFAULT '0',
  `transfers-add` tinyint(1) DEFAULT '0',
  `transfers-edit` tinyint(1) DEFAULT '0',
  `transfers-pdf` tinyint(1) DEFAULT '0',
  `transfers-email` tinyint(1) DEFAULT '0',
  `transfers-export` tinyint(1) DEFAULT '0',
  `transfers-import` tinyint(1) DEFAULT '0',
  `transfers-delete` tinyint(1) DEFAULT '0',
  `customers-index` tinyint(1) DEFAULT '0',
  `customers-add` tinyint(1) DEFAULT '0',
  `customers-edit` tinyint(1) DEFAULT '0',
  `customers-delete` tinyint(1) DEFAULT '0',
  `customers-import` tinyint(1) DEFAULT '0',
  `customers-export` tinyint(1) DEFAULT '0',
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
  `sales-email_delivery` tinyint(1) DEFAULT '0',
  `sales-pdf_delivery` tinyint(1) DEFAULT '0',
  `sales-gift_cards` tinyint(1) DEFAULT '0',
  `sales-add_gift_card` tinyint(1) DEFAULT '0',
  `sales-edit_gift_card` tinyint(1) DEFAULT '0',
  `sales-delete_gift_card` tinyint(1) DEFAULT '0',
  `sales-export_gift_card` tinyint(1) DEFAULT '0',
  `sales-import_gift_card` tinyint(1) DEFAULT '0',
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
  `accounts-export` tinyint(1) DEFAULT '0',
  `accounts-import` tinyint(1) DEFAULT '0',
  `sales-loan` tinyint(1) DEFAULT '0',
  `reports-daily_purchases` tinyint(1) DEFAULT '0',
  `reports-monthly_purchases` tinyint(1) DEFAULT '0',
  `overview-chart` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_permissions`
--

INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `products-import`, `products-export`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `quotes-import`, `quotes-export`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `sales-import`, `sales-export`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `purchases-import`, `purchases-export`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `transfers-import`, `transfers-export`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `customers-import`, `customers-export`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `suppliers-import`, `suppliers-export`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-import_delivery`, `sales-export_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `sales-import_gift_card`, `sales-export_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `accounts-import`, `accounts-export`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, NULL, NULL, NULL, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(2, 6, 1, NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(3, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(4, 8, 1, 1, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(5, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(6, 10, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(7, 11, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(8, 11, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(9, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, NULL, 1, 1, 1, 1, NULL, NULL, 1, 1, 1, 1, NULL, NULL, 1, 1, 1, 1, NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, NULL, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, NULL, NULL, NULL, 1, 1, 1, 1, 1, NULL, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(10, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(11, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(12, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(13, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(14, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(15, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(16, 19, 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(17, 19, 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(18, 20, 1, 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0);
INSERT INTO `erp_permissions` (`id`, `group_id`, `products-index`, `products-add`, `products-edit`, `products-delete`, `products-cost`, `products-price`, `quotes-index`, `quotes-add`, `quotes-edit`, `quotes-pdf`, `quotes-email`, `quotes-delete`, `sales-index`, `sales-add`, `sales-edit`, `sales-pdf`, `sales-email`, `sales-delete`, `purchases-index`, `purchases-add`, `purchases-edit`, `purchases-pdf`, `purchases-email`, `purchases-delete`, `transfers-index`, `transfers-add`, `transfers-edit`, `transfers-pdf`, `transfers-email`, `transfers-delete`, `customers-index`, `customers-add`, `customers-edit`, `customers-delete`, `suppliers-index`, `suppliers-add`, `suppliers-edit`, `suppliers-delete`, `sales-deliveries`, `sales-add_delivery`, `sales-edit_delivery`, `sales-delete_delivery`, `sales-email_delivery`, `sales-pdf_delivery`, `sales-gift_cards`, `sales-add_gift_card`, `sales-edit_gift_card`, `sales-delete_gift_card`, `pos-index`, `sales-return_sales`, `reports-index`, `reports-warehouse_stock`, `reports-quantity_alerts`, `reports-expiry_alerts`, `reports-products`, `reports-daily_sales`, `reports-monthly_sales`, `reports-sales`, `reports-payments`, `reports-purchases`, `reports-profit_loss`, `reports-customers`, `reports-suppliers`, `reports-staff`, `reports-register`, `reports-account`, `sales-payments`, `purchases-payments`, `purchases-expenses`, `bulk_actions`, `customers-deposits`, `customers-delete_deposit`, `products-adjustments`, `accounts-index`, `accounts-add`, `accounts-edit`, `accounts-delete`, `sales-loan`, `reports-daily_purchases`, `reports-monthly_purchases`) VALUES(19, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `erp_pos_register`
--

DROP TABLE IF EXISTS `erp_pos_register`;
CREATE TABLE IF NOT EXISTS `erp_pos_register` (
  `id` int(11) NOT NULL,
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
  `closed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_pos_settings`
--

DROP TABLE IF EXISTS `erp_pos_settings`;
CREATE TABLE IF NOT EXISTS `erp_pos_settings` (
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
  `auto_delivery` tinyint(1) unsigned DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_pos_settings`
--

INSERT INTO `erp_pos_settings` (`pos_id`, `cat_limit`, `pro_limit`, `default_category`, `default_customer`, `default_biller`, `display_time`, `cf_title1`, `cf_title2`, `cf_value1`, `cf_value2`, `receipt_printer`, `cash_drawer_codes`, `focus_add_item`, `add_manual_product`, `customer_selection`, `add_customer`, `toggle_category_slider`, `toggle_subcategory_slider`, `show_search_item`, `product_unit`, `cancel_sale`, `suspend_sale`, `print_items_list`, `finalize_sale`, `today_sale`, `open_hold_bills`, `close_register`, `keyboard`, `pos_printers`, `java_applet`, `product_button_color`, `tooltips`, `paypal_pro`, `stripe`, `rounding`, `char_per_line`, `pin_code`, `purchase_code`, `envato_username`, `version`, `show_item_img`, `pos_layout`, `display_qrcode`, `show_suspend_bar`, `show_payment_noted`, `payment_balance`, `authorize`, `show_product_code`, `auto_delivery`) VALUES(1, 22, 20, 6, 4, 3, '1', 'GST Reg', 'VAT Reg', '123456789', '987654321', 'BIXOLON SRP-350II', 'x1C', 'Ctrl+F3', 'Ctrl+Shift+M', 'Ctrl+Shift+C', 'Ctrl+Shift+A', 'Ctrl+F11', 'Ctrl+F12', 'F1', 'F2', 'F4', 'F7', 'F9', 'F8', 'Ctrl+F1', 'Ctrl+F2', 'Ctrl+F10', 0, 'BIXOLON SRP-350II, BIXOLON SRP-350II', 0, 'warning', 0, 0, 0, 0, 42, NULL, 'purchase_code', 'envato_username', '3.0.1.21', 1, 0, 0, 30, 1, 1, 0, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `erp_products`
--

DROP TABLE IF EXISTS `erp_products`;
CREATE TABLE IF NOT EXISTS `erp_products` (
  `id` int(11) NOT NULL,
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
  `inactived` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_product_photos`
--

DROP TABLE IF EXISTS `erp_product_photos`;
CREATE TABLE IF NOT EXISTS `erp_product_photos` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `photo` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_product_variants`
--

DROP TABLE IF EXISTS `erp_product_variants`;
CREATE TABLE IF NOT EXISTS `erp_product_variants` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `name` varchar(55) NOT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  `price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `qty_unit` decimal(15,4) DEFAULT NULL,
  `currentcy_code` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_purchases`
--

DROP TABLE IF EXISTS `erp_purchases`;
CREATE TABLE IF NOT EXISTS `erp_purchases` (
  `id` int(11) NOT NULL,
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
  `tax_status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `erp_purchases`
--
DROP TRIGGER IF EXISTS `gl_trans_purchase_delete`;
DELIMITER $$
CREATE TRIGGER `gl_trans_purchase_delete` AFTER DELETE ON `erp_purchases`
 FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_purchase_insert`;
DELIMITER $$
CREATE TRIGGER `gl_trans_purchase_insert` AFTER INSERT ON `erp_purchases`
 FOR EACH ROW BEGIN
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
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_purchase_update`;
DELIMITER $$
CREATE TRIGGER `gl_trans_purchase_update` AFTER UPDATE ON `erp_purchases`
 FOR EACH ROW BEGIN
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
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `erp_purchase_items`
--

DROP TABLE IF EXISTS `erp_purchase_items`;
CREATE TABLE IF NOT EXISTS `erp_purchase_items` (
  `id` int(11) NOT NULL,
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
  `supplier_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_quotes`
--

DROP TABLE IF EXISTS `erp_quotes`;
CREATE TABLE IF NOT EXISTS `erp_quotes` (
  `id` int(11) NOT NULL,
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
  `supplier` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_quote_items`
--

DROP TABLE IF EXISTS `erp_quote_items`;
CREATE TABLE IF NOT EXISTS `erp_quote_items` (
  `id` int(11) NOT NULL,
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
  `real_unit_price` decimal(25,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_return_items`
--

DROP TABLE IF EXISTS `erp_return_items`;
CREATE TABLE IF NOT EXISTS `erp_return_items` (
  `id` int(11) NOT NULL,
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
  `real_unit_price` decimal(25,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_return_purchases`
--

DROP TABLE IF EXISTS `erp_return_purchases`;
CREATE TABLE IF NOT EXISTS `erp_return_purchases` (
  `id` int(11) NOT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
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
  `attachment` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_return_purchase_items`
--

DROP TABLE IF EXISTS `erp_return_purchase_items`;
CREATE TABLE IF NOT EXISTS `erp_return_purchase_items` (
  `id` int(11) NOT NULL,
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
  `real_unit_cost` decimal(25,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_return_sales`
--

DROP TABLE IF EXISTS `erp_return_sales`;
CREATE TABLE IF NOT EXISTS `erp_return_sales` (
  `id` int(11) NOT NULL,
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
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_sales`
--

DROP TABLE IF EXISTS `erp_sales`;
CREATE TABLE IF NOT EXISTS `erp_sales` (
  `id` int(11) NOT NULL,
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
  `suspend_note` varchar(20) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) NOT NULL,
  `other_cur_paid_rate` decimal(25,0) NOT NULL DEFAULT '0',
  `other_cur_paid1` decimal(25, 4) NOT NULL DEFAULT '0',
  `other_cur_paid_rate1` decimal (25, 4) NOT NULL DEFAULT '0',
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) NOT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `erp_sales`
--
DROP TRIGGER IF EXISTS `gl_trans_sale_delete`;
DELIMITER $$
CREATE TRIGGER `gl_trans_sale_delete` AFTER DELETE ON `erp_sales`
 FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_sale_insert`;
DELIMITER $$
CREATE TRIGGER `gl_trans_sale_insert` AFTER INSERT ON `erp_sales`
 FOR EACH ROW BEGIN

DECLARE v_tran_no INTEGER;


DECLARE v_tran_date DATETIME;

IF NEW.sale_status = "completed"
AND NEW.total > 0 THEN

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


END
IF;

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


END
IF;


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


END
IF;

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


END
IF;

END
IF;

END
IF;


END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gl_trans_sale_update`;
DELIMITER $$
CREATE TRIGGER `gl_trans_sale_update` AFTER UPDATE ON `erp_sales`
 FOR EACH ROW BEGIN
DECLARE v_tran_no INTEGER;
DECLARE v_tran_date DATETIME;

IF NEW.sale_status="returned"  AND  NEW.return_id > 0 THEN
/*

	SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);	
	UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m'); 
*/

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
			(-1) * NEW.grand_total,
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
			NEW.grand_total,
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


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `erp_sale_dev_items`
--

DROP TABLE IF EXISTS `erp_sale_dev_items`;
CREATE TABLE IF NOT EXISTS `erp_sale_dev_items` (
  `id` int(11) NOT NULL,
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
  `cf3` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_sale_items`
--

DROP TABLE IF EXISTS `erp_sale_items`;
CREATE TABLE IF NOT EXISTS `erp_sale_items` (
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
  `product_noted` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_sale_tax`
--

DROP TABLE IF EXISTS `erp_sale_tax`;
CREATE TABLE IF NOT EXISTS `erp_sale_tax` (
  `vat_id` int(11) NOT NULL,
  `sale_id` varchar(100) DEFAULT '',
  `customer_id` varchar(100) DEFAULT '',
  `group_id` varchar(100) DEFAULT '',
  `issuedate` datetime DEFAULT NULL,
  `amound_tax` double DEFAULT '0',
  `amound_declare` double DEFAULT NULL,
  `vatin` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `qty` double(8,4) DEFAULT NULL,
  `non_tax_sale` double(8,4) DEFAULT NULL,
  `value_export` double(8,4) DEFAULT NULL,
  `tax_value` double(8,4) DEFAULT NULL,
  `vat` double(8,4) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_date` datetime DEFAULT NULL,
  `journal_location` varchar(100) DEFAULT NULL,
  `referent_no` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_suspended_items`
--

DROP TABLE IF EXISTS `erp_purchase_tax`;
CREATE TABLE `erp_purchase_tax` (
  `vat_id` int(11) NOT NULL,
  `reference_no` varchar(100) DEFAULT '',
  `purchase_id` varchar(10) DEFAULT  '',
  `purchase_ref` varchar(100) DEFAULT  '',
  `supplier_id` varchar(100) DEFAULT  '',
  `group_id` varchar(100) DEFAULT  '',
  `issuedate` datetime DEFAULT NULL,
  `amount` double(15,8) DEFAULT NULL,
  `amount_tax` double(15,8) DEFAULT NULL,
  `amount_declear` double(15,8) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `vatin` varchar(100) DEFAULT NULL,
  `qty` double(25,8) DEFAULT NULL,
  `non_tax_pur` double(25,4) DEFAULT NULL,
  `tax_value` double(25,4) DEFAULT NULL,
  `vat` double(25,4) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_location` varchar(255) DEFAULT NULL,
  `journal_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_sessions`
--

DROP TABLE IF EXISTS `erp_sessions`;
CREATE TABLE IF NOT EXISTS `erp_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_sessions`
--

INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('1795c3cf0df574cc4cb159575228440d160e6264', '42.115.42.218', 1466233037, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233323738383b7265717565737465645f706167657c733a303a22223b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332313831223b6c6173745f69707c733a31313a223131392e31352e39342e36223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b6176617461727c733a33363a2231313664383035336532336561326164303237663133656664343835643332612e706e67223b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('1c10d33bad7192da8e9bf8bae8e96f061df9929d', '119.15.94.6', 1466232199, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233323136343b7265717565737465645f706167657c733a383a2270726f6475637473223b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323331383035223b6c6173745f69707c733a31313a223131392e31352e39342e36223b6176617461727c733a33363a2233313432353333316632346535386434343330393565323934663631336632622e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('2f8f91b47d69304448dffb302a3821e4c1925687', '42.115.42.218', 1466232524, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233323431383b7265717565737465645f706167657c733a31333a227075726368617365732f616464223b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332333539223b6c6173745f69707c733a31333a2234322e3131352e34322e323138223b6176617461727c733a33363a2233313432353333316632346535386434343330393565323934663631336632622e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b6d6573736167657c733a33383a223c703e596f7520617265207375636365737366756c6c79206c6f6767656420696e2e3c2f703e223b5f5f63695f766172737c613a313a7b733a373a226d657373616765223b733a333a226f6c64223b7d757365725f637372667c733a32303a227054696e63584762315a4f454b797853644a416c223b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('357e4c42f16dcb36031f2bc47841ab7253fefcf7', '42.115.42.218', 1466234432, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233343232393b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332353233223b6c6173745f69707c733a31333a2234322e3131352e34322e323138223b6176617461727c733a33363a2231313664383035336532336561326164303237663133656664343835643332612e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b6c6173745f61637469766974797c693a313436363233333634313b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('5917b1cc6dddd8296fc53843bd6532ec0d45d56a', '42.115.42.218', 1466232569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233323335323b7265717565737465645f706167657c733a303a22223b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332313831223b6c6173745f69707c733a31313a223131392e31352e39342e36223b6176617461727c733a33363a2233313432353333316632346535386434343330393565323934663631336632622e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('605d5a40f23b168db2cd82fc0e18351b55b2cdb6', '42.115.42.218', 1466233301, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233333033303b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332353233223b6c6173745f69707c733a31333a2234322e3131352e34322e323138223b6176617461727c733a33363a2231313664383035336532336561326164303237663133656664343835643332612e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('6fc0c18112104279a6de30cf438616db73cf2e8b', '42.115.42.218', 1466233000, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233323732333b7265717565737465645f706167657c733a31333a227075726368617365732f616464223b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332333539223b6c6173745f69707c733a31333a2234322e3131352e34322e323138223b6176617461727c733a33363a2233313432353333316632346535386434343330393565323934663631336632622e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b757365725f637372667c733a32303a227054696e63584762315a4f454b797853644a416c223b6d6573736167657c733a32393a2253657474696e6773207375636365737366756c6c792075706461746564223b5f5f63695f766172737c613a313a7b733a373a226d657373616765223b733a333a226f6c64223b7d);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('822f02cab1edaf68991a5b0ca7c8350834ecc4cc', '119.15.94.6', 1466233110, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233333030333b7265717565737465645f706167657c733a383a2270726f6475637473223b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323331383035223b6c6173745f69707c733a31313a223131392e31352e39342e36223b6176617461727c733a33363a2233313432353333316632346535386434343330393565323934663631336632622e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('b7687f2cde2e849de2e25fabd59ca351fbddd72b', '42.115.42.218', 1466234645, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233343539343b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332353233223b6c6173745f69707c733a31333a2234322e3131352e34322e323138223b6176617461727c733a33363a2231313664383035336532336561326164303237663133656664343835643332612e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b6c6173745f61637469766974797c693a313436363233333634313b);
INSERT INTO `erp_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES('c788f487b17a5d91e6cd20f1917dada0bda1475c', '42.115.42.218', 1466233789, 0x5f5f63695f6c6173745f726567656e65726174657c693a313436363233333537393b6964656e746974797c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365726e616d657c733a353a226f776e6572223b656d61696c7c733a32313a226f776e657240636c6f75646e65742e636f6d2e6b68223b757365725f69647c733a313a2231223b6f6c645f6c6173745f6c6f67696e7c733a31303a2231343636323332353233223b6c6173745f69707c733a31333a2234322e3131352e34322e323138223b6176617461727c733a33363a2231313664383035336532336561326164303237663133656664343835643332612e706e67223b67656e6465727c733a343a226d616c65223b67726f75705f69647c733a313a2231223b77617265686f7573655f69647c4e3b766965775f72696768747c733a313a2230223b656469745f72696768747c733a313a2230223b616c6c6f775f646973636f756e747c4e3b62696c6c65725f69647c4e3b636f6d70616e795f69647c4e3b73686f775f636f73747c733a313a2230223b73686f775f70726963657c733a313a2230223b6c6173745f61637469766974797c693a313436363233333634313b);

-- --------------------------------------------------------

--
-- Table structure for table `erp_settings`
--

DROP TABLE IF EXISTS `erp_settings`;
CREATE TABLE IF NOT EXISTS `erp_settings` (
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
  `convert_prefix` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_settings`
--

INSERT INTO `erp_settings` (`setting_id`, `logo`, `logo2`, `site_name`, `language`, `default_warehouse`, `accounting_method`, `default_currency`, `default_tax_rate`, `rows_per_page`, `version`, `default_tax_rate2`, `dateformat`, `sales_prefix`, `quote_prefix`, `purchase_prefix`, `transfer_prefix`, `delivery_prefix`, `payment_prefix`, `return_prefix`, `expense_prefix`, `transaction_prefix`, `item_addition`, `theme`, `product_serial`, `default_discount`, `product_discount`, `discount_method`, `tax1`, `tax2`, `overselling`, `restrict_user`, `restrict_calendar`, `timezone`, `iwidth`, `iheight`, `twidth`, `theight`, `watermark`, `reg_ver`, `allow_reg`, `reg_notification`, `auto_reg`, `protocol`, `mailpath`, `smtp_host`, `smtp_user`, `smtp_pass`, `smtp_port`, `smtp_crypto`, `corn`, `customer_group`, `default_email`, `mmode`, `bc_fix`, `auto_detect_barcode`, `captcha`, `reference_format`, `racks`, `attributes`, `product_expiry`, `purchase_decimals`, `decimals`, `qty_decimals`, `decimals_sep`, `thousands_sep`, `invoice_view`, `default_biller`, `envato_username`, `purchase_code`, `rtl`, `each_spent`, `ca_point`, `each_sale`, `sa_point`, `update`, `sac`, `display_all_products`, `display_symbol`, `symbol`, `item_slideshow`, `barcode_separator`, `remove_expired`, `sale_payment_prefix`, `purchase_payment_prefix`, `sale_loan_prefix`, `auto_print`, `returnp_prefix`, `alert_day`, `convert_prefix`) VALUES(1, 'logo2.png', 'login_logo.png', 'American Outlet', 'english', 1, 2, 'USD', 1, 10, '3.0.2', 1, 5, 'SALE', 'QUOTE', 'PO', 'TR', 'DO', 'IPAY', 'RE', 'EX', 'J', 0, 'default', 0, 1, 1, 1, 1, 1, 1, 1, 0, 'Asia/Phnom_Penh', 800, 800, 60, 60, 0, 0, 0, 0, NULL, 'mail', '/usr/sbin/sendmail', 'pop.gmail.com', 'iclouderp@gmail.com', 'jEFTM4T63AiQ9dsidxhPKt9CIg4HQjCN58n/RW9vmdC/UDXCzRLR469ziZ0jjpFlbOg43LyoSmpJLBkcAHh0Yw==', '25', NULL, NULL, 1, 'iclouderp@gmail.com', 0, 4, 0, 0, 1, 1, 1, 1, 2, 2, 0, '.', ',', 0, 1, 'cloud-net', '53d35644-a36e-45cd-b7ee-8dde3a08f83d', 0, '10.0000', 1, '100.0000', 1, 0, 0, 0, 0, '$', 0, '_', 0, 'RV', 'PV', 'LOAN', 0, 'PRE', 7, 'CON');

-- --------------------------------------------------------

--
-- Table structure for table `erp_skrill`
--

DROP TABLE IF EXISTS `erp_skrill`;
CREATE TABLE IF NOT EXISTS `erp_skrill` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL DEFAULT 'testaccount2@moneybookers.com',
  `secret_word` varchar(20) NOT NULL DEFAULT 'mbtest',
  `skrill_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_skrill`
--

INSERT INTO `erp_skrill` (`id`, `active`, `account_email`, `secret_word`, `skrill_currency`, `fixed_charges`, `extra_charges_my`, `extra_charges_other`) VALUES(1, 0, 'laykiry@yahoo.com', 'mbtest', 'USD', '0.0000', '0.0000', '0.0000');

-- --------------------------------------------------------

--
-- Table structure for table `erp_subcategories`
--

DROP TABLE IF EXISTS `erp_subcategories`;
CREATE TABLE IF NOT EXISTS `erp_subcategories` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  `image` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_suspended`
--

DROP TABLE IF EXISTS `erp_suspended`;
CREATE TABLE IF NOT EXISTS `erp_suspended` (
  `id` mediumint(8) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `floor` varchar(20) DEFAULT '0',
  `ppl_number` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_suspended_bills`
--

DROP TABLE IF EXISTS `erp_suspended_bills`;
CREATE TABLE IF NOT EXISTS `erp_suspended_bills` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` timestamp NULL DEFAULT NULL,
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
  `suspend_name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_suspended_items`
--

DROP TABLE IF EXISTS `erp_suspended_items`;
CREATE TABLE IF NOT EXISTS `erp_suspended_items` (
  `id` int(11) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_tax_purchase_vat`
--

DROP TABLE IF EXISTS `erp_tax_purchase_vat`;
CREATE TABLE IF NOT EXISTS `erp_tax_purchase_vat` (
  `vat_id` int(11) NOT NULL,
  `bill_num` varchar(100) DEFAULT NULL,
  `debtorno` varchar(100) DEFAULT NULL,
  `locationname` varchar(100) DEFAULT NULL,
  `issuedate` date DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `amount_tax` double DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_location` varchar(255) DEFAULT NULL,
  `journal_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `erp_tax_rates`
--

DROP TABLE IF EXISTS `erp_tax_rates`;
CREATE TABLE IF NOT EXISTS `erp_tax_rates` (
  `id` int(11) NOT NULL,
  `name` varchar(55) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `rate` decimal(12,4) NOT NULL,
  `type` varchar(50) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_tax_rates`
--

INSERT INTO `erp_tax_rates` (`id`, `name`, `code`, `rate`, `type`) VALUES(1, 'No Tax', 'NT', '0.0000', '2');
INSERT INTO `erp_tax_rates` (`id`, `name`, `code`, `rate`, `type`) VALUES(2, 'VAT @10%', 'VAT10', '10.0000', '1');
INSERT INTO `erp_tax_rates` (`id`, `name`, `code`, `rate`, `type`) VALUES(3, 'GST @6%', 'GST', '6.0000', '1');
INSERT INTO `erp_tax_rates` (`id`, `name`, `code`, `rate`, `type`) VALUES(4, 'VAT @20%', 'VT20', '20.0000', '1');
INSERT INTO `erp_tax_rates` (`id`, `name`, `code`, `rate`, `type`) VALUES(5, 'TAX @10%', 'TAX', '10.0000', '1');

-- --------------------------------------------------------

--
-- Table structure for table `erp_transfers`
--

DROP TABLE IF EXISTS `erp_transfers`;
CREATE TABLE IF NOT EXISTS `erp_transfers` (
  `id` int(11) NOT NULL,
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
  `attachment` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_transfer_items`
--

DROP TABLE IF EXISTS `erp_transfer_items`;
CREATE TABLE IF NOT EXISTS `erp_transfer_items` (
  `id` int(11) NOT NULL,
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
  `warehouse_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_users`
--

DROP TABLE IF EXISTS `erp_users`;
CREATE TABLE IF NOT EXISTS `erp_users` (
  `id` int(11) unsigned NOT NULL,
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
  `pack_id` varchar(50) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_users`
--

INSERT INTO `erp_users` (`id`, `last_ip_address`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `last_login`, `active`, `first_name`, `last_name`, `company`, `phone`, `avatar`, `gender`, `group_id`, `warehouse_id`, `biller_id`, `company_id`, `show_cost`, `show_price`, `award_points`, `view_right`, `edit_right`, `allow_discount`, `annualLeave`, `sickday`, `speacialLeave`, `othersLeave`, `first_name_kh`, `last_name_kh`, `nationality_kh`, `race_kh`) VALUES(1, 0x34322e3131352e34322e323138, 0x0000, 'owner', 'f536eef28fd507c1fe24273c65171af8d4299d14', NULL, 'owner@cloudnet.com.kh', NULL, NULL, NULL, '8a5d98b76e7cad45a8efc6c8c4eda7cdd1ab04a5', 1351661704, 1466233046, 1, 'Owner', 'Owner', 'ABC Shop', '012345678', '116d8053e23ea2ad027f13efd485d32a.png', 'male', 1, NULL, NULL, NULL, 0, 0, 2574, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, '');
INSERT INTO `erp_users` (`id`, `last_ip_address`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `last_login`, `active`, `first_name`, `last_name`, `company`, `phone`, `avatar`, `gender`, `group_id`, `warehouse_id`, `biller_id`, `company_id`, `show_cost`, `show_price`, `award_points`, `view_right`, `edit_right`, `allow_discount`, `annualLeave`, `sickday`, `speacialLeave`, `othersLeave`, `first_name_kh`, `last_name_kh`, `nationality_kh`, `race_kh`) VALUES(2, 0x34322e3131352e31312e313835, 0x34322e3131352e31312e313835, 'manager', '2732eb091ddcefb745a940450ec21250e2fee44a', NULL, 'manager@cloudnet.com.kh', NULL, NULL, NULL, NULL, 1445470525, 1445470670, 1, 'manager', 'manager', 'ABC Shop', '023 634 6666', NULL, 'male', 2, 1, 3, NULL, 0, 0, 119, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, '');
INSERT INTO `erp_users` (`id`, `last_ip_address`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `last_login`, `active`, `first_name`, `last_name`, `company`, `phone`, `avatar`, `gender`, `group_id`, `warehouse_id`, `biller_id`, `company_id`, `show_cost`, `show_price`, `award_points`, `view_right`, `edit_right`, `allow_discount`, `annualLeave`, `sickday`, `speacialLeave`, `othersLeave`, `first_name_kh`, `last_name_kh`, `nationality_kh`, `race_kh`) VALUES(3, 0x3230322e35382e39392e313230, 0x34322e3131352e31312e313835, 'sale', '7a54a62cdddf60c47a653fe7ea71d4f108370304', NULL, 'sales@cloudnet.com.kh', NULL, NULL, NULL, 'af293c89d9bd795ff8fe5a1592eb5daaa1dacd02', 1445470636, 1446851301, 1, 'Lay', 'Chanda', 'ABC Shop', '012345678', 'fed503c5c169b9e1b337803ba9bd8e34.png', 'female', 5, 1, 3, NULL, 1, 1, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, '');
INSERT INTO `erp_users` (`id`, `last_ip_address`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `last_login`, `active`, `first_name`, `last_name`, `company`, `phone`, `avatar`, `gender`, `group_id`, `warehouse_id`, `biller_id`, `company_id`, `show_cost`, `show_price`, `award_points`, `view_right`, `edit_right`, `allow_discount`, `annualLeave`, `sickday`, `speacialLeave`, `othersLeave`, `first_name_kh`, `last_name_kh`, `nationality_kh`, `race_kh`) VALUES(4, 0x3139322e3136382e312e3139, 0x3139322e3136382e312e313939, 'test', 'f6ce3fa3548133f371d4d5c69a941bb22c6420c9', NULL, 'test@test.com', NULL, NULL, NULL, NULL, 1461114995, 1462757045, 1, 'test', 'test', 'test', '092581212', NULL, 'male', 5, 2, 3, NULL, 1, 1, 27, 1, 1, 1, 0, 0, NULL, NULL, NULL, NULL, NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `erp_user_logins`
--

DROP TABLE IF EXISTS `erp_user_logins`;
CREATE TABLE IF NOT EXISTS `erp_user_logins` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `ip_address` varbinary(16) NOT NULL,
  `login` varchar(100) NOT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_user_logins`
--

INSERT INTO `erp_user_logins` (`id`, `user_id`, `company_id`, `ip_address`, `login`, `time`) VALUES(1, 1, NULL, 0x3131392e31352e39342e36, 'owner@cloudnet.com.kh', '2016-06-18 06:36:45');
INSERT INTO `erp_user_logins` (`id`, `user_id`, `company_id`, `ip_address`, `login`, `time`) VALUES(2, 1, NULL, 0x3131392e31352e39342e36, 'owner@cloudnet.com.kh', '2016-06-18 06:43:01');
INSERT INTO `erp_user_logins` (`id`, `user_id`, `company_id`, `ip_address`, `login`, `time`) VALUES(3, 1, NULL, 0x34322e3131352e34322e323138, 'owner@cloudnet.com.kh', '2016-06-18 06:45:59');
INSERT INTO `erp_user_logins` (`id`, `user_id`, `company_id`, `ip_address`, `login`, `time`) VALUES(4, 1, NULL, 0x34322e3131352e34322e323138, 'owner@cloudnet.com.kh', '2016-06-18 06:48:43');
INSERT INTO `erp_user_logins` (`id`, `user_id`, `company_id`, `ip_address`, `login`, `time`) VALUES(5, 1, NULL, 0x34322e3131352e34322e323138, 'owner@cloudnet.com.kh', '2016-06-18 06:57:26');

-- --------------------------------------------------------

--
-- Table structure for table `erp_variants`
--

DROP TABLE IF EXISTS `erp_variants`;
CREATE TABLE IF NOT EXISTS `erp_variants` (
  `id` int(11) NOT NULL,
  `name` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_warehouses`
--

DROP TABLE IF EXISTS `erp_warehouses`;
CREATE TABLE IF NOT EXISTS `erp_warehouses` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `map` varchar(255) DEFAULT NULL,
  `phone` varchar(55) DEFAULT NULL,
  `email` varchar(55) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `erp_warehouses`
--

INSERT INTO `erp_warehouses` (`id`, `code`, `name`, `address`, `map`, `phone`, `email`) VALUES(1, 'WH1', 'Warehouse 1', '<p>Phnom Penh</p>', NULL, '089333255', 'icloud-erp@gmail.com');
INSERT INTO `erp_warehouses` (`id`, `code`, `name`, `address`, `map`, `phone`, `email`) VALUES(2, 'WH2', 'Warehouse 2', '<p>Siem Reap</p>', NULL, '016282825', 'icloud-erp@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `erp_warehouses_products`
--

DROP TABLE IF EXISTS `erp_warehouses_products`;
CREATE TABLE IF NOT EXISTS `erp_warehouses_products` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `rack` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `erp_warehouses_products_variants`
--

DROP TABLE IF EXISTS `erp_warehouses_products_variants`;
CREATE TABLE IF NOT EXISTS `erp_warehouses_products_variants` (
  `id` int(11) NOT NULL,
  `option_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `rack` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `erp_account_settings`
--
ALTER TABLE `erp_account_settings`
  ADD PRIMARY KEY (`id`,`biller_id`);

--
-- Indexes for table `erp_adjustments`
--
ALTER TABLE `erp_adjustments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_bom`
--
ALTER TABLE `erp_bom`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_bom_items`
--
ALTER TABLE `erp_bom_items`
  ADD PRIMARY KEY (`id`), ADD KEY `transfer_id` (`bom_id`), ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `erp_calendar`
--
ALTER TABLE `erp_calendar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_captcha`
--
ALTER TABLE `erp_captcha`
  ADD PRIMARY KEY (`captcha_id`), ADD KEY `word` (`word`);

--
-- Indexes for table `erp_categories`
--
ALTER TABLE `erp_categories`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_combine_items`
--
ALTER TABLE `erp_combine_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_combo_items`
--
ALTER TABLE `erp_combo_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_companies`
--
ALTER TABLE `erp_companies`
  ADD PRIMARY KEY (`id`), ADD KEY `group_id` (`group_id`), ADD KEY `group_id_2` (`group_id`);

--
-- Indexes for table `erp_condition_tax`
--
ALTER TABLE `erp_condition_tax`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_convert`
--
ALTER TABLE `erp_convert`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_convert_items`
--
ALTER TABLE `erp_convert_items`
  ADD PRIMARY KEY (`id`), ADD KEY `transfer_id` (`convert_id`), ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `erp_costing`
--
ALTER TABLE `erp_costing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_currencies`
--
ALTER TABLE `erp_currencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_customer_groups`
--
ALTER TABLE `erp_customer_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_date_format`
--
ALTER TABLE `erp_date_format`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_deliveries`
--
ALTER TABLE `erp_deliveries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_deposits`
--
ALTER TABLE `erp_deposits`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_expenses`
--
ALTER TABLE `erp_expenses`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`) USING BTREE;

--
-- Indexes for table `erp_gift_cards`
--
ALTER TABLE `erp_gift_cards`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `card_no` (`card_no`);

--
-- Indexes for table `erp_gl_charts`
--
ALTER TABLE `erp_gl_charts`
  ADD PRIMARY KEY (`accountcode`), ADD KEY `AccountCode` (`accountcode`) USING BTREE, ADD KEY `AccountName` (`accountname`) USING BTREE;

--
-- Indexes for table `erp_gl_charts_tax`
--
ALTER TABLE `erp_gl_charts_tax`
  ADD PRIMARY KEY (`account_tax_id`), ADD KEY `AccountCode` (`accountcode`) USING BTREE, ADD KEY `AccountName` (`accountname`) USING BTREE;

--
-- Indexes for table `erp_gl_sections`
--
ALTER TABLE `erp_gl_sections`
  ADD PRIMARY KEY (`sectionid`);

--
-- Indexes for table `erp_gl_trans`
--
ALTER TABLE `erp_gl_trans`
  ADD PRIMARY KEY (`tran_id`), ADD KEY `Account` (`account_code`) USING BTREE, ADD KEY `TranDate` (`tran_date`) USING BTREE, ADD KEY `TypeNo` (`tran_no`) USING BTREE, ADD KEY `Type_and_Number` (`tran_type`,`tran_no`) USING BTREE;

--
-- Indexes for table `erp_groups`
--
ALTER TABLE `erp_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_loans`
--
ALTER TABLE `erp_loans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_login_attempts`
--
ALTER TABLE `erp_login_attempts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_marchine`
--
ALTER TABLE `erp_marchine`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_marchine_logs`
--
ALTER TABLE `erp_marchine_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_notifications`
--
ALTER TABLE `erp_notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_order_ref`
--
ALTER TABLE `erp_order_ref`
  ADD PRIMARY KEY (`ref_id`);

--
-- Indexes for table `erp_pack_lists`
--
ALTER TABLE `erp_pack_lists`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_payments`
--
ALTER TABLE `erp_payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_paypal`
--
ALTER TABLE `erp_paypal`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_permissions`
--
ALTER TABLE `erp_permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_pos_register`
--
ALTER TABLE `erp_pos_register`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_pos_settings`
--
ALTER TABLE `erp_pos_settings`
  ADD PRIMARY KEY (`pos_id`);

--
-- Indexes for table `erp_products`
--
ALTER TABLE `erp_products`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `code` (`code`), ADD KEY `category_id` (`category_id`), ADD KEY `id` (`id`), ADD KEY `id_2` (`id`), ADD KEY `category_id_2` (`category_id`);

--
-- Indexes for table `erp_product_photos`
--
ALTER TABLE `erp_product_photos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_product_variants`
--
ALTER TABLE `erp_product_variants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_purchases`
--
ALTER TABLE `erp_purchases`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`) USING BTREE;

--
-- Indexes for table `erp_purchase_items`
--
ALTER TABLE `erp_purchase_items`
  ADD PRIMARY KEY (`id`), ADD KEY `purchase_id` (`purchase_id`), ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `erp_quotes`
--
ALTER TABLE `erp_quotes`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_quote_items`
--
ALTER TABLE `erp_quote_items`
  ADD PRIMARY KEY (`id`), ADD KEY `quote_id` (`quote_id`), ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `erp_return_items`
--
ALTER TABLE `erp_return_items`
  ADD PRIMARY KEY (`id`), ADD KEY `sale_id` (`sale_id`), ADD KEY `product_id` (`product_id`), ADD KEY `product_id_2` (`product_id`,`sale_id`), ADD KEY `sale_id_2` (`sale_id`,`product_id`);

--
-- Indexes for table `erp_return_purchases`
--
ALTER TABLE `erp_return_purchases`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_return_purchase_items`
--
ALTER TABLE `erp_return_purchase_items`
  ADD PRIMARY KEY (`id`), ADD KEY `purchase_id` (`purchase_id`), ADD KEY `product_id` (`product_id`), ADD KEY `product_id_2` (`product_id`,`purchase_id`), ADD KEY `purchase_id_2` (`purchase_id`,`product_id`);

--
-- Indexes for table `erp_return_sales`
--
ALTER TABLE `erp_return_sales`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_sales`
--
ALTER TABLE `erp_sales`
  ADD PRIMARY KEY (`id`,`surcharge`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_sale_dev_items`
--
ALTER TABLE `erp_sale_dev_items`
  ADD PRIMARY KEY (`id`), ADD KEY `sale_id` (`sale_id`), ADD KEY `product_id` (`product_id`), ADD KEY `product_id_2` (`product_id`,`sale_id`), ADD KEY `sale_id_2` (`sale_id`,`product_id`);

--
-- Indexes for table `erp_sale_items`
--
ALTER TABLE `erp_sale_items`
  ADD PRIMARY KEY (`id`), ADD KEY `sale_id` (`sale_id`), ADD KEY `product_id` (`product_id`), ADD KEY `product_id_2` (`product_id`,`sale_id`), ADD KEY `sale_id_2` (`sale_id`,`product_id`);

--
-- Indexes for table `erp_sale_tax`
--
ALTER TABLE `erp_sale_tax`
  ADD PRIMARY KEY (`vat_id`);

--
-- Indexes for table `erp_purchase_tax`
--
ALTER TABLE `erp_purchase_tax`
  ADD PRIMARY KEY (`vat_id`);

--
-- Indexes for table `erp_sessions`
--
ALTER TABLE `erp_sessions`
  ADD PRIMARY KEY (`id`), ADD KEY `ci_sessions_timestamp` (`timestamp`);

--
-- Indexes for table `erp_settings`
--
ALTER TABLE `erp_settings`
  ADD PRIMARY KEY (`setting_id`);

--
-- Indexes for table `erp_skrill`
--
ALTER TABLE `erp_skrill`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_subcategories`
--
ALTER TABLE `erp_subcategories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_suspended`
--
ALTER TABLE `erp_suspended`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_suspended_bills`
--
ALTER TABLE `erp_suspended_bills`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_suspended_items`
--
ALTER TABLE `erp_suspended_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_tax_purchase_vat`
--
ALTER TABLE `erp_tax_purchase_vat`
  ADD PRIMARY KEY (`vat_id`);

--
-- Indexes for table `erp_tax_rates`
--
ALTER TABLE `erp_tax_rates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_transfers`
--
ALTER TABLE `erp_transfers`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_transfer_items`
--
ALTER TABLE `erp_transfer_items`
  ADD PRIMARY KEY (`id`), ADD KEY `transfer_id` (`transfer_id`), ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `erp_users`
--
ALTER TABLE `erp_users`
  ADD PRIMARY KEY (`id`), ADD KEY `group_id` (`group_id`,`warehouse_id`,`biller_id`), ADD KEY `group_id_2` (`group_id`,`company_id`);

--
-- Indexes for table `erp_user_logins`
--
ALTER TABLE `erp_user_logins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_variants`
--
ALTER TABLE `erp_variants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `erp_warehouses`
--
ALTER TABLE `erp_warehouses`
  ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

--
-- Indexes for table `erp_warehouses_products`
--
ALTER TABLE `erp_warehouses_products`
  ADD PRIMARY KEY (`id`), ADD KEY `product_id` (`product_id`), ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Indexes for table `erp_warehouses_products_variants`
--
ALTER TABLE `erp_warehouses_products_variants`
  ADD PRIMARY KEY (`id`), ADD KEY `option_id` (`option_id`), ADD KEY `product_id` (`product_id`), ADD KEY `warehouse_id` (`warehouse_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `erp_adjustments`
--
ALTER TABLE `erp_adjustments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_bom`
--
ALTER TABLE `erp_bom`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_bom_items`
--
ALTER TABLE `erp_bom_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_calendar`
--
ALTER TABLE `erp_calendar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_captcha`
--
ALTER TABLE `erp_captcha`
  MODIFY `captcha_id` bigint(13) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `erp_categories`
--
ALTER TABLE `erp_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_combine_items`
--
ALTER TABLE `erp_combine_items`
  MODIFY `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_combo_items`
--
ALTER TABLE `erp_combo_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_companies`
--
ALTER TABLE `erp_companies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `erp_condition_tax`
--
ALTER TABLE `erp_condition_tax`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `erp_convert`
--
ALTER TABLE `erp_convert`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_convert_items`
--
ALTER TABLE `erp_convert_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_costing`
--
ALTER TABLE `erp_costing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_currencies`
--
ALTER TABLE `erp_currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `erp_customer_groups`
--
ALTER TABLE `erp_customer_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `erp_date_format`
--
ALTER TABLE `erp_date_format`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `erp_deliveries`
--
ALTER TABLE `erp_deliveries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_deposits`
--
ALTER TABLE `erp_deposits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_expenses`
--
ALTER TABLE `erp_expenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_gift_cards`
--
ALTER TABLE `erp_gift_cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_gl_charts_tax`
--
ALTER TABLE `erp_gl_charts_tax`
  MODIFY `account_tax_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=91;
--
-- AUTO_INCREMENT for table `erp_gl_trans`
--
ALTER TABLE `erp_gl_trans`
  MODIFY `tran_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_groups`
--
ALTER TABLE `erp_groups`
  MODIFY `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT for table `erp_loans`
--
ALTER TABLE `erp_loans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_login_attempts`
--
ALTER TABLE `erp_login_attempts`
  MODIFY `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `erp_marchine`
--
ALTER TABLE `erp_marchine`
  MODIFY `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `erp_marchine_logs`
--
ALTER TABLE `erp_marchine_logs`
  MODIFY `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_notifications`
--
ALTER TABLE `erp_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `erp_order_ref`
--
ALTER TABLE `erp_order_ref`
  MODIFY `ref_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT for table `erp_pack_lists`
--
ALTER TABLE `erp_pack_lists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_payments`
--
ALTER TABLE `erp_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_permissions`
--
ALTER TABLE `erp_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `erp_pos_register`
--
ALTER TABLE `erp_pos_register`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_products`
--
ALTER TABLE `erp_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_product_photos`
--
ALTER TABLE `erp_product_photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_product_variants`
--
ALTER TABLE `erp_product_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_purchases`
--
ALTER TABLE `erp_purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_purchase_items`
--
ALTER TABLE `erp_purchase_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_quotes`
--
ALTER TABLE `erp_quotes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_quote_items`
--
ALTER TABLE `erp_quote_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_return_items`
--
ALTER TABLE `erp_return_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_return_purchases`
--
ALTER TABLE `erp_return_purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_return_purchase_items`
--
ALTER TABLE `erp_return_purchase_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_return_sales`
--
ALTER TABLE `erp_return_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_sales`
--
ALTER TABLE `erp_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_sale_dev_items`
--
ALTER TABLE `erp_sale_dev_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_sale_items`
--
ALTER TABLE `erp_sale_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_sale_tax`
--
ALTER TABLE `erp_sale_tax`
  MODIFY `vat_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_purchase_tax`
--
ALTER TABLE `erp_purchase_tax`
  MODIFY `vat_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_subcategories`
--
ALTER TABLE `erp_subcategories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_suspended`
--
ALTER TABLE `erp_suspended`
  MODIFY `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_suspended_bills`
--
ALTER TABLE `erp_suspended_bills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_suspended_items`
--
ALTER TABLE `erp_suspended_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_tax_purchase_vat`
--
ALTER TABLE `erp_tax_purchase_vat`
  MODIFY `vat_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_tax_rates`
--
ALTER TABLE `erp_tax_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `erp_transfers`
--
ALTER TABLE `erp_transfers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_transfer_items`
--
ALTER TABLE `erp_transfer_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_users`
--
ALTER TABLE `erp_users`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `erp_user_logins`
--
ALTER TABLE `erp_user_logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `erp_variants`
--
ALTER TABLE `erp_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_warehouses`
--
ALTER TABLE `erp_warehouses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `erp_warehouses_products`
--
ALTER TABLE `erp_warehouses_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `erp_warehouses_products_variants`
--
ALTER TABLE `erp_warehouses_products_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
