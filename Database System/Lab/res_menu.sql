CREATE SCHEMA `restaurant` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `restaurant`.`user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(50) NULL DEFAULT NULL,
  `middleName` VARCHAR(50) NULL DEFAULT NULL,
  `lastName` VARCHAR(50) NULL DEFAULT NULL,
  `mobile` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL,
  `passwordHash` VARCHAR(32) NOT NULL,
  `admin` TINYINT(1) NOT NULL DEFAULT 0,
  `vendor` TINYINT(1) NOT NULL DEFAULT 0,
  `chef` TINYINT(1) NOT NULL DEFAULT 0,
  `agent` TINYINT(1) NOT NULL DEFAULT 0,
  `registeredAt` DATETIME NOT NULL,
  `lastLogin` DATETIME NULL DEFAULT NULL,
  `intro` TINYTEXT NULL DEFAULT NULL,
  `profile` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_mobile` (`mobile` ASC),
  UNIQUE INDEX `uq_email` (`email` ASC) );
  
CREATE TABLE `restaurant`.`ingredient` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `vendorId` BIGINT DEFAULT NULL,
  `title` VARCHAR(75) NOT NULL,
  `slug` VARCHAR(100) NOT NULL,
  `summary` TINYTEXT NULL,
  `type` SMALLINT(6) NOT NULL DEFAULT 0,
  `sku` VARCHAR(100) NOT NULL,
  `quantity` FLOAT NOT NULL DEFAULT 0,
  `unit` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_slug` (`slug` ASC),
  INDEX `idx_ingredient_user` (`userId` ASC),
  CONSTRAINT `fk_ingredient_user`
    FOREIGN KEY (`userId`)
    REFERENCES `restaurant`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);

ALTER TABLE `restaurant`.`ingredient`
ADD INDEX `idx_ingredient_vendor` (`vendorId` ASC);
ALTER TABLE `restaurant`.`ingredient` 
ADD CONSTRAINT `fk_ingredient_vendor`
  FOREIGN KEY (`vendorId`)
  REFERENCES `restaurant`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `vendorId` BIGINT DEFAULT NULL,
  `title` VARCHAR(75) NOT NULL,
  `slug` VARCHAR(100) NOT NULL,
  `summary` TINYTEXT NULL,
  `type` SMALLINT(6) NOT NULL DEFAULT 0,
  `cooking` TINYINT(1) NOT NULL DEFAULT 0,
  `sku` VARCHAR(100) NOT NULL,
  `price` FLOAT NOT NULL DEFAULT 0,
  `quantity` FLOAT NOT NULL DEFAULT 0,
  `unit` SMALLINT(6) NOT NULL DEFAULT 0,
  `recipe` TEXT NULL DEFAULT NULL,
  `instructions` TEXT NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_slug` (`slug` ASC),
  INDEX `idx_item_user` (`userId` ASC),
  CONSTRAINT `fk_item_user`
    FOREIGN KEY (`userId`)
    REFERENCES `restaurant`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);

ALTER TABLE `restaurant`.`item`
ADD INDEX `idx_item_vendor` (`vendorId` ASC);
ALTER TABLE `restaurant`.`item` 
ADD CONSTRAINT `fk_item_vendor`
  FOREIGN KEY (`vendorId`)
  REFERENCES `restaurant`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `restaurant`.`recipe` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `itemId` BIGINT NOT NULL,
  `ingredientId` BIGINT NOT NULL,
  `quantity` FLOAT NOT NULL DEFAULT 0,
  `unit` SMALLINT(6) NOT NULL DEFAULT 0,
  `instructions` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_recipe_item` (`itemId` ASC),
  UNIQUE INDEX `uq_recipe_item_ingredient` (`itemId` ASC, `ingredientId` ASC),
  CONSTRAINT `fk_recipe_item`
    FOREIGN KEY (`itemId`)
    REFERENCES `restaurant`.`item` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `restaurant`.`recipe`
ADD INDEX `idx_recipe_ingredient` (`ingredientId` ASC);
ALTER TABLE `restaurant`.`recipe` 
ADD CONSTRAINT `fk_recipe_ingredient`
  FOREIGN KEY (`ingredientId`)
  REFERENCES `restaurant`.`ingredient` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `title` VARCHAR(75) NOT NULL,
  `slug` VARCHAR(100) NOT NULL,
  `summary` TINYTEXT NULL,
  `type` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_slug` (`slug` ASC),
  INDEX `idx_menu_user` (`userId` ASC),
  CONSTRAINT `fk_menu_user`
    FOREIGN KEY (`userId`)
    REFERENCES `restaurant`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);
    
CREATE TABLE `restaurant`.`menu_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `menuId` BIGINT NOT NULL,
  `itemId` BIGINT NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `idx_menu_item_menu` (`menuId` ASC),
  UNIQUE INDEX `uq_menu_item` (`menuId` ASC, `itemId` ASC),
  CONSTRAINT `fk_menu_item_menu`
    FOREIGN KEY (`menuId`)
    REFERENCES `restaurant`.`menu` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `restaurant`.`menu_item`
ADD INDEX `idx_menu_item_item` (`itemId` ASC);
ALTER TABLE `restaurant`.`menu_item` 
ADD CONSTRAINT `fk_menu_item_item`
  FOREIGN KEY (`itemId`)
  REFERENCES `restaurant`.`item` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`item_chef` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `itemId` BIGINT NOT NULL,
  `chefId` BIGINT NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `idx_item_chef_item` (`itemId` ASC),
  UNIQUE INDEX `uq_item_chef` (`itemId` ASC, `chefId` ASC),
  CONSTRAINT `fk_item_chef_item`
    FOREIGN KEY (`itemId`)
    REFERENCES `restaurant`.`item` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `restaurant`.`item_chef`
ADD INDEX `idx_item_chef_chef` (`chefId` ASC);
ALTER TABLE `restaurant`.`item_chef` 
ADD CONSTRAINT `fk_item_chef_chef`
  FOREIGN KEY (`chefId`)
  REFERENCES `restaurant`.`user` (`id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`table_top` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(100) NOT NULL,
  `status` SMALLINT(6) NOT NULL DEFAULT 0,
  `capacity` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`));
  
CREATE TABLE `restaurant`.`booking` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `tableId` BIGINT NOT NULL,
  `userId` BIGINT NULL DEFAULT NULL,
  `token` VARCHAR(100) NOT NULL,
  `status` SMALLINT(6) NOT NULL DEFAULT 0,
  `firstName` VARCHAR(50) NULL DEFAULT NULL,
  `middleName` VARCHAR(50) NULL DEFAULT NULL,
  `lastName` VARCHAR(50) NULL DEFAULT NULL,
  `mobile` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL,
  `line1` VARCHAR(50) NULL DEFAULT NULL,
  `line2` VARCHAR(50) NULL DEFAULT NULL,
  `city` VARCHAR(50) NULL DEFAULT NULL,
  `province` VARCHAR(50) NULL DEFAULT NULL,
  `country` VARCHAR(50) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_booking_table` (`tableId` ASC),
  CONSTRAINT `fk_booking_table`
    FOREIGN KEY (`tableId`)
    REFERENCES `restaurant`.`table_top` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `restaurant`.`booking`
ADD INDEX `idx_booking_user` (`userId` ASC);
ALTER TABLE `restaurant`.`booking` 
ADD CONSTRAINT `fk_booking_user`
  FOREIGN KEY (`userId`)
  REFERENCES `restaurant`.`user` (`id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`booking_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `bookingId` BIGINT NOT NULL,
  `itemId` BIGINT NOT NULL,
  `sku` VARCHAR(100) NOT NULL,
  `price` FLOAT NOT NULL DEFAULT 0,
  `discount` FLOAT NOT NULL DEFAULT 0,
  `quantity` FLOAT NOT NULL DEFAULT 0,
  `unit` SMALLINT(6) NOT NULL DEFAULT 0,
  `status` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_booking_item_booking` (`bookingId` ASC),
  CONSTRAINT `fk_booking_item_booking`
    FOREIGN KEY (`bookingId`)
    REFERENCES `restaurant`.`booking` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);

ALTER TABLE `restaurant`.`booking_item` 
ADD INDEX `idx_booking_item_item` (`itemId` ASC);
ALTER TABLE `restaurant`.`booking_item` 
ADD CONSTRAINT `fk_booking_item_item`
  FOREIGN KEY (`itemId`)
  REFERENCES `restaurant`.`item` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NULL DEFAULT NULL,
  `vendorId` BIGINT NULL DEFAULT NULL,
  `token` VARCHAR(100) NOT NULL,
  `status` SMALLINT(6) NOT NULL DEFAULT 0,
  `subTotal` FLOAT NOT NULL DEFAULT 0,
  `itemDiscount` FLOAT NOT NULL DEFAULT 0,
  `tax` FLOAT NOT NULL DEFAULT 0,
  `shipping` FLOAT NOT NULL DEFAULT 0,
  `total` FLOAT NOT NULL DEFAULT 0,
  `promo` VARCHAR(50) NULL DEFAULT NULL,
  `discount` FLOAT NOT NULL DEFAULT 0,
  `grandTotal` FLOAT NOT NULL DEFAULT 0,
  `firstName` VARCHAR(50) NULL DEFAULT NULL,
  `middleName` VARCHAR(50) NULL DEFAULT NULL,
  `lastName` VARCHAR(50) NULL DEFAULT NULL,
  `mobile` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL,
  `line1` VARCHAR(50) NULL DEFAULT NULL,
  `line2` VARCHAR(50) NULL DEFAULT NULL,
  `city` VARCHAR(50) NULL DEFAULT NULL,
  `province` VARCHAR(50) NULL DEFAULT NULL,
  `country` VARCHAR(50) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_order_user` (`userId` ASC),
  CONSTRAINT `fk_order_user`
    FOREIGN KEY (`userId`)
    REFERENCES `restaurant`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `restaurant`.`order` 
ADD INDEX `idx_order_vendor` (`vendorId` ASC);
ALTER TABLE `restaurant`.`order` 
ADD CONSTRAINT `fk_order_vendor`
  FOREIGN KEY (`vendorId`)
  REFERENCES `restaurant`.`user` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`order_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `orderId` BIGINT NOT NULL,
  `itemId` BIGINT NOT NULL,
  `sku` VARCHAR(100) NOT NULL,
  `price` FLOAT NOT NULL DEFAULT 0,
  `discount` FLOAT NOT NULL DEFAULT 0,
  `quantity` FLOAT NOT NULL DEFAULT 0,
  `unit` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_order_item_order` (`orderId` ASC),
  CONSTRAINT `fk_order_item_order`
    FOREIGN KEY (`orderId`)
    REFERENCES `restaurant`.`order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `restaurant`.`order_item` 
ADD INDEX `idx_order_item_item` (`itemId` ASC);
ALTER TABLE `restaurant`.`order_item` 
ADD CONSTRAINT `fk_order_item_item`
  FOREIGN KEY (`itemId`)
  REFERENCES `restaurant`.`item` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
CREATE TABLE `restaurant`.`transaction` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `vendorId` BIGINT NOT NULL,
  `orderId` BIGINT NOT NULL,
  `code` VARCHAR(100) NOT NULL,
  `type` SMALLINT(6) NOT NULL DEFAULT 0,
  `mode` SMALLINT(6) NOT NULL DEFAULT 0,
  `status` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_transaction_user` (`userId` ASC),
  CONSTRAINT `fk_transaction_user`
    FOREIGN KEY (`userId`)
    REFERENCES `restaurant`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `restaurant`.`transaction` 
ADD INDEX `idx_transaction_vendor` (`vendorId` ASC),
ADD INDEX `idx_transaction_order` (`orderId` ASC);

ALTER TABLE `restaurant`.`transaction` 
ADD CONSTRAINT `fk_transaction_vendor`
  FOREIGN KEY (`vendorId`)
  REFERENCES `restaurant`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_transaction_order`
  FOREIGN KEY (`orderId`)
  REFERENCES `restaurant`.`order` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
