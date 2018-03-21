ALTER TABLE `erp_adjustments`
ADD `quantity_po` DECIMAL (19, 4) NULL DEFAULT '0';
ALTER TABLE `erp_purchase_items` ADD `product_type` VARCHAR(55) NULL;

ALTER TABLE `erp_settings`
ADD `credit_limit` INT (11) NULL DEFAULT '0';

ALTER TABLE `erp_order_ref`
ADD `sd` INT (11) NULL DEFAULT '1';
ADD `es` INT (11) NULL DEFAULT '1';
ADD `esr` INT (11) NULL DEFAULT '1';
ADD `sao` INT (11) NULL DEFAULT '1';
ADD `poa` INT (11) NULL DEFAULT '1';

ALTER TABLE `erp_purchases`
ADD `opening_ap` TINYINT (1) NULL DEFAULT NULL;

ALTER TABLE `erp_sale_order`
ADD `bill_to` VARCHAR(255) NULL,
ADD `po` VARCHAR(50) NULL;

ALTER TABLE `erp_sales`
ADD `bill_to` VARCHAR(255) NULL,
ADD `po` VARCHAR(50) NULL;

