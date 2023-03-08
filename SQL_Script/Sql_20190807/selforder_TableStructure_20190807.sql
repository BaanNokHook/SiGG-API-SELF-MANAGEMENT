/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.0.45
 Source Server Type    : MariaDB
 Source Server Version : 100137
 Source Host           : 192.168.0.45:3306
 Source Schema         : selforder

 Target Server Type    : MariaDB
 Target Server Version : 100137
 File Encoding         : 65001

 Date: 07/08/2019 07:46:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_users
-- ----------------------------
DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE `admin_users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'key',
  `fname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'firstname',
  `lname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'lastname',
  `email` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'email',
  `phone` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'phone number',
  `uname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'username',
  `pword` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'password',
  `is_lock` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'n' COMMENT 'flag is lock or not',
  `roles_id` int(11) NOT NULL COMMENT 'pk role',
  `created_at` datetime(0) NULL DEFAULT NULL COMMENT 'date create data',
  `created_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'username to create data',
  `updated_at` datetime(0) NULL DEFAULT NULL COMMENT 'date update data',
  `updated_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'username to update data',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'collect data of member and shop member' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `image1` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `image2` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `image3` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `image4` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `image5` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `Eng` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'อังกฤษ',
  `Tha` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ไทย',
  `Chi` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'จีน',
  `Lao` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ลาว',
  `Mya` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'พม่า',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for brand
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Theme` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`CompanyId`, `BrandId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `CategoryId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `OtherName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `DepartmentId` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `SeqNo` int(3) NULL DEFAULT NULL COMMENT 'ลำดับในการแสดง',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT 'active or inactive categry',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `CategoryId`) USING BTREE,
  INDEX `testIndex`(`OutletId`, `CategoryId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `CompanyName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Template` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Screen Style',
  PRIMARY KEY (`CompanyId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `DepartmentId` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `OtherName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `DepartmentId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for language
-- ----------------------------
DROP TABLE IF EXISTS `language`;
CREATE TABLE `language`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Module` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Section` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Caption` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Eng` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'อังกฤษ',
  `Tha` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ไทย',
  `Chi` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'จีน',
  `Lao` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ลาว',
  `Mya` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'พม่า',
  PRIMARY KEY (`id`, `Module`, `Section`, `Caption`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for languagemaster
-- ----------------------------
DROP TABLE IF EXISTS `languagemaster`;
CREATE TABLE `languagemaster`  (
  `Code` char(3) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `LanguageName` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `LanguageLocal` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  INDEX `Code`(`Code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for modiitem
-- ----------------------------
DROP TABLE IF EXISTS `modiitem`;
CREATE TABLE `modiitem`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ModiItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `OtherName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT 'active or inactive product',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `ModiItemId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for modilist
-- ----------------------------
DROP TABLE IF EXISTS `modilist`;
CREATE TABLE `modilist`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `CategoryId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ModiSetId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ModiItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Price` decimal(8, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `CategoryId`, `ItemId`, `ModiItemId`, `ModiSetId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for modiset
-- ----------------------------
DROP TABLE IF EXISTS `modiset`;
CREATE TABLE `modiset`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ModiSetId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `OtherName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `ModiSetId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for mytableevents
-- ----------------------------
DROP TABLE IF EXISTS `mytableevents`;
CREATE TABLE `mytableevents`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `email` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `randome_string` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 26 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for orderheader
-- ----------------------------
DROP TABLE IF EXISTS `orderheader`;
CREATE TABLE `orderheader`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `TableType` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'T=TakeOut',
  `Pax` tinyint(4) NULL DEFAULT NULL COMMENT 'จำนวนคน',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for orderhistory
-- ----------------------------
DROP TABLE IF EXISTS `orderhistory`;
CREATE TABLE `orderhistory`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemNo` int(3) NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ReferenceId` decimal(11, 8) NOT NULL,
  `ItemName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Product Name Show',
  `LocalName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `EnglishName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `OtherName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'ประเภท Size = 1 - 5',
  `SizeName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'Size Name',
  `SizeLocalName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeEnglishName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeOtherName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `OrgSize` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'เก็บ Size ก่อนเปลี่ยน',
  `DepartmentId` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Department',
  `CategoryId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Category',
  `AddModiCode` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'รายการ modify',
  `TotalAmount` decimal(14, 4) NULL DEFAULT NULL COMMENT 'ยอดรวม',
  `Quantity` decimal(8, 4) NULL DEFAULT NULL COMMENT 'จำนวน ',
  `OrgQty` decimal(8, 4) NULL DEFAULT NULL COMMENT 'จำนวน ก่อนเปลี่ยน',
  `UnitPrice` decimal(14, 4) NULL DEFAULT NULL COMMENT 'ราคาต่อหน่วย',
  `Free` tinyint(1) NULL DEFAULT NULL COMMENT 'รายการฟรี',
  `noService` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `Status` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'V=Void',
  `PrintTo` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'พิมพ์ที่ Value=123',
  `NeedPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'รายการใหม่ = true',
  `LocalPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'print to local printer',
  `KitchenLang` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `Parent` tinyint(1) NULL DEFAULT NULL COMMENT 'item หลัก(มี modify) = true',
  `Child` tinyint(1) NULL DEFAULT NULL COMMENT 'modify=true',
  `OrderDate` date NULL DEFAULT NULL COMMENT 'วันที่ order',
  `OrderTime` time(0) NULL DEFAULT NULL COMMENT 'เวลา order',
  `KitchenNote` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'open modifier',
  `MainItem` tinyint(1) NULL DEFAULT 0 COMMENT 'รายการหลัก',
  `GuestName` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ชื่อผู้ order',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `ItemId`, `ReferenceId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for ordering
-- ----------------------------
DROP TABLE IF EXISTS `ordering`;
CREATE TABLE `ordering`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemNo` int(3) NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ReferenceId` decimal(11, 8) NOT NULL,
  `ItemName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Product Name Show',
  `LocalName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `EnglishName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `OtherName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'ประเภท Size = 1 - 5',
  `SizeName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'Size Name',
  `SizeLocalName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeEnglishName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeOtherName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `OrgSize` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'เก็บ Size ก่อนเปลี่ยน',
  `DepartmentId` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Department',
  `CategoryId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Category',
  `AddModiCode` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'รายการ modify',
  `TotalAmount` decimal(14, 4) NULL DEFAULT NULL COMMENT 'ยอดรวม',
  `Quantity` decimal(8, 4) NULL DEFAULT NULL COMMENT 'จำนวน ',
  `OrgQty` decimal(8, 4) NULL DEFAULT NULL COMMENT 'จำนวน ก่อนเปลี่ยน',
  `UnitPrice` decimal(14, 4) NULL DEFAULT NULL COMMENT 'ราคาต่อหน่วย',
  `Free` tinyint(1) NULL DEFAULT 0 COMMENT 'รายการฟรี',
  `noService` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `Status` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'V=Void',
  `PrintTo` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'พิมพ์ที่ Value=123',
  `NeedPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'รายการใหม่ = true',
  `LocalPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'print to local printer',
  `KitchenLang` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `Parent` tinyint(1) NULL DEFAULT NULL COMMENT 'item หลัก(มี modify) = true',
  `Child` tinyint(1) NULL DEFAULT NULL COMMENT 'modify=true',
  `OrderDate` date NULL DEFAULT NULL COMMENT 'วันที่ order',
  `OrderTime` time(0) NULL DEFAULT NULL COMMENT 'เวลา order',
  `KitchenNote` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'open modifier',
  `MainItem` tinyint(1) NULL DEFAULT 0 COMMENT 'รายการหลัก',
  `GuestName` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT 'ชื่อผู้ order',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `ItemId`, `ReferenceId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for orderingdetail
-- ----------------------------
DROP TABLE IF EXISTS `orderingdetail`;
CREATE TABLE `orderingdetail`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemNo` int(3) NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ReferenceId` decimal(11, 8) NOT NULL,
  `ItemName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Product Name Show',
  `LocalName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `EnglishName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `OtherName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'ประเภท Size = 1 - 5',
  `SizeName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'Size Name',
  `SizeLocalName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeEnglishName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `SizeOtherName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `OrgSize` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'เก็บ Size ก่อนเปลี่ยน',
  `DepartmentId` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Department',
  `CategoryId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Category',
  `AddModiCode` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'รายการ modify',
  `TotalAmount` decimal(14, 4) NULL DEFAULT NULL COMMENT 'ยอดรวม',
  `Quantity` decimal(8, 4) NULL DEFAULT NULL COMMENT 'จำนวน ',
  `OrgQty` decimal(8, 4) NULL DEFAULT NULL COMMENT 'จำนวน ก่อนเปลี่ยน',
  `UnitPrice` decimal(14, 4) NULL DEFAULT NULL COMMENT 'ราคาต่อหน่วย',
  `Free` tinyint(1) NULL DEFAULT NULL COMMENT 'รายการฟรี',
  `noService` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `Status` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'V=Void',
  `PrintTo` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'พิมพ์ที่ Value=123',
  `NeedPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'รายการใหม่ = true',
  `LocalPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'print to local printer',
  `KitchenLang` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `Parent` tinyint(1) NULL DEFAULT NULL COMMENT 'item หลัก(มี modify) = true',
  `Child` tinyint(1) NULL DEFAULT NULL COMMENT 'modify=true',
  `OrderDate` date NULL DEFAULT NULL COMMENT 'วันที่ order',
  `OrderTime` time(0) NULL DEFAULT NULL COMMENT 'เวลา order',
  `KitchenNote` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT 'open modifier',
  `MainItem` tinyint(1) NULL DEFAULT 0 COMMENT 'รายการหลัก',
  `GuestName` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ชื่อผู้ order',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `ItemId`, `ReferenceId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for outlet
-- ----------------------------
DROP TABLE IF EXISTS `outlet`;
CREATE TABLE `outlet`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletName` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for outletsetting
-- ----------------------------
DROP TABLE IF EXISTS `outletsetting`;
CREATE TABLE `outletsetting`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `MaxQty` int(1) NOT NULL,
  `Locallanguage` char(3) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Tha' COMMENT 'ภาษาท้องถิ้น',
  `PosTimeOut` int(5) NULL DEFAULT NULL COMMENT 'Time Out min',
  `PosTimeStamp` datetime(0) NULL DEFAULT NULL COMMENT 'Last Update from thirt party',
  `ServerTimeStamp` datetime(0) NULL DEFAULT NULL COMMENT 'ServerTimeUpdate',
  `MasterFileTimeStamp` datetime(0) NULL DEFAULT NULL COMMENT 'เวลาแก้ไขข้อมูลสินค้าครั้งล่าสุด',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`) USING BTREE,
  INDEX `SetLanguage`(`Locallanguage`) USING BTREE,
  CONSTRAINT `SetLanguage` FOREIGN KEY (`Locallanguage`) REFERENCES `languagemaster` (`Code`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `OtherName` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `CategoryId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Category',
  `DepartmentId` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Department',
  `ShowOnCategory` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'แสดงเพิ่มเติมใน Category อื่นๆ',
  `PrintTo` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Print To Printer Vaue = 123',
  `LocalPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'พิมพ์ที่ local printer',
  `KitchenLang` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `ReduceQty` tinyint(1) NULL DEFAULT NULL COMMENT 'ปรับปรุงจำนวน QtyOnHane',
  `QtyOnHand` int(6) NULL DEFAULT NULL COMMENT 'จำนวนสินค้าที่มีอยู่',
  `StockOut` tinyint(1) NULL DEFAULT NULL COMMENT 'True = Stock Out ',
  `LocalDescription` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Product Local Description',
  `EnglishDescription` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Product English Description',
  `OtherDescription` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Product Other Description',
  `SeqNo` int(3) NULL DEFAULT NULL COMMENT 'ลำดับในการแสดง',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT 'active or inactive product',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `ItemId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for productimage
-- ----------------------------
DROP TABLE IF EXISTS `productimage`;
CREATE TABLE `productimage`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `image` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `ItemId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for productrecommend
-- ----------------------------
DROP TABLE IF EXISTS `productrecommend`;
CREATE TABLE `productrecommend`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SeqNo` int(3) NULL DEFAULT NULL COMMENT 'ลำดับในการแสดง',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `ItemId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for productsetting
-- ----------------------------
DROP TABLE IF EXISTS `productsetting`;
CREATE TABLE `productsetting`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `OtherName` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `CategoryId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Category',
  `DepartmentId` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Department',
  `ShowOnCategory` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'แสดงเพิ่มเติมใน Category อื่นๆ',
  `PrintTo` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Print To Printer Vaue = 123',
  `LocalPrint` tinyint(1) NULL DEFAULT NULL COMMENT 'พิมพ์ที่ local printer',
  `KitchenLang` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `ReduceQty` tinyint(1) NULL DEFAULT NULL COMMENT 'ปรับปรุงจำนวน QtyOnHane',
  `QtyOnHand` decimal(6, 0) NULL DEFAULT NULL COMMENT 'จำนวนสินค้าที่มีอยู่',
  `StockOut` tinyint(1) NULL DEFAULT NULL COMMENT 'True = Stock Out ',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `ItemId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for productsize
-- ----------------------------
DROP TABLE IF EXISTS `productsize`;
CREATE TABLE `productsize`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SizeId` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SizeLocalName` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Size Name',
  `SizeEnglishName` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Size Name',
  `SizeOtherName` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'Size Name',
  `DefaultSize` tinyint(1) NULL DEFAULT NULL,
  `Price` decimal(10, 4) NULL DEFAULT NULL COMMENT 'Price Size ',
  `Free` tinyint(1) NULL DEFAULT NULL COMMENT 'รายการฟรี',
  `noService` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) NULL DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `ReduceQty` tinyint(1) NULL DEFAULT NULL COMMENT 'ปรับปรุงจำนวน QtyOnHane',
  `QtyOnHand` int(6) NULL DEFAULT NULL COMMENT 'จำนวนสินค้าที่มีอยู่',
  `StockOut` tinyint(1) NULL DEFAULT NULL COMMENT 'True = Stock Out ',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `SizeId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for runningtext
-- ----------------------------
DROP TABLE IF EXISTS `runningtext`;
CREATE TABLE `runningtext`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Eng` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'อังกฤษ',
  `Tha` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ไทย',
  `Chi` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'จีน',
  `Lao` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'ลาว',
  `Mya` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'พม่า',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for table
-- ----------------------------
DROP TABLE IF EXISTS `table`;
CREATE TABLE `table`  (
  `CompanyId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `Status` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '',
  `TableType` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'T=TakeOut',
  `Pax` tinyint(4) NULL DEFAULT NULL COMMENT 'จำนวนคน',
  `CallWaiter` tinyint(1) NULL DEFAULT NULL COMMENT 'เรียกพนักงาน',
  `CallWaiterTime` time(0) NULL DEFAULT NULL,
  `CallCheckBill` tinyint(1) NULL DEFAULT NULL COMMENT 'เรียกเก็บเงิน',
  `CallCheckBillTime` time(0) NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT 'active or inactive product',
  `active_Device` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'P=POS  S=SelfOrder',
  PRIMARY KEY (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- View structure for check_duplicate
-- ----------------------------
DROP VIEW IF EXISTS `check_duplicate`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `check_duplicate` AS SELECT
product.CompanyId,
product.BrandId,
product.OutletId,
product.ItemId,
product.LocalName,
product.EnglishName,
Count(product.ItemId) AS duplicate
FROM
product
GROUP BY
product.CompanyId,
product.BrandId,
product.OutletId,
product.ItemId ;

-- ----------------------------
-- View structure for test_modifylistcategoryproduct
-- ----------------------------
DROP VIEW IF EXISTS `test_modifylistcategoryproduct`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `test_modifylistcategoryproduct` AS SELECT
modilist.CompanyId AS CompanyId,
modilist.BrandId AS BrandId,
modilist.OutletId AS OutletId,
modilist.CategoryId AS CategoryId,
fgetCategoryAndProductName(modilist.CompanyId,modilist.BrandId,modilist.OutletId,modilist.CategoryId,'') AS CategoryName,
modilist.ItemId AS ItemId,
fgetCategoryAndProductName(modilist.CompanyId,modilist.BrandId,modilist.OutletId,'',modilist.ItemId) AS ItemName,
modilist.ModiSetId AS ModiSetId,
modilist.ModiItemId AS ModiItemId,
concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS ModiItemCode,
'' AS ModiItemName,
concat(`modiset`.`LocalName`,`fCheckEmpty`(`modiitem`.`LocalName`,'N/A')) AS modiLocalName,
concat(`modiset`.`EnglishName`,`fCheckEmpty`(`modiitem`.`EnglishName`,'N/A')) AS modiEnglishName,
concat(`modiset`.`OtherName`,`fCheckEmpty`(`modiitem`.`OtherName`,`modiitem`.`LocalName`)) AS modiOtherName,
modilist.Price AS Price
FROM
((modilist
JOIN modiitem ON (((modilist.CompanyId = modiitem.CompanyId) AND (modilist.BrandId = modiitem.BrandId) AND (modilist.OutletId = modiitem.OutletId) AND (modilist.ModiItemId = modiitem.ModiItemId))))
LEFT JOIN modiset ON (((modilist.CompanyId = modiset.CompanyId) AND (modilist.BrandId = modiset.BrandId) AND (modilist.OutletId = modiset.OutletId) AND (modilist.ModiSetId = modiset.ModiSetId))))
ORDER BY
CompanyId ASC,
BrandId ASC,
OutletId ASC,
CategoryId ASC,
ItemId ASC,
ModiSetId ASC ;

-- ----------------------------
-- View structure for test_productmodicategory
-- ----------------------------
DROP VIEW IF EXISTS `test_productmodicategory`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `test_productmodicategory` AS SELECT
product.LocalName,
product.EnglishName,
product.OtherName,
modiset.ModiSetId,
modiset.LocalName AS modisetLocalname,
modiset.EnglishName AS modisetEnglishname,
modiset.OtherName AS modisetOthername,
modiitem.LocalName AS modiLocalName,
modiitem.EnglishName AS modiEnglishName,
modiitem.OtherName AS modiOtherName
FROM
product
INNER JOIN modilist ON product.CompanyId = modilist.CompanyId AND product.BrandId = modilist.BrandId AND product.OutletId = modilist.OutletId AND product.CategoryId = modilist.CategoryId
INNER JOIN modiitem ON modilist.CompanyId = modiitem.CompanyId AND modilist.BrandId = modiitem.BrandId AND modilist.OutletId = modiitem.OutletId AND modilist.ModiItemId = modiitem.ModiItemId
INNER JOIN modiset ON modilist.CompanyId = modiset.CompanyId AND modilist.BrandId = modiset.BrandId AND modilist.OutletId = modiset.OutletId AND modilist.ModiSetId = modiset.ModiSetId ;

-- ----------------------------
-- View structure for test_productmodiitem
-- ----------------------------
DROP VIEW IF EXISTS `test_productmodiitem`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `test_productmodiitem` AS SELECT
product.ItemId,
product.LocalName,
product.EnglishName,
product.OtherName,
modiset.ModiSetId,
modiset.LocalName AS modisetLocalname,
modiset.EnglishName AS modisetEnglishname,
modiset.OtherName AS modisetOthername,
modiitem.LocalName AS modiLocalName,
modiitem.EnglishName AS modiEnglishName,
modiitem.OtherName AS modiOtherName
FROM
product
INNER JOIN modilist ON product.CompanyId = modilist.CompanyId AND product.BrandId = modilist.BrandId AND product.OutletId = modilist.OutletId AND product.ItemId = modilist.ItemId
INNER JOIN modiitem ON modilist.CompanyId = modiitem.CompanyId AND modilist.BrandId = modiitem.BrandId AND modilist.OutletId = modiitem.OutletId AND modilist.ModiItemId = modiitem.ModiItemId
INNER JOIN modiset ON modilist.CompanyId = modiset.CompanyId AND modilist.BrandId = modiset.BrandId AND modilist.OutletId = modiset.OutletId AND modilist.ModiSetId = modiset.ModiSetId ;

-- ----------------------------
-- View structure for view_category
-- ----------------------------
DROP VIEW IF EXISTS `view_category`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_category` AS SELECT
category.CompanyId,
category.BrandId,
category.OutletId,
category.CategoryId,
'' AS CategoryName,
`fCheckEmpty`(`category`.`LocalName`,'N/A') AS LocalName,
`fCheckEmpty`(`category`.`EnglishName`,'N/A') AS EnglishName,
`fCheckEmpty`(`category`.`OtherName`,'N/A') AS OtherName,
category.SeqNo,
IF(category.is_active IS NULL,0,category.is_active) AS is_active
FROM
category
WHERE
category.is_active = 1
ORDER BY
category.CompanyId ASC,
category.BrandId ASC,
category.OutletId ASC,
category.SeqNo ASC ;

-- ----------------------------
-- View structure for view_modifyitem
-- ----------------------------
DROP VIEW IF EXISTS `view_modifyitem`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_modifyitem` AS SELECT
modilist.CompanyId AS CompanyId,
modilist.BrandId AS BrandId,
modilist.OutletId AS OutletId,
modilist.CategoryId AS CategoryId,
modilist.ItemId AS ItemId,
modilist.ModiSetId AS ModiSetId,
modilist.ModiItemId AS ModiItemId,
concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS ModiItemCode,
'' AS ModiItemName,
fCheckEmpty(`modiitem`.`LocalName`,'N/A') AS modiLocalName,
fCheckEmpty(`modiitem`.`EnglishName`,'N/A') AS modiEnglishName,
fCheckEmpty(`modiitem`.`OtherName`,`modiitem`.`LocalName`) AS modiOtherName
FROM
((modilist
JOIN modiitem ON (((modilist.CompanyId = modiitem.CompanyId) AND (modilist.BrandId = modiitem.BrandId) AND (modilist.OutletId = modiitem.OutletId) AND (modilist.ModiItemId = modiitem.ModiItemId)))))
GROUP BY
modilist.CompanyId,
modilist.BrandId,
modilist.OutletId,
modilist.CategoryId,
modilist.ItemId,
modilist.ModiItemId
ORDER BY
CategoryId ASC,
ItemId ASC ;

-- ----------------------------
-- View structure for view_modifylistall
-- ----------------------------
DROP VIEW IF EXISTS `view_modifylistall`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_modifylistall` AS SELECT
modilist.CompanyId AS CompanyId,
modilist.BrandId AS BrandId,
modilist.OutletId AS OutletId,
modilist.CategoryId AS CategoryId,
modilist.ItemId AS ItemId,
modilist.ModiSetId AS ModiSetId,
modilist.ModiItemId AS ModiItemId,
concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS ModiItemCode,
'' AS ModiItemName,
concat(`modiset`.`LocalName`,`fCheckEmpty`(`modiitem`.`LocalName`,'N/A')) AS modiLocalName,
concat(`modiset`.`EnglishName`,`fCheckEmpty`(`modiitem`.`EnglishName`,'N/A')) AS modiEnglishName,
concat(`modiset`.`OtherName`,`fCheckEmpty`(`modiitem`.`OtherName`,`modiitem`.`LocalName`)) AS modiOtherName,
modilist.Price AS Price
FROM
((modilist
JOIN modiitem ON (((modilist.CompanyId = modiitem.CompanyId) AND (modilist.BrandId = modiitem.BrandId) AND (modilist.OutletId = modiitem.OutletId) AND (modilist.ModiItemId = modiitem.ModiItemId))))
LEFT JOIN modiset ON (((modilist.CompanyId = modiset.CompanyId) AND (modilist.BrandId = modiset.BrandId) AND (modilist.OutletId = modiset.OutletId) AND (modilist.ModiSetId = modiset.ModiSetId))))
WHERE
modiitem.is_active = 1
ORDER BY
modiset.CompanyId ASC,
modiset.BrandId ASC,
modiset.OutletId ASC,
CategoryId ASC,
ItemId ASC,
modiset.ModiSetId ASC ;

-- ----------------------------
-- View structure for view_modifyprefix
-- ----------------------------
DROP VIEW IF EXISTS `view_modifyprefix`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_modifyprefix` AS SELECT
modilist.CompanyId AS CompanyId,
modilist.BrandId AS BrandId,
modilist.OutletId AS OutletId,
modilist.CategoryId AS CategoryId,
modilist.ItemId AS ItemId,
modilist.ModiSetId AS ModiSetId,
modilist.ModiItemId AS ModiItemId,
concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS ModiItemCode,
modiset.EnglishName,
modiset.LocalName,
modiset.OtherName,
modilist.Price AS Price
FROM
((modilist)
LEFT JOIN modiset ON (((modilist.CompanyId = modiset.CompanyId) AND (modilist.BrandId = modiset.BrandId) AND (modilist.OutletId = modiset.OutletId) AND (modilist.ModiSetId = modiset.ModiSetId))))
ORDER BY
CategoryId ASC,
ItemId ASC,
ModiItemId ASC,
ModiSetId ASC ;

-- ----------------------------
-- View structure for view_orderdetail
-- ----------------------------
DROP VIEW IF EXISTS `view_orderdetail`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_orderdetail` AS SELECT
orderingdetail.CompanyId AS CompanyId,
orderingdetail.BrandId AS BrandId,
orderingdetail.OutletId AS OutletId,
orderingdetail.SystemDate AS SystemDate,
orderingdetail.TableNo AS TableNo,
orderingdetail.StartTime AS StartTime,
orderingdetail.ItemNo AS ItemNo,
orderingdetail.ItemId AS ItemId,
orderingdetail.ReferenceId AS ReferenceId,
orderingdetail.ItemName AS ItemName,
orderingdetail.LocalName AS LocalName,
orderingdetail.EnglishName AS EnglishName,
orderingdetail.OtherName AS OtherName,
orderingdetail.SizeId AS SizeId,
orderingdetail.SizeName AS SizeName,
orderingdetail.SizeLocalName AS SizeLocalName,
orderingdetail.SizeEnglishName AS SizeEnglishName,
orderingdetail.SizeOtherName AS SizeOtherName,
orderingdetail.OrgSize AS OrgSize,
orderingdetail.DepartmentId AS DepartmentId,
orderingdetail.CategoryId AS CategoryId,
orderingdetail.AddModiCode AS AddModiCode,
orderingdetail.TotalAmount AS TotalAmount,
orderingdetail.Quantity AS Quantity,
orderingdetail.OrgQty AS OrgQty,
orderingdetail.UnitPrice AS UnitPrice,
orderingdetail.Free AS Free,
orderingdetail.noService AS noService,
orderingdetail.noVat AS noVat,
orderingdetail.`Status` AS `Status`,
orderingdetail.PrintTo AS PrintTo,
orderingdetail.NeedPrint AS NeedPrint,
orderingdetail.LocalPrint AS LocalPrint,
orderingdetail.KitchenLang AS KitchenLang,
orderingdetail.Parent AS Parent,
orderingdetail.Child AS Child,
orderingdetail.OrderDate AS OrderDate,
orderingdetail.OrderTime AS OrderTime,
orderingdetail.KitchenNote AS KitchenNote,
orderingdetail.MainItem AS MainItem,
`fGetImageURL`(`orderingdetail`.`CompanyId`,`orderingdetail`.`BrandId`,`orderingdetail`.`OutletId`,`orderingdetail`.`ItemId`) AS image,
`fOrderingDetailItemTotalAmount`(`orderingdetail`.`CompanyId`,`orderingdetail`.`BrandId`,`orderingdetail`.`OutletId`,`orderingdetail`.`SystemDate`,`orderingdetail`.`TableNo`,`orderingdetail`.`StartTime`,`orderingdetail`.`ItemNo`) AS TotalAmountSummery
from `orderingdetail` ;

-- ----------------------------
-- View structure for view_ordering
-- ----------------------------
DROP VIEW IF EXISTS `view_ordering`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_ordering` AS SELECT
ordering.CompanyId AS CompanyId,
ordering.BrandId AS BrandId,
ordering.OutletId AS OutletId,
ordering.TableNo AS TableNo,
ordering.ItemNo AS ItemNo,
ordering.ItemId AS ItemId,
ordering.ItemName AS ItemName,
ordering.LocalName AS LocalName,
ordering.EnglishName AS EnglishName,
ordering.OtherName AS OtherName,
ordering.SizeName AS SizeName,
ordering.SizeLocalName AS SizeLocalName,
ordering.SizeEnglishName AS SizeEnglishName,
ordering.SizeOtherName AS SizeOtherName,
ordering.SizeId AS SizeId,
ordering.OrgSize AS OrgSize,
ordering.DepartmentId AS DepartmentId,
ordering.CategoryId AS CategoryId,
ordering.AddModiCode AS AddModiCode,
ordering.TotalAmount AS TotalAmount,
ordering.Quantity AS Quantity,
ordering.OrgQty AS OrgQty,
ordering.UnitPrice AS UnitPrice,
ordering.Free AS Free,
ordering.noService AS noService,
ordering.noVat AS noVat,
ordering.`Status` AS `Status`,
ordering.PrintTo AS PrintTo,
ordering.NeedPrint AS NeedPrint,
ordering.LocalPrint AS LocalPrint,
ordering.KitchenLang AS KitchenLang,
ordering.Parent AS Parent,
ordering.Child AS Child,
ordering.OrderDate AS OrderDate,
ordering.OrderTime AS OrderTime,
ordering.KitchenNote AS KitchenNote,
ordering.SystemDate AS SystemDate,
ordering.StartTime AS StartTime,
ordering.ReferenceId AS ReferenceId,
ordering.MainItem AS MainItem,
`fGetImageURL`(`ordering`.`CompanyId`,`ordering`.`BrandId`,`ordering`.`OutletId`,`ordering`.`ItemId`) AS image,
`fOrderingItemTotalAmount`(`ordering`.`CompanyId`,`ordering`.`BrandId`,`ordering`.`OutletId`,`ordering`.`SystemDate`,`ordering`.`TableNo`,`ordering`.`StartTime`,`ordering`.`ItemNo`) AS TotalAmountSummery
from `ordering` ;

-- ----------------------------
-- View structure for view_outletsetting
-- ----------------------------
DROP VIEW IF EXISTS `view_outletsetting`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_outletsetting` AS SELECT
outletsetting.CompanyId,
outletsetting.BrandId,
outletsetting.OutletId,
outletsetting.MaxQty,
SUBSTRING("999999999", 1, outletsetting.MaxQty) AS QtyFormat,
outletsetting.Locallanguage,
outletsetting.PosTimeOut,
outletsetting.PosTimeStamp,
outletsetting.ServerTimeStamp
FROM
outletsetting ;

-- ----------------------------
-- View structure for view_productdata
-- ----------------------------
DROP VIEW IF EXISTS `view_productdata`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_productdata` AS SELECT
product.CompanyId AS CompanyId,
product.BrandId AS BrandId,
product.OutletId AS OutletId,
product.ItemId AS ItemId,
'' AS ItemName,
`fCheckEmpty`(`product`.`LocalName`,'N/A') AS LocalName,
`fCheckEmpty`(`product`.`EnglishName`,'N/A') AS EnglishName,
`fCheckEmpty`(`product`.`OtherName`,'N/A') AS OtherName,
product.CategoryId AS CategoryId,
product.DepartmentId AS DepartmentId,
product.ShowOnCategory AS ShowOnCategory,
product.PrintTo AS PrintTo,
product.LocalPrint AS LocalPrint,
product.KitchenLang AS KitchenLang,
product.ReduceQty AS ReduceQty,
product.QtyOnHand AS QtyOnHand,
product.StockOut AS StockOut,
`fGetImageURL`(`product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`ItemId`) AS image,
(
	SELECT getProductDefaultPrice(
		product.CompanyId,product.BrandId,product.OutletId,product.ItemId
	)
) AS Price,
product.SeqNo,
IF(product.is_active IS NULL,0,product.is_active) AS is_active
FROM
(product
LEFT JOIN productimage ON (((product.CompanyId = productimage.CompanyId) AND (product.BrandId = productimage.BrandId) AND (product.OutletId = productimage.OutletId) AND (product.ItemId = productimage.ItemId))))
WHERE
product.is_active = 1
ORDER BY
productimage.CompanyId ASC,
productimage.BrandId ASC,
productimage.OutletId ASC,
product.SeqNo ASC ;

-- ----------------------------
-- View structure for view_productrecommend
-- ----------------------------
DROP VIEW IF EXISTS `view_productrecommend`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_productrecommend` AS SELECT
product.CompanyId AS CompanyId,
product.BrandId AS BrandId,
product.OutletId AS OutletId,
product.ItemId AS ItemId,
'' AS ItemName,
`fCheckEmpty`(`product`.`LocalName`,'N/A') AS LocalName,
`fCheckEmpty`(`product`.`EnglishName`,'N/A') AS EnglishName,
`fCheckEmpty`(`product`.`OtherName`,'N/A') AS OtherName,
product.CategoryId AS CategoryId,
product.DepartmentId AS DepartmentId,
product.ShowOnCategory AS ShowOnCategory,
product.PrintTo AS PrintTo,
product.LocalPrint AS LocalPrint,
product.KitchenLang AS KitchenLang,
product.ReduceQty AS ReduceQty,
product.QtyOnHand AS QtyOnHand,
product.StockOut AS StockOut,
`fGetImageURL`(`product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`ItemId`) AS image,
(
	SELECT getProductDefaultPrice(
		product.CompanyId,product.BrandId,product.OutletId,product.ItemId
	)
) AS Price,
productrecommend.SeqNo
FROM
(product)
RIGHT JOIN productrecommend ON productrecommend.CompanyId = product.CompanyId AND productrecommend.BrandId = product.BrandId AND productrecommend.OutletId = product.OutletId AND productrecommend.ItemId = product.ItemId
WHERE
product.ItemId IS NOT NULL AND
product.is_active = 1
ORDER BY
productrecommend.CompanyId ASC,
productrecommend.BrandId ASC,
productrecommend.OutletId ASC,
productrecommend.SeqNo ASC ;

-- ----------------------------
-- View structure for view_productsizeall
-- ----------------------------
DROP VIEW IF EXISTS `view_productsizeall`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_productsizeall` AS SELECT
productsize.SizeId,
#productsize.SizeLocalName,
#productsize.SizeEnglishName,
#productsize.SizeOtherName,
fCheckEmpty(productsize.SizeLocalName, 'N/A') as SizeLocalName,
fCheckEmpty(productsize.SizeEnglishName, 'N/A') as SizeEnglishName,
fCheckEmpty(productsize.SizeOtherName, 'N/A') as SizeOtherName,
productsize.DefaultSize,
productsize.Price,
productsize.Free,
productsize.noService,
productsize.noVat,
productsize.CompanyId,
productsize.BrandId,
productsize.OutletId,
productsize.ItemId,
productsize.ReduceQty,
productsize.QtyOnHand,
productsize.StockOut
FROM
productsize ;

-- ----------------------------
-- View structure for view_table
-- ----------------------------
DROP VIEW IF EXISTS `view_table`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_table` AS SELECT
`table`.CompanyId,
`table`.BrandId,
`table`.OutletId,
`table`.SystemDate,
`table`.TableNo,
IF (`table`.`StartTime` IS NULL , '00:00:00' , `table`.`StartTime`) AS StartTime,
`table`.`Status`,
IF (`table`.`StartTime` <> '' AND
		`table`.`Status` = 'N'  , '1','0') AS CanOrder,
IF (`table`.`TableType` IS NULL OR `table`.`TableType` = '' , '1', '0') AS DineIn,
IF (`table`.`TableType` = 'T', '1', '0') AS TakeHome,
IF (`table`.`TableType` = 'R', '1', '0') AS RoomService,
IF (`table`.Pax IS NULL , 0 , `table`.Pax) AS Pax,
IF (`table`.is_active IS NULL,0,`table`.is_active) AS is_active
FROM
`table`
WHERE
`table`.is_active = 1 ;

-- ----------------------------
-- Procedure structure for del_clearOrdering
-- ----------------------------
DROP PROCEDURE IF EXISTS `del_clearOrdering`;
delimiter ;;
CREATE PROCEDURE `del_clearOrdering`(IN TABLENO VARCHAR(8))
BEGIN
   DELETE FROM ordering WHERE ordering.TableNo = TABLENO;
   DELETE FROM orderingdetail WHERE orderingdetail.TableNo = TABLENO;
   UPDATE `table` SET `table`.StartTime = '', `table`.`Status`='',`table`.Pax = 0 WHERE `table`.TableNo = TABLENO;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_defaultFunction
-- ----------------------------
DROP FUNCTION IF EXISTS `del_defaultFunction`;
delimiter ;;
CREATE FUNCTION `del_defaultFunction`(pAmt1 DECIMAL(18,2),pAmt2 DECIMAL(18,2))
 RETURNS decimal(18,2)
BEGIN
	DECLARE diffAmt DECIMAL(18,2);
	  
	SET diffAmt = pAmt1 - pAmt2;
		
	RETURN diffAmt;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_fCallBrandByID
-- ----------------------------
DROP FUNCTION IF EXISTS `del_fCallBrandByID`;
delimiter ;;
CREATE FUNCTION `del_fCallBrandByID`(`pCompanyCode` VARCHAR(10), `pBrandCode` VARCHAR(10))
 RETURNS varchar(100) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
	DECLARE BrandName   VARCHAR(100);

	SET BrandName = ( SELECT brand.BrandName FROM brand WHERE brand.CompanyId = pCompanyCode AND brand.BrandId = pBrandCode  LIMIT 1);
		
	RETURN BrandName;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_fCallCompanyByID
-- ----------------------------
DROP FUNCTION IF EXISTS `del_fCallCompanyByID`;
delimiter ;;
CREATE FUNCTION `del_fCallCompanyByID`(`pCompanyCode` VARCHAR(4))
 RETURNS varchar(100) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
	DECLARE CompanyName VARCHAR(100);
	#SET CompanyName = CONCAT('COMPANY');
	SET CompanyName = (SELECT `company`.`CompanyName` FROM `company` WHERE `company`.`CompanyId` = pCompanyCode LIMIT 1 );

	RETURN CompanyName;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_fCallOutletByID
-- ----------------------------
DROP FUNCTION IF EXISTS `del_fCallOutletByID`;
delimiter ;;
CREATE FUNCTION `del_fCallOutletByID`(`pCompanyCode` VARCHAR(10), `pBrandCode` VARCHAR(10), `pOutletCode` VARCHAR(10))
 RETURNS varchar(100) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
	DECLARE OutletName VARCHAR(100);
	  
	SET OutletName = ( SELECT outlet.OutletName FROM outlet WHERE outlet.CompanyId = pCompanyCode AND outlet.BrandId = pBrandCode AND outlet.OutletId = pOutletCode LIMIT 1 );
		
	RETURN OutletName;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_fCallVat
-- ----------------------------
DROP FUNCTION IF EXISTS `del_fCallVat`;
delimiter ;;
CREATE FUNCTION `del_fCallVat`(`priceInt` INT, `vat` INT)
 RETURNS decimal(14,4)
BEGIN
DECLARE ReturnData DECIMAL(14,4);

SET ReturnData = priceInt * (vat / 100);
	RETURN ReturnData;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_fCallVat2
-- ----------------------------
DROP FUNCTION IF EXISTS `del_fCallVat2`;
delimiter ;;
CREATE FUNCTION `del_fCallVat2`(`priceInt` INT)
 RETURNS decimal(14,2)
BEGIN
DECLARE ReturnData DECIMAL(14,2);
SET ReturnData = priceInt * 7 / 100;
	RETURN ReturnData;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_fOrderingItemQuantity
-- ----------------------------
DROP FUNCTION IF EXISTS `del_fOrderingItemQuantity`;
delimiter ;;
CREATE FUNCTION `del_fOrderingItemQuantity`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3))
 RETURNS decimal(8,4)
BEGIN 
	
	DECLARE result decimal(8,4) DEFAULT 0 ;

	SET result = (
		SELECT SUM(if( Free = 1 , 0 , Quantity)) 
			FROM `ordering` 
			WHERE `ordering`.CompanyId = pCompanyId AND
			`ordering`.BrandId = pBrandId AND
			`ordering`.OutletId = pOutletId AND
			`ordering`.SystemDate = pSystemDate AND
			`ordering`.TableNo = pTableNo AND
			`ordering`.StartTime = pStartTime AND 
			`ordering`.ItemNo = pItemNo 
		);

	RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for del_getItemReferenceId_back
-- ----------------------------
DROP FUNCTION IF EXISTS `del_getItemReferenceId_back`;
delimiter ;;
CREATE FUNCTION `del_getItemReferenceId_back`()
 RETURNS varchar(50) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
	#Routine body goes here...

	RETURN (
					LOWER(CONCAT(
							LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0'), 
							LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0'), '-',
							LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0'), '-', 
							'4',
							LPAD(HEX(FLOOR(RAND() * 0x0fff)), 3, '0'), '-', 
							HEX(FLOOR(RAND() * 4 + 8)), 
							LPAD(HEX(FLOOR(RAND() * 0x0fff)), 3, '0'), '-', 
							LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0'),
							LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0'),
							LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0')))
);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for del_getModifyAll
-- ----------------------------
DROP PROCEDURE IF EXISTS `del_getModifyAll`;
delimiter ;;
CREATE PROCEDURE `del_getModifyAll`(IN `ID` VARCHAR(8))
BEGIN
   SELECT * FROM view_modifylistall WHERE view_modifylistall.CategoryId = ID;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for del_getModifyByProduct
-- ----------------------------
DROP PROCEDURE IF EXISTS `del_getModifyByProduct`;
delimiter ;;
CREATE PROCEDURE `del_getModifyByProduct`(IN `ItemId` VARCHAR(8), IN `CategoryId` VARCHAR(2))
BEGIN
   SELECT * FROM view_modifylistall WHERE view_modifylistall.ItemId = ItemId or view_modifylistall.CategoryId = CategoryId;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for del_getPnewItemNO
-- ----------------------------
DROP PROCEDURE IF EXISTS `del_getPnewItemNO`;
delimiter ;;
CREATE PROCEDURE `del_getPnewItemNO`(IN `TABLENO` VARCHAR(8), OUT `ITEMNO` VARCHAR(10))
BEGIN
   DECLARE ReturnNOID VARCHAR(10);
   SET ReturnNOID = (SELECT 1);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for del_getProductSizeAll
-- ----------------------------
DROP PROCEDURE IF EXISTS `del_getProductSizeAll`;
delimiter ;;
CREATE PROCEDURE `del_getProductSizeAll`(IN `ID` VARCHAR(8))
BEGIN
   SELECT * FROM view_productsizeall WHERE view_productsizeall.ItemId = ID;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for del_pTableInOutletSum
-- ----------------------------
DROP PROCEDURE IF EXISTS `del_pTableInOutletSum`;
delimiter ;;
CREATE PROCEDURE `del_pTableInOutletSum`(IN `pCaompnyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletID` VARCHAR(4))
BEGIN
	SELECT
	view_table.CompanyId,
	view_table.BrandId,
	view_table.OutletId,
	sum(view_table.CanOrder) as CanOrder,
	sum(view_table.DineIn) as DineIn,
	sum(view_table.TakeHome) as TakeHome,
	sum(view_table.RoomService) as RoomService,
	sum(view_table.Pax) as Pax
	FROM view_table
	WHERE view_table.CompanyId = pCaompnyId AND
				view_table.BrandId = pBrandId AND
				view_table.OutletId = pOutletID;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for del_pWriteLog
-- ----------------------------
DROP PROCEDURE IF EXISTS `del_pWriteLog`;
delimiter ;;
CREATE PROCEDURE `del_pWriteLog`(IN `pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pErrorNo` VARCHAR(10), `pErrorMessage` VARCHAR(500))
BEGIN
	#INSERT error to log

	INSERT INTO `log`(CompanyId,BrandId,OutletId,SystemDate,ErrorNo,ErrorMessage) 
	VALUES (pCompanyId,pBrandId,pOutletId,pSystemDate,pErrorNo,pErrorMessage);

END
;;
delimiter ;

-- ----------------------------
-- Function structure for fCheckCanOrdering
-- ----------------------------
DROP FUNCTION IF EXISTS `fCheckCanOrdering`;
delimiter ;;
CREATE FUNCTION `fCheckCanOrdering`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8))
 RETURNS int(1)
BEGIN
	
	DECLARE result int(1);
	SET result = 0;
	SET result = (SELECT
						IF (`table`.`StartTime` <> '' AND
								`table`.`Status` = 'N'  , '1' , '0' ) as 'CanOrder'
						FROM `table` 
						WHERE `table`.CompanyId = pCompanyId AND
						`table`.BrandId = pBrandId AND
						`table`.OutletId = pOutletId AND
						`table`.SystemDate = pSystemDate AND
						`table`.TableNo = pTableNo AND
						`table`.StartTime = pStartTime
						);


	IF (result IS NULL ) THEN
		SET result =  0;
	END IF;

RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for fCheckCanSendOrdering
-- ----------------------------
DROP FUNCTION IF EXISTS `fCheckCanSendOrdering`;
delimiter ;;
CREATE FUNCTION `fCheckCanSendOrdering`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8))
 RETURNS int(1)
BEGIN
	
	DECLARE result int(1);
	SET result = 0;
	SET result = (SELECT
						IF (`table`.`StartTime` <> '' AND
								(`table`.`active_Device` <> 'P' OR `table`.`active_Device` IS NULL) AND
								`table`.`Status` = 'N'  , '1' , '0' ) as 'CanOrder'
						FROM `table` 
						WHERE `table`.CompanyId = pCompanyId AND
						`table`.BrandId = pBrandId AND
						`table`.OutletId = pOutletId AND
						`table`.SystemDate = pSystemDate AND
						`table`.TableNo = pTableNo AND
						`table`.StartTime = pStartTime
						);


	IF (result IS NULL ) THEN
		SET result =  0;
	END IF;

RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for fCheckEmpty
-- ----------------------------
DROP FUNCTION IF EXISTS `fCheckEmpty`;
delimiter ;;
CREATE FUNCTION `fCheckEmpty`(`strText` VARCHAR(300), `defaultText` VARCHAR(100))
 RETURNS varchar(100) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
DECLARE ReturnData VARCHAR(300);
  SET ReturnData = IF (strText IS NULL OR strText = '', defaultText , strText);
	RETURN ReturnData;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for fgetCategoryAndProductName
-- ----------------------------
DROP FUNCTION IF EXISTS `fgetCategoryAndProductName`;
delimiter ;;
CREATE FUNCTION `fgetCategoryAndProductName`(pCompanyId varchar(100),pBrandId varchar(100),pOutletId varchar(100),pCategoryId varchar(100),pItemId varchar(100))
 RETURNS varchar(200) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
	# This feature is duplicate for modify
	DECLARE ReturnData VARCHAR(200);
	DECLARE CategoryName VARCHAR (200);
	DECLARE ItemName VARCHAR(200);

	
	IF !(ISNULL(pCategoryId)) THEN
		SET CategoryName = (
		SELECT category.EnglishName FROM category
			 WHERE 
					category.CompanyId   = pCompanyId  AND
					category.BrandId     = pBrandId AND
					category.OutletId    = pOutletId AND
					category.CategoryId  = pCategoryId
		);
  END IF;
	
	IF !(ISNULL(pItemId)) THEN
		SET ItemName = (
		SELECT product.EnglishName FROM product
			 WHERE 
					product.CompanyId   = pCompanyId  AND
					product.BrandId     = pBrandId AND
					product.OutletId    = pOutletId AND
					product.ItemId  = pItemId
		);
  END IF;
	
	SET CategoryName = IF(CategoryName IS NULL,'', CategoryName);
	SET ItemName = IF(ItemName IS NULL,'', ItemName);

	SET ReturnData = CONCAT(CategoryName,ItemName);
-- 	SET ReturnData = ItemName;
	
	RETURN IF(ReturnData IS NULL,'', ReturnData);
END
;;
delimiter ;

-- ----------------------------
-- Function structure for fGetImageURL
-- ----------------------------
DROP FUNCTION IF EXISTS `fGetImageURL`;
delimiter ;;
CREATE FUNCTION `fGetImageURL`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pItemId` VARCHAR(8))
 RETURNS varchar(100) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
	#Routine body goes here...
	DECLARE imagePath VARCHAR(50);
	DECLARE ImageName VARCHAR(200);
	DECLARE ImageURL VARCHAR(200);
	
	IF (LOCATE('M',pItemId,1) > 0 ) THEN		# Locate modifier item
		SET ImageURL = '';
	
	ELSE
		# Product Item.
		SET imagePath = CONCAT('/',pCompanyId,'/',pBrandId,'/',pOutletId,'/');
		SET ImageName = (SELECT if (productimage.image IS NULL OR productimage.image = '', 'default.jpg', productimage.image) as image
						FROM productimage
						WHERE productimage.CompanyId = pCompanyId AND
						productimage.BrandId = pBrandId AND 
						productimage.OutletId = pOutletId AND
						productimage.ItemId = pItemId);


		SET ImageURL = CONCAT(imagePath, if (ImageName IS NULL OR ImageName = '','default.jpg', ImageName));
	
	END IF;


	RETURN ImageURL;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for fOrderingDetailItemTotalAmount
-- ----------------------------
DROP FUNCTION IF EXISTS `fOrderingDetailItemTotalAmount`;
delimiter ;;
CREATE FUNCTION `fOrderingDetailItemTotalAmount`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3))
 RETURNS decimal(14,4)
BEGIN 
	
	DECLARE result decimal(14,4) DEFAULT 0 ;

	SET result = (
		SELECT SUM(TotalAmount) as TotalAmountSummery
			FROM `orderingdetail` 
			WHERE `orderingdetail`.CompanyId = pCompanyId AND
			`orderingdetail`.BrandId = pBrandId AND
			`orderingdetail`.OutletId = pOutletId AND
			`orderingdetail`.SystemDate = pSystemDate AND
			`orderingdetail`.TableNo = pTableNo AND
			`orderingdetail`.StartTime = pStartTime AND
			`orderingdetail`.ItemNo = pItemNo 
		);

	RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for fOrderingItemChangeQty
-- ----------------------------
DROP FUNCTION IF EXISTS `fOrderingItemChangeQty`;
delimiter ;;
CREATE FUNCTION `fOrderingItemChangeQty`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3),`pQty` DECIMAL(8,4))
 RETURNS int(1)
BEGIN 
	
	DECLARE result int(1);
		SET result =  1;
		
	UPDATE ordering
	SET Quantity = pQty
		WHERE `ordering`.CompanyId = pCompanyId AND
		`ordering`.BrandId = pBrandId AND
		`ordering`.OutletId = pOutletId AND
		`ordering`.SystemDate = pSystemDate AND
		`ordering`.TableNo = pTableNo AND
		`ordering`.StartTime = pStartTime AND
		`ordering`.ItemNo = pItemNo ;
		

	RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for fOrderingItemDelete
-- ----------------------------
DROP FUNCTION IF EXISTS `fOrderingItemDelete`;
delimiter ;;
CREATE FUNCTION `fOrderingItemDelete`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3))
 RETURNS int(1)
BEGIN 
	
	DECLARE result int(1);
		SET result =  1;
		
-- 	DECLARE `_rollback` BOOL DEFAULT 0;
-- 	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	DELETE FROM `ordering` 
		WHERE `ordering`.CompanyId = pCompanyId AND
		`ordering`.BrandId = pBrandId AND
		`ordering`.OutletId = pOutletId AND
		`ordering`.SystemDate = pSystemDate AND
		`ordering`.TableNo = pTableNo AND
		`ordering`.StartTime = pStartTime AND
		`ordering`.ItemNo = pItemNo ;
	

-- 	IF `_rollback` THEN
-- 			ROLLBACK;
-- 	ELSE
-- 			COMMIT;
-- 	END IF;

	RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for fOrderingItemTotalAmount
-- ----------------------------
DROP FUNCTION IF EXISTS `fOrderingItemTotalAmount`;
delimiter ;;
CREATE FUNCTION `fOrderingItemTotalAmount`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3))
 RETURNS decimal(14,4)
BEGIN 
	
	DECLARE result decimal(14,4) DEFAULT 0 ;

	SET result = (
		SELECT SUM(TotalAmount) as TotalAmountSummery
			FROM `ordering` 
			WHERE `ordering`.CompanyId = pCompanyId AND
			`ordering`.BrandId = pBrandId AND
			`ordering`.OutletId = pOutletId AND
			`ordering`.SystemDate = pSystemDate AND
			`ordering`.TableNo = pTableNo AND
			`ordering`.StartTime = pStartTime AND
			`ordering`.ItemNo = pItemNo 
		);

	RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for fTestReturn
-- ----------------------------
DROP FUNCTION IF EXISTS `fTestReturn`;
delimiter ;;
CREATE FUNCTION `fTestReturn`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8))
 RETURNS varchar(255) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN 
	
	DECLARE result VARCHAR(10);
		SET result =  'Complete';
		
-- 	DECLARE `_rollback` BOOL DEFAULT 0;
-- 	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;


-- 	DELETE FROM `ordering` 
-- 		WHERE `ordering`.CompanyId = pCompanyId AND
-- 		`ordering`.BrandId = pBrandId AND
-- 		`ordering`.OutletId = pOutletId AND
-- 		`ordering`.SystemDate = pSystemDate AND
-- 		`ordering`.TableNo = pTableNo AND
-- 		`ordering`.StartTime = pStartTime AND
-- 		`ordering`.ItemNo = pItemNo ;
	

-- 	IF `_rollback` THEN
-- 			ROLLBACK;
-- 	ELSE
-- 			COMMIT;
-- 	END IF;

	
	RETURN  result;


END
;;
delimiter ;

-- ----------------------------
-- Function structure for getItemReferenceId
-- ----------------------------
DROP FUNCTION IF EXISTS `getItemReferenceId`;
delimiter ;;
CREATE FUNCTION `getItemReferenceId`()
 RETURNS decimal(11,8)
BEGIN

	# This feature is duplicate for modify
	DECLARE ReturnData DECIMAL(11,8); DECLARE TRADE INT(1);
  #SET TRADE = SELECT SLEEP(0.1);
  #SET ReturnData = TIME_TO_SEC(TIME(NOW())) / 180;
	#SET ReturnData = ROUND(RAND()*10000,0) + RAND();
	
	# Need return value decimal xxx.xxxxxxxx (decimal 3.8)
	SET ReturnData = ROUND(RAND()*1000,0) + RAND();
	RETURN ReturnData;
	

							
END
;;
delimiter ;

-- ----------------------------
-- Function structure for getNewItemNO
-- ----------------------------
DROP FUNCTION IF EXISTS `getNewItemNO`;
delimiter ;;
CREATE FUNCTION `getNewItemNO`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8))
 RETURNS int(3)
BEGIN

	DECLARE ItemNo_OrderDetail int(3);
	DECLARE ItemNo_Ordering int(3);
	DECLARE newItemNo int(3);
	DECLARE currItemNo int(3);

	SET ItemNo_OrderDetail = (
	SELECT MAX(ItemNo) AS currItemNo 
	FROM `orderingdetail` 
	WHERE CompanyId = pCompanyId AND BrandId = pBrandId 
				AND	OutletId = pOutletId AND SystemDate = pSystemDate 
				AND TableNo = pTableNo AND StartTime = pStartTime);

	SET ItemNo_Ordering = (
	SELECT MAX(ItemNo) AS currItemNo 
	FROM `ordering` 
	WHERE CompanyId = pCompanyId AND BrandId = pBrandId AND	
				OutletId = pOutletId AND SystemDate = pSystemDate AND 
				TableNo = pTableNo AND StartTime = pStartTime);


	SET ItemNo_Ordering = if (ItemNo_Ordering IS NULL , 0, ItemNo_Ordering );
	SET ItemNo_OrderDetail = if (ItemNo_OrderDetail IS NULL , 0, ItemNo_OrderDetail );
	
	# get max itemNo
	SET currItemNo = (GREATEST(ItemNo_Ordering,ItemNo_OrderDetail));
	
	# check selforder neew startt itemno = 501 
	SET newItemNo = IF(currItemNo < 501,501,currItemNo+1);
	
	
	RETURN newItemNo;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for getProductDefaultPrice
-- ----------------------------
DROP FUNCTION IF EXISTS `getProductDefaultPrice`;
delimiter ;;
CREATE FUNCTION `getProductDefaultPrice`(pCompanyId varchar(100),pBrandId varchar(100),pOutletId varchar(100),pItemId varchar(100))
 RETURNS decimal(12,8)
BEGIN
	# This feature is duplicate for modify
	DECLARE ReturnData DECIMAL(12,8);
  SET ReturnData = (
	SELECT productsize.Price FROM productsize
		 WHERE 
				productsize.CompanyId   = pCompanyId  AND
				productsize.BrandId     = pBrandId AND
				productsize.OutletId    = pOutletId AND
				productsize.ItemId      = pItemId AND
				productsize.DefaultSize = 1
	);
  
	RETURN IF(ReturnData IS NULL,0, ReturnData);					
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pBanner
-- ----------------------------
DROP PROCEDURE IF EXISTS `pBanner`;
delimiter ;;
CREATE PROCEDURE `pBanner`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4))
BEGIN
	
DECLARE cUrl VARCHAR(100) ;
set cUrl = CONCAT('/',pCompanyId,'/',pBrandId,'/',pOutletId,'/banner/');
# Get Langaage value
SELECT 
	fCheckEmpty(CONCAT(cUrl,image1),'') as image1,
	fCheckEmpty(CONCAT(cUrl,image2),'') as image2,
	fCheckEmpty(CONCAT(cUrl,image3),'') as image3,
	fCheckEmpty(CONCAT(cUrl,image4),'') as image4,
	fCheckEmpty(CONCAT(cUrl,image5),'') as image5
FROM `banner`
WHERE CompanyId = pCompanyID AND 
			BrandId = pBrandID AND 
			OutletId = pOutletId;



	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pCallBilling
-- ----------------------------
DROP PROCEDURE IF EXISTS `pCallBilling`;
delimiter ;;
CREATE PROCEDURE `pCallBilling`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8), IN `pFlag` INT(1) UNSIGNED)
BEGIN


	UPDATE `table`
	SET `table`.CallCheckBill =  pFlag
	WHERE `table`.CompanyId  = pCompanyId AND
				`table`.BrandId    = pBrandId AND
				`table`.OutletId   = pOutletId AND
				`table`.SystemDate = pSystemDate AND
				`table`.TableNo = pTableNo AND
				`table`.StartTime = pStartTime;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pCallWaiter
-- ----------------------------
DROP PROCEDURE IF EXISTS `pCallWaiter`;
delimiter ;;
CREATE PROCEDURE `pCallWaiter`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8))
BEGIN


	UPDATE `table`
	SET `table`.CallWaiter = 1
	WHERE `table`.CompanyId  = pCompanyId AND
				`table`.BrandId    = pBrandId AND
				`table`.OutletId   = pOutletId AND
				`table`.SystemDate = pSystemDate AND
				`table`.TableNo = pTableNo AND
				`table`.StartTime = pStartTime;


END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pCheckCanOrdering
-- ----------------------------
DROP PROCEDURE IF EXISTS `pCheckCanOrdering`;
delimiter ;;
CREATE PROCEDURE `pCheckCanOrdering`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8))
BEGIN
	
		SELECT
		IF (`table`.`StartTime` <> '' AND
				`table`.`Status` = 'N'  , '1' , '0' ) as 'IsCanOrder',
		`table`.`Status`,
		`table`.`StartTime`,
		`table`.`active_Device`
		FROM `table` 
		WHERE `table`.CompanyId = pCompanyId AND
		`table`.BrandId = pBrandId AND
		`table`.OutletId = pOutletId AND
		`table`.SystemDate = pSystemDate AND
		`table`.TableNo = pTableNo;
		
-- 		`table`.StartTime = pStartTime;
					
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pInputPax
-- ----------------------------
DROP PROCEDURE IF EXISTS `pInputPax`;
delimiter ;;
CREATE PROCEDURE `pInputPax`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8),IN pPax VARCHAR(3))
BEGIN


	UPDATE `table`
	SET `table`.Pax = pPax
	WHERE `table`.CompanyId  = pCompanyId AND
				`table`.BrandId    = pBrandId AND
				`table`.OutletId   = pOutletId AND
				`table`.SystemDate = pSystemDate AND
				`table`.TableNo = pTableNo AND
				`table`.StartTime = pStartTime;


END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pLanguageCaption
-- ----------------------------
DROP PROCEDURE IF EXISTS `pLanguageCaption`;
delimiter ;;
CREATE PROCEDURE `pLanguageCaption`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4),`pModule` VARCHAR(100))
BEGIN

	DECLARE localLang VARCHAR(3) ;
	
# Get Outlet Setting local Language.
	SET localLang = (SELECT Locallanguage FROM outletsetting WHERE CompanyId = pCompanyID AND BrandId = pBrandID AND OutletId = pOutletId);

	
# Get Langaage value

SELECT 
	Module,Section,Caption,'' AS CurrentCaption,
	Eng AS EnglishCaption,
	CASE WHEN localLang = "Tha" THEN Tha
			 WHEN LocalLang = "Chi" THEN Chi
			 WHEN LocalLang = "Lao" THEN Lao
			 WHEN LocalLang = "Mya" THEN Mya
			 ELSE Eng	# Default value to English Caption.
	END AS LocalCaption
FROM `language`
WHERE UPPER(`language`.Module) = UPPER(pModule);



SELECT '2' as LanguageCode , LanguageName, LanguageLocal FROM languagemaster WHERE languagemaster.`Code` = localLang;
	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pMoveOrderingToOrderDetail
-- ----------------------------
DROP PROCEDURE IF EXISTS `pMoveOrderingToOrderDetail`;
delimiter ;;
CREATE PROCEDURE `pMoveOrderingToOrderDetail`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8))
BEGIN

	INSERT INTO orderingdetail SELECT * FROM ordering
	WHERE ordering.CompanyId  = pCompanyId AND
				ordering.BrandId    = pBrandId AND
				ordering.OutletId   = pOutletId AND
				ordering.SystemDate = pSystemDate  AND
				ordering.TableNo    = pTableNo AND
				ordering.StartTime  = pStartTime;
			

	DELETE FROM ordering
	WHERE ordering.CompanyId  = pCompanyId AND
				ordering.BrandId    = pBrandId AND
				ordering.OutletId   = pOutletId AND
				ordering.SystemDate = pSystemDate  AND
				ordering.TableNo    = pTableNo AND
				ordering.StartTime  = pStartTime;
	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pOutletSetting_MasterFileTimeStamp
-- ----------------------------
DROP PROCEDURE IF EXISTS `pOutletSetting_MasterFileTimeStamp`;
delimiter ;;
CREATE PROCEDURE `pOutletSetting_MasterFileTimeStamp`(`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4))
BEGIN
	
		UPDATE `outletsetting` 
		SET MasterFileTimeStamp = CURRENT_TIME()
		WHERE `outletsetting`.CompanyId = pCompanyId AND
		`outletsetting`.BrandId = pBrandId AND
		`outletsetting`.OutletId = pOutletId ;
					
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pRunningTextCaption
-- ----------------------------
DROP PROCEDURE IF EXISTS `pRunningTextCaption`;
delimiter ;;
CREATE PROCEDURE `pRunningTextCaption`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4))
BEGIN

	DECLARE localLang VARCHAR(3) ;
	
# Get Outlet Setting local Language.
	SET localLang = (SELECT Locallanguage FROM outletsetting WHERE CompanyId = pCompanyID AND BrandId = pBrandID AND OutletId = pOutletId);

	
# Get Langaage value

SELECT 
	'' AS CurrentCaption,
	Eng AS EnglishCaption,
	CASE WHEN localLang = "Tha" THEN Tha
			 WHEN LocalLang = "Chi" THEN Chi
			 WHEN LocalLang = "Lao" THEN Lao
			 WHEN LocalLang = "Mya" THEN Mya
			 ELSE Eng	# Default value to English Caption.
	END AS LocalCaption
FROM `banner`
WHERE CompanyId = pCompanyID AND 
			BrandId = pBrandID AND 
			OutletId = pOutletId;



	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pSetItemImageName
-- ----------------------------
DROP PROCEDURE IF EXISTS `pSetItemImageName`;
delimiter ;;
CREATE PROCEDURE `pSetItemImageName`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pItemId` VARCHAR(8), IN `pImageName` VARCHAR(50))
BEGIN
	# physical path for image split by CompanyId,BrandId,OutletId
	# 

	DECLARE FoundImage INT(10);

	SET FoundImage = ( SELECT COUNT(*) as FoundImage FROM productimage
										WHERE productimage.CompanyId = pCompanyId AND
													productimage.BrandId   = pBrandId AND
													productimage.OutletId  = pOutletId AND
													productimage.ItemId    = pItemId);
									 

	IF FoundImage = 0 THEN
			#INSERT
			INSERT INTO productimage (productimage.CompanyId,productimage.BrandId,productimage.OutletId,productimage.ItemId,productimage.image)
			VALUES (pCompanyId,pBrandId,pOutletId,pItemId,pImageName);
	ELSE
			#UPDATE
			UPDATE productimage SET productimage.image = pImageName
			WHERE productimage.CompanyId = pCompanyId AND
			productimage.BrandId   = pBrandId AND
			productimage.OutletId  = pOutletId AND
			productimage.ItemId    = pItemId;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for pWelcomeText
-- ----------------------------
DROP PROCEDURE IF EXISTS `pWelcomeText`;
delimiter ;;
CREATE PROCEDURE `pWelcomeText`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4))
BEGIN

	DECLARE localLang VARCHAR(3) ;
	
# Get Outlet Setting local Language.
	SET localLang = (SELECT Locallanguage FROM outletsetting WHERE CompanyId = pCompanyID AND BrandId = pBrandID AND OutletId = pOutletId);

	
# Get Langaage value

SELECT 
	'' AS CurrentCaption,
	Eng AS EnglishCaption,
	CASE WHEN localLang = "Tha" THEN Tha
			 WHEN LocalLang = "Chi" THEN Chi
			 WHEN LocalLang = "Lao" THEN Lao
			 WHEN LocalLang = "Mya" THEN Mya
			 ELSE Eng	# Default value to English Caption.
	END AS LocalCaption
FROM `banner`
WHERE CompanyId = pCompanyID AND 
			BrandId = pBrandID AND 
			OutletId = pOutletId;



	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for rptOrderHistory
-- ----------------------------
DROP PROCEDURE IF EXISTS `rptOrderHistory`;
delimiter ;;
CREATE PROCEDURE `rptOrderHistory`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pStartDate` VARCHAR(10), IN `pEndDate` VARCHAR(10))
BEGIN

	SELECT *  FROM `orderhistory`
	WHERE `orderhistory`.CompanyId  = pCompanyId AND
				`orderhistory`.BrandId    = pBrandId AND
				`orderhistory`.OutletId   = pOutletId AND
				`orderhistory`.SystemDate BETWEEN pStartDate AND pEndDate ;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for rptOrderRankingAmt
-- ----------------------------
DROP PROCEDURE IF EXISTS `rptOrderRankingAmt`;
delimiter ;;
CREATE PROCEDURE `rptOrderRankingAmt`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pStartDate` VARCHAR(10), IN `pEndDate` VARCHAR(10))
BEGIN

	SELECT  * FROM (
				SELECT 
				`orderhistory`.CompanyId,
				`orderhistory`.BrandId,
				`orderhistory`.OutletId,
				`orderhistory`.SystemDate,
				`orderhistory`.ItemId,
				`orderhistory`.ItemName,
				`orderhistory`.LocalName,
				`orderhistory`.EnglishName,
				`orderhistory`.SizeId,
				`orderhistory`.SizeName,
				Sum(`orderhistory`.TotalAmount) AS TotalAmt,
				Sum(`orderhistory`.Quantity) AS Qty
				FROM orderhistory
				WHERE `orderhistory`.CompanyId  = pCompanyId AND
							`orderhistory`.BrandId    = pBrandId AND
							`orderhistory`.OutletId   = pOutletId AND
							`orderhistory`.SystemDate BETWEEN pStartDate AND pEndDate
				GROUP BY
						`orderhistory`.CompanyId,
						`orderhistory`.BrandId,
						`orderhistory`.OutletId,
						`orderhistory`.ItemId,
						`orderhistory`.SystemDate,
						`orderhistory`.ItemName,
						`orderhistory`.LocalName,
						`orderhistory`.EnglishName,
						`orderhistory`.SizeId,
						`orderhistory`.SizeName
	) AS P
	ORDER BY TotalAmt DESC 
	LIMIT 10 ;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for rptOrderRankingQty
-- ----------------------------
DROP PROCEDURE IF EXISTS `rptOrderRankingQty`;
delimiter ;;
CREATE PROCEDURE `rptOrderRankingQty`(IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pStartDate` VARCHAR(10), IN `pEndDate` VARCHAR(10))
BEGIN

	SELECT  * FROM (
				SELECT 
				`orderhistory`.CompanyId,
				`orderhistory`.BrandId,
				`orderhistory`.OutletId,
				`orderhistory`.SystemDate,
				`orderhistory`.ItemId,
				`orderhistory`.ItemName,
				`orderhistory`.LocalName,
				`orderhistory`.EnglishName,
				`orderhistory`.SizeId,
				`orderhistory`.SizeName,
				Sum(`orderhistory`.TotalAmount) AS TotalAmt,
				Sum(`orderhistory`.Quantity) AS Qty
				FROM orderhistory
				WHERE `orderhistory`.CompanyId  = pCompanyId AND
							`orderhistory`.BrandId    = pBrandId AND
							`orderhistory`.OutletId   = pOutletId AND
							`orderhistory`.SystemDate BETWEEN pStartDate AND pEndDate
				GROUP BY
						`orderhistory`.CompanyId,
						`orderhistory`.BrandId,
						`orderhistory`.OutletId,
						`orderhistory`.ItemId,
						`orderhistory`.SystemDate,
						`orderhistory`.ItemName,
						`orderhistory`.LocalName,
						`orderhistory`.EnglishName,
						`orderhistory`.SizeId,
						`orderhistory`.SizeName
	) AS P
	ORDER BY Qty DESC 
	LIMIT 10 ;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for test
-- ----------------------------
DROP PROCEDURE IF EXISTS `test`;
delimiter ;;
CREATE PROCEDURE `test`(OUT `pOutput` VARCHAR(100))
BEGIN
	#Routine body goes here...
	set pOutput = CONCAT("Hello MySQL : ");

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for testClearOrderingCompany
-- ----------------------------
DROP PROCEDURE IF EXISTS `testClearOrderingCompany`;
delimiter ;;
CREATE PROCEDURE `testClearOrderingCompany`()
BEGIN


	DELETE FROM ordering 	WHERE ordering.CompanyId  = 999 ;
	
END
;;
delimiter ;

-- ----------------------------
-- Function structure for test_sys_exec
-- ----------------------------
DROP FUNCTION IF EXISTS `test_sys_exec`;
delimiter ;;
CREATE FUNCTION `test_sys_exec`()
 RETURNS tinyint(4)
BEGIN
 DECLARE cmd CHAR(255);
 DECLARE result int(10);
 SET cmd=CONCAT('sudo /home/sarbac/hello_world ','Sarbajit');
--  SET result = sys_exec(cmd);
 SET result = sys_exec(cmd);

	RETURN 0;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for test_sys_exec_resetMasterTable
-- ----------------------------
DROP FUNCTION IF EXISTS `test_sys_exec_resetMasterTable`;
delimiter ;;
CREATE FUNCTION `test_sys_exec_resetMasterTable`()
 RETURNS tinyint(4)
BEGIN
 DECLARE cmd CHAR(255);
 DECLARE result int(10);
 SET cmd=CONCAT('http://localhost:3000/','001/001/001');
--  SET result = sys_exec(cmd);
 SET result = sys_exec(cmd);

	RETURN 0;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for InsertData
-- ----------------------------
DROP EVENT IF EXISTS `InsertData`;
delimiter ;;
CREATE EVENT `InsertData`
ON SCHEDULE
EVERY '1' SECOND STARTS '2019-04-22 17:27:32'
DISABLE
DO BEGIN
 INSERT INTO myTableEvents (`myTableEvents`.`name`,`myTableEvents`.`email`,`myTableEvents`.randome_string)
 VALUES ('Name','Email@thaicreate.com', getItemReferenceId() );
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table ordering
-- ----------------------------
DROP TRIGGER IF EXISTS `NewOrderTransection`;
delimiter ;;
CREATE TRIGGER `NewOrderTransection` BEFORE INSERT ON `ordering` FOR EACH ROW BEGIN
	# Default value for filed ITemReferenceID (random value)
  DECLARE VITEM decimal(12,8);
	# Calculate Total Amount
	DECLARE pTotalAmount decimal(14,4) DEFAULT 0;
	
  SET VITEM = getItemReferenceId();
  SET NEW.ReferenceId = VITEM;
	
	
	# Calculate Total Amount
	IF NEW.Free = 1 THEN
		SET NEW.TotalAmount = 0;	# Free ITem
	ELSE
		SELECT SUM( NEW.Quantity * NEW.UnitPrice ) INTO  pTotalAmount;
		SET NEW.TotalAmount = pTotalAmount;
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table ordering
-- ----------------------------
DROP TRIGGER IF EXISTS `CalculateItemUpdate`;
delimiter ;;
CREATE TRIGGER `CalculateItemUpdate` BEFORE UPDATE ON `ordering` FOR EACH ROW BEGIN
		# Calculate Total Amount
		DECLARE pTotalAmount decimal(14,4) DEFAULT 0;
		
		IF NEW.Free = 1 THEN
			SET NEW.TotalAmount = 0;	# Free ITem
		ELSE
			SELECT SUM( NEW.Quantity * NEW.UnitPrice ) INTO  pTotalAmount;
			SET NEW.TotalAmount = pTotalAmount;
		END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table orderingdetail
-- ----------------------------
DROP TRIGGER IF EXISTS `TrigerInsertOrderDetail`;
delimiter ;;
CREATE TRIGGER `TrigerInsertOrderDetail` BEFORE DELETE ON `orderingdetail` FOR EACH ROW BEGIN
-- 	INSERT INTO orderhistory 
-- 	SELECT * FROM orderingdetail
-- 	WHERE orderingdetail.CompanyId  = old.CompanyId AND
-- 				orderingdetail.BrandId    = old.BrandId AND
-- 				orderingdetail.OutletId   = old.OutletId AND
-- 				orderingdetail.SystemDate = old.SystemDate  AND
-- 				orderingdetail.TableNo    = old.TableNo AND
-- 				orderingdetail.StartTime  = old.StartTime AND
-- 				orderingdetail.ItemNo			= old.ItemNo AND
-- 				orderingdetail.ItemId			= old.ItemId AND
-- 				orderingdetail.ReferenceId = old.ReferenceId;
				
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table outletsetting
-- ----------------------------
DROP TRIGGER IF EXISTS `UpdateServerTimeStamp`;
delimiter ;;
CREATE TRIGGER `UpdateServerTimeStamp` BEFORE UPDATE ON `outletsetting` FOR EACH ROW BEGIN

	# Calculate Total Amount
	IF NEW.PosTimeStamp <> OLD.PosTimeStamp THEN
		SET NEW.ServerTimeStamp = CURRENT_TIMESTAMP;
	END IF;
	
	
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table table
-- ----------------------------
DROP TRIGGER IF EXISTS `AddCurrentTime`;
delimiter ;;
CREATE TRIGGER `AddCurrentTime` BEFORE UPDATE ON `table` FOR EACH ROW BEGIN

	DECLARE Api_Url VARCHAR(255) DEFAULT 'curl http://localhost:3000/selforder/tablestatus/';
	DECLARE Param VARCHAR(255);
	DECLARE tStatus VARCHAR(255);
	DECLARE currDateTime VARCHAR(255);
	DECLARE cmd CHAR(255);
	DECLARE result int(10);
	
	# Call Waiter
	IF OLD.CallWaiter = 0 AND NEW.CallWaiter <> 0 THEN
		SET NEW.CallWaiterTime = CURRENT_TIME;
	ELSEIF OLD.CallWaiter <> 0 AND NEW.CallWaiter = 0 THEN
		SET NEW.CallWaiterTime = NULL;
	END IF;
	
	# Call Check Bill
	IF OLD.CallCheckBill = 0 AND NEW.CallCheckBill <> 0 THEN
		SET NEW.CallCheckBillTime = CURRENT_TIME;
	ELSEIF OLD.CallCheckBill <> 0 AND NEW.CallCheckBill = 0 THEN
		SET NEW.CallCheckBillTime = NULL;
	END IF;
	
	
	# Tiger send table status update.
-- 	IF OLD.`Status` <> NEW.`Status`  THEN
-- 		CASE NEW.`Status`
-- 		WHEN "N" THEN
-- 			SET tStatus = "OPENTABLE";
-- 		WHEN "B" THEN
-- 			SET tStatus = "PRINTBILL";
-- 		ELSE
-- 			SET tStatus = "EMPTYTABLE";
-- 		END CASE;
-- 		SET Param = CONCAT(NEW.CompanyId,'/',NEW.BrandId,'/',NEW.OutletId,'/',NEW.SystemDate,'/',NEW.TableNo,'/',NEW.StartTime);
-- 		SET currDateTime = CONCAT(CURRENT_DATE,'_',CURRENT_TIME);
-- 		SET cmd = CONCAT(Api_Url,Param,'/',tStatus,'/',currDateTime);
-- 	-- 	select sys_eval('curl http://localhost:3000/selforder/tablestatus/001/001/001/001/PRINTBILL');
-- 		SET result = sys_eval(cmd);
-- 	END IF;
	
	
	
	# Close Table : Move OrderDetail to OrderHistory
	IF (OLD.`Status` = "B" AND  NEW.`Status` = "") AND
		 (OLD.`StartTime` <> "" AND NEW.`StartTime` = "") THEN
	
		# Move Table Record to OrderHeader.
		INSERT INTO `orderheader`( CompanyId,BrandId,OutletId,SystemDate,TableNo,StartTime,TableType,Pax)
		SELECT CompanyId,BrandId,OutletId,SystemDate,TableNo,StartTime,TableType,Pax FROM `table`
		WHERE `table`.CompanyId  = old.CompanyId AND
					`table`.BrandId    = old.BrandId AND
					`table`.OutletId   = old.OutletId AND
					`table`.SystemDate = old.SystemDate  AND
					`table`.TableNo    = old.TableNo AND
					`table`.StartTime  = old.StartTime;
		
		# Move OrderDetail to OrderHistory
		INSERT INTO orderhistory 
		SELECT * FROM orderingdetail
		WHERE orderingdetail.CompanyId  = old.CompanyId AND
					orderingdetail.BrandId    = old.BrandId AND
					orderingdetail.OutletId   = old.OutletId AND
					orderingdetail.SystemDate = old.SystemDate  AND
					orderingdetail.TableNo    = old.TableNo AND
					orderingdetail.StartTime  = old.StartTime;
					
					
		# Delete From OrderingDetail
		DELETE FROM orderingdetail
			WHERE orderingdetail.CompanyId  = old.CompanyId AND
						orderingdetail.BrandId    = old.BrandId AND
						orderingdetail.OutletId   = old.OutletId AND
						orderingdetail.SystemDate = old.SystemDate  AND
						orderingdetail.TableNo    = old.TableNo AND
						orderingdetail.StartTime  = old.StartTime;


		# Delete From Ordering
		DELETE FROM ordering
			WHERE ordering.CompanyId  = old.CompanyId AND
						ordering.BrandId    = old.BrandId AND
						ordering.OutletId   = old.OutletId AND
						ordering.SystemDate = old.SystemDate  AND
						ordering.TableNo    = old.TableNo AND
						ordering.StartTime  = old.StartTime;

	END IF;
	
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
