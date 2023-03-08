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

 Date: 06/08/2019 15:33:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- ----------------------------
-- Records of admin_users
-- ----------------------------
INSERT INTO `admin_users` VALUES (2, 'admin', 'system', 'admin@system', '0200000000', 'admin', 'admin', 'n', 1, '2019-07-02 13:42:06', 'system', '2019-07-02 13:42:06', 'system');


-- ----------------------------
-- Records of languagemaster
-- ----------------------------
INSERT INTO `languagemaster` VALUES ('Tha', 'Thai', 'ภาษาไ ทย');
INSERT INTO `languagemaster` VALUES ('Chi', 'Chinese', '中國');
INSERT INTO `languagemaster` VALUES ('Lao', 'Lao', 'ພາສາລາວ');
INSERT INTO `languagemaster` VALUES ('Mya', 'Myanma', 'မြန်မာ');

-- ----------------------------
-- Records of language
-- ----------------------------
INSERT INTO `language` VALUES (1, 'SelfOrder', 'Management', 'Admin', 'Admin', 'ผู้ดูแลระบบ', '管理員', 'ຜູ້​ບໍ​ລິ​ຫານ', 'အုပ်ချုပ်သူ');
INSERT INTO `language` VALUES (2, 'SelfOrder', 'Management', 'Password', 'Password', 'รหัสผ่าน', '密碼', 'ລະຫັດຜ່ານ', 'စကားဝှက်ကို');
INSERT INTO `language` VALUES (3, 'SalesReport', '', 'SalesReport', 'Sales Report', 'หัวรายงาน', '銷售報告', 'ລາຍງານການຂາຍ', 'အရောင်းအစီရင်ခံစာ');
INSERT INTO `language` VALUES (4, 'SelfOrder', 'Table', 'InputPin', 'Input Pin', 'ใส่รหัสพิน', '輸入引腳', 'ໃສ່ລະຫັດຜ່ານ', 'စကားဝှက်ကိုရိုက်ထည့်ပါ');
INSERT INTO `language` VALUES (5, 'SelfOrder', 'Table', 'SelectTable', 'Select Table', 'จัดการโต๊ะ', '選擇一張桌子', 'ເລືອກຕາຕະລາງ', 'စားပွဲပေါ်မှာကို Select လုပ်ပါ');
INSERT INTO `language` VALUES (6, 'SelfOrder', 'Table', 'CurrenceTable', 'Currence Table', 'โต๊ะปัจจุบัน', '當前表', 'ຕາລາງປັດຈຸບັນ', 'လက်ရှိစားပွဲပေါ်မှာ');
INSERT INTO `language` VALUES (7, 'SelfOrder', 'Table', 'Test', 'Test Eng', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of company
-- ----------------------------
INSERT INTO `company` VALUES ('001', 'Nittaya', 'IpadMenu');
INSERT INTO `company` VALUES ('002', 'YENTAFO', 'MobileGrid');
INSERT INTO `company` VALUES ('003', 'Kingkong', 'IpadMenu');
-- ----------------------------
-- Records of brand
-- ----------------------------
INSERT INTO `brand` VALUES ('001', '001', 'Nittaya', NULL);
INSERT INTO `brand` VALUES ('001', '002', 'Santa Cruise', NULL);
INSERT INTO `brand` VALUES ('002', '001', 'Yentafo', NULL);
INSERT INTO `brand` VALUES ('003', '001', 'Kingkong', NULL);


-- ----------------------------
-- Records of outlet
-- ----------------------------
INSERT INTO `outlet` VALUES ('001', '001', '001', 'Bristro01');
INSERT INTO `outlet` VALUES ('001', '001', '002', 'Bristro02');
INSERT INTO `outlet` VALUES ('001', '001', '014', 'Nittaya014');
INSERT INTO `outlet` VALUES ('002', '001', '001', 'Yentafo01');
INSERT INTO `outlet` VALUES ('003', '001', '001', 'Kingkong01');


-- ----------------------------
-- Records of outletsetting
-- ----------------------------
INSERT INTO `outletsetting` VALUES ('001', '001', '001', 4, 'Tha', 60, '2019-07-31 13:11:56', '2019-07-31 13:11:54', '2019-08-02 15:57:29');
INSERT INTO `outletsetting` VALUES ('001', '001', '002', 4, 'Lao', NULL, NULL, NULL, NULL);
INSERT INTO `outletsetting` VALUES ('001', '001', '003', 2, 'Chi', NULL, NULL, NULL, NULL);
INSERT INTO `outletsetting` VALUES ('001', '001', '004', 2, 'Mya', NULL, NULL, NULL, NULL);
INSERT INTO `outletsetting` VALUES ('002', '001', '001', 2, 'Tha', 60, '2019-06-17 13:14:47', '2019-06-17 13:13:59', NULL);
INSERT INTO `outletsetting` VALUES ('003', '001', '001', 2, 'Tha', 60, '2019-08-02 15:55:30', '2019-08-02 15:55:36', NULL);


-- ----------------------------
-- Records of runningtext
-- ----------------------------
INSERT INTO `runningtext` VALUES ('001', '001', '001', 'Just click share NITTAYA, get free SOMTUM', 'เพียงกดแชร์ ร้านไก่ย่างนิตยา รับสมตำฟรี 1 จาน', '只需點擊即可分享，免費獲得一道菜', 'ພຽງແຕ່ຄລິກທີ່ຈະແບ່ງປັນ, ໄດ້ຮັບອາຫານ 1 ຟຣີ', 'ရုံဝေမျှမယ်နှိပ်ပြီးအခမဲ့ 1 အစိမ်းရောင်သင်္ဘောသီးသုပ်ပန်းကန်လက်ခံရရှိသည်။');


-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES ('001', '001', '001', 'banner1_.jpg', 'banner2_.jpg', 'banner3_.jpg', NULL, NULL, 'Welcome to NITTAYA.', 'ยินดีต้อนรับ นิตยาไก่ย่าง', '歡迎', 'ຍິນດີຕ້ອນຮັບ', 'ကွိုဆို ');





SET FOREIGN_KEY_CHECKS = 1;
