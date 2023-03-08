-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 31, 2019 at 06:44 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `selforder`
--
CREATE DATABASE IF NOT EXISTS `selforder` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `selforder`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `del_clearOrdering`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_clearOrdering` (IN `TABLENO` VARCHAR(8))  BEGIN
   DELETE FROM ordering WHERE ordering.TableNo = TABLENO;
   DELETE FROM orderingdetail WHERE orderingdetail.TableNo = TABLENO;
   UPDATE `table` SET `table`.StartTime = '', `table`.`Status`='',`table`.Pax = 0 WHERE `table`.TableNo = TABLENO;
END$$

DROP PROCEDURE IF EXISTS `del_getModifyAll`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_getModifyAll` (IN `ID` VARCHAR(8))  BEGIN
   SELECT * FROM view_modifylistall WHERE view_modifylistall.CategoryId = ID;
END$$

DROP PROCEDURE IF EXISTS `del_getModifyByProduct`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_getModifyByProduct` (IN `ItemId` VARCHAR(8), IN `CategoryId` VARCHAR(2))  BEGIN
   SELECT * FROM view_modifylistall WHERE view_modifylistall.ItemId = ItemId or view_modifylistall.CategoryId = CategoryId;
END$$

DROP PROCEDURE IF EXISTS `del_getPnewItemNO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_getPnewItemNO` (IN `TABLENO` VARCHAR(8), OUT `ITEMNO` VARCHAR(10))  BEGIN
   DECLARE ReturnNOID VARCHAR(10);
   SET ReturnNOID = (SELECT 1);
END$$

DROP PROCEDURE IF EXISTS `del_getProductSizeAll`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_getProductSizeAll` (IN `ID` VARCHAR(8))  BEGIN
   SELECT * FROM view_productsizeall WHERE view_productsizeall.ItemId = ID;
END$$

DROP PROCEDURE IF EXISTS `del_pTableInOutletSum`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_pTableInOutletSum` (IN `pCaompnyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletID` VARCHAR(4))  BEGIN
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

END$$

DROP PROCEDURE IF EXISTS `del_pWriteLog`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_pWriteLog` (IN `pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pErrorNo` VARCHAR(10), `pErrorMessage` VARCHAR(500))  BEGIN
	

	INSERT INTO `log`(CompanyId,BrandId,OutletId,SystemDate,ErrorNo,ErrorMessage) 
	VALUES (pCompanyId,pBrandId,pOutletId,pSystemDate,pErrorNo,pErrorMessage);

END$$

DROP PROCEDURE IF EXISTS `pBanner`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pBanner` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4))  BEGIN
	
DECLARE cUrl VARCHAR(100) ;
set cUrl = CONCAT('/',pCompanyId,'/',pBrandId,'/',pOutletId,'/banner/');

SELECT 
	fCheckEmpty(CONCAT(cUrl,image1),'') as image1,
	fCheckEmpty(CONCAT(cUrl,image2),'') as image2,
	fCheckEmpty(CONCAT(cUrl,image3),'') as image3,
	fCheckEmpty(CONCAT(cUrl,image4),'') as image4,
	fCheckEmpty(CONCAT(cUrl,image5),'') as image5,
	fCheckEmpty(CONCAT(cUrl,image5),'') as image6,
	fCheckEmpty(CONCAT(cUrl,image5),'') as image7,
	fCheckEmpty(CONCAT(cUrl,image5),'') as image8,
	fCheckEmpty(CONCAT(cUrl,image5),'') as image9,
	fCheckEmpty(CONCAT(cUrl,image5),'') as image10
FROM `banner`
WHERE CompanyId = pCompanyID AND 
			BrandId = pBrandID AND 
			OutletId = pOutletId;



	
END$$

DROP PROCEDURE IF EXISTS `pCallBilling`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pCallBilling` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8), IN `pFlag` INT(1) UNSIGNED)  BEGIN


	UPDATE `table`
	SET `table`.CallCheckBill =  pFlag , `table`.active_Device = 'P'
	WHERE `table`.CompanyId  = pCompanyId AND
				`table`.BrandId    = pBrandId AND
				`table`.OutletId   = pOutletId AND
				`table`.SystemDate = pSystemDate AND
				`table`.TableNo = pTableNo AND
				`table`.StartTime = pStartTime;

END$$

DROP PROCEDURE IF EXISTS `pCallWaiter`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pCallWaiter` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8))  BEGIN


	UPDATE `table`
	SET `table`.CallWaiter = 1
	WHERE `table`.CompanyId  = pCompanyId AND
				`table`.BrandId    = pBrandId AND
				`table`.OutletId   = pOutletId AND
				`table`.SystemDate = pSystemDate AND
				`table`.TableNo = pTableNo AND
				`table`.StartTime = pStartTime;


END$$

DROP PROCEDURE IF EXISTS `pCheckCanOrdering`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pCheckCanOrdering` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8))  BEGIN
	
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
		

					
END$$

DROP PROCEDURE IF EXISTS `pInputPax`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pInputPax` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8), IN `pPax` VARCHAR(3))  BEGIN


	UPDATE `table`
	SET `table`.Pax = pPax
	WHERE `table`.CompanyId  = pCompanyId AND
				`table`.BrandId    = pBrandId AND
				`table`.OutletId   = pOutletId AND
				`table`.SystemDate = pSystemDate AND
				`table`.TableNo = pTableNo AND
				`table`.StartTime = pStartTime;


END$$

DROP PROCEDURE IF EXISTS `pLanguageCaption`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pLanguageCaption` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), `pModule` VARCHAR(100))  BEGIN

	DECLARE localLang VARCHAR(3) ;
	

	SET localLang = (SELECT Locallanguage FROM outletsetting WHERE CompanyId = pCompanyID AND BrandId = pBrandID AND OutletId = pOutletId);

	


SELECT 
	Module,Section,Caption,'' AS CurrentCaption,
	Eng AS EnglishCaption,
	CASE WHEN localLang = "Tha" THEN Tha
			 WHEN LocalLang = "Chi" THEN Chi
			 WHEN LocalLang = "Lao" THEN Lao
			 WHEN LocalLang = "Mya" THEN Mya
			 ELSE Eng	
	END AS LocalCaption
FROM `language`
WHERE UPPER(`language`.Module) = UPPER(pModule);



SELECT '2' as LanguageCode , LanguageName, LanguageLocal FROM languagemaster WHERE languagemaster.`Code` = localLang;
	
END$$

DROP PROCEDURE IF EXISTS `pMoveOrderingToOrderDetail`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pMoveOrderingToOrderDetail` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pSystemDate` VARCHAR(10), IN `pTableNo` VARCHAR(10), IN `pStartTime` VARCHAR(8))  BEGIN

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
	
END$$

DROP PROCEDURE IF EXISTS `pOutletSetting_MasterFileTimeStamp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pOutletSetting_MasterFileTimeStamp` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4))  BEGIN
	
		UPDATE `outletsetting` 
		SET MasterFileTimeStamp = CURRENT_TIME()
		WHERE `outletsetting`.CompanyId = pCompanyId AND
		`outletsetting`.BrandId = pBrandId AND
		`outletsetting`.OutletId = pOutletId ;
					
END$$

DROP PROCEDURE IF EXISTS `pProductShowCategoryList`$$
CREATE DEFINER=`root`@`%` PROCEDURE `pProductShowCategoryList` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4))  BEGIN#Routine body goes here...
	DECLARE x INT;
	DECLARE nRecord INT;

	DROP TABLE IF EXISTS product_sort;
	CREATE TEMPORARY TABLE product_sort
	SELECT * , ShowOnCategory as ShowCat
	FROM view_productdata
	LIMIT 0 ;

	set x = 1;
	
	label1: LOOP
		DROP TABLE IF EXISTS product_showcat;
		CREATE TEMPORARY TABLE product_showcat
		SELECT *, SUBSTR(ShowOnCategory, x, 2 ) AS ShowCat 
		FROM 	view_productdata  
		WHERE SUBSTR(ShowOnCategory, x, 2 ) > 0 AND
				CompanyId  = pCompanyId AND
				BrandId    = pBrandId AND
				OutletId   = pOutletId;
		
		# Merge table
		INSERT IGNORE 
			INTO product_sort 
		SELECT *
			FROM product_showcat
				 ;
			 
		UPDATE product_sort SET ShowOnCategory = ShowCat;
		

		
		
		# check empty record
		SET nRecord = (SELECT COUNT(*) FROM product_showcat);
		IF nRecord > 0 THEN
			SET x = x + 3;
			ITERATE label1;
		END IF;
		LEAVE label1;
	END LOOP label1;
	
	
	# check ShowCat is category productrecommend = TRUE
	UPDATE product_sort SET product_sort.SeqNo = 8888 WHERE product_sort.ShowCat = 
	( SELECT CategoryId FROM `category` WHERE `category`.CategoryId = product_sort.ShowCat AND `category`.recommend = 1 );
		
	# check ShowCat is category productrecommend 
	UPDATE product_sort SET product_sort.SeqNo =  
	(SELECT SeqNo FROM `productrecommend` 
		WHERE product_sort.ShowCat = `productrecommend`.ShowOnCategory 
			AND  product_sort.ItemId = `productrecommend`.ItemId)
		 WHERE product_sort.SeqNo = 8888;
		
	# Clear null in fires SeqNo
	UPDATE product_sort SET product_sort.SeqNo = 0 WHERE ISNULL(product_sort.SeqNo);

	
	# return value
	SELECT * FROM product_sort ORDER BY ShowOnCategory,SeqNo,ItemId;
		
		
	DROP TABLE IF EXISTS product_sort;
	DROP TABLE IF EXISTS product_showcat;
		
		
END$$

DROP PROCEDURE IF EXISTS `pRunningTextCaption`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pRunningTextCaption` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4))  BEGIN

	DECLARE localLang VARCHAR(3) ;
	

	SET localLang = (SELECT Locallanguage FROM outletsetting WHERE CompanyId = pCompanyID AND BrandId = pBrandID AND OutletId = pOutletId);

	


SELECT 
	'' AS CurrentCaption,
	Eng AS EnglishCaption,
	CASE WHEN localLang = "Tha" THEN Tha
			 WHEN LocalLang = "Chi" THEN Chi
			 WHEN LocalLang = "Lao" THEN Lao
			 WHEN LocalLang = "Mya" THEN Mya
			 ELSE Eng	
	END AS LocalCaption
FROM `banner`
WHERE CompanyId = pCompanyID AND 
			BrandId = pBrandID AND 
			OutletId = pOutletId;



	
END$$

DROP PROCEDURE IF EXISTS `pSetItemImageName`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pSetItemImageName` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pItemId` VARCHAR(8), IN `pImageName` VARCHAR(50))  BEGIN
	
	

	DECLARE FoundImage INT(10);

	SET FoundImage = ( SELECT COUNT(*) as FoundImage FROM productimage
										WHERE productimage.CompanyId = pCompanyId AND
													productimage.BrandId   = pBrandId AND
													productimage.OutletId  = pOutletId AND
													productimage.ItemId    = pItemId);
									 

	IF FoundImage = 0 THEN
			
			INSERT INTO productimage (productimage.CompanyId,productimage.BrandId,productimage.OutletId,productimage.ItemId,productimage.image)
			VALUES (pCompanyId,pBrandId,pOutletId,pItemId,pImageName);
	ELSE
			
			UPDATE productimage SET productimage.image = pImageName
			WHERE productimage.CompanyId = pCompanyId AND
			productimage.BrandId   = pBrandId AND
			productimage.OutletId  = pOutletId AND
			productimage.ItemId    = pItemId;
	END IF;

END$$

DROP PROCEDURE IF EXISTS `pWelcomeText`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pWelcomeText` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4))  BEGIN

	DECLARE localLang VARCHAR(3) ;
	

	SET localLang = (SELECT Locallanguage FROM outletsetting WHERE CompanyId = pCompanyID AND BrandId = pBrandID AND OutletId = pOutletId);

	


SELECT 
	'' AS CurrentCaption,
	Eng AS EnglishCaption,
	CASE WHEN localLang = "Tha" THEN Tha
			 WHEN LocalLang = "Chi" THEN Chi
			 WHEN LocalLang = "Lao" THEN Lao
			 WHEN LocalLang = "Mya" THEN Mya
			 ELSE Eng	
	END AS LocalCaption
FROM `banner`
WHERE CompanyId = pCompanyID AND 
			BrandId = pBrandID AND 
			OutletId = pOutletId;



	
END$$

DROP PROCEDURE IF EXISTS `rptOrderHistory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rptOrderHistory` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pStartDate` VARCHAR(10), IN `pEndDate` VARCHAR(10))  BEGIN

	SELECT *  FROM `orderhistory`
	WHERE `orderhistory`.CompanyId  = pCompanyId AND
				`orderhistory`.BrandId    = pBrandId AND
				`orderhistory`.OutletId   = pOutletId AND
				`orderhistory`.SystemDate BETWEEN pStartDate AND pEndDate;

END$$

DROP PROCEDURE IF EXISTS `rptOrderRankingAmt`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rptOrderRankingAmt` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pStartDate` VARCHAR(10), IN `pEndDate` VARCHAR(10))  BEGIN

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

END$$

DROP PROCEDURE IF EXISTS `rptOrderRankingQty`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rptOrderRankingQty` (IN `pCompanyId` VARCHAR(4), IN `pBrandId` VARCHAR(4), IN `pOutletId` VARCHAR(4), IN `pStartDate` VARCHAR(10), IN `pEndDate` VARCHAR(10))  BEGIN

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

END$$

DROP PROCEDURE IF EXISTS `test`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `test` (OUT `pOutput` VARCHAR(100))  BEGIN
	
	set pOutput = CONCAT("Hello MySQL : ");

END$$

DROP PROCEDURE IF EXISTS `testClearOrderingCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `testClearOrderingCompany` ()  BEGIN


	DELETE FROM ordering 	WHERE ordering.CompanyId  = 999 ;
	
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `del_defaultFunction`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_defaultFunction` (`pAmt1` DECIMAL(18,2), `pAmt2` DECIMAL(18,2)) RETURNS DECIMAL(18,2) BEGIN
	DECLARE diffAmt DECIMAL(18,2);
	  
	SET diffAmt = pAmt1 - pAmt2;
		
	RETURN diffAmt;
END$$

DROP FUNCTION IF EXISTS `del_fCallBrandByID`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_fCallBrandByID` (`pCompanyCode` VARCHAR(10), `pBrandCode` VARCHAR(10)) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
	DECLARE BrandName   VARCHAR(100);

	SET BrandName = ( SELECT brand.BrandName FROM brand WHERE brand.CompanyId = pCompanyCode AND brand.BrandId = pBrandCode  LIMIT 1);
		
	RETURN BrandName;
END$$

DROP FUNCTION IF EXISTS `del_fCallCompanyByID`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_fCallCompanyByID` (`pCompanyCode` VARCHAR(4)) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
	DECLARE CompanyName VARCHAR(100);
	
	SET CompanyName = (SELECT `company`.`CompanyName` FROM `company` WHERE `company`.`CompanyId` = pCompanyCode LIMIT 1 );

	RETURN CompanyName;
END$$

DROP FUNCTION IF EXISTS `del_fCallOutletByID`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_fCallOutletByID` (`pCompanyCode` VARCHAR(10), `pBrandCode` VARCHAR(10), `pOutletCode` VARCHAR(10)) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
	DECLARE OutletName VARCHAR(100);
	  
	SET OutletName = ( SELECT outlet.OutletName FROM outlet WHERE outlet.CompanyId = pCompanyCode AND outlet.BrandId = pBrandCode AND outlet.OutletId = pOutletCode LIMIT 1 );
		
	RETURN OutletName;
END$$

DROP FUNCTION IF EXISTS `del_fCallVat`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_fCallVat` (`priceInt` INT, `vat` INT) RETURNS DECIMAL(14,4) BEGIN
DECLARE ReturnData DECIMAL(14,4);

SET ReturnData = priceInt * (vat / 100);
	RETURN ReturnData;
END$$

DROP FUNCTION IF EXISTS `del_fCallVat2`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_fCallVat2` (`priceInt` INT) RETURNS DECIMAL(14,2) BEGIN
DECLARE ReturnData DECIMAL(14,2);
SET ReturnData = priceInt * 7 / 100;
	RETURN ReturnData;
END$$

DROP FUNCTION IF EXISTS `del_fOrderingItemQuantity`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_fOrderingItemQuantity` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3)) RETURNS DECIMAL(8,4) BEGIN 
	
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


END$$

DROP FUNCTION IF EXISTS `del_getItemReferenceId_back`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `del_getItemReferenceId_back` () RETURNS VARCHAR(50) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
	

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
END$$

DROP FUNCTION IF EXISTS `fCheckCanOrdering`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fCheckCanOrdering` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8)) RETURNS INT(1) BEGIN
	
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


END$$

DROP FUNCTION IF EXISTS `fCheckCanSendOrdering`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fCheckCanSendOrdering` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8)) RETURNS INT(1) BEGIN
	
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


END$$

DROP FUNCTION IF EXISTS `fCheckEmpty`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fCheckEmpty` (`strText` VARCHAR(300), `defaultText` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
DECLARE ReturnData VARCHAR(300);
  SET ReturnData = IF (strText IS NULL OR strText = '', defaultText , strText);
	RETURN ReturnData;
END$$

DROP FUNCTION IF EXISTS `fgetCategoryAndProductName`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fgetCategoryAndProductName` (`pCompanyId` VARCHAR(100), `pBrandId` VARCHAR(100), `pOutletId` VARCHAR(100), `pCategoryId` VARCHAR(100), `pItemId` VARCHAR(100)) RETURNS VARCHAR(200) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
	
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

	
	RETURN IF(ReturnData IS NULL,'', ReturnData);
END$$

DROP FUNCTION IF EXISTS `fGetImageURL`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fGetImageURL` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pItemId` VARCHAR(8)) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
	
	DECLARE imagePath VARCHAR(50);
	DECLARE ImageName VARCHAR(200);
	DECLARE ImageURL VARCHAR(200);
	
	IF (LOCATE('M',pItemId,1) > 0 ) THEN		
		SET ImageURL = '';
	
	ELSE
		
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
END$$

DROP FUNCTION IF EXISTS `fOrderingDetailItemTotalAmount`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fOrderingDetailItemTotalAmount` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3)) RETURNS DECIMAL(14,4) BEGIN 
	
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


END$$

DROP FUNCTION IF EXISTS `fOrderingItemChangeQty`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fOrderingItemChangeQty` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3), `pQty` DECIMAL(8,4)) RETURNS INT(1) BEGIN 
	
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


END$$

DROP FUNCTION IF EXISTS `fOrderingItemDelete`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fOrderingItemDelete` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3)) RETURNS INT(1) BEGIN 
	
	DECLARE result int(1);
		SET result =  1;
		


	
	DELETE FROM `ordering` 
		WHERE `ordering`.CompanyId = pCompanyId AND
		`ordering`.BrandId = pBrandId AND
		`ordering`.OutletId = pOutletId AND
		`ordering`.SystemDate = pSystemDate AND
		`ordering`.TableNo = pTableNo AND
		`ordering`.StartTime = pStartTime AND
		`ordering`.ItemNo = pItemNo ;
	







	RETURN  result;


END$$

DROP FUNCTION IF EXISTS `fOrderingItemTotalAmount`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fOrderingItemTotalAmount` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8), `pItemNo` INT(3)) RETURNS DECIMAL(14,4) BEGIN 
	
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


END$$

DROP FUNCTION IF EXISTS `fTestReturn`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fTestReturn` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8)) RETURNS VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN 
	
	DECLARE result VARCHAR(10);
		SET result =  'Complete';
		












	







	
	RETURN  result;


END$$

DROP FUNCTION IF EXISTS `getItemReferenceId`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getItemReferenceId` () RETURNS DECIMAL(11,8) BEGIN

	
	DECLARE ReturnData DECIMAL(11,8); DECLARE TRADE INT(1);
  
  
	SET ReturnData = ROUND(RAND()*1000,0) + RAND();
	RETURN ReturnData;
	

END$$

DROP FUNCTION IF EXISTS `getNewItemNO`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getNewItemNO` (`pCompanyId` VARCHAR(4), `pBrandId` VARCHAR(4), `pOutletId` VARCHAR(4), `pSystemDate` VARCHAR(10), `pTableNo` VARCHAR(10), `pStartTime` VARCHAR(8)) RETURNS INT(3) BEGIN

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
	
	
	SET currItemNo = (GREATEST(ItemNo_Ordering,ItemNo_OrderDetail));
	
	
	SET newItemNo = IF(currItemNo < 501,501,currItemNo+1);
	
	
	RETURN newItemNo;
END$$

DROP FUNCTION IF EXISTS `getProductDefaultPrice`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getProductDefaultPrice` (`pCompanyId` VARCHAR(100), `pBrandId` VARCHAR(100), `pOutletId` VARCHAR(100), `pItemId` VARCHAR(100)) RETURNS DECIMAL(12,8) BEGIN
	
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
END$$

DROP FUNCTION IF EXISTS `test_sys_exec`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `test_sys_exec` () RETURNS TINYINT(4) BEGIN
 DECLARE cmd CHAR(255);
 DECLARE result int(10);
 SET cmd=CONCAT('sudo /home/sarbac/hello_world ','Sarbajit');

 SET result = sys_exec(cmd);

	RETURN 0;
END$$

DROP FUNCTION IF EXISTS `test_sys_exec_resetMasterTable`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `test_sys_exec_resetMasterTable` () RETURNS TINYINT(4) BEGIN
 DECLARE cmd CHAR(255);
 DECLARE result int(10);
 SET cmd=CONCAT('http://localhost:3000/','001/001/001');

 SET result = sys_exec(cmd);

	RETURN 0;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL COMMENT 'key',
  `fname` varchar(32) DEFAULT NULL COMMENT 'firstname',
  `lname` varchar(32) DEFAULT NULL COMMENT 'lastname',
  `email` varchar(32) DEFAULT NULL COMMENT 'email',
  `phone` varchar(10) DEFAULT NULL COMMENT 'phone number',
  `uname` varchar(32) DEFAULT NULL COMMENT 'username',
  `pword` varchar(32) DEFAULT NULL COMMENT 'password',
  `is_lock` char(1) DEFAULT 'n' COMMENT 'flag is lock or not',
  `roles_id` int(11) NOT NULL COMMENT 'pk role',
  `created_at` datetime DEFAULT NULL COMMENT 'date create data',
  `created_by` varchar(32) DEFAULT NULL COMMENT 'username to create data',
  `updated_at` datetime DEFAULT NULL COMMENT 'date update data',
  `updated_by` varchar(32) DEFAULT NULL COMMENT 'username to update data'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='collect data of member and shop member' ROW_FORMAT=COMPACT;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `fname`, `lname`, `email`, `phone`, `uname`, `pword`, `is_lock`, `roles_id`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(2, 'admin', 'system', 'admin@system', '0200000000', 'admin', 'admin', 'n', 1, '2019-07-02 13:42:06', 'system', '2019-07-02 13:42:06', 'system');

-- --------------------------------------------------------

--
-- Table structure for table `banner`
--

DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `image1` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image3` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image4` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image5` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image6` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image7` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image8` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image9` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image10` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Eng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'อังกฤษ',
  `Tha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ไทย',
  `Chi` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'จีน',
  `Lao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ลาว',
  `Mya` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'พม่า'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `banner`
--

INSERT INTO `banner` (`CompanyId`, `BrandId`, `OutletId`, `image1`, `image2`, `image3`, `image4`, `image5`, `image6`, `image7`, `image8`, `image9`, `image10`, `Eng`, `Tha`, `Chi`, `Lao`, `Mya`) VALUES
('001', '001', 'K01', 'banner1_.jpg', 'banner2_.jpg', 'banner3_.jpg', 'media.mp4', 'banner3_.jpg', 'banner3_.jpg', 'banner3_.jpg', 'banner3_.jpg', 'banner3_.jpg', 'media.mp4', 'Welcome to KAITAKRA.', 'ยินดีต้อนรับ ไก่ตระกร้า', '歡迎', 'ຍິນດີຕ້ອນຮັບ', 'ကွိုဆို ');

-- --------------------------------------------------------

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandName` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `Theme` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `brand`
--

INSERT INTO `brand` (`CompanyId`, `BrandId`, `BrandName`, `Theme`) VALUES
('001', 'K01', 'Nittaya', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `CategoryId` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OtherName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DepartmentId` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SeqNo` int(3) DEFAULT NULL COMMENT 'ลำดับในการแสดง',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'active or inactive categry',
  `recommend` tinyint(1) DEFAULT '0' COMMENT 'sort by procudtrecomment'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CompanyId`, `BrandId`, `OutletId`, `CategoryId`, `LocalName`, `EnglishName`, `OtherName`, `DepartmentId`, `SeqNo`, `is_active`, `recommend`) VALUES
('001', '001', 'K01', '01', 'เครื่องดื่ม', 'เครื่องดื่ม', 'เครื่องดื่ม', '', 2, 1, 0),
('001', '001', 'K01', '02', 'ปลา', 'ปลา', 'ปลา', '', 3, 1, 0),
('001', '001', 'K01', '03', 'ทอด', 'ทอด', 'ทอด', '', 4, 1, 0),
('001', '001', 'K01', '04', 'ส้มตำ', 'ส้มตำ', 'ส้มตำ', '', 5, 1, 0),
('001', '001', 'K01', '05', 'ปู', 'ปู', 'ปู', '', 6, 1, 0),
('001', '001', 'K01', '06', 'ยำ', 'ยำ', 'ยำ', '', 7, 1, 0),
('001', '001', 'K01', '07', 'ต้ม  แกง', 'ต้ม  แกง', 'ต้ม  แกง', '', 8, 1, 0),
('001', '001', 'K01', '08', 'ผัด อบ', 'ผัด อบ', 'ผัด อบ', '', 9, 1, 0),
('001', '001', 'K01', '09', 'ข้าว', 'ข้าว', 'ข้าว', '', 10, 1, 0),
('001', '001', 'K01', '10', 'ของหวาน', 'ของหวาน', 'ของหวาน', '', 11, 1, 0),
('001', '001', 'K01', '11', 'แอลกอฮออล์', 'แอลกอฮออล์', 'แอลกอฮออล์', '', 12, 1, 0),
('001', '001', 'K01', '12', 'แนะนำ', 'แนะนำ', 'แนะนำ', '', 1, 1, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `check_duplicate`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `check_duplicate`;
CREATE TABLE `check_duplicate` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`ItemId` varchar(8)
,`LocalName` varchar(200)
,`EnglishName` varchar(200)
,`duplicate` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `CompanyName` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `Template` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Screen Style'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`CompanyId`, `CompanyName`, `Template`) VALUES
('001', 'Nittaya', 'IpadMenu');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `DepartmentId` varchar(1) COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OtherName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`CompanyId`, `BrandId`, `OutletId`, `DepartmentId`, `LocalName`, `EnglishName`, `OtherName`) VALUES
('001', '001', 'K01', '1', 'อาหาร', 'Food', 'Food'),
('001', '001', 'K01', '2', 'เครื่องดื่ม', 'Drink', 'Drink'),
('001', '001', 'K01', '3', 'ของหวาน', 'Dessert', 'Dessert'),
('001', '001', 'K01', '4', 'อื่นๆ', 'Other', 'Other'),
('001', '001', 'K01', '5', 'สมนาคุณ', 'Reward', ''),
('001', '001', 'K01', '6', 'ไก่ย่าง', 'Grill Chicken', ''),
('001', '001', 'K01', '7', 'ครัวไทย', 'Thai Kitchen', ''),
('001', '001', 'K01', '8', 'ส้มตำ', 'Somtum', ''),
('001', '001', 'K01', '9', 'เบียร์', 'Beer', ''),
('001', '001', 'K01', 'A', 'เครื่องดื่ม-ของหวาน', 'Drink&Dessert', ''),
('001', '001', 'K01', 'B', 'บุหรี่', 'Cigarette', ''),
('001', '001', 'K01', 'C', 'ค่าห้อง', 'Room Service', '');

-- --------------------------------------------------------

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
CREATE TABLE `language` (
  `id` int(11) NOT NULL,
  `Module` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Section` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Caption` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `Eng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'อังกฤษ',
  `Tha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ไทย',
  `Chi` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'จีน',
  `Lao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ลาว',
  `Mya` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'พม่า'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `language`
--

INSERT INTO `language` (`id`, `Module`, `Section`, `Caption`, `Eng`, `Tha`, `Chi`, `Lao`, `Mya`) VALUES
(1, 'SelfOrder', 'Management', 'Admin', 'Admin', 'ผู้ดูแลระบบ', '管理員', 'ຜູ້​ບໍ​ລິ​ຫານ', 'အုပ်ချုပ်သူ'),
(2, 'SelfOrder', 'Management', 'Password', 'Password', 'รหัสผ่าน', '密碼', 'ລະຫັດຜ່ານ', 'စကားဝှက်ကို'),
(3, 'SalesReport', '', 'SalesReport', 'Sales Report', 'หัวรายงาน', '銷售報告', 'ລາຍງານການຂາຍ', 'အရောင်းအစီရင်ခံစာ'),
(4, 'SelfOrder', 'Table', 'InputPin', 'Input Pin', 'ใส่รหัสพิน', '輸入引腳', 'ໃສ່ລະຫັດຜ່ານ', 'စကားဝှက်ကိုရိုက်ထည့်ပါ'),
(5, 'SelfOrder', 'Table', 'SelectTable', 'Select Table', 'จัดการโต๊ะ', '選擇一張桌子', 'ເລືອກຕາຕະລາງ', 'စားပွဲပေါ်မှာကို Select လုပ်ပါ'),
(6, 'SelfOrder', 'Table', 'CurrenceTable', 'Currence Table', 'โต๊ะปัจจุบัน', '當前表', 'ຕາລາງປັດຈຸບັນ', 'လက်ရှိစားပွဲပေါ်မှာ'),
(7, 'SelfOrder', 'Table', 'Test', 'Test Eng', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `languagemaster`
--

DROP TABLE IF EXISTS `languagemaster`;
CREATE TABLE `languagemaster` (
  `Code` char(3) COLLATE utf8_unicode_ci NOT NULL,
  `LanguageName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LanguageLocal` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `languagemaster`
--

INSERT INTO `languagemaster` (`Code`, `LanguageName`, `LanguageLocal`) VALUES
('Tha', 'Thai', 'ภาษาไ ทย'),
('Chi', 'Chinese', '中國'),
('Lao', 'Lao', 'ພາສາລາວ'),
('Mya', 'Myanma', 'မြန်မာ');

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `CurrentDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SystemDate` date DEFAULT NULL,
  `ErrorNo` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ErrorMessage` text COLLATE utf8_unicode_ci,
  `TableNo` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ItemId` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ItemName` text COLLATE utf8_unicode_ci COMMENT 'Product Name Show',
  `localName` text COLLATE utf8_unicode_ci,
  `EnglishName` text COLLATE utf8_unicode_ci,
  `OtherName` text COLLATE utf8_unicode_ci,
  `TotalAmount` decimal(14,4) DEFAULT NULL COMMENT 'ยอดรวม',
  `Quantity` decimal(8,4) DEFAULT NULL COMMENT 'จำนวน ',
  `UnitPrice` decimal(14,4) DEFAULT NULL COMMENT 'ราคาต่อหน่วย'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `Id` int(11) NOT NULL,
  `Name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Surname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Tel` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `Email` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `modiitem`
--

DROP TABLE IF EXISTS `modiitem`;
CREATE TABLE `modiitem` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ModiItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OtherName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'active or inactive product'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `modiitem`
--

INSERT INTO `modiitem` (`CompanyId`, `BrandId`, `OutletId`, `ModiItemId`, `LocalName`, `EnglishName`, `OtherName`, `is_active`) VALUES
('001', '001', 'K01', 'A001', 'เปรี้ยว', 'เปรี้ยว', 'เปรี้ยว', 1),
('001', '001', 'K01', 'A002', 'เปรี้ยวนำ', 'เปรี้ยวนำ', 'เปรี้ยวนำ', 1),
('001', '001', 'K01', 'A003', 'เปรี้ยวน้อย', 'เปรี้ยวน้อย', 'เปรี้ยวน้อย', 1),
('001', '001', 'K01', 'A004', 'เปรี้ยวมาก', 'เปรี้ยวมาก', 'เปรี้ยวมาก', 1),
('001', '001', 'K01', 'A005', 'หวาน', 'หวาน', 'หวาน', 1),
('001', '001', 'K01', 'A006', 'หวานนำ', 'หวานนำ', 'หวานนำ', 1),
('001', '001', 'K01', 'A007', 'หวานน้อย', 'หวานน้อย', 'หวานน้อย', 1),
('001', '001', 'K01', 'A008', 'หวานมาก', 'หวานมาก', 'หวานมาก', 1),
('001', '001', 'K01', 'A009', 'เผ็ด', 'เผ็ด', 'เผ็ด', 1),
('001', '001', 'K01', 'A010', 'เผ็ดนำ', 'เผ็ดนำ', 'เผ็ดนำ', 1),
('001', '001', 'K01', 'A011', 'เผ็ดน้อย', 'เผ็ดน้อย', 'เผ็ดน้อย', 1),
('001', '001', 'K01', 'A012', 'เผ็ดมาก', 'เผ็ดมาก', 'เผ็ดมาก', 1),
('001', '001', 'K01', 'A013', 'เค็ม', 'เค็ม', 'เค็ม', 1),
('001', '001', 'K01', 'A014', 'เค็มนำ', 'เค็มนำ', 'เค็มนำ', 1),
('001', '001', 'K01', 'A015', 'เค็มน้อย', 'เค็มน้อย', 'เค็มน้อย', 1),
('001', '001', 'K01', 'A016', 'เค็มมาก', 'เค็มมาก', 'เค็มมาก', 1),
('001', '001', 'K01', 'A017', 'มัน', 'มัน', 'มัน', 1),
('001', '001', 'K01', 'A018', 'มันนำ', 'มันนำ', 'มันนำ', 1),
('001', '001', 'K01', 'A019', 'มันน้อย', 'มันน้อย', 'มันน้อย', 1),
('001', '001', 'K01', 'A020', 'มันมาก', 'มันมาก', 'มันมาก', 1),
('001', '001', 'K01', 'A021', 'รสจัด', 'รสจัด', 'รสจัด', 1),
('001', '001', 'K01', 'A022', 'สามรส', 'สามรส', 'สามรส', 1),
('001', '001', 'K01', 'B001', 'ตับหมู', 'ตับหมู', '', 1),
('001', '001', 'K01', 'B002', 'เครื่องในไก่', 'เครื่องในไก่', '', 1),
('001', '001', 'K01', 'B003', 'หนังหมู', 'หนังหมู', 'หนังหมู', 1),
('001', '001', 'K01', 'B004', 'ปลาสลิด', 'ปลาสลิด', 'ปลาสลิด', 1),
('001', '001', 'K01', 'B005', 'ปลาหมึก', 'ปลาหมึก', 'ปลาหมึก', 1),
('001', '001', 'K01', 'B006', 'กุ้งอบ', 'กุ้งอบ', 'กุ้งอบ', 1),
('001', '001', 'K01', 'B007', 'กุ้งแห้ง', 'กุ้งแห้ง', 'กุ้งแห้ง', 1),
('001', '001', 'K01', 'B008', 'กุ้งสด (ส)', 'กุ้งสด (ส)', '', 1),
('001', '001', 'K01', 'B009', 'ปูม้า', 'ปูม้า', 'ปูม้า', 1),
('001', '001', 'K01', 'B010', 'ปูเค็ม', 'ปูเค็ม', 'ปูเค็ม', 1),
('001', '001', 'K01', 'B011', 'ปูเค็มลวก', 'ปูเค็มลวก', 'ปูเค็มลวก', 1),
('001', '001', 'K01', 'B013', 'ปูม้าลวก', 'ปูม้าลวก', 'ปูม้าลวก', 1),
('001', '001', 'K01', 'B014', 'หมูชิ้น', 'หมูชิ้น', '', 1),
('001', '001', 'K01', 'B015', 'แคบหมู', 'แคบหมู', 'แคบหมู', 1),
('001', '001', 'K01', 'B016', 'คอหมูย่าง', 'คอหมูย่าง', 'คอหมูย่าง', 1),
('001', '001', 'K01', 'B017', 'หมูเด้ง', 'หมูเด้ง', 'หมูเด้ง', 1),
('001', '001', 'K01', 'B018', 'โครงอ่อน', 'โครงอ่อน', 'โครงอ่อน', 1),
('001', '001', 'K01', 'B019', 'เนื้อตุ๋น', 'เนื้อตุ๋น', 'เนื้อตุ๋น', 1),
('001', '001', 'K01', 'B020', 'เนื้อไก่', 'เนื้อไก่', '', 1),
('001', '001', 'K01', 'B021', 'ปลาร้า', 'ปลาร้า', 'ปลาร้า', 1),
('001', '001', 'K01', 'B022', 'หอยดอง', 'หอยดอง', 'หอยดอง', 1),
('001', '001', 'K01', 'B023', 'หอยขม', 'หอยขม', 'หอยขม', 1),
('001', '001', 'K01', 'B024', 'หนังไก่', 'หนังไก่', '', 1),
('001', '001', 'K01', 'B025', 'ตูดไก่', 'ตูดไก่', '', 1),
('001', '001', 'K01', 'B026', 'เลาะกระดูกไก่', 'เลาะกระดูกไก่', '', 1),
('001', '001', 'K01', 'B027', 'กุ้งแช่', 'กุ้งแช่', '', 1),
('001', '001', 'K01', 'B028', 'กุ้งลวก', 'กุ้งลวก', '', 1),
('001', '001', 'K01', 'B029', 'หนังปลากรอบ', 'หนังปลากรอบ', '', 1),
('001', '001', 'K01', 'B030', 'ปลาเค็ม', 'ปลาเค็ม', '', 1),
('001', '001', 'K01', 'B031', 'เนื้อปู', 'เนื้อปู', '', 1),
('001', '001', 'K01', 'B032', 'ไข่มดแดง', 'ไข่มดแดง', '', 1),
('001', '001', 'K01', 'B033', 'ปลาดุกย่าง', 'ปลาดุกย่าง', '', 1),
('001', '001', 'K01', 'B034', 'เนื้อ', 'เนื้อ', '', 1),
('001', '001', 'K01', 'B035', 'กุ้งลวก', 'กุ้งลวก', '', 1),
('001', '001', 'K01', 'B036', 'หมูบด', 'หมูบด', '', 1),
('001', '001', 'K01', 'B037', 'กุ้งสด (คท)', 'กุ้งสด (คท)', '', 1),
('001', '001', 'K01', 'B038', 'เนื้อปลากะพง', 'เนื้อปลากะพง', '', 1),
('001', '001', 'K01', 'C001', 'ผัก', 'ผัก', 'ผัก', 1),
('001', '001', 'K01', 'C002', 'ผักชีทุกชนิด', 'ผักชีทุกชนิด', 'ผักชีทุกชนิด', 1),
('001', '001', 'K01', 'C003', 'ผักลวก', 'ผักลวก', 'ผักลวก', 1),
('001', '001', 'K01', 'C004', 'ผักลวก+น้ำจิ้ม', 'ผักลวก+น้ำจิ้ม', 'ผักลวก+น้ำจิ้ม', 1),
('001', '001', 'K01', 'C005', 'ผักสด(ผักชุด)', 'ผักสด(ผักชุด)', 'ผักสด(ผักชุด)', 1),
('001', '001', 'K01', 'C006', 'ผักหวาน', 'ผักหวาน', 'ผักหวาน', 1),
('001', '001', 'K01', 'C007', 'ผักแกงส้ม', 'ผักแกงส้ม', 'ผักแกงส้ม', 1),
('001', '001', 'K01', 'C008', 'ใบชะพลู', 'ใบชะพลู', 'ใบชะพลู', 1),
('001', '001', 'K01', 'C009', 'เห็ดฟาง', 'เห็ดฟาง', 'เห็ดฟาง', 1),
('001', '001', 'K01', 'C010', 'ชะอมไข่', 'ชะอมไข่', 'ชะอมไข่', 1),
('001', '001', 'K01', 'C011', 'ยอดมะพร้าว', 'ยอดมะพร้าว', 'ยอดมะพร้าว', 1),
('001', '001', 'K01', 'C012', 'เครื่องกระชายกรอบ', 'เครื่องกระชายกรอบ', 'เครื่องกระชายกรอบ', 1),
('001', '001', 'K01', 'C014', 'เส้นมะละกอ', 'เส้นมะละกอ', 'เส้นมะละกอ', 1),
('001', '001', 'K01', 'C015', 'เส้นแครอท', 'เส้นแครอท', 'เส้นแครอท', 1),
('001', '001', 'K01', 'C016', 'แตงกวาสไลด์', 'แตงกวาสไลด์', 'แตงกวาสไลด์', 1),
('001', '001', 'K01', 'C017', 'มะเขือเทศสไลด์', 'มะเขือเทศสไลด์', 'มะเขือเทศสไลด์', 1),
('001', '001', 'K01', 'C018', 'มะนาวสไลด์', 'มะนาวสไลด์', 'มะนาวสไลด์', 1),
('001', '001', 'K01', 'C019', 'แครอท', 'แครอท', 'แครอท', 1),
('001', '001', 'K01', 'C020', 'ถั่วลิสง', 'ถั่วลิสง', 'ถั่วลิสง', 1),
('001', '001', 'K01', 'C021', 'ถั่วฝักยาว', 'ถั่วฝักยาว', 'ถั่วฝักยาว', 1),
('001', '001', 'K01', 'C022', 'กระเทียม', 'กระเทียม', 'กระเทียม', 1),
('001', '001', 'K01', 'C023', 'พริก', 'พริก', 'พริก', 1),
('001', '001', 'K01', 'C024', 'พริกไทย', 'พริกไทย', 'พริกไทย', 1),
('001', '001', 'K01', 'C025', 'หอมแดง', 'หอมแดง', 'หอมแดง', 1),
('001', '001', 'K01', 'C026', 'หอมใหญ่', 'หอมใหญ่', 'หอมใหญ่', 1),
('001', '001', 'K01', 'C027', 'ต้นหอม', 'ต้นหอม', 'ต้นหอม', 1),
('001', '001', 'K01', 'C028', 'สาระแน่', 'สาระแน่', 'สาระแน่', 1),
('001', '001', 'K01', 'C029', 'มะกอก', 'มะกอก', 'มะกอก', 1),
('001', '001', 'K01', 'C030', 'มะเขือเหลือง', 'มะเขือเหลือง', 'มะเขือเหลือง', 1),
('001', '001', 'K01', 'C031', 'มะเขือเทศ', 'มะเขือเทศ', 'มะเขือเทศ', 1),
('001', '001', 'K01', 'C032', 'มะเขือลาย', 'มะเขือลาย', 'มะเขือลาย', 1),
('001', '001', 'K01', 'C033', 'พริกแห้ง', 'พริกแห้ง', 'พริกแห้ง', 1),
('001', '001', 'K01', 'C034', 'เห็ดเผาะ', 'เห็ดเผาะ', 'เห็ดเผาะ', 1),
('001', '001', 'K01', 'C036', 'ถั่วปากอ้า', 'ถั่วปากอ้า', 'ถั่วปากอ้า', 1),
('001', '001', 'K01', 'C037', 'ถั่วโรย', 'ถั่วโรย', '', 1),
('001', '001', 'K01', 'C038', 'สาหร่าย', 'สาหร่าย', 'สาหร่าย', 1),
('001', '001', 'K01', 'C039', 'เต้าหู้ไข่', 'เต้าหู้ไข่', '', 1),
('001', '001', 'K01', 'C040', 'เห็ดโคน', 'เห็ดโคน', 'เห็ดโคน', 1),
('001', '001', 'K01', 'C041', 'เห็ดออรินจิ', 'เห็ดออรินจิ', 'เห็ดออรินจิ', 1),
('001', '001', 'K01', 'C042', 'มะม่วง', 'มะม่วง', 'มะม่วง', 1),
('001', '001', 'K01', 'C043', 'ตะไคร้', 'ตะไคร้', 'ตะไคร้', 1),
('001', '001', 'K01', 'C044', 'มะเขือเปราะ', 'มะเขือเปราะ', '', 1),
('001', '001', 'K01', 'C045', 'กระเทียมเจียว', 'กระเทียมเจียว', '', 1),
('001', '001', 'K01', 'C048', 'วุ้นเส้น', 'วุ้นเส้น', '', 1),
('001', '001', 'K01', 'C049', 'ขิง', 'ขิง', '', 1),
('001', '001', 'K01', 'C050', 'ข้าวโพด', 'ข้าวโพด', '', 1),
('001', '001', 'K01', 'C051', 'ชะอม', 'ชะอม', '', 1),
('001', '001', 'K01', 'C052', 'ผักชีฝรั่ง', 'ผักชีฝรั่ง', '', 1),
('001', '001', 'K01', 'C053', 'ผักชีลาว', 'ผักชีลาว', '', 1),
('001', '001', 'K01', 'C054', 'ผักชีไทย', 'ผักชีไทย', '', 1),
('001', '001', 'K01', 'C055', 'ขนมจีน', 'ขนมจีน', '', 1),
('001', '001', 'K01', 'C056', 'เม็ดกระถิน', 'เม็ดกระถิน', '', 1),
('001', '001', 'K01', 'C057', 'คะน้า', 'คะน้า', '', 1),
('001', '001', 'K01', 'C058', 'หน่อไม้', 'หน่อไม้', '', 1),
('001', '001', 'K01', 'D001', 'น้ำแกงส้ม', 'น้ำแกงส้ม', 'น้ำแกงส้ม', 1),
('001', '001', 'K01', 'D002', 'น้ำยำปลาดุกฟู', 'น้ำยำปลาดุกฟู', 'น้ำยำปลาดุกฟู', 1),
('001', '001', 'K01', 'D003', 'น้ำยำช่อนฟู', 'น้ำยำช่อนฟู', 'น้ำยำช่อนฟู', 1),
('001', '001', 'K01', 'D004', 'น้ำปลาริม', 'น้ำปลาริม', 'น้ำปลาริม', 1),
('001', '001', 'K01', 'D005', 'น้ำราดปลาทอด', 'น้ำราดปลาทอด', 'น้ำราดปลาทอด', 1),
('001', '001', 'K01', 'D006', 'น้ำจิ้มซีฟู้ด', 'น้ำจิ้มซีฟู้ด', 'น้ำจิ้มซีฟู้ด', 1),
('001', '001', 'K01', 'D008', 'น้ำ', 'น้ำ', '', 1),
('001', '001', 'K01', 'E001', 'น้ำตาล', 'น้ำตาล', 'น้ำตาล', 1),
('001', '001', 'K01', 'E002', 'น้ำปลา', 'น้ำปลา', 'น้ำปลา', 1),
('001', '001', 'K01', 'E003', 'ผงชูรส', 'ผงชูรส', 'ผงชูรส', 1),
('001', '001', 'K01', 'E004', 'เกลือ', 'เกลือ', 'เกลือ', 1),
('001', '001', 'K01', 'E005', 'นม', 'นม', '', 1),
('001', '001', 'K01', 'E006', 'ปลาร้า', 'ปลาร้า', '', 1),
('001', '001', 'K01', 'E007', 'พริกไทย', 'พริกไทย', '', 1),
('001', '001', 'K01', 'E008', 'ข้าวคั่ว', 'ข้าวคั่ว', '', 1),
('001', '001', 'K01', 'E009', 'น้ำมะนาว', 'น้ำมะนาว', '', 1),
('001', '001', 'K01', 'F001', 'ไข่มดแดง', 'ไข่มดแดง', 'ไข่มดแดง', 1),
('001', '001', 'K01', 'F002', 'ไข่ต้ม', 'ไข่ต้ม', 'ไข่ต้ม', 1),
('001', '001', 'K01', 'F003', 'ไข่ดาว', 'ไข่ดาว', 'ไข่ดาว', 1),
('001', '001', 'K01', 'F004', 'ไข่เจียว', 'ไข่เจียว', 'ไข่เจียว', 1),
('001', '001', 'K01', 'F005', 'ไข่เค็ม', 'ไข่เค็ม', 'ไข่เค็ม', 1),
('001', '001', 'K01', 'F006', 'ไข่แดง', 'ไข่แดง', '', 1),
('001', '001', 'K01', 'G001', 'ทับทิม', 'ทับทิม', 'ทับทิม', 1),
('001', '001', 'K01', 'G002', 'เม็ดบัว', 'เม็ดบัว', 'เม็ดบัว', 1),
('001', '001', 'K01', 'G003', 'ถั่วแดง', 'ถั่วแดง', 'ถั่วแดง', 1),
('001', '001', 'K01', 'G004', 'ทับทิม+เม็ดบัว+ถั่วแดง', 'ทับทิม+เม็ดบัว+ถั่วแดง', '', 1),
('001', '001', 'K01', 'H001', '(มัง)', '(มัง)', '(มัง)', 1),
('001', '001', 'K01', 'H002', 'น้ำข้น', 'น้ำข้น', 'น้ำข้น', 1),
('001', '001', 'K01', 'H003', 'น้ำใส', 'น้ำใส', 'น้ำใส', 1),
('001', '001', 'K01', 'H004', 'แห้ง', 'แห้ง', 'แห้ง', 1),
('001', '001', 'K01', 'H005', 'ไม่แห้ง', 'ไม่แห้ง', 'ไม่แห้ง', 1),
('001', '001', 'K01', 'H006', 'กรอบๆ', 'กรอบๆ', 'กรอบๆ', 1),
('001', '001', 'K01', 'H007', 'เกรียมๆ', 'เกรียมๆ', 'เกรียมๆ', 1),
('001', '001', 'K01', 'H008', 'ทะเล (กุ้ง+ปลาหมึก)', 'ทะเล (กุ้ง+ปลาหมึก)', 'ทะเล', 1),
('001', '001', 'K01', 'H010', 'ไก่แบ่ง 2 จาน', 'ไก่แบ่ง 2 จาน', 'ไก่แบ่ง 2 จาน', 1),
('001', '001', 'K01', 'H011', 'คลุกเลย', 'คลุกเลย', 'คลุกเลย', 1),
('001', '001', 'K01', 'H012', 'ตำนิ่มๆ', 'ตำนิ่มๆ', 'ตำนิ่มๆ', 1),
('001', '001', 'K01', 'H013', 'ตำแหลกๆ', 'ตำแหลกๆ', '', 1),
('001', '001', 'K01', 'H014', 'แยกน้ำ', 'แยกน้ำ', '', 1),
('001', '001', 'K01', 'H015', 'ล้างครก', 'ล้างครก', 'ล้างครก', 1),
('001', '001', 'K01', 'H016', 'น้ำแข็ง', 'น้ำแข็ง', 'น้ำแข็ง', 1),
('001', '001', 'K01', 'H017', 'น้ำแข็งแก้ว', 'น้ำแข็งแก้ว', 'น้ำแข็งแก้ว', 1),
('001', '001', 'K01', 'H018', 'สุกมาก', 'สุกมาก', 'สุกมาก', 1),
('001', '001', 'K01', 'H019', 'สุกน้อย', 'สุกน้อย', 'สุกน้อย', 1),
('001', '001', 'K01', 'H020', 'ไม่สุก', 'ไม่สุก', 'ไม่สุก', 1),
('001', '001', 'K01', 'H021', 'วุ้นเส้น', 'วุ้นเส้น', 'วุ้นเส้น', 1),
('001', '001', 'K01', 'H022', 'ร้อน', 'ร้อน', 'ร้อน', 1),
('001', '001', 'K01', 'H023', 'ปลาทอด', 'ปลาทอด', 'ปลาทอด', 1),
('001', '001', 'K01', 'H024', 'ไม่สับ', 'ไม่สับ', 'ไม่สับ', 1),
('001', '001', 'K01', 'H026', 'ลาว', 'ลาว', '', 1),
('001', '001', 'K01', 'H027', 'น้ำแข็ง', 'น้ำแข็ง', '', 1),
('001', '001', 'K01', 'H028', 'ทำร้อน', 'ทำร้อน', '', 1),
('001', '001', 'K01', 'H029', 'ไม่เตา', 'ไม่เตา', '', 1),
('001', '001', 'K01', 'H030', 'ใส่ชาม', 'ใส่ชาม', '', 1),
('001', '001', 'K01', 'H031', 'ชิ้น', 'ชิ้น', '', 1),
('001', '001', 'K01', 'H032', 'ริมสวน', 'ริมสวน', '', 1),
('001', '001', 'K01', 'H033', 'ราดพริก', 'ราดพริก', '', 1),
('001', '001', 'K01', 'H034', 'น้ำตก', 'น้ำตก', '', 1),
('001', '001', 'K01', 'H035', 'ไม่ต้องทำ', 'ไม่ต้องทำ', '', 1),
('001', '001', 'K01', 'H036', 'ทานที่ร้าน', 'ทานที่ร้าน', '', 1),
('001', '001', 'K01', 'H038', 'ใส่ถุง', 'ใส่ถุง', '', 1),
('001', '001', 'K01', 'H040', 'น้ำปลาร้า', 'น้ำปลาร้า', '', 1),
('001', '001', 'K01', 'HO32', 'แก้ว 2 ใบ', 'แก้ว 2  ใบ', '', 1),
('001', '001', 'K01', 'I001', 'พริก', 'พริก', '', 1),
('001', '001', 'K01', 'I002', 'พริก 1 เม็ด', 'พริก 1 เม็ด', '', 1),
('001', '001', 'K01', 'I003', 'พริก 2 เม็ด', 'พริก 2 เม็ด', '', 1),
('001', '001', 'K01', 'I004', 'พริก 3 เม็ด', 'พริก 3 เม็ด', '', 1),
('001', '001', 'K01', 'I005', 'พริก 4 เม็ด', 'พริก 4 เม็ด', '', 1),
('001', '001', 'K01', 'I006', 'มากกว่า 10 เม็ด', 'มากกว่า 10 เม็ด', '', 1),
('001', '001', 'K01', 'I007', 'มากกว่า 20 เม็ด', 'มากกว่า 20 เม็ด', '', 1),
('001', '001', 'K01', 'I008', 'พริกเผา', 'พริกเผา', '', 1),
('001', '001', 'K01', 'I009', 'พริกแห้ง', 'พริกแห้ง', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `modilist`
--

DROP TABLE IF EXISTS `modilist`;
CREATE TABLE `modilist` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `CategoryId` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `ModiSetId` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `ModiItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `Price` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `modilist`
--

INSERT INTO `modilist` (`CompanyId`, `BrandId`, `OutletId`, `CategoryId`, `ItemId`, `ModiSetId`, `ModiItemId`, `Price`) VALUES
('001', '001', 'K01', '', 'BE0002', '1', '0401', '10.00'),
('001', '001', 'K01', '', 'BE0002', '2', '0401', '10.00'),
('001', '001', 'K01', '', 'BE0002', '1', '0402', '10.00'),
('001', '001', 'K01', '', 'BE0002', '2', '0402', '10.00'),
('001', '001', 'K01', '', 'BE0002', '1', '0403', '10.00'),
('001', '001', 'K01', '', 'BE0002', '2', '0403', '10.00'),
('001', '001', 'K01', '', 'BE0002', '3', '0404', '-10.00'),
('001', '001', 'K01', '', 'BE0002', '4', '0404', '-10.00'),
('001', '001', 'K01', '', 'BE0003', '1', '0403', '10.00'),
('001', '001', 'K01', '', 'BE0003', '2', '0403', '10.00'),
('001', '001', 'K01', '', 'BE0003', '3', '0404', '-10.00'),
('001', '001', 'K01', '', 'BE0003', '4', '0404', '-10.00');

-- --------------------------------------------------------

--
-- Table structure for table `modiset`
--

DROP TABLE IF EXISTS `modiset`;
CREATE TABLE `modiset` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ModiSetId` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OtherName` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `modiset`
--

INSERT INTO `modiset` (`CompanyId`, `BrandId`, `OutletId`, `ModiSetId`, `LocalName`, `EnglishName`, `OtherName`) VALUES
('001', '001', 'K01', '1', '', '', ''),
('001', '001', 'K01', '2', 'เพิ่ม/', 'Add/', 'Add'),
('001', '001', 'K01', '3', 'ไม่/', 'No/', 'Less'),
('001', '001', 'K01', '4', 'ลด/', 'Less/', 'Less/'),
('001', '001', 'K01', '5', 'แยก/', 'Seperate/', 'Seperate/'),
('001', '001', 'K01', '6', 'ทำเป็น/', 'Change/', 'Change/');

-- --------------------------------------------------------

--
-- Table structure for table `orderheader`
--

DROP TABLE IF EXISTS `orderheader`;
CREATE TABLE `orderheader` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `TableType` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'T=TakeOut',
  `Pax` tinyint(4) DEFAULT NULL COMMENT 'จำนวนคน'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `orderheader`
--

INSERT INTO `orderheader` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `TableType`, `Pax`) VALUES
('001', '001', 'K01', '2019-10-24', '001', '15:27', '', 1),
('001', '001', 'K01', '2019-10-24', '002', '15:32', '', 3),
('001', '001', 'K01', '2019-10-24', '002', '17:11', '', 1),
('001', '001', 'K01', '2019-10-24', '003', '15:27', '', 1),
('001', '001', 'K01', '2019-10-24', '003', '17:40', '', 1),
('001', '001', 'K01', '2019-10-24', '003', '18:20', '', 1),
('001', '001', 'K01', '2019-10-24', '004', '15:27', '', 1),
('001', '001', 'K01', '2019-10-24', '004', '17:40', '', 0),
('001', '001', 'K01', '2019-10-24', '005', '15:27', '', 1),
('001', '001', 'K01', '2019-10-24', '006', '17:20', '', 2),
('001', '001', 'K01', '2019-10-24', '007', '17:40', '', 0),
('001', '001', 'K01', '2019-10-24', '008', '17:40', '', 0),
('001', '001', 'K01', '2019-10-24', '009', '17:40', '', 1),
('001', '001', 'K01', '2019-10-24', '010', '17:10', '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', '', 1),
('001', '001', 'K01', '2019-10-28', '005', '10:42', '', 1),
('001', '001', 'K01', '2019-10-28', '005', '11:29', '', 1),
('001', '001', 'K01', '2019-10-28', '005', '11:48', '', 1),
('001', '001', 'K01', '2019-10-28', '005', '12:11', '', 1),
('001', '001', 'K01', '2019-10-28', '007', '10:41', '', 1),
('001', '001', 'K01', '2019-10-29', '001', '12:13', '', 2),
('001', '001', 'K01', '2019-10-29', '001', '12:14', '', 2),
('001', '001', 'K01', '2019-10-29', '001', '12:17', '', 1),
('001', '001', 'K01', '2019-10-29', '001', '12:41', '', 1),
('001', '001', 'K01', '2019-10-29', '001', '13:27', '', 1),
('001', '001', 'K01', '2019-10-29', '001', '14:43', '', 2),
('001', '001', 'K01', '2019-10-29', '001', '15:11', '', 2),
('001', '001', 'K01', '2019-10-29', '001', '15:17', '', 1),
('001', '001', 'K01', '2019-10-29', '001', '15:19', '', 1),
('001', '001', 'K01', '2019-10-29', '001', '15:29', '', 2),
('001', '001', 'K01', '2019-10-29', '001', '15:37', '', 1),
('001', '001', 'K01', '2019-10-29', '001', '16:25', '', 1),
('001', '001', 'K01', '2019-10-29', '002', '12:13', '', 2),
('001', '001', 'K01', '2019-10-29', '002', '12:17', '', 1),
('001', '001', 'K01', '2019-10-29', '002', '15:29', '', 2),
('001', '001', 'K01', '2019-10-29', '003', '12:14', '', 1),
('001', '001', 'K01', '2019-10-29', '003', '15:29', '', 1),
('001', '001', 'K01', '2019-10-29', '004', '15:13', '', 1),
('001', '001', 'K01', '2019-10-29', '004', '15:33', '', 5),
('001', '001', 'K01', '2019-10-29', '005', '15:33', '', 5),
('001', '001', 'K01', '2019-10-29', '005', '16:24', '', 4),
('001', '001', 'K01', '2019-10-29', '006', '12:17', '', 1),
('001', '001', 'K01', '2019-10-29', '006', '15:31', '', 1),
('001', '001', 'K01', '2019-10-29', '006', '15:37', '', 1),
('001', '001', 'K01', '2019-10-29', '007', '15:14', '', 2),
('001', '001', 'K01', '2019-10-29', '007', '15:31', '', 1),
('001', '001', 'K01', '2019-10-29', '008', '15:31', '', 1),
('001', '001', 'K01', '2019-10-29', '009', '12:20', '', 1),
('001', '001', 'K01', '2019-10-29', '009', '15:29', '', 2),
('001', '001', 'K01', '2019-10-29', '009', '15:37', '', 1),
('001', '001', 'K01', '2019-10-30', '003', '15:39', '', 2),
('001', '001', 'K01', '2019-10-30', '003', '16:51', '', 20),
('001', '001', 'K01', '2019-10-30', '004', '10:20', '', 2),
('001', '001', 'K01', '2019-10-30', '005', '11:45', '', 2);

-- --------------------------------------------------------

--
-- Table structure for table `orderhistory`
--

DROP TABLE IF EXISTS `orderhistory`;
CREATE TABLE `orderhistory` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `ItemNo` int(3) UNSIGNED NOT NULL,
  `Level` int(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'ลำดับอาหารชุด',
  `SubLevel` int(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'ลำดับย่อย',
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL COMMENT 'รหัสสินค้า',
  `ReferenceId` decimal(11,8) NOT NULL COMMENT 'อ้างอิง',
  `ItemName` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Product Name Show',
  `LocalName` text COLLATE utf8_unicode_ci,
  `EnglishName` text COLLATE utf8_unicode_ci,
  `OtherName` text COLLATE utf8_unicode_ci,
  `SizeId` varchar(2) COLLATE utf8_unicode_ci NOT NULL COMMENT 'ประเภท Size = 1 - 5',
  `SizeName` text COLLATE utf8_unicode_ci COMMENT 'Size Name',
  `SizeLocalName` text COLLATE utf8_unicode_ci,
  `SizeEnglishName` text COLLATE utf8_unicode_ci,
  `SizeOtherName` text COLLATE utf8_unicode_ci,
  `OrgSize` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'เก็บ Size ก่อนเปลี่ยน',
  `DepartmentId` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Department',
  `CategoryId` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Category',
  `AddModiCode` text COLLATE utf8_unicode_ci COMMENT 'รายการ modify',
  `TotalAmount` decimal(14,4) DEFAULT NULL COMMENT 'ยอดรวม',
  `Quantity` decimal(8,4) DEFAULT NULL COMMENT 'จำนวน ',
  `OrgQty` decimal(8,4) DEFAULT NULL COMMENT 'จำนวน ก่อนเปลี่ยน',
  `UnitPrice` decimal(14,4) DEFAULT NULL COMMENT 'ราคาต่อหน่วย',
  `Free` tinyint(1) DEFAULT NULL COMMENT 'รายการฟรี',
  `noService` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `Status` varchar(1) COLLATE utf8_unicode_ci NOT NULL COMMENT 'V=Void',
  `PrintTo` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'พิมพ์ที่ Value=123',
  `NeedPrint` tinyint(1) DEFAULT NULL COMMENT 'รายการใหม่ = true',
  `LocalPrint` tinyint(1) DEFAULT NULL COMMENT 'print to local printer',
  `KitchenLang` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `Parent` tinyint(1) DEFAULT NULL COMMENT 'item หลัก(มี modify) = true',
  `Child` tinyint(1) DEFAULT NULL COMMENT 'modify=true',
  `OrderDate` date DEFAULT NULL COMMENT 'วันที่ order',
  `OrderTime` time DEFAULT NULL COMMENT 'เวลา order',
  `KitchenNote` text COLLATE utf8_unicode_ci COMMENT 'open modifier',
  `MainItem` tinyint(1) DEFAULT '0' COMMENT 'รายการหลัก',
  `GuestName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ชื่อผู้ order',
  `isPackage` tinyint(1) DEFAULT NULL COMMENT 'อาหารชุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `orderhistory`
--

INSERT INTO `orderhistory` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `Level`, `SubLevel`, `ItemId`, `ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`, `SizeId`, `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `OrgSize`, `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`, `MainItem`, `GuestName`, `isPackage`) VALUES
('001', '001', 'K01', '2019-10-24', '001', '15:27', 1, 0, 1, '010003', '340.02990000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '17:00:05', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 1, 0, 1, '010017', '326.81990000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '5', 'E', 'E', 'E', 'N/A', '5', '1', '01', '', '1500.0000', '5.0000', '5.0000', '300.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '03:52:33', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 2, 0, 2, '090011', '326.82030000', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:54:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 3, 0, 3, '090013', '326.82070000', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:54:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 4, 0, 4, '090014', '326.82110000', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:54:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 5, 0, 5, '090015', '326.82150000', 'ไอศกรีมทุเรียน+กล้วย', 'ไอศกรีมทุเรียน+กล้วย', 'ไอศกรีมทุเรียน+กล้วย', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:54:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 6, 0, 6, '090018', '326.82190000', 'ไอศกรีมช็อคโกแลต+กล้วย', 'ไอศกรีมช็อคโกแลต+กล้วย', 'ไอศกรีมช็อคโกแลต+กล้วย', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:55:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 7, 0, 7, '090019', '326.82230000', 'เยลลี่', 'เยลลี่', 'เยลลี่', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '20.0000', '1.0000', '1.0000', '20.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:55:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 8, 0, 8, '090017', '326.82270000', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '270.0000', '6.0000', '6.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '04:18:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 9, 0, 9, '090025', '326.82300000', 'บัวลอยเผือก', 'บัวลอยเผือก', 'บัวลอยเผือก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '35.0000', '1.0000', '1.0000', '35.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:55:06', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 10, 0, 10, '090024', '326.82350000', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:55:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 11, 0, 11, '050003', '326.82380000', 'ตำปู', 'ตำปู', 'ตำปู', 'ตำปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '03:56:06', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 12, 0, 12, '050004', '326.82420000', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '75.0000', '1.0000', '1.0000', '75.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '03:56:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 13, 0, 13, '050007', '326.82460000', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '80.0000', '1.0000', '1.0000', '80.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '03:56:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 14, 0, 14, '090025', '326.82500000', 'บัวลอยเผือก', 'บัวลอยเผือก', 'บัวลอยเผือก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '35.0000', '1.0000', '1.0000', '35.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:56:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 15, 0, 15, '090024', '326.82540000', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '03:56:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 16, 0, 16, '010017', '326.82580000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '720.0000', '6.0000', '6.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '04:10:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 17, 0, 17, '050001', '326.82770000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '440.0000', '4.0000', '4.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '04:16:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 17, 0, 18, '050002', '326.82970000', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '280.0000', '4.0000', '4.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '04:16:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 17, 0, 19, '130008', '326.83160000', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '160.0000', '4.0000', '4.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-24', '04:16:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 17, 0, 20, '140073', '326.83360000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '160.0000', '4.0000', '4.0000', '40.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-24', '04:16:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 17, 0, 21, '500003', '326.83520000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '1200.0000', '4.0000', '4.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-24', '04:16:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '15:32', 18, 0, 22, '500003', '326.83550000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-24', '04:17:30', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-24', '002', '17:11', 1, 0, 1, '030002', '353.18610000', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-24', '05:11:57', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '17:11', 2, 0, 2, '030003', '353.18660000', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-24', '05:12:05', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '002', '17:11', 3, 0, 3, '210003', '353.18690000', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '21', '', '100.0000', '4.0000', '4.0000', '25.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-24', '05:30:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '003', '15:27', 1, 0, 1, '010013', '340.06320000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '130.0000', '1.0000', '0.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-24', '17:00:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 1, 0, 0, '020003', '382.76938835', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '02', '', '100.0000', '1.0000', '0.0000', '100.0000', 0, 0, 0, '*', '6', 1, 0, '', 0, 0, '2019-10-24', '17:54:19', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 2, 0, 0, '500001', '854.70598679', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '0', '', '', '', '', '', '1', '50', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 1, 0, '', 1, 0, '2019-10-24', '17:59:41', '', 1, '', 1),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 2, 1, 0, '020002', '854.99590616', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '1', '', '', '', '', '', '1', '02', '', '80.0000', '1.0000', '0.0000', '80.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '17:59:41', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 2, 2, 0, '010003', '260.86769974', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '17:59:41', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 2, 3, 0, '050001', '648.69153224', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '17:59:41', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 2, 4, 0, '130001', '278.43690545', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '40.0000', '1.0000', '0.0000', '40.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 1, '2019-10-24', '17:59:41', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 3, 0, 0, '500001', '187.95393490', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '0', '', '', '', '', '', '1', '50', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 1, 0, '', 1, 0, '2019-10-24', '18:00:09', '', 1, '', 1),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 3, 1, 0, '010017', '714.69897197', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', '', '', '', '', '', '1', '01', '', '120.0000', '1.0000', '0.0000', '120.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:00:09', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 3, 2, 0, '010003', '505.61193534', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:00:09', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 3, 3, 0, '050001', '558.07838229', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:00:09', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '17:40', 3, 4, 0, '130001', '881.52612731', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '40.0000', '1.0000', '0.0000', '40.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 1, '2019-10-24', '18:00:09', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 1, 0, 0, '500001', '878.67835661', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', '', '', '', '', '', '1', '50', '', '150.0000', '1.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 1, 0, '', 1, 0, '2019-10-24', '18:21:50', '', 1, '', 1),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 1, 1, 0, '010017', '938.05174073', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', '', '', '', '', '', '1', '01', '', '120.0000', '1.0000', '0.0000', '120.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:21:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 1, 2, 0, '010003', '519.03954699', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:21:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 1, 3, 0, '050001', '123.90565242', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:21:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 1, 4, 0, '130001', '553.86521811', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '40.0000', '1.0000', '0.0000', '40.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 1, '2019-10-24', '18:21:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 2, 0, 0, '500001', '864.53561806', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', '', '', '', '', '', '1', '50', '', '150.0000', '1.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 1, 0, '', 1, 0, '2019-10-24', '18:23:52', '', 1, '', 1),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 2, 1, 0, '010017', '147.35631339', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', '', '', '', '', '', '1', '01', '', '120.0000', '1.0000', '0.0000', '120.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:23:52', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 2, 2, 0, '010003', '180.16750856', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:23:52', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 2, 3, 0, '050001', '95.65871570', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-24', '18:23:52', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 2, 4, 0, '130001', '117.89713217', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '40.0000', '1.0000', '0.0000', '40.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 1, '2019-10-24', '18:23:52', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '285.64193404', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '403.82993190', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '635.29228905', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '662.90042967', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '736.34818429', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '764.30489743', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '783.95983485', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '010003', '856.36098170', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '215.85214135', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '556.68989840', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '558.35054538', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '561.85245787', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '612.54880263', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '663.66196394', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '819.72084250', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050001', '880.61089599', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '220.0000', '2.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '21.96131558', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '24.41668540', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '61.39818507', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '75.02889557', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '213.60660920', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '455.79284107', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '862.45975298', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '050002', '997.25612552', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', '', '', '', '', '', '1', '05', '', '140.0000', '2.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '42.67476694', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '67.38324151', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '172.81777627', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '523.47297597', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '554.50840662', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '748.63458066', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '775.07562156', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130008', '883.32409855', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '278.85812817', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '505.07550171', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '682.00347523', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '725.12756955', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '866.01237152', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '914.27551389', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '938.64457800', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130009', '968.47419850', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '60.0000', '2.0000', '0.0000', '30.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '133.09948474', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '370.30181786', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '375.59419708', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '416.38007321', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '761.98061403', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '870.74148878', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '924.31548145', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '130010', '924.53510398', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', '', '', '', '', '', '3', '13', '', '100.0000', '2.0000', '0.0000', '50.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '3.58334780', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '56.70026835', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '301.34848272', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '317.51814131', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '504.11891313', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '539.49835730', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '541.70183955', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '140073', '694.30055394', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', '', '', '', '', '', '4', '14', '', '80.0000', '2.0000', '0.0000', '40.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '255.92396443', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '266.87177199', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '466.42333999', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '493.02172602', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '600.15112534', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '735.01072307', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '847.65923507', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '003', '18:20', 3, 0, 0, '500003', '931.50559516', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', '', '', '', '', '', '1', '50', '', '600.0000', '2.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 0, '2019-10-24', '18:26:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-24', '004', '15:27', 1, 0, 1, '010003', '340.09090000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '17:00:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '004', '15:27', 2, 0, 2, '010008', '340.09670000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '130.0000', '1.0000', '0.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '17:00:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '005', '15:27', 1, 0, 1, '010003', '340.12690000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '17:00:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 1, 0, 1, '190024', '347.24700000', 'Package 999', 'Package 999', 'Package 999', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '19', '', '999.0000', '1.0000', '1.0000', '999.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-24', '05:21:21', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 1, 1, 2, '010001', '347.24750000', '', '', '', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '', '', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 1, '', 0, 1, '2019-10-24', '05:21:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 2, 0, 3, '190015', '348.09910000', 'ส้มตำไทย(ฟรี Rabbit)', 'ส้มตำไทย(ฟรี Rabbit)', 'ส้มตำไทย(ฟรี Rabbit)', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '19', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-24', '05:21:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 3, 0, 4, '210001', '348.09950000', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '21', '', '225.0000', '9.0000', '9.0000', '25.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-24', '05:22:33', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 4, 0, 5, '210001', '348.09980000', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '21', '', '25.0000', '1.0000', '1.0000', '25.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-24', '05:23:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 5, 0, 6, '210002', '356.39360000', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '21', '', '25.0000', '1.0000', '1.0000', '25.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-24', '05:24:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 6, 0, 7, '210002', '356.39410000', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '21', '', '175.0000', '7.0000', '7.0000', '25.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-24', '05:24:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 7, 0, 8, '010013', '357.71320000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-24', '17:53:08', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 8, 0, 9, '190007', '358.68780000', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '19', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-24', '05:52:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 9, 0, 10, '190008', '358.68820000', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '19', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-24', '05:52:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 10, 0, 11, '190002', '358.68860000', 'โปรปลากะพงเขียวหวาน', 'โปรปลากะพงเขียวหวาน', 'โปรปลากะพงเขียวหวาน', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '19', '', '299.0000', '1.0000', '1.0000', '299.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '05:54:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 11, 0, 12, '190008', '358.68900000', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '19', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-24', '05:54:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 12, 0, 13, '190007', '360.95130000', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '19', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-24', '05:58:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 0, 14, '500003', '360.95170000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-24', '05:59:25', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 1, 15, '010003', '360.95210000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-24', '05:59:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 2, 16, '050002', '360.95250000', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-24', '05:59:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 2, 17, '050003', '360.95290000', 'ตำปู', 'ตำปู', 'ตำปู', 'ตำปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-24', '05:59:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 3, 18, '140073', '360.95330000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-24', '05:59:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 4, 19, '130008', '360.95370000', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-24', '05:59:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 4, 20, '130009', '360.95410000', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-24', '05:59:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 13, 4, 21, '130010', '360.95440000', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '50.0000', '1.0000', '1.0000', '50.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-24', '05:59:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 14, 0, 22, '010003', '360.95640000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '220.0000', '2.0000', '2.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '06:02:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 14, 0, 23, '010017', '360.95830000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '300.0000', '2.0000', '2.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '06:02:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 14, 0, 24, '050001', '360.96030000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '220.0000', '2.0000', '2.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '06:02:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 14, 0, 25, '130001', '360.96230000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '80.0000', '2.0000', '2.0000', '40.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-24', '06:02:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-24', '006', '17:20', 14, 0, 26, '500001', '360.96420000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '2.0000', '2.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-24', '06:02:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 1, 0, 0, '500001', '89.79178071', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', '', '', '', '', '', '1', '50', '', '150.0000', '1.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 1, 0, '', 1, 0, '2019-10-28', '17:22:50', '', 1, '', 1),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 1, 1, 1, '020003', '28.37672405', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', '1', '', '', '', '', '', '1', '02', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '6', 1, 0, '', 0, 1, '2019-10-28', '17:22:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 1, 2, 1, '010003', '69.79533137', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-28', '17:22:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 1, 3, 1, '050001', '336.68227935', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', '', '', '', '', '', '1', '05', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-28', '17:22:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 1, 4, 1, '130001', '660.77415774', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', '', '', '', '', '', '3', '13', '', '0.0000', '3.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 1, '2019-10-28', '17:22:50', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 2, 0, 0, '500002', '880.51017611', 'ชุด B', 'ชุด B', 'Set B', 'N/A', '1', '', '', '', '', '', '1', '50', '', '250.0000', '1.0000', '0.0000', '250.0000', 0, 0, 0, '*', '2', 1, 0, '', 1, 0, '2019-10-28', '18:06:04', '', 1, '', 1),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 2, 1, 1, '010003', '987.71385462', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-28', '18:06:04', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 2, 1, 2, '010004', '819.12768323', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', '', '', '', '', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-28', '18:06:04', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 2, 3, 1, '140046', '390.60105170', 'บ๊วย 3 รส', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '1', '', '', '', '', '', '4', '14', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 1, '2019-10-28', '18:06:04', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 3, 0, 0, '500002', '415.71160015', 'ชุด B', 'ชุด B', 'Set B', 'N/A', '1', '', '', '', '', '', '1', '50', '', '250.0000', '1.0000', '0.0000', '250.0000', 0, 0, 0, '*', '2', 1, 0, '', 1, 0, '2019-10-28', '18:06:41', '', 1, '', 1),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 3, 1, 1, '010003', '126.80566331', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', '', '', '', '', '', '1', '01', '', '0.0000', '2.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 1, '2019-10-28', '18:06:41', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 3, 2, 1, '020004', '590.16184897', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '1', '', '', '', '', '', '1', '02', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '6', 1, 0, '', 0, 1, '2019-10-28', '18:06:41', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '001', '10:40', 3, 3, 1, '140046', '38.05173002', 'บ๊วย 3 รส', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '1', '', '', '', '', '', '4', '14', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 1, 0, '', 0, 1, '2019-10-28', '18:06:41', '', 1, '', 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 1, 0, 1, '500001', '222.94960000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '11:08:34', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 1, 1, 2, '010017', '222.94990000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:08:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 1, 2, 3, '010003', '222.95020000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:08:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 1, 3, 4, '050001', '222.95060000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:08:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 1, 4, 5, '130001', '222.95080000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '11:08:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 2, 0, 6, '500002', '223.55050000', 'ชุด B', 'ชุด B', 'Set B', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '250.0000', '1.0000', '1.0000', '250.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-28', '11:10:24', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 2, 1, 7, '010017', '223.55080000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '4', 'N/A', 'N/A', 'N/A', 'N/A', '4', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:10:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 2, 2, 8, '220017', '223.55110000', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '22', '', '15.0000', '1.0000', '1.0000', '15.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-28', '11:10:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 2, 3, 9, '020006', '223.55140000', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '100.0000', '1.0000', '1.0000', '100.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '11:10:24', '', 1, NULL, 0);
INSERT INTO `orderhistory` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `Level`, `SubLevel`, `ItemId`, `ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`, `SizeId`, `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `OrgSize`, `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`, `MainItem`, `GuestName`, `isPackage`) VALUES
('001', '001', 'K01', '2019-10-28', '005', '10:42', 2, 4, 10, '020008', '223.55170000', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '11:10:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 2, 5, 11, '100001', '223.55200000', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-28', '11:10:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 0, 12, '190024', '224.70420000', 'Package 999', 'Package 999', 'Package 999', '', '1', 'N/A', 'N/A', 's', 'N/A', '', '1', '19', '', '999.0000', '1.0000', '0.0000', '999.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '11:14:06', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 1, 13, '010001', '20.78170000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '11:14:06', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 2, 14, '020007', '67.52100000', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '02', 'M3A012', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-28', '11:14:08', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 2, 15, 'M3A012', '45.32570000', 'ไม่เผ็ดมาก', 'ไม่เผ็ดมาก', 'Noเผ็ดมาก', 'Lessเผ็ดมาก', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '', '', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:14:19', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 2, 16, '020009', '24.25890000', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '02', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:14:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 3, 17, '040027', '86.78610000', 'ไข่ดาว', 'ไข่ดาว', 'ไข่ดาว', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '04', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:14:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 4, 18, '210004', '37.72410000', 'น้ำมะตูม', 'น้ำมะตูม', 'น้ำมะตูม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '2', '21', 'M5A013', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 1, 1, '2019-10-28', '11:14:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '10:42', 3, 4, 19, 'M5A013', '80.45130000', 'แยกเค็ม', 'แยกเค็ม', 'Seperateเค็ม', 'Seperateเค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '', '', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '11:14:50', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 1, 0, 1, '500001', '230.26600000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '11:30:37', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 1, 1, 2, '010017', '230.26630000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:30:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 1, 2, 3, '010003', '230.26670000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:30:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 1, 3, 4, '050001', '230.26720000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:30:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 1, 4, 5, '130001', '230.26750000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '11:30:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 2, 0, 6, '500001', '231.37690000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '11:34:07', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 2, 1, 7, '010017', '55.48430000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:34:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 2, 2, 8, '010003', '90.87820000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:34:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 2, 3, 9, '050001', '83.31940000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:34:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:29', 2, 4, 10, '130001', '24.35460000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '11:34:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 1, 0, 1, '500001', '236.18570000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '11:48:33', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 1, 1, 2, '010017', '55.48430000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 1, 2, 3, '010003', '90.87820000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 1, 3, 4, '050001', '83.31940000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 1, 4, 5, '130001', '24.35460000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 2, 0, 6, '500001', '241.12360000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '12:02:37', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 2, 1, 7, '010017', '241.12390000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:02:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 2, 2, 8, '010003', '241.12430000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:02:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 2, 3, 9, '050001', '241.12480000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:02:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 2, 4, 10, '130001', '241.12510000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '12:02:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '11:48', 3, 0, 11, '010002', '242.86320000', '(เจ)ตำผลไม้รวม', '(เจ)ตำผลไม้รวม', '(เจ)ตำผลไม้รวม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '75.0000', '1.0000', '0.0000', '75.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-28', '12:08:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 1, 0, 1, '500001', '244.16980000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '12:12:23', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 1, 1, 2, '020002', '244.17020000', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:12:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 1, 2, 3, '010003', '244.17050000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:12:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 1, 3, 4, '050001', '244.17100000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:12:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 1, 4, 5, '130001', '244.17130000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '12:12:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 2, 0, 6, '500001', '244.27630000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '12:12:49', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 2, 1, 7, '010017', '57.82180000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:12:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 2, 2, 8, '010003', '33.67050000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:12:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 2, 3, 9, '050001', '67.30920000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:12:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 2, 4, 10, '130001', '40.21140000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '12:12:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 3, 0, 11, '500002', '244.53240000', 'ชุด B', 'ชุด B', 'Set B', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '250.0000', '1.0000', '1.0000', '250.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-28', '12:13:22', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 3, 1, 12, '010016', '244.53280000', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 3, 2, 13, '220017', '244.53320000', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '22', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-28', '12:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 3, 3, 14, '020006', '244.53360000', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '12:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 3, 4, 15, '020008', '244.53400000', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '12:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 3, 5, 16, '100001', '244.53440000', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-28', '12:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 4, 0, 17, '010013', '244.70530000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', 'M1A001', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 1, 0, '2019-10-28', '12:14:06', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 4, 0, 18, 'M1A001', '82.31980000', 'เปรี้ยว', 'เปรี้ยว', 'เปรี้ยว', 'เปรี้ยว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '', '', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '12:14:10', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 5, 0, 19, '190024', '244.76460000', 'Package 999', 'Package 999', 'Package 999', '', '1', 'N/A', 'N/A', 's', 'N/A', '1', '1', '19', '', '999.0000', '1.0000', '1.0000', '999.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '12:14:17', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 5, 1, 20, '010001', '20.82190000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '12:14:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 5, 2, 21, '020009', '28.39610000', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', 'M1A002', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-28', '12:14:19', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 5, 2, 22, 'M1A002', '61.88460000', 'เปรี้ยวนำ', 'เปรี้ยวนำ', 'เปรี้ยวนำ', 'เปรี้ยวนำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '', '', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:14:26', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 5, 2, 23, '020010', '88.71750000', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:14:19', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 5, 3, 24, '040027', '88.17600000', 'ไข่ดาว', 'ไข่ดาว', 'ไข่ดาว', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:14:20', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 5, 4, 25, '210004', '64.59330000', 'น้ำมะตูม', 'น้ำมะตูม', 'น้ำมะตูม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '21', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '12:14:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 0, 26, '500003', '244.86790000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-28', '12:13:58', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 1, 27, '010006', '244.86830000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '12:13:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 2, 28, '050003', '244.86870000', 'ตำปู', 'ตำปู', 'ตำปู', 'ตำปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:13:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 2, 29, '050004', '244.86910000', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:13:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 3, 30, '140073', '244.86950000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-28', '12:13:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 4, 31, '130008', '244.86990000', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-28', '12:13:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 4, 32, '130009', '244.87020000', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '12:13:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 6, 4, 33, '130010', '244.87070000', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '12:13:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 7, 0, 34, '190024', '245.70820000', 'Package 999', 'Package 999', 'Package 999', '', '1', 'N/A', 'N/A', 's', 'N/A', '', '1', '19', '', '999.0000', '1.0000', '0.0000', '999.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '12:17:07', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 7, 1, 35, '010001', '51.80550000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-28', '12:17:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 7, 2, 36, '020007', '39.64300000', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '02', 'M1A003', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-28', '12:17:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 7, 2, 37, 'M1A003', '38.34840000', 'เปรี้ยวน้อย', 'เปรี้ยวน้อย', 'เปรี้ยวน้อย', 'เปรี้ยวน้อย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '', '', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:17:16', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 7, 2, 38, '020009', '38.81980000', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '02', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:17:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 7, 3, 39, '040027', '10.46150000', 'ไข่ดาว', 'ไข่ดาว', 'ไข่ดาว', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '04', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '12:17:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '005', '12:11', 7, 4, 40, '210004', '72.49120000', 'น้ำมะตูม', 'น้ำมะตูม', 'น้ำมะตูม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '2', '21', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '12:17:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '007', '10:41', 1, 0, 1, '500001', '238.80930000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-28', '11:48:33', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-28', '007', '10:41', 1, 1, 2, '010017', '238.80970000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '007', '10:41', 1, 2, 3, '010003', '238.81010000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '007', '10:41', 1, 3, 4, '050001', '238.81050000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-28', '007', '10:41', 2, 4, 5, '130001', '238.81090000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-28', '11:48:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:13', 1, 0, 1, '010009', '244.53810000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '170.0000', '1.0000', '0.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:13:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:13', 2, 0, 2, '010003', '244.53990000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:13:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:13', 3, 0, 3, '500001', '244.56770000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '50', '', '150.0000', '1.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '12:13:42', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '12:13', 3, 1, 4, '010017', '24.35460000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:13:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:13', 3, 2, 5, '010003', '76.86130000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:13:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:13', 3, 3, 6, '050001', '55.77660000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '05', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:13:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:13', 3, 4, 7, '130001', '13.53180000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '3', '13', '', '0.0000', '3.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '12:13:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 1, 0, 1, '010003', '245.13040000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:15:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 2, 0, 2, '010008', '245.13170000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:15:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 3, 0, 3, '010009', '245.13290000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:15:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 4, 0, 4, '500002', '245.14390000', 'ชุด B', 'ชุด B', 'Set B', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '250.0000', '1.0000', '1.0000', '250.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '12:15:25', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 4, 1, 5, '010004', '64.59330000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:27', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 4, 1, 6, '010004', '61.88460000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:28', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 4, 2, 7, '020005', '51.80550000', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-29', '12:15:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:14', 4, 3, 8, '140046', '39.64300000', 'บ๊วย 3 รส', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '12:15:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 1, 0, 0, '050002', '147.92325983', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '05', '', '70.0000', '1.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:17:54', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 2, 0, 0, '050001', '685.32258460', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '05', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:17:56', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 3, 0, 0, '070002', '165.31838284', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '07', '', '250.0000', '1.0000', '0.0000', '250.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:18:01', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 4, 0, 0, '070001', '386.96546626', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '07', '', '190.0000', '1.0000', '0.0000', '190.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:18:02', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 5, 0, 0, '220011', '236.45825467', 'ข้าวผัดปู', 'ข้าวผัดปู', 'ข้าวผัดปู', 'N/A', '1', 'เล็ก', 'เล็ก', 'เล็ก', 'N/A', '', '1', '22', '', '90.0000', '1.0000', '0.0000', '90.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:18:38', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 5, 0, 0, '220011', '358.58963715', 'ข้าวผัดปู', 'ข้าวผัดปู', 'ข้าวผัดปู', 'N/A', '1', 'เล็ก', 'เล็ก', 'เล็ก', 'N/A', '', '1', '22', '', '90.0000', '1.0000', '0.0000', '90.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:18:37', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 5, 0, 0, '220011', '688.02105995', 'ข้าวผัดปู', 'ข้าวผัดปู', 'ข้าวผัดปู', 'N/A', '1', 'เล็ก', 'เล็ก', 'เล็ก', 'N/A', '', '1', '22', '', '90.0000', '1.0000', '0.0000', '90.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:18:38', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:17', 5, 0, 0, '220011', '862.87167869', 'ข้าวผัดปู', 'ข้าวผัดปู', 'ข้าวผัดปู', 'N/A', '1', 'เล็ก', 'เล็ก', 'เล็ก', 'N/A', '', '1', '22', '', '90.0000', '1.0000', '0.0000', '90.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-29', '12:18:37', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 1, 0, 1, '010003', '259.66680000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:59:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 2, 0, 2, '010004', '259.66820000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:59:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 3, 0, 3, '500001', '259.67560000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '12:59:01', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 3, 1, 4, '010017', '55.48430000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:59:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 3, 2, 5, '010003', '90.87820000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', 'M1A001', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-29', '12:59:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 3, 2, 6, 'M1A001', '76.86130000', 'เปรี้ยว', 'เปรี้ยว', 'เปรี้ยว', 'เปรี้ยว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '', '', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:59:07', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 3, 3, 7, '050001', '83.31940000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:59:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 3, 4, 8, '130001', '24.35460000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '12:59:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 4, 0, 9, '500001', '260.33940000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '01:00:25', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 4, 1, 10, '020002', '260.33980000', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '01:00:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 4, 2, 11, '010003', '260.34010000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '01:00:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 4, 3, 12, '050001', '260.34040000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '01:00:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 4, 4, 13, '130001', '260.34070000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '01:00:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 5, 0, 14, '120024', '260.50090000', 'ไอศกรีมข้าวไรซ์ฯ 1/2 โล', 'ไอศกรีมข้าวไรซ์ฯ 1/2 โล', 'ไอศกรีมข้าวไรซ์ฯ 1/2 โล', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '100.0000', '1.0000', '1.0000', '100.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-29', '13:01:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 6, 0, 15, '500001', '260.52530000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '13:01:34', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 6, 1, 16, '010017', '55.77660000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '2', '1', '01', 'M2B001', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-29', '13:01:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 6, 1, 17, 'M2B001', '33.67050000', 'เพิ่มตับหมู', 'เพิ่มตับหมู', 'Addตับหมู', 'Add', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '', '', '', '10.0000', '1.0000', '1.0000', '10.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '13:01:43', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 6, 2, 18, '010003', '13.53180000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '13:01:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 6, 3, 19, '050001', '38.06270000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '13:01:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '12:41', 6, 4, 20, '130001', '57.82180000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '13:01:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 1, 0, 1, '010003', '269.24720000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '13:27:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 2, 0, 2, '010004', '269.25220000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '13:27:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 3, 0, 3, '080006', '269.25910000', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '13:27:46', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 4, 0, 4, '090006', '269.26890000', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '60.0000', '1.0000', '1.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-29', '13:27:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 5, 0, 5, '100002', '269.27600000', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-29', '13:27:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 6, 0, 6, '050002', '269.28440000', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '13:27:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 7, 0, 7, '050007', '269.28640000', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '80.0000', '1.0000', '1.0000', '80.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '13:27:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 8, 0, 8, '050008', '269.28790000', 'ตำมั่วลาว', 'ตำมั่วลาว', 'ตำมั่วลาว', 'ตำมั่วลาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '80.0000', '1.0000', '1.0000', '80.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '13:27:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 9, 0, 9, '010006', '269.44190000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '01:27:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 10, 0, 10, '010005', '269.44240000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '01:27:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 11, 0, 11, '010004', '269.44270000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '01:27:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 0, 12, '500003', '292.62560000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-29', '02:37:32', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 1, 13, '010003', '292.62600000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '02:37:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 1, 14, '010004', '292.62640000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '02:37:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 1, 15, '010005', '292.62680000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '02:37:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 1, 20, '010003', '51.80550000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '14:38:06', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 1, 21, '010009', '39.64300000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '14:38:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 2, 16, '050001', '292.62720000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '2.0000', '2.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '02:37:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 3, 17, '140073', '292.62760000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-29', '02:37:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 4, 18, '130009', '292.62800000', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '02:37:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 12, 4, 19, '130010', '292.62840000', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '02:37:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 13, 0, 22, '190001', '292.73950000', 'โปรเปิดร้านสุดคุ้ม', 'โปรเปิดร้านสุดคุ้ม', 'โปรเปิดร้านสุดคุ้ม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '19', '', '199.0000', '1.0000', '1.0000', '199.0000', 0, 0, 0, '*', '5', 0, 0, '', 1, 0, '2019-10-29', '14:38:13', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 13, 1, 23, '020001', '38.81980000', 'ยำปลาทับทิมอบอ้อย', 'ยำปลาทับทิมอบอ้อย', 'ยำปลาทับทิมอบอ้อย', 'ยำปลาทับทิมอบอ้อย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '14:38:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 13, 2, 24, '030001', '10.46150000', 'ปลาทับทิมอบอ้อย', 'ปลาทับทิมอบอ้อย', 'ปลาทับทิมอบอ้อย', 'ปลาทับทิมอบอ้อย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', 'M1A011', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-29', '14:38:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 13, 2, 25, 'M1A011', '72.49120000', 'เผ็ดน้อย', 'เผ็ดน้อย', 'เผ็ดน้อย', 'เผ็ดน้อย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '', '', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '14:38:20', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 14, 0, 26, '190008', '292.75850000', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '19', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-29', '14:38:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 15, 0, 27, '010004', '293.99120000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '70.0000', '1.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '14:41:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '13:27', 16, 0, 0, '090004', '631.71788456', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '3', '09', '', '40.0000', '1.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 1, 0, '', 0, 0, '2019-10-29', '14:42:09', '', 1, '', 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 1, 0, 1, '090003', '294.66640000', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-29', '02:43:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 2, 0, 2, '500001', '294.66690000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '02:43:49', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 2, 1, 3, '010017', '294.66720000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '02:43:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 2, 2, 4, '010003', '294.66770000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '02:43:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 2, 3, 5, '050001', '294.66800000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '02:43:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 2, 4, 6, '130001', '294.66840000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '02:43:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 3, 0, 7, '500001', '294.73200000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '2.0000', '2.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '14:44:11', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 3, 1, 8, '010017', '1.68930000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '2', '1', '01', '', '0.0000', '2.0000', '2.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '14:44:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 3, 2, 9, '010003', '89.02230000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '2.0000', '2.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '14:44:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 3, 3, 10, '050001', '24.18040000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', 'M1A001', '0.0000', '2.0000', '2.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-29', '14:44:13', '', 1, NULL, 0);
INSERT INTO `orderhistory` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `Level`, `SubLevel`, `ItemId`, `ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`, `SizeId`, `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `OrgSize`, `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`, `MainItem`, `GuestName`, `isPackage`) VALUES
('001', '001', 'K01', '2019-10-29', '001', '14:43', 3, 3, 11, 'M1A001', '80.38560000', 'เปรี้ยว', 'เปรี้ยว', 'เปรี้ยว', 'เปรี้ยว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '', '', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '14:44:21', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '14:43', 3, 4, 12, '130001', '8.87090000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '6.0000', '6.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '14:44:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:11', 1, 0, 1, '010003', '304.02620000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:12:04', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:11', 2, 0, 2, '010009', '304.02850000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:12:05', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:17', 1, 0, 1, '010005', '305.76830000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:17:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:17', 2, 0, 2, '010012', '305.77280000', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:17:19', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:19', 1, 0, 1, '010009', '306.52460000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:19:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:29', 1, 0, 1, '010010', '309.84160000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:29:31', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:37', 1, 0, 1, '010014', '327.70460000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '16:23:06', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:37', 2, 0, 2, '010004', '327.70750000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '16:23:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '15:37', 3, 0, 3, '010003', '327.70870000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '16:23:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 0, 1, '500003', '329.11780000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-29', '04:27:12', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 1, 2, '010003', '329.11830000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 1, 3, '010004', '329.11860000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 1, 4, '010005', '329.11910000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 1, 5, '010006', '329.11940000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 1, 6, '010007', '329.11980000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 1, 7, '010008', '329.12020000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 2, 8, '050001', '329.12060000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 2, 9, '050003', '329.12100000', 'ตำปู', 'ตำปู', 'ตำปู', 'ตำปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 3, 10, '140073', '329.12140000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 4, 11, '130008', '329.12170000', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 4, 12, '130009', '329.12220000', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 1, 4, 13, '130013', '329.12250000', 'ลูกตาล', 'ลูกตาล', 'ลูกตาล', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '04:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 0, 14, '500003', '329.29190000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-29', '16:27:52', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 15, '010003', '69.91710000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 16, '010004', '5.16230000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 17, '010005', '40.61540000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 18, '010006', '80.47740000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-29', '16:27:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 19, '010007', '80.39930000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 20, '010008', '73.18750000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:57', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 21, '010009', '26.94750000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:57', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 1, 22, '010010', '95.41450000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 2, 23, '050001', '62.94180000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:27:59', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 2, 24, '050002', '62.23290000', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:28:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 3, 25, '140073', '19.24600000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-29', '16:28:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 4, 26, '130008', '92.78230000', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-29', '16:28:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 4, 27, '130009', '94.75440000', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '16:28:04', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 2, 4, 28, '130010', '4.06820000', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '16:28:05', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 0, 29, '500003', '330.06510000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-29', '16:30:11', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 30, '010003', '24.25890000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 31, '010004', '86.78610000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 32, '010005', '37.72410000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 33, '010006', '45.32570000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-29', '16:30:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 34, '010007', '80.45130000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 35, '010008', '21.12920000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 36, '010009', '25.45760000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 1, 37, '010010', '47.29630000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 2, 38, '050001', '43.28330000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 2, 39, '050002', '43.40690000', 'ตำไทย', 'ตำไทย', 'ตำไทย', 'ตำไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:30:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 3, 3, 40, '140073', '59.44520000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-29', '16:30:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 4, 0, 41, '500001', '331.08890000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '50', '', '150.0000', '1.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '16:33:16', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 4, 1, 42, '010017', '35.77970000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:33:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 4, 2, 43, '010003', '37.14790000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:33:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 4, 3, 44, '050001', '37.52700000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '05', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:33:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 4, 4, 45, '130001', '71.15340000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '3', '13', '', '0.0000', '3.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '16:33:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 5, 0, 46, '500002', '331.10280000', 'ชุด B', 'ชุด B', 'Set B', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '50', '', '250.0000', '1.0000', '0.0000', '250.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '16:33:18', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 5, 1, 47, '010004', '37.93200000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:33:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 5, 1, 48, '010005', '63.18390000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', 'M1B001', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-29', '16:33:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 5, 1, 49, 'M1B001', '79.48900000', 'ตับหมู', 'ตับหมู', 'ตับหมู', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '', '', '', '10.0000', '1.0000', '0.0000', '10.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '16:33:28', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 5, 2, 50, '020004', '61.31590000', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '02', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-29', '16:33:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '001', '16:25', 5, 3, 51, '140046', '50.10850000', 'บ๊วย 3 รส', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '4', '14', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '16:33:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '002', '12:13', 1, 0, 1, '010004', '244.60800000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '70.0000', '1.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:13:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '002', '12:13', 2, 0, 2, '010009', '244.60960000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '170.0000', '1.0000', '0.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:13:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '002', '12:13', 3, 0, 3, '010015', '244.61160000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '90.0000', '1.0000', '0.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:13:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '002', '12:17', 1, 0, 1, '010009', '251.66030000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '170.0000', '1.0000', '0.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:34:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '002', '12:17', 2, 0, 2, '010008', '251.66190000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '130.0000', '1.0000', '0.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:34:59', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '002', '15:29', 1, 0, 1, '010010', '309.80850000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:29:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 1, 0, 1, '010015', '245.21540000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '90.0000', '1.0000', '0.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:15:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 2, 0, 2, '010010', '245.21890000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '195.0000', '1.0000', '0.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:15:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 3, 0, 3, '010004', '245.22050000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '70.0000', '1.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:15:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 0, 4, '500003', '245.22910000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '50', '', '300.0000', '1.0000', '0.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-29', '12:15:41', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 5, '010003', '38.81980000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 6, '010004', '10.46150000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 7, '010005', '72.49120000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 8, '010006', '38.34840000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-29', '12:15:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 9, '010007', '30.60780000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 10, '010010', '1.68930000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 11, '010009', '89.02230000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 1, 12, '010008', '24.18040000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 2, 13, '050007', '8.87090000', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '05', 'M2A012', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 1, '2019-10-29', '12:15:46', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 2, 14, 'M2A012', '40.61540000', 'เพิ่มเผ็ดมาก', 'เพิ่มเผ็ดมาก', 'Addเผ็ดมาก', 'Addเผ็ดมาก', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '', '', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:57', '', 0, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 2, 15, '050007', '80.38560000', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '05', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:15:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 3, 16, '140073', '94.08890000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '4', '14', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-29', '12:15:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 4, 17, '130008', '42.67620000', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '3', '13', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-29', '12:15:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 4, 18, '130009', '69.91710000', 'ลูกจาก', 'ลูกจาก', 'ลูกจาก', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '3', '13', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '12:15:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '003', '12:14', 4, 4, 19, '130010', '5.16230000', 'ขนมเค้ก', 'ขนมเค้ก', 'ขนมเค้ก', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '3', '13', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '12:15:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '004', '15:13', 1, 0, 1, '010005', '304.46230000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:13:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '004', '15:13', 2, 0, 2, '010010', '304.46690000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:13:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '004', '15:33', 1, 0, 1, '010004', '311.23520000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:33:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '004', '15:33', 2, 0, 2, '010004', '311.23710000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:33:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '006', '12:17', 1, 0, 1, '010014', '247.58520000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:22:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '006', '12:17', 2, 0, 2, '010015', '247.58650000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:22:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '006', '12:17', 3, 0, 3, '010015', '247.58740000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:22:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '006', '15:31', 1, 0, 1, '010004', '310.56400000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:31:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '006', '15:31', 2, 0, 2, '010009', '310.56730000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:31:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '006', '15:37', 1, 0, 1, '010003', '312.99300000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '110.0000', '1.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '006', '15:37', 2, 0, 2, '010004', '312.99430000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '70.0000', '1.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '007', '15:14', 1, 0, 1, '010004', '304.86540000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:14:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '007', '15:14', 2, 0, 2, '010009', '304.86820000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:14:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '007', '15:14', 3, 0, 3, '010012', '304.86900000', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:14:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '007', '15:31', 1, 0, 1, '010005', '310.59840000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:31:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 1, 0, 1, '010015', '247.87490000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:23:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 2, 0, 2, '010009', '247.87620000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:23:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 3, 0, 3, '010003', '247.87730000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '12:23:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 4, 0, 4, '500001', '247.91090000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '50', '', '150.0000', '1.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '12:23:43', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 4, 1, 5, '010017', '90.87820000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '', '2', 'B', 'B', 'B', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:23:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 4, 2, 6, '010003', '83.31940000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:23:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 4, 3, 7, '050001', '24.35460000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '05', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:23:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 4, 4, 8, '130001', '76.86130000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '3', '13', '', '0.0000', '3.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '12:23:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 5, 0, 9, '500002', '247.92100000', 'ชุด B', 'ชุด B', 'Set B', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '50', '', '250.0000', '1.0000', '0.0000', '250.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-29', '12:23:45', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 5, 1, 10, '010003', '55.77660000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:23:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 5, 1, 11, '010003', '13.53180000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '01', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-29', '12:23:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 5, 2, 12, '020004', '38.06270000', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '02', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-29', '12:23:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '12:20', 5, 3, 13, '140046', '57.82180000', 'บ๊วย 3 รส', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '4', '14', '', '0.0000', '1.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-29', '12:23:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:29', 1, 0, 1, '010004', '309.87810000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:29:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:29', 2, 0, 2, '010003', '309.88860000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:29:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 1, 0, 1, '010003', '312.87890000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 2, 0, 2, '010004', '312.87980000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 3, 0, 3, '010005', '312.88080000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 4, 0, 4, '010006', '312.88160000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:38:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 5, 0, 5, '010010', '312.88250000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 6, 0, 6, '010009', '312.88330000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 7, 0, 7, '080005', '312.88840000', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '85.0000', '1.0000', '1.0000', '85.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 8, 0, 8, '080006', '312.88930000', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 9, 0, 9, '080007', '312.89020000', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 10, 0, 10, '080015', '312.89100000', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '95.0000', '1.0000', '1.0000', '95.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 11, 0, 11, '080014', '312.89250000', 'ผัดฉ่าเห็ดโคนญี่ปุ่น', 'ผัดฉ่าเห็ดโคนญี่ปุ่น', 'ผัดฉ่าเห็ดโคนญี่ปุ่น', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '100.0000', '1.0000', '1.0000', '100.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 12, 0, 12, '030022', '312.89690000', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:38:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 13, 0, 13, '030022', '312.89770000', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:38:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 14, 0, 14, '030012', '312.89850000', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:38:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 15, 0, 15, '030015', '312.89950000', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:38:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 16, 0, 16, '040018', '312.90570000', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '80.0000', '1.0000', '1.0000', '80.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 17, 0, 17, '040020', '312.90740000', 'หมูข้าวเม่า', 'หมูข้าวเม่า', 'หมูข้าวเม่า', 'หมูข้าวเม่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '100.0000', '1.0000', '1.0000', '100.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:38:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 18, 0, 18, '040003', '312.90900000', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-29', '15:38:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 19, 0, 19, '040024', '312.91100000', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '260.0000', '1.0000', '1.0000', '260.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 20, 0, 20, '040028', '312.91150000', 'ไข่เจียว', 'ไข่เจียว', 'ไข่เจียว', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '50.0000', '1.0000', '1.0000', '50.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:38:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 21, 0, 21, '010004', '313.07390000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:39:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 22, 0, 22, '010009', '313.07650000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '340.0000', '2.0000', '2.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:39:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-29', '009', '15:37', 23, 0, 23, '010003', '313.10200000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-29', '15:39:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 1, 0, 1, '010003', '313.48490000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '03:40:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 2, 0, 2, '010008', '313.49200000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:40:28', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 3, 0, 3, '020005', '325.15620000', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '0.0000', '0.0000', '85.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:15:28', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 4, 0, 4, '040001', '325.15750000', 'รวมมิตรตะกร้า', 'รวมมิตรตะกร้า', 'รวมมิตรตะกร้า', 'รวมมิตรตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '0.0000', '0.0000', '0.0000', '170.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:15:28', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 5, 0, 5, '040003', '325.15880000', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '0.0000', '0.0000', '0.0000', '90.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:15:28', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 6, 0, 6, '040004', '325.16000000', 'หมึกตะกร้า', 'หมึกตะกร้า', 'หมึกตะกร้า', 'หมึกตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '0.0000', '0.0000', '0.0000', '95.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:15:28', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 7, 0, 7, '040024', '325.16710000', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '0.0000', '0.0000', '0.0000', '260.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:15:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 8, 0, 8, '010017', '325.39460000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'N/A', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '04:16:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 9, 0, 9, '010004', '325.39500000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '04:16:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 9, 0, 10, '010017', '325.39530000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '0.0000', '0.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '04:16:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 9, 0, 11, '050001', '325.39560000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '0.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '04:16:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 9, 0, 12, '130001', '325.39590000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '0.0000', '0.0000', '40.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-30', '04:16:03', '', 1, NULL, 0);
INSERT INTO `orderhistory` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `Level`, `SubLevel`, `ItemId`, `ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`, `SizeId`, `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `OrgSize`, `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`, `MainItem`, `GuestName`, `isPackage`) VALUES
('001', '001', 'K01', '2019-10-30', '003', '15:39', 9, 0, 13, '500001', '325.39620000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '0.0000', '0.0000', '0.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '04:16:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 10, 0, 14, '020005', '328.56670000', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '0.0000', '0.0000', '85.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '04:16:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 11, 0, 15, '500002', '328.56700000', 'ชุด B', 'ชุด B', 'Set B', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '0.0000', '0.0000', '0.0000', '250.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '04:24:02', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 11, 1, 16, '010004', '328.56730000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '04:24:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '15:39', 11, 3, 17, '140046', '328.56760000', 'บ๊วย 3 รส', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '0.0000', '0.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '04:24:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 1, 0, 1, '010008', '236.54560000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 2, 0, 2, '010005', '236.54850000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 3, 0, 3, '220006', '307.69330000', 'ข้าวผัดหน่อกะลา', 'ข้าวผัดหน่อกะลา', 'ข้าวผัดหน่อกะลา', '', '1', 'เล็ก', 'เล็ก', 'เล็ก', 'N/A', '1', '1', '22', '', '80.0000', '1.0000', '1.0000', '80.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:23:04', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 4, 0, 4, '220001', '307.69460000', 'ข้าวผัดมันกุ้งก้ามกราม', 'ข้าวผัดมันกุ้งก้ามกราม', 'ข้าวผัดมันกุ้งก้ามกราม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '22', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:23:05', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 5, 0, 5, '010003', '307.43240000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:22:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 6, 0, 6, '010009', '307.43460000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:22:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 7, 0, 7, '010010', '307.43530000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:22:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 8, 0, 8, '010014', '307.43670000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:22:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 9, 0, 9, '010008', '307.43770000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:22:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 10, 0, 10, '010010', '307.43860000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:22:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 11, 0, 11, '080006', '244.89910000', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 12, 0, 12, '040019', '244.90000000', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '100.0000', '1.0000', '1.0000', '100.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 13, 0, 13, '080005', '244.90130000', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '85.0000', '1.0000', '1.0000', '85.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 14, 0, 14, '080005', '244.90220000', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '85.0000', '1.0000', '1.0000', '85.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 15, 0, 15, '080001', '244.90320000', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 16, 0, 16, '080001', '244.90410000', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 17, 0, 17, '080002', '244.90510000', 'ผัดฉ่าเห็ด 3 อย่าง', 'ผัดฉ่าเห็ด 3 อย่าง', 'ผัดฉ่าเห็ด 3 อย่าง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '95.0000', '1.0000', '1.0000', '95.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 18, 0, 18, '080003', '244.90600000', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '85.0000', '1.0000', '1.0000', '85.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 19, 0, 19, '010003', '311.16360000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:33:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 20, 0, 20, '010017', '224.90490000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'N/A', '5', 'E', 'E', 'E', 'N/A', '5', '1', '01', '', '2700.0000', '9.0000', '9.0000', '300.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '10:54:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 21, 0, 21, '500001', '226.90810000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '11:19:35', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 21, 1, 22, '010017', '226.90850000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:19:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 21, 3, 23, '050001', '226.90890000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:19:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 21, 4, 24, '130001', '226.90930000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '11:19:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 22, 0, 25, '500001', '226.90970000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '11:20:10', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 22, 1, 26, '010017', '226.91010000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:20:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 22, 3, 27, '050001', '226.91040000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:20:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 22, 4, 28, '130001', '226.91090000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '11:20:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 23, 0, 29, '500001', '226.91120000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '11:20:27', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 23, 1, 30, '010017', '226.91170000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'N/A', '2', 'N/A', 'N/A', 'N/A', 'N/A', '2', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:20:27', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 23, 3, 31, '050001', '226.91200000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:20:27', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 23, 4, 32, '130001', '226.91240000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '11:20:27', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 24, 0, 33, '030002', '235.49880000', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 25, 0, 34, '030007', '235.49990000', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 26, 0, 35, '030012', '235.50080000', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 27, 0, 36, '030021', '235.50170000', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 28, 0, 37, '030022', '235.50260000', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 29, 0, 38, '030015', '235.50370000', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 30, 0, 39, '010013', '236.57090000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:49:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 31, 0, 40, '010008', '236.57200000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 32, 0, 41, '010009', '236.57290000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 33, 0, 42, '010010', '236.57460000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 34, 0, 43, '010012', '236.57530000', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:49:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 35, 0, 44, '080009', '236.60230000', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '80.0000', 1, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 36, 0, 45, '080001', '236.60340000', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '90.0000', 1, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 37, 0, 46, '030002', '236.60700000', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:49:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 38, 0, 47, '030008', '236.60820000', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '0.0000', '1.0000', '1.0000', '350.0000', 1, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:49:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 39, 0, 48, '030009', '236.60900000', 'ตำลาว', 'ตำลาว', 'ตำลาว', 'ตำลาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '0.0000', '1.0000', '1.0000', '70.0000', 1, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-30', '11:49:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 40, 0, 49, '030010', '236.60980000', 'ตำโคราช', 'ตำโคราช', 'ตำโคราช', 'ตำโคราช', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '0.0000', '1.0000', '1.0000', '75.0000', 1, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-30', '11:49:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 41, 0, 50, '500001', '276.53870000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '11:27:22', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 41, 1, 51, '020002', '276.53910000', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:27:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 41, 2, 52, '010004', '276.53950000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:27:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 41, 3, 53, '050001', '276.53990000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:27:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 41, 4, 54, '130001', '276.54030000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '11:27:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 42, 0, 55, '500003', '276.54070000', 'ชุด C ยกเว้น', 'ชุด C ยกเว้น', 'Set C', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '300.0000', '1.0000', '1.0000', '300.0000', 0, 0, 0, '*', '', 0, 0, '', 1, 0, '2019-10-30', '01:48:56', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 42, 1, 56, '010005', '276.54100000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '01:48:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 42, 3, 57, '140073', '276.54150000', 'หมี่กรอบ', 'หมี่กรอบ', 'หมี่กรอบ', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '14', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 1, '2019-10-30', '01:48:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 42, 4, 58, '130008', '276.54180000', 'เต้าทึง', 'เต้าทึง', 'เต้าทึง', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 1, '2019-10-30', '01:48:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 43, 0, 59, '010003', '306.71630000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:20:08', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 44, 0, 60, '010013', '306.90750000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '15:20:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 45, 0, 61, '010017', '306.98760000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', '', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:20:57', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 46, 0, 62, '090003', '308.21030000', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:24:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 47, 0, 63, '090002', '308.23380000', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:24:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 48, 0, 64, '090004', '308.25530000', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:24:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 49, 0, 65, '010013', '309.02260000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '15:27:04', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 50, 0, 66, '010003', '309.06470000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:27:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 51, 0, 67, '010004', '309.06650000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:27:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 52, 0, 68, '010005', '309.06780000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:27:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 53, 0, 69, '010003', '235.27950000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 54, 0, 70, '010008', '235.28460000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 55, 0, 71, '010014', '235.28590000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 56, 0, 72, '010017', '235.28750000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', '', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 57, 0, 73, '010016', '235.28920000', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 58, 0, 74, '010013', '235.29030000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:45:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 59, 0, 75, '010007', '235.29130000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 60, 0, 76, '010004', '235.29320000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 61, 0, 77, '010009', '235.29390000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 62, 0, 78, '010015', '235.29510000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 63, 0, 79, '500001', '235.29870000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '11:45:53', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 63, 1, 80, '020003', '40.48090000', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-30', '11:45:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 63, 2, 81, '010004', '29.08830000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:45:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 63, 3, 82, '050001', '20.78170000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:45:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 63, 4, 83, '130001', '67.52100000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '11:45:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 64, 0, 84, '010007', '236.65800000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 65, 0, 85, '010008', '236.65920000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 66, 0, 86, '010004', '236.66020000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 67, 0, 87, '010005', '236.66300000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:49:59', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 68, 0, 88, '030002', '236.66440000', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:49:59', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 69, 0, 89, '030008', '236.66550000', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:49:59', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 70, 0, 90, '030009', '236.66640000', 'ตำลาว', 'ตำลาว', 'ตำลาว', 'ตำลาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-30', '11:49:59', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 71, 0, 91, '030010', '236.66720000', 'ตำโคราช', 'ตำโคราช', 'ตำโคราช', 'ตำโคราช', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '75.0000', '1.0000', '1.0000', '75.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-30', '11:50:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 72, 0, 92, '030022', '236.66920000', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:50:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 73, 0, 93, '090002', '307.88750000', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '0.0000', '0.0000', '0.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:23:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 74, 0, 94, '090007', '307.88870000', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '1', 'ถ้วย', 'ถ้วย', 'ถ้วย', 'N/A', '1', '3', '09', '', '0.0000', '0.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:23:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 75, 0, 95, '090003', '307.88960000', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '0.0000', '0.0000', '0.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:23:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 76, 0, 96, '090008', '307.89060000', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '0.0000', '0.0000', '0.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:23:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 77, 0, 97, '090004', '307.89140000', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '0.0000', '0.0000', '0.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:23:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 78, 0, 98, '090002', '235.40140000', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 79, 0, 99, '090007', '235.40260000', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '1', 'ถ้วย', 'ถ้วย', 'ถ้วย', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 80, 0, 100, '090016', '235.40420000', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 81, 0, 101, '090016', '235.40500000', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 82, 0, 102, '090020', '235.40580000', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 83, 0, 103, '090016', '235.40690000', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 84, 0, 104, '090012', '235.40800000', 'ไอศกรีมสตอเบอร์รี่', 'ไอศกรีมสตอเบอร์รี่', 'ไอศกรีมสตอเบอร์รี่', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 85, 0, 105, '090008', '235.40890000', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '600.0000', '20.0000', '20.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 86, 0, 106, '090003', '235.41010000', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 87, 0, 107, '090012', '235.41110000', 'ไอศกรีมสตอเบอร์รี่', 'ไอศกรีมสตอเบอร์รี่', 'ไอศกรีมสตอเบอร์รี่', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 88, 0, 108, '090017', '235.41360000', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 89, 0, 109, '090013', '235.41500000', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:14', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 90, 0, 110, '090013', '235.41950000', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 91, 0, 111, '090025', '235.42070000', 'บัวลอยเผือก', 'บัวลอยเผือก', 'บัวลอยเผือก', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '700.0000', '20.0000', '20.0000', '35.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 92, 0, 112, '090026', '235.42170000', 'พุดดิ้งมะพร้าวอ่อน', 'พุดดิ้งมะพร้าวอ่อน', 'พุดดิ้งมะพร้าวอ่อน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 93, 0, 113, '090019', '235.42280000', 'เยลลี่', 'เยลลี่', 'เยลลี่', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '400.0000', '20.0000', '20.0000', '20.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 94, 0, 114, '090014', '235.42390000', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 95, 0, 115, '090014', '235.42480000', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 96, 0, 116, '090010', '235.42540000', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 97, 0, 117, '090010', '235.42600000', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 98, 0, 118, '090005', '235.42670000', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 99, 0, 119, '090005', '235.42730000', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 100, 0, 120, '090006', '235.42790000', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '1200.0000', '20.0000', '20.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 101, 0, 121, '120023', '235.43090000', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 102, 0, 122, '120023', '235.43160000', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 103, 0, 123, '090015', '235.43350000', 'ไอศกรีมทุเรียน+กล้วย', 'ไอศกรีมทุเรียน+กล้วย', 'ไอศกรีมทุเรียน+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 104, 0, 124, '090011', '235.43450000', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '800.0000', '20.0000', '20.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 105, 0, 125, '090024', '235.44020000', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:19', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 106, 0, 126, '090017', '235.44140000', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '900.0000', '20.0000', '20.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:46:19', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 107, 0, 127, '010013', '307.31550000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '15:21:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 108, 0, 128, '010008', '324.38390000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 109, 0, 129, '010004', '324.38500000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:09', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 110, 0, 130, '500001', '324.38600000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '16:13:09', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 110, 1, 131, '020002', '55.48430000', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '16:13:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 110, 2, 132, '010004', '90.87820000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '16:13:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 110, 3, 133, '050001', '83.31940000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '16:13:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 110, 4, 134, '130001', '24.35460000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '16:13:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 111, 0, 135, '010004', '244.77290000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:19', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 112, 0, 136, '010005', '244.78160000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:20', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 113, 0, 137, '010006', '244.78290000', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '12:14:20', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 114, 0, 138, '010012', '244.78390000', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '12:14:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 115, 0, 139, '010012', '244.78480000', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '12:14:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 116, 0, 140, '010010', '244.78590000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 117, 0, 141, '010010', '244.78680000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 118, 0, 142, '010010', '244.78760000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 119, 0, 143, '010015', '244.78890000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:22', '', 1, NULL, 0);
INSERT INTO `orderhistory` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `Level`, `SubLevel`, `ItemId`, `ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`, `SizeId`, `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `OrgSize`, `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`, `MainItem`, `GuestName`, `isPackage`) VALUES
('001', '001', 'K01', '2019-10-30', '003', '16:51', 120, 0, 144, '010014', '244.79000000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 121, 0, 145, '010013', '244.79130000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '12:14:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 122, 0, 146, '010017', '244.79300000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', '', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 123, 0, 147, '010008', '244.79460000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 124, 0, 148, '010003', '244.79570000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '12:14:23', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 125, 0, 149, '220002', '307.40290000', 'ข้าวผัดแหนม', 'ข้าวผัดแหนม', 'ข้าวผัดแหนม', '', '1', 'เล็ก', 'เล็ก', 'เล็ก', 'N/A', '1', '1', '22', '', '80.0000', '1.0000', '1.0000', '80.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:22:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 126, 0, 150, '010003', '329.68480000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:29:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 127, 0, 151, '010009', '331.23010000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:33:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 128, 0, 152, '010010', '331.23110000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:33:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 129, 0, 153, '010003', '331.28110000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '04:33:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 130, 0, 154, '030002', '334.26830000', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:42:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 131, 0, 155, '010013', '336.50900000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:49:31', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 132, 0, 156, '040025', '337.01970000', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '140.0000', '1.0000', '1.0000', '140.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:51:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 133, 0, 157, '120004', '351.35130000', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '12', '', '550.0000', '1.0000', '1.0000', '550.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-30', '05:31:28', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 134, 0, 158, '120004', '351.35180000', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '12', '', '3850.0000', '7.0000', '7.0000', '550.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-30', '05:31:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 135, 0, 159, '120007', '351.35210000', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', 'N/A', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '12', '', '400.0000', '1.0000', '1.0000', '400.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-30', '05:31:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 136, 0, 160, '010017', '239.34160000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', '', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:58:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 137, 0, 161, '010008', '239.34320000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:58:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 138, 0, 162, '010009', '239.34400000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:58:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 139, 0, 163, '090007', '239.34700000', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '1', 'ถ้วย', 'ถ้วย', 'ถ้วย', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 140, 0, 164, '090008', '239.34800000', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 141, 0, 165, '090009', '239.34900000', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', '1', '.', '.', '.', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 142, 0, 166, '090017', '239.35000000', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 143, 0, 167, '090017', '239.35090000', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 144, 0, 168, '090019', '239.35200000', 'เยลลี่', 'เยลลี่', 'เยลลี่', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '20.0000', '1.0000', '1.0000', '20.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 145, 0, 169, '090010', '239.35310000', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 146, 0, 170, '090005', '239.35400000', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 147, 0, 171, '090011', '239.35480000', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '11:58:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 148, 0, 172, '010008', '324.91750000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:14:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 149, 0, 173, '010017', '324.91850000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', '', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:14:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 150, 0, 174, '010009', '324.91950000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:14:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 151, 0, 175, '010010', '324.92050000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:14:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 152, 0, 176, '010010', '324.92140000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:14:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 153, 0, 177, '010016', '348.63670000', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:25:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 154, 0, 178, '010008', '348.63840000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:25:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 155, 0, 179, '010008', '348.63930000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:25:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 156, 0, 180, '090002', '244.55930000', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '12:13:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 157, 0, 181, '090007', '244.56080000', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '1', 'ถ้วย', 'ถ้วย', 'ถ้วย', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '12:13:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 158, 0, 182, '120015', '244.56180000', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', '', '1', 'ถ้วย', 'ถ้วย', 'ถ้วย', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '12:13:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 159, 0, 183, '090016', '244.56370000', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '12:13:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 160, 0, 184, '090020', '244.56570000', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '40.0000', '1.0000', '1.0000', '40.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '12:13:41', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 161, 0, 185, '120015', '244.56890000', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', '', '3', '1Km', '1Km', '1Km', 'N/A', '3', '3', '09', '', '200.0000', '1.0000', '1.0000', '200.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '12:13:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 162, 0, 186, '150003', '339.73890000', 'Regency (700ml)', 'Regency (700ml)', 'Regency (700ml)', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '4', '15', '', '750.0000', '1.0000', '1.0000', '750.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-30', '16:59:13', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 163, 0, 187, '010016', '306.76840000', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:20:18', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 164, 0, 188, '010005', '349.98800000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:29:57', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 165, 0, 189, '010005', '349.98890000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:29:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 166, 0, 190, '010010', '349.98990000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:29:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 167, 0, 191, '010009', '349.99140000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:29:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 168, 0, 192, '010008', '349.99190000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:29:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 169, 0, 193, '010014', '349.99270000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:29:58', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 170, 0, 194, '030003', '329.95140000', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:29:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 171, 0, 195, '030026', '329.95290000', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:29:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 172, 0, 196, '030015', '329.95360000', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:29:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 173, 0, 197, '030009', '329.95490000', 'ตำลาว', 'ตำลาว', 'ตำลาว', 'ตำลาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '4', 0, 0, '', 0, 0, '2019-10-30', '16:29:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 174, 0, 198, '030004', '329.95620000', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:29:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 175, 0, 199, '030007', '329.95750000', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:29:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 176, 0, 200, '010015', '355.64460000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:46:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 177, 0, 201, '010014', '355.64570000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:46:56', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 178, 0, 202, '010004', '355.75460000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:47:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 179, 0, 203, '010015', '356.21120000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 180, 0, 204, '010008', '356.21260000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 181, 0, 205, '010008', '356.21360000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 182, 0, 206, '010014', '356.21470000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 183, 0, 207, '010009', '356.28270000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 184, 0, 208, '010014', '356.28390000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:51', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 185, 0, 209, '020007', '356.50200000', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:49:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 186, 0, 210, '020009', '356.50310000', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:49:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '003', '16:51', 187, 0, 211, '010001', '356.80930000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '100.0000', '1.0000', '1.0000', '100.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '17:50:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 1, 0, 1, '010008', '235.52540000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 2, 0, 2, '010008', '235.52650000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 3, 0, 3, '010005', '235.52840000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 4, 0, 4, '010010', '235.52920000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 5, 0, 5, '010013', '235.53460000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 6, 0, 6, '010008', '235.53550000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 7, 0, 7, '010009', '235.53620000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 8, 0, 8, '030026', '235.54030000', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 9, 0, 9, '030008', '235.54140000', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 10, 0, 10, '030031', '235.54460000', 'ปลากะพงริมสวน', 'ปลากะพงริมสวน', 'ปลากะพงริมสวน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 11, 0, 11, '030015', '235.54590000', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 12, 0, 12, '030004', '235.54670000', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 13, 0, 13, '030005', '235.54760000', 'ปลาทับทิมทอดน้ำปลา', 'ปลาทับทิมทอดน้ำปลา', 'ปลาทับทิมทอดน้ำปลา', 'ปลาทับทิมทอดน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 14, 0, 14, '030032', '235.54980000', 'ทับทิมนึ่งมะนาว', 'ทับทิมนึ่งมะนาว', 'ทับทิมนึ่งมะนาว', 'ทับทิมนึ่งมะนาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:38', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 15, 0, 15, '030025', '235.55080000', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 16, 0, 16, '030011', '235.55180000', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 17, 0, 17, '030003', '235.55390000', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '11:46:39', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 18, 0, 18, '030024', '235.55880000', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '180.0000', '1.0000', '1.0000', '180.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:40', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 19, 0, 19, '050007', '307.05690000', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '80.0000', '1.0000', '1.0000', '80.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:21:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 20, 0, 20, '040019', '307.19330000', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '0.0000', '0.0000', '0.0000', '100.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:21:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 21, 0, 21, '010017', '324.45270000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', '', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 22, 0, 22, '020012', '324.45550000', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '85.0000', '1.0000', '1.0000', '85.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 23, 0, 23, '020007', '324.45630000', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 24, 0, 24, '020008', '324.45720000', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 25, 0, 25, '020013', '324.45830000', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '410.0000', '1.0000', '1.0000', '410.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 26, 0, 26, '020009', '324.45930000', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '1500.0000', '10.0000', '10.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:22', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 27, 0, 27, '010004', '327.75060000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:23:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '10:20', 28, 0, 28, '350003', '328.29980000', 'ยำซีฟู๊ด (ลวก)', 'ยำซีฟู๊ด (ลวก)', 'ยำซีฟู๊ด (ลวก)', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '35', '', '280.0000', '1.0000', '1.0000', '280.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:24:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 1, 0, 1, '010007', '235.23930000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 2, 0, 2, '010003', '235.24180000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 3, 0, 3, '010008', '235.24280000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 4, 0, 4, '010004', '235.24370000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 5, 0, 5, '010004', '235.24460000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:45:44', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 6, 0, 6, '010009', '235.58670000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 7, 0, 7, '010015', '235.58780000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 8, 0, 8, '010015', '235.58870000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 9, 0, 9, '010009', '235.58980000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:46', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 10, 0, 10, '500001', '235.59280000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '11:46:46', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 10, 1, 11, '020003', '94.69780000', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 1, '2019-10-30', '11:46:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 10, 2, 12, '010004', '87.34790000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:46:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 10, 3, 13, '050001', '28.23330000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '11:46:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 10, 4, 14, '130001', '36.36720000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '11:46:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 11, 0, 15, '010008', '235.60040000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '11:46:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 12, 0, 16, '010005', '307.09190000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '15:21:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 13, 0, 17, '500001', '307.11020000', 'ชุด A ไก่ฟ้า', 'ชุด A ไก่ฟ้า', 'Set A', 'ชุด A ไก่ฟ้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '50', '', '150.0000', '1.0000', '1.0000', '150.0000', 0, 0, 0, '*', '2', 0, 0, '', 1, 0, '2019-10-30', '15:21:19', '', 1, NULL, 1),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 13, 1, 21, '020002', '38.06270000', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '02', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '15:21:29', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 13, 2, 18, '010004', '24.35460000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '15:21:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 13, 3, 19, '050001', '76.86130000', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '05', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 1, '2019-10-30', '15:21:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 13, 4, 20, '130001', '55.77660000', 'พุดดิ้ง', 'พุดดิ้ง', 'พุดดิ้ง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '13', '', '0.0000', '3.0000', '3.0000', '0.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 1, '2019-10-30', '15:21:21', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 14, 0, 22, '030003', '307.17410000', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '15:21:31', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 15, 0, 23, '100002', '307.29910000', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '15:21:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 16, 0, 24, '040019', '320.19160000', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '04', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 17, 0, 25, '080005', '320.19330000', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:34', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 18, 0, 26, '080001', '320.19500000', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 19, 0, 27, '080006', '320.19630000', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 20, 0, 28, '080002', '320.19790000', 'ผัดฉ่าเห็ด 3 อย่าง', 'ผัดฉ่าเห็ด 3 อย่าง', 'ผัดฉ่าเห็ด 3 อย่าง', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 21, 0, 29, '080007', '320.19910000', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 22, 0, 30, '080003', '320.20060000', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 23, 0, 31, '080021', '320.20180000', 'กระเพราเนื้อตุ๋น', 'กระเพราเนื้อตุ๋น', 'กระเพราเนื้อตุ๋น', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 24, 0, 32, '080004', '320.20340000', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 25, 0, 33, '080008', '320.20490000', 'ผัดผักยอดดอย', 'ผัดผักยอดดอย', 'ผัดผักยอดดอย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '08', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:00:36', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 26, 0, 34, '010013', '324.41920000', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:13:15', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 27, 0, 35, '010014', '324.42340000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 28, 0, 36, '010008', '324.42420000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 29, 0, 37, '010009', '324.42520000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 30, 0, 38, '010015', '324.42640000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 31, 0, 39, '010010', '324.42740000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 32, 0, 40, '010010', '324.42860000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 33, 0, 41, '010010', '324.42930000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:13:17', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 34, 0, 42, '010014', '348.80820000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:26:25', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 35, 0, 43, '010022', '235.42430000', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 36, 0, 44, '010027', '235.42550000', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 37, 0, 45, '010021', '235.42680000', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:46:16', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 38, 0, 46, '010032', '235.46850000', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '15.0000', '1.0000', '1.0000', '15.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-31', '11:46:24', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '005', '11:45', 39, 0, 47, '010027', '235.46990000', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:46:24', '', 1, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ordering`
--

DROP TABLE IF EXISTS `ordering`;
CREATE TABLE `ordering` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `ItemNo` int(3) UNSIGNED NOT NULL,
  `Level` int(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'ลำดับอาหารชุด',
  `SubLevel` int(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'ลำดับย่อย',
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL COMMENT 'รหัสสินค้า',
  `ReferenceId` decimal(11,8) NOT NULL COMMENT 'อ้างอิง',
  `ItemName` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Product Name Show',
  `LocalName` text COLLATE utf8_unicode_ci,
  `EnglishName` text COLLATE utf8_unicode_ci,
  `OtherName` text COLLATE utf8_unicode_ci,
  `SizeId` varchar(2) COLLATE utf8_unicode_ci NOT NULL COMMENT 'ประเภท Size = 1 - 5',
  `SizeName` text COLLATE utf8_unicode_ci COMMENT 'Size Name',
  `SizeLocalName` text COLLATE utf8_unicode_ci,
  `SizeEnglishName` text COLLATE utf8_unicode_ci,
  `SizeOtherName` text COLLATE utf8_unicode_ci,
  `OrgSize` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'เก็บ Size ก่อนเปลี่ยน',
  `DepartmentId` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Department',
  `CategoryId` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Category',
  `AddModiCode` text COLLATE utf8_unicode_ci COMMENT 'รายการ modify',
  `TotalAmount` decimal(14,4) DEFAULT NULL COMMENT 'ยอดรวม',
  `Quantity` decimal(8,4) DEFAULT NULL COMMENT 'จำนวน ',
  `OrgQty` decimal(8,4) DEFAULT NULL COMMENT 'จำนวน ก่อนเปลี่ยน',
  `UnitPrice` decimal(14,4) DEFAULT NULL COMMENT 'ราคาต่อหน่วย',
  `Free` tinyint(1) DEFAULT '0' COMMENT 'รายการฟรี',
  `noService` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `Status` varchar(1) COLLATE utf8_unicode_ci NOT NULL COMMENT 'V=Void',
  `PrintTo` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'พิมพ์ที่ Value=123',
  `NeedPrint` tinyint(1) DEFAULT NULL COMMENT 'รายการใหม่ = true',
  `LocalPrint` tinyint(1) DEFAULT NULL COMMENT 'print to local printer',
  `KitchenLang` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `Parent` tinyint(1) DEFAULT NULL COMMENT 'item หลัก(มี modify) = true',
  `Child` tinyint(1) DEFAULT NULL COMMENT 'modify=true',
  `OrderDate` date DEFAULT NULL COMMENT 'วันที่ order',
  `OrderTime` time DEFAULT NULL COMMENT 'เวลา order',
  `KitchenNote` text COLLATE utf8_unicode_ci COMMENT 'open modifier',
  `MainItem` tinyint(1) DEFAULT '0' COMMENT 'รายการหลัก',
  `GuestName` varchar(30) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'ชื่อผู้ order',
  `isPackage` tinyint(1) DEFAULT NULL COMMENT 'อาหารชุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Triggers `ordering`
--
DROP TRIGGER IF EXISTS `CalculateItemUpdate`;
DELIMITER $$
CREATE TRIGGER `CalculateItemUpdate` BEFORE UPDATE ON `ordering` FOR EACH ROW BEGIN
		
-- 		DECLARE pTotalAmount decimal(14,4) DEFAULT 0;
-- 		
-- 			IF NEW.Free = 1 OR OLD.SubLevel > 0 THEN
-- 				SET NEW.TotalAmount = 0;	
-- 			ELSE
-- 				SELECT SUM( NEW.Quantity * NEW.UnitPrice ) INTO  pTotalAmount ;
-- 				SET NEW.TotalAmount = pTotalAmount;
-- 			END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `NewOrderTransection`;
DELIMITER $$
CREATE TRIGGER `NewOrderTransection` BEFORE INSERT ON `ordering` FOR EACH ROW BEGIN
	
  DECLARE VITEM decimal(12,8);
	
-- 	DECLARE pTotalAmount decimal(14,4) DEFAULT 0;
	
  SET VITEM = getItemReferenceId();
  SET NEW.ReferenceId = VITEM;
	
	
-- change method calculate to api : david 20191025
-- 	IF NEW.Free = 1 OR NEW.SubLevel > 0  THEN
-- 		SET NEW.TotalAmount = 0;	
-- 	ELSE
-- 		SELECT SUM( NEW.Quantity * NEW.UnitPrice ) INTO  pTotalAmount;
-- 		SET NEW.TotalAmount = pTotalAmount;
-- 	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orderingdetail`
--

DROP TABLE IF EXISTS `orderingdetail`;
CREATE TABLE `orderingdetail` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `ItemNo` int(3) UNSIGNED NOT NULL,
  `Level` int(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'ลำดับอาหารชุด',
  `SubLevel` int(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'ลำดับย่อย',
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL COMMENT 'รหัสสินค้า',
  `ReferenceId` decimal(11,8) NOT NULL COMMENT 'อ้างอิง',
  `ItemName` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Product Name Show',
  `LocalName` text COLLATE utf8_unicode_ci,
  `EnglishName` text COLLATE utf8_unicode_ci,
  `OtherName` text COLLATE utf8_unicode_ci,
  `SizeId` varchar(2) COLLATE utf8_unicode_ci NOT NULL COMMENT 'ประเภท Size = 1 - 5',
  `SizeName` text COLLATE utf8_unicode_ci COMMENT 'Size Name',
  `SizeLocalName` text COLLATE utf8_unicode_ci,
  `SizeEnglishName` text COLLATE utf8_unicode_ci,
  `SizeOtherName` text COLLATE utf8_unicode_ci,
  `OrgSize` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'เก็บ Size ก่อนเปลี่ยน',
  `DepartmentId` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Department',
  `CategoryId` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Category',
  `AddModiCode` text COLLATE utf8_unicode_ci COMMENT 'รายการ modify',
  `TotalAmount` decimal(14,4) DEFAULT NULL COMMENT 'ยอดรวม',
  `Quantity` decimal(8,4) DEFAULT NULL COMMENT 'จำนวน ',
  `OrgQty` decimal(8,4) DEFAULT NULL COMMENT 'จำนวน ก่อนเปลี่ยน',
  `UnitPrice` decimal(14,4) DEFAULT NULL COMMENT 'ราคาต่อหน่วย',
  `Free` tinyint(1) DEFAULT NULL COMMENT 'รายการฟรี',
  `noService` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `Status` varchar(1) COLLATE utf8_unicode_ci NOT NULL COMMENT 'V=Void',
  `PrintTo` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'พิมพ์ที่ Value=123',
  `NeedPrint` tinyint(1) DEFAULT NULL COMMENT 'รายการใหม่ = true',
  `LocalPrint` tinyint(1) DEFAULT NULL COMMENT 'print to local printer',
  `KitchenLang` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `Parent` tinyint(1) DEFAULT NULL COMMENT 'item หลัก(มี modify) = true',
  `Child` tinyint(1) DEFAULT NULL COMMENT 'modify=true',
  `OrderDate` date DEFAULT NULL COMMENT 'วันที่ order',
  `OrderTime` time DEFAULT NULL COMMENT 'เวลา order',
  `KitchenNote` text COLLATE utf8_unicode_ci COMMENT 'open modifier',
  `MainItem` tinyint(1) DEFAULT '0' COMMENT 'รายการหลัก',
  `GuestName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ชื่อผู้ order',
  `isPackage` tinyint(1) DEFAULT NULL COMMENT 'อาหารชุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `orderingdetail`
--

INSERT INTO `orderingdetail` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `ItemNo`, `Level`, `SubLevel`, `ItemId`, `ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`, `SizeId`, `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `OrgSize`, `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`, `MainItem`, `GuestName`, `isPackage`) VALUES
('001', '001', 'K01', '2019-10-30', '004', '17:50', 1, 0, 1, '010009', '357.48650000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:52:27', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '17:50', 2, 0, 2, '010009', '357.48740000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '1.0000', '1.0000', '0.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:52:27', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '17:50', 3, 0, 3, '010033', '235.17100000', 'โซดา', 'โซดา', 'โซดา', 'โซดา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-31', '11:45:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '17:50', 4, 0, 4, '010028', '235.17180000', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '60.0000', '1.0000', '1.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-31', '11:45:30', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '17:50', 5, 0, 5, '010027', '235.17260000', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:45:31', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '17:50', 6, 0, 6, '010032', '235.17360000', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '15.0000', '1.0000', '1.0000', '15.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-31', '11:45:31', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '17:50', 7, 0, 7, '010032', '236.30730000', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '2', '01', '', '15.0000', '1.0000', '0.0000', '15.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-31', '11:48:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '004', '17:50', 8, 0, 8, '010027', '236.30830000', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '2', '01', '', '45.0000', '1.0000', '0.0000', '45.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:48:55', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 1, 0, 1, '010021', '234.96040000', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:44:52', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 2, 0, 2, '010026', '234.96160000', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:44:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 3, 0, 3, '010027', '234.96330000', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:44:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 4, 0, 4, '010023', '234.96450000', 'น้ำมะตูม', 'น้ำมะตูม', 'น้ำมะตูม', 'น้ำมะตูม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:44:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 5, 0, 5, '010027', '234.96550000', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:44:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 6, 0, 6, '010032', '234.96660000', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '15.0000', '1.0000', '1.0000', '15.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-31', '11:44:53', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 7, 0, 7, '010028', '234.96740000', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '60.0000', '1.0000', '1.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-31', '11:44:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 8, 0, 8, '010028', '234.96840000', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '60.0000', '1.0000', '1.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-31', '11:44:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 9, 0, 9, '010022', '234.96930000', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:44:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 10, 0, 10, '010026', '234.97100000', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '5', 0, 0, '', 0, 0, '2019-10-31', '11:44:54', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 11, 0, 11, '010028', '235.37860000', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '60.0000', '1.0000', '1.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-31', '11:46:08', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 12, 0, 12, '010033', '235.37980000', 'โซดา', 'โซดา', 'โซดา', 'โซดา', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-31', '11:46:08', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '006', '11:44', 13, 0, 13, '010032', '235.38090000', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '01', '', '15.0000', '1.0000', '1.0000', '15.0000', 0, 0, 0, '*', '', 0, 0, '', 0, 0, '2019-10-31', '11:46:08', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 1, 0, 1, '010015', '355.72500000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:47:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 2, 0, 2, '010009', '355.72630000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:47:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 3, 0, 3, '010004', '355.72690000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:47:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 4, 0, 4, '010014', '355.72770000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:47:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 5, 0, 5, '010008', '356.26590000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 6, 0, 6, '010008', '356.26680000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 7, 0, 7, '010008', '356.26770000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 8, 0, 8, '010009', '356.26850000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 9, 0, 9, '010015', '355.19840000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:45:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 10, 0, 10, '010009', '355.19990000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:45:35', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 11, 0, 11, '010005', '356.39140000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:49:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 12, 0, 12, '010014', '356.39290000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:49:10', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 13, 0, 13, '010014', '355.00310000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:45:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 14, 0, 14, '010007', '355.00420000', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:45:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 15, 0, 15, '010001', '355.00500000', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '100.0000', '1.0000', '1.0000', '100.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '17:45:00', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 16, 0, 16, '010009', '355.00610000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:45:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 17, 0, 17, '010003', '327.20620000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:21:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 18, 0, 18, '010004', '327.20780000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:21:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 19, 0, 19, '010004', '327.20910000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:21:37', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 20, 0, 20, '010003', '327.66530000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:22:59', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 21, 0, 21, '100002', '329.40380000', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '0.0000', '0.0000', '0.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '16:28:12', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 22, 0, 22, '090008', '355.67750000', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '30.0000', '1.0000', '1.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '17:47:01', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 23, 0, 23, '090017', '355.67880000', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '3', '09', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '17:47:02', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 24, 0, 24, '010015', '356.23700000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:42', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 25, 0, 25, '010017', '356.24050000', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', 'ไก่ตะกร้า-Size', '', '1', 'A', 'A', 'A', 'N/A', '1', '1', '01', '', '120.0000', '1.0000', '1.0000', '120.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 26, 0, 26, '010014', '356.24140000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 27, 0, 27, '010008', '356.24220000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 28, 0, 28, '010008', '356.24300000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:48:43', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 29, 0, 29, '010005', '356.68390000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '110.0000', '1.0000', '1.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:50:03', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 30, 0, 30, '010005', '356.70860000', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:50:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 31, 0, 31, '010004', '356.71090000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:50:07', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '007', '17:46', 32, 0, 32, '010010', '357.27370000', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '195.0000', '1.0000', '1.0000', '195.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:51:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 1, 0, 1, '010004', '326.44180000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:19:19', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 2, 0, 2, '030002', '327.25950000', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '0.0000', '0.0000', '0.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:21:46', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 3, 0, 3, '030003', '327.26110000', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:21:46', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 4, 0, 4, '030004', '327.26260000', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '03', '', '350.0000', '1.0000', '1.0000', '350.0000', 0, 0, 0, '*', '6', 0, 0, '', 0, 0, '2019-10-30', '16:21:47', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 5, 0, 5, '100008', '327.27120000', 'แตงโมปั่น', 'แตงโมปั่น', 'แตงโมปั่น', 'แตงโมปั่น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '60.0000', '1.0000', '1.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '16:21:48', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 6, 0, 6, '100002', '327.27240000', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '0.0000', '0.0000', '0.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '16:21:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 7, 0, 7, '100016', '327.27350000', 'ชาจีนร้อน', 'ชาจีนร้อน', 'ชาจีนร้อน', 'ชาจีนร้อน', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '0.0000', '0.0000', '0.0000', '30.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '16:21:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 8, 0, 8, '100003', '327.27470000', 'ชาเย็น', 'ชาเย็น', 'ชาเย็น', 'ชาเย็น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '45.0000', '1.0000', '1.0000', '45.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '16:21:49', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 9, 0, 9, '100008', '327.39650000', 'แตงโมปั่น', 'แตงโมปั่น', 'แตงโมปั่น', 'แตงโมปั่น', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '2', '10', '', '60.0000', '1.0000', '1.0000', '60.0000', 0, 0, 0, '*', '1', 0, 0, '', 0, 0, '2019-10-30', '16:22:11', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 10, 0, 10, '010003', '327.58680000', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '0.0000', '0.0000', '0.0000', '110.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:22:45', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 11, 0, 11, '010004', '328.18120000', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '70.0000', '1.0000', '1.0000', '70.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:24:32', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 12, 0, 12, '200001', '329.36610000', 'น้ำจิ้มซีฟู้ด', 'น้ำจิ้มซีฟู้ด', 'น้ำจิ้มซีฟู้ด', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '20', '', '50.0000', '1.0000', '1.0000', '50.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '16:28:05', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 13, 0, 13, '010015', '355.61480000', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '90.0000', '1.0000', '1.0000', '90.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:46:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 14, 0, 14, '010009', '355.61540000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:46:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 15, 0, 15, '010008', '355.61610000', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '130.0000', '1.0000', '1.0000', '130.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:46:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 16, 0, 16, '010014', '355.61660000', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:46:50', '', 1, NULL, 0),
('001', '001', 'K01', '2019-10-30', '009', '16:18', 17, 0, 17, '010009', '357.25710000', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '1', 'N/A', 'N/A', 'N/A', 'N/A', '1', '1', '01', '', '170.0000', '1.0000', '1.0000', '170.0000', 0, 0, 0, '*', '2', 0, 0, '', 0, 0, '2019-10-30', '17:51:46', '', 1, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `outlet`
--

DROP TABLE IF EXISTS `outlet`;
CREATE TABLE `outlet` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletName` varchar(150) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `outlet`
--

INSERT INTO `outlet` (`CompanyId`, `BrandId`, `OutletId`, `OutletName`) VALUES
('001', '001', 'K01', 'Kaitakra');

-- --------------------------------------------------------

--
-- Table structure for table `outletsetting`
--

DROP TABLE IF EXISTS `outletsetting`;
CREATE TABLE `outletsetting` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `MaxQty` int(1) NOT NULL DEFAULT '99',
  `Locallanguage` char(3) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Tha' COMMENT 'ภาษาท้องถิ้น',
  `PosTimeOut` int(5) DEFAULT '60' COMMENT 'Time Out min',
  `PosTimeStamp` datetime DEFAULT NULL COMMENT 'Last Update from thirt party',
  `ServerTimeStamp` datetime DEFAULT NULL COMMENT 'ServerTimeUpdate',
  `MasterFileTimeStamp` datetime DEFAULT NULL COMMENT 'เวลาแก้ไขข้อมูลสินค้าครั้งล่าสุด',
  `SoftwareDateStart` datetime DEFAULT NULL COMMENT 'วันที่เริ่มใช้โปรแกรม',
  `DatabaseVersion` varchar(25) COLLATE utf8_unicode_ci DEFAULT '',
  `ApiVersion` varchar(25) COLLATE utf8_unicode_ci DEFAULT '',
  `BackEndVersion` varchar(25) COLLATE utf8_unicode_ci DEFAULT '',
  `FontEndVersion` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SerialKey` varchar(255) COLLATE utf8_unicode_ci DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `outletsetting`
--

INSERT INTO `outletsetting` (`CompanyId`, `BrandId`, `OutletId`, `MaxQty`, `Locallanguage`, `PosTimeOut`, `PosTimeStamp`, `ServerTimeStamp`, `MasterFileTimeStamp`, `SoftwareDateStart`, `DatabaseVersion`, `ApiVersion`, `BackEndVersion`, `FontEndVersion`, `SerialKey`) VALUES
('001', '001', 'K01', 9, 'Tha', 60, '2019-10-31 12:43:14', '2019-10-31 12:43:14', '2019-10-31 12:54:51', '0000-00-00 00:00:00', '001 Database', '001 API', '001 Back', '001 Font', '001 Serial Key');

--
-- Triggers `outletsetting`
--
DROP TRIGGER IF EXISTS `UpdateServerTimeStamp`;
DELIMITER $$
CREATE TRIGGER `UpdateServerTimeStamp` BEFORE UPDATE ON `outletsetting` FOR EACH ROW BEGIN

	
	IF NEW.PosTimeStamp <> OLD.PosTimeStamp THEN
		SET NEW.ServerTimeStamp = CURRENT_TIMESTAMP;
	END IF;
	
	
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OtherName` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CategoryId` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Category',
  `DepartmentId` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Department',
  `ShowOnCategory` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'แสดงเพิ่มเติมใน Category อื่นๆ',
  `PrintTo` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Print To Printer Vaue = 123',
  `LocalPrint` tinyint(1) DEFAULT NULL COMMENT 'พิมพ์ที่ local printer',
  `KitchenLang` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `ReduceQty` tinyint(1) DEFAULT NULL COMMENT 'ปรับปรุงจำนวน QtyOnHane',
  `QtyOnHand` int(6) DEFAULT NULL COMMENT 'จำนวนสินค้าที่มีอยู่',
  `StockOut` tinyint(1) DEFAULT NULL COMMENT 'True = Stock Out ',
  `LocalDescription` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Product Local Description',
  `EnglishDescription` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Product English Description',
  `OtherDescription` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Product Other Description',
  `SeqNo` int(3) DEFAULT NULL COMMENT 'ลำดับในการแสดง',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'active or inactive product',
  `isPackage` tinyint(1) DEFAULT '0' COMMENT 'สินค้าที่เป็น Package'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `LocalName`, `EnglishName`, `OtherName`, `CategoryId`, `DepartmentId`, `ShowOnCategory`, `PrintTo`, `LocalPrint`, `KitchenLang`, `ReduceQty`, `QtyOnHand`, `StockOut`, `LocalDescription`, `EnglishDescription`, `OtherDescription`, `SeqNo`, `is_active`, `isPackage`) VALUES
('001', '001', 'K01', '010021', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', '01', '2', '01', '5', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '010022', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', '01', '2', '01', '5', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '010023', 'น้ำมะตูม', 'น้ำมะตูม', 'น้ำมะตูม', '01', '2', '01', '5', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '010024', 'น้ำตะไคร้', 'น้ำตะไคร้', 'น้ำตะไคร้', '01', '2', '01', '5', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '010025', 'น้ำใบเตย', 'น้ำใบเตย', 'น้ำใบเตย', '01', '2', '01', '5', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '010026', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', '01', '2', '01', '5', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '010027', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '01', '2', '01', '5', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '010028', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '01', '2', '01', '1', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '010029', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', '01', '2', '01', '1', 0, '', 0, 0, 1, '', '', '', 9, 1, 0),
('001', '001', 'K01', '010030', 'ชาจีนร้อน', 'ชาจีนร้อน', 'ชาจีนร้อน', '01', '2', '01', '1', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '010031', 'เอส', 'เอส', 'เอส', '01', '2', '01', '1', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '010032', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '01', '2', '01', '', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '010033', 'โซดา', 'โซดา', 'โซดา', '01', '2', '01', '1', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '010034', 'น้ำแข็ง', 'น้ำแข็ง', 'น้ำแข็ง', '01', '2', '01', '1', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '010035', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', '01', '2', '01', '1', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '010036', 'สตออว์เบอร์รี โซดา', 'สตออว์เบอร์รี โซดา', 'น้ำเก็กฮวย', '01', '2', '01 12', '5', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '010037', 'บลูเบอร์รี โซดา', 'บลูเบอร์รี โซดา', 'น้ำเก็กฮวย', '01', '2', '01 12', '5', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '020021', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '020022', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '020023', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '020024', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '020025', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '020026', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '020027', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '020028', 'ปลากะพงขี่พริกหอม', 'ปลากะพงขี่พริกหอม', 'ปลากะพงขี่พริกหอม', '02', '1', '12 02', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030041', 'เห็ดตะกร้า', 'เห็ดตะกร้า', 'เห็ดตะกร้า', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030042', 'ข้าวโพดทอด', 'ข้าวโพดทอด', 'ข้าวโพดทอด', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030043', 'ทอดมันปลากราย', 'ทอดมันปลากราย', 'ทอดมันปลากราย', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '030044', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '030045', 'ปากเป็ดทอด', 'ปากเป็ดทอด', 'ปากเป็ดทอด', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '030046', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '030047', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '030048', 'แคบหมู', 'แคบหมู', 'แคบหมู', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '030049', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', '03', '1', '03', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '030050', 'หมูข้าวเม่า', 'หมูข้าวเม่า', 'หมูข้าวเม่า', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '030051', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '030052', 'ฮ่อยจ๊อ เบบี้', 'ฮ่อยจ๊อ เบบี้', 'ฮ่อยจ๊อ เบบี้', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '030053', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '030054', 'คอหมูทอด', 'คอหมูทอด', 'คอหมูทอด', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '030055', 'หมูยอทอด', 'หมูยอทอด', 'หมูยอทอด', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '030056', 'ไก่บ้านทอด(ตัว)', 'ไก่บ้านทอด(ตัว)', 'ไก่บ้านทอด(ตัว)', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 16, 1, 0),
('001', '001', 'K01', '030057', 'สามกรอบยำแห้ง', 'สามกรอบยำแห้ง', 'สามกรอบยำแห้ง', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 17, 1, 0),
('001', '001', 'K01', '030058', 'เฟรนซ์ฟราย', 'เฟรนซ์ฟราย', 'เฟรนซ์ฟราย', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 18, 1, 0),
('001', '001', 'K01', '030059', 'นักเก็ตไก่ไข่เค็ม', 'นักเก็ตไก่ไข่เค็ม', 'นักเก็ตไก่ไข่เค็ม', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 19, 1, 0),
('001', '001', 'K01', '030060', 'เอ็นข้อไก่แซ่บ', 'เอ็นข้อไก่แซ่บ', 'เอ็นข้อไก่แซ่บ', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 20, 1, 0),
('001', '001', 'K01', '030061', 'ไก่ทอด', 'ไก่ทอด', 'ไก่ทอด', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 21, 1, 0),
('001', '001', 'K01', '030062', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', '03', '1', '03 12', '2', 0, '', 0, 0, 0, '', '', '', 22, 1, 0),
('001', '001', 'K01', '040041', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '04', '1', '04', '2', 0, '', 0, 1, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '040042', 'ตำไทย', 'ตำไทย', 'ตำไทย', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '040043', 'ตำปู', 'ตำปู', 'ตำปู', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '040044', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '040045', 'ตำปลาร้า', 'ตำปลาร้า', 'ตำปลาร้า', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '040046', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '040047', 'ตำมั่วลาว', 'ตำมั่วลาว', 'ตำมั่วลาว', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '040048', 'ตำข้าวโพด', 'ตำข้าวโพด', 'ตำข้าวโพด', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '040049', 'ตำปูปลาร้า', 'ตำปูปลาร้า', 'ตำปูปลาร้า', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '040050', 'ตำไข่เค็ม', 'ตำไข่เค็ม', 'ตำไข่เค็ม', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '040051', 'ตำปูม้า', 'ตำปูม้า', 'ตำปูม้า', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '040052', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '040053', 'ตำหอยดอง', 'ตำหอยดอง', 'ตำหอยดอง', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '040054', 'ลาบเป็ด', 'ลาบเป็ด', 'ลาบเป็ด', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '040055', 'ลาบหมู', 'ลาบหมู', 'ลาบหมู', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '040056', 'ซุปหน่อไม้', 'ซุปหน่อไม้', 'ซุปหน่อไม้', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 16, 1, 0),
('001', '001', 'K01', '040057', 'ตับหวาน', 'ตับหวาน', 'ตับหวาน', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 17, 1, 0),
('001', '001', 'K01', '040058', 'ตำป่าแตก', 'ตำป่าแตก', 'ตำป่า', '04', '1', '04 12', '4', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '040059', 'ตำเวียงจันทร์', 'ตำเวียงจันทร์', 'ตำลาว', '04', '1', '03 12', '4', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '050041', 'ไข่ฟูปูก้อน', 'ไข่ฟูปูก้อน', 'ไข่ฟูปูก้อน', '05', '1', '05', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '050042', 'ขนมจีนแกงปูก้อน', 'ขนมจีนแกงปูก้อน', 'ขนมจีนแกงปูก้อน', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '050043', 'แกงปูก้อน', 'แกงปูก้อน', 'แกงปูก้อน', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '050044', 'เนื้อปูก้อนผัดผงกะหรี่', 'เนื้อปูก้อนผัดผงกะหรี่', 'เนื้อปูก้อนผัดผงกะหรี่', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '050045', 'เนื้อปูก้อนผัดข้าว', 'เนื้อปูก้อนผัดข้าว', 'เนื้อปูก้อนผัดข้าว', '05', '1', '05', '2', 0, '', 0, 0, 1, '', '', '', 5, 1, 0),
('001', '001', 'K01', '060041', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '060042', 'ยำรวมมิตร', 'ยำรวมมิตร', 'ยำรวมมิตร', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '060043', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', '06', '1', '06', '6', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '060044', 'ยำปูม้ากุ้งแช่ (ดิบ)', 'ยำปูม้ากุ้งแช่ (ดิบ)', 'ยำปูม้ากุ้งแช่ (ดิบ)', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '060045', 'ยำหมูยอไข่แดง', 'ยำหมูยอไข่แดง', 'ยำหมูยอไข่แดง', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '060046', 'ยำมาม่า', 'ยำมาม่า', 'ยำมาม่า', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '060047', 'ยำปลาดุกฟูลิ้นจี่ย่าง', 'ยำปลาดุกฟูลิ้นจี่ย่าง', 'ยำปลาดุกฟูลิ้นจี่ย่าง', '06', '1', '06', '6', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '060048', 'ยำเขยจ๋า', 'ยำเขยจ๋า', 'ยำเขยจ๋า', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '060049', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '060050', 'ยำหมึกดำไข่แดง', 'ยำหมึกดำไข่แดง', 'ยำหมึกดำไข่แดง', '06', '1', '12 06', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '060051', 'ยำซีฟู๊ด (สุก)', 'ยำซีฟู๊ด (สุก)', 'ยำซีฟู๊ด (สุก)', '06', '1', '12 06', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '060052', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '06', '1', '06 12', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '070061', 'แกงส้มปลาแซลมอน', 'แกงส้มปลาแซลมอน', 'แกงส้มปลาแซลมอน', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '070062', 'แกงส้มผักรวม', 'แกงส้มผักรวม', 'แกงส้มผักรวม', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '070063', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '070064', 'แกงเนื้อพริกขี้หนูหอม', 'แกงเนื้อพริกขี้หนูหอม', 'แกงเนื้อพริกขี้หนูหอม', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '070065', 'แกงหมูพริกขี้หนูหอม', 'แกงหมูพริกขี้หนูหอม', 'แกงหมูพริกขี้หนูหอม', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '070066', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '070067', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '070068', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '070069', 'ต้มแซ่บหมูเด้ง', 'ต้มแซ่บหมูเด้ง', 'ต้มแซ่บหมูเด้ง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '070070', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '070071', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '070072', 'ต้มเปรี้ยวไก่', 'ต้มเปรี้ยวไก่', 'ต้มเปรี้ยวไก่', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '070073', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '070074', 'โป๊ะแตกน้ำ', 'โป๊ะแตกน้ำ', 'โป๊ะแตกน้ำ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '070075', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '070076', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 16, 1, 0),
('001', '001', 'K01', '070077', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', '07', '1', '07 12', '2', 0, '', 0, 0, 0, '', '', '', 17, 1, 0),
('001', '001', 'K01', '070078', 'แกงคั่วหอยขม', 'แกงคั่วหอยขม', 'แกงคั่วหอยขม', '07', '1', '07 12', '2', 0, '', 0, 0, 0, '', '', '', 18, 1, 0),
('001', '001', 'K01', '080031', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '080032', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '080033', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '080034', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '080035', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '080036', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '080038', 'หอยแมลงภู่NZ อบหม้อดิน', 'หอยแมลงภู่NZ อบหม้อดิน', 'หอยแมลงภู่NZ อบหม้อดิน', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '080039', 'ผัดคะน้าปลาสลิด', 'ผัดคะน้าปลาสลิด', 'ผัดคะน้าปลาสลิด', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '080040', 'ผัดคะน้าปลาเค็ม', 'ผัดคะน้าปลาเค็ม', 'ผัดคะน้าปลาเค็ม', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '080041', 'ผัดฉ่าลูกชิ้นปลากราย', 'ผัดฉ่าลูกชิ้นปลากราย', 'ผัดฉ่าลูกชิ้นปลากราย', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '080042', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '080043', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '080044', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '090031', 'ข้าวผัดปลาเค็ม', 'ข้าวผัดปลาเค็ม', 'ข้าวผัดปลาเค็ม', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '090032', 'ข้าวผัดปลาสลิดกรอบ', 'ข้าวผัดปลาสลิดกรอบ', 'ข้าวผัดปลาสลิดกรอบ', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '090033', 'ข้าวผัดหมู', 'ข้าวผัดหมู', 'ข้าวผัดหมู', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '090034', 'ข้าวผัดไก่', 'ข้าวผัดไก่', 'ข้าวผัดไก่', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '090035', 'ข้าวผัดกุ้ง', 'ข้าวผัดกุ้ง', 'ข้าวผัดกุ้ง', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '090036', 'ข้าวราดกระเพราหมู', 'ข้าวราดกระเพราหมู', 'ข้าวราดกระเพราหมู', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '090037', 'ข้าวราดกระเพราไก่', 'ข้าวราดกระเพราไก่', 'ข้าวราดกระเพราไก่', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '090038', 'ข้าวราดกระเพรากุ้ง', 'ข้าวราดกระเพรากุ้ง', 'ข้าวราดกระเพรากุ้ง', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '090039', 'ข้าวราดกระเพราปลาหมึก', 'ข้าวราดกระเพราปลาหมึก', 'ข้าวราดกระเพราปลาหมึก', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '090040', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', '09', '1', '09', '', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '090041', 'ข้าวเหนียวขาว', 'ข้าวเหนียวขาว', 'ข้าวเหนียวขาว', '09', '1', '09', '', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '090042', 'ขนมจีน', 'ขนมจีน', 'ขนมจีน', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '090043', 'ไข่ดาว', 'ไข่ดาว', 'ไข่ดาว', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '090044', 'ไข่เจียว', 'ไข่เจียว', 'ไข่เจียว', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '090045', 'ไข่เจียวหมูสับ', 'ไข่เจียวหมูสับ', 'ไข่เจียวหมูสับ', '09', '1', '09', '2', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '090046', 'ข้าวผัดกุ้งก้ามกราม', 'ข้าวผัดกุ้งก้ามกราม', 'ข้าวผัดกุ้ง', '09', '1', '09 12', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '100031', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '10', '3', '10', '1', 0, '', 0, -1, 1, '', '', '', 1, 1, 0),
('001', '001', 'K01', '100032', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '10', '3', '10', '1', 0, '', 0, -1, 1, '', '', '', 2, 1, 0),
('001', '001', 'K01', '100033', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '100034', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '100035', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '100036', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '100037', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '100038', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '100039', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '100040', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '100041', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', '10', '3', '10', '1', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '100042', 'ไอศกรีมช็อกโกแลตลาวา', 'ไอศกรีมช็อกโกแลตลาวา', 'ไอศกรีมทุเรียน', '10', '3', '10 12', '1', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '110001', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '110002', 'เบียร์สิงห์', 'เบียร์สิงห์', 'เบียร์สิงห์', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '110003', 'เบียร์ลีโอ', 'เบียร์ลีโอ', 'เบียร์ลีโอ', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '110004', 'เบียร์ช้าง', 'เบียร์ช้าง', 'เบียร์ช้าง', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '110007', 'พอลลาเนอร์', 'พอลลาเนอร์', 'พอลลาเนอร์', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '110008', 'เบียร์โฮกาเด้น', 'เบียร์โฮกาเด้น', 'เบียร์โฮกาเด้น', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '110009', 'เบียร์โฮกาเด้น โรเซ่', 'เบียร์โฮกาเด้น โรเซ่', 'เบียร์โฮกาเด้น โรเซ่', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '110010', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', '11', '2', '11', '5', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '110011', 'รีเจนซี่(กลม)', 'รีเจนซี่(กลม)', 'รีเจนซี่(กลม)', '11', '2', '11', '5', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '110012', 'แบล็คเลเบิ้ล (1litre)', 'แบล็คเลเบิ้ล (1litre)', 'แบล็คเลเบิ้ล (1litre)', '11', '2', '11', '5', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '110013', 'เรดเลเบิ้ล (1litre)', 'เรดเลเบิ้ล (1litre)', 'เรดเลเบิ้ล (1litre)', '11', '2', '11', '5', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '110014', 'BLEND 285', 'BLEND 285', 'BLEND 285', '11', '2', '11', '5', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '120024', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '12', '1', '12', '6', 0, '', 0, 0, 1, '', '', '', 4, 0, 0),
('001', '001', 'K01', '120025', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '12', '1', '12', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '120026', 'หมึกน้ำดำ', 'หมึกน้ำดำ', 'หมึกน้ำดำ', '12', '1', '12', '6', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '120027', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '12', '1', '12', '6', 0, '', 0, 0, 0, '', '', '', 7, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `productcontrol`
--

DROP TABLE IF EXISTS `productcontrol`;
CREATE TABLE `productcontrol` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `CategoryControlId` varchar(2) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Category code',
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Product code',
  `SeqNo` int(3) DEFAULT NULL COMMENT 'ลำดับในการแสดง',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'active or inactive product'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `productcontrol`
--

INSERT INTO `productcontrol` (`CompanyId`, `BrandId`, `OutletId`, `CategoryControlId`, `ItemId`, `SeqNo`, `is_active`) VALUES
('001', '001', '001', '01', '010001', 1, 1),
('001', '001', '001', '01', '010007', 7, 1),
('001', '001', '001', '01', '010023', 23, 1),
('001', '001', '001', '02', '010004', 4, 1),
('001', '001', '001', '02', '020013', 0, 1),
('001', '001', '001', '03', '010005', 5, 1),
('001', '001', '001', '03', '030005', 0, 1),
('001', '001', '001', '03', '030006', 0, 1),
('001', '001', '001', '03', '030007', 0, 1),
('001', '001', '001', '03', '030008', 0, 1),
('001', '001', '001', '03', '030009', 0, 1),
('001', '001', '001', '03', '030010', 0, 1),
('001', '001', '001', '03', '030011', 0, 1),
('001', '001', '001', '03', '030012', 0, 1),
('001', '001', '001', '03', '030013', 0, 1),
('001', '001', '001', '03', '030014', 0, 1),
('001', '001', '001', '03', '030015', 0, 1),
('001', '001', '001', '03', '030016', 0, 1),
('001', '001', '001', '03', '030017', 0, 1),
('001', '001', '001', '03', '030018', 0, 1),
('001', '001', '001', '03', '030019', 0, 1),
('001', '001', '001', '03', '030020', 0, 1),
('001', '001', '001', '03', '030021', 0, 1),
('001', '001', '001', '03', '030022', 0, 1),
('001', '001', '001', '03', '030023', 0, 1),
('001', '001', '001', '03', '030024', 0, 1),
('001', '001', '001', '03', '030025', 0, 1),
('001', '001', '001', '03', '030026', 0, 1),
('001', '001', '001', '03', '030027', 0, 1),
('001', '001', '001', '03', '030028', 1, 1),
('001', '001', '001', '03', '030029', 2, 1),
('001', '001', '001', '03', '030030', 3, 1),
('001', '001', '001', '03', '030031', 4, 1),
('001', '001', '001', '03', '030032', 5, 1),
('001', '001', '001', '03', '030033', 6, 1),
('001', '001', '001', '03', '030034', 7, 1),
('001', '001', '001', '03', '030036', 9, 1),
('001', '001', '001', '03', '030037', 10, 1),
('001', '001', '001', '04', '010006', 6, 1),
('001', '001', '001', '04', '040001', 0, 1),
('001', '001', '001', '04', '040002', 0, 1),
('001', '001', '001', '04', '040003', 0, 1),
('001', '001', '001', '04', '040004', 0, 1),
('001', '001', '001', '04', '040005', 0, 1),
('001', '001', '001', '04', '040006', 0, 1),
('001', '001', '001', '04', '040007', 0, 1),
('001', '001', '001', '04', '040008', 0, 1),
('001', '001', '001', '04', '040009', 0, 1),
('001', '001', '001', '04', '040010', 0, 1),
('001', '001', '001', '04', '040011', 0, 1),
('001', '001', '001', '06', '060019', 5, 1),
('001', '001', '001', '08', '080005', 0, 1),
('001', '001', '001', '08', '080006', 0, 1),
('001', '001', '001', '08', '080007', 0, 1),
('001', '001', '001', '08', '080008', 0, 1),
('001', '001', '001', '08', '080009', 0, 1),
('001', '001', '001', '08', '080010', 0, 1),
('001', '001', '001', '08', '080011', 0, 1),
('001', '001', '001', '08', '080012', 0, 1),
('001', '001', '001', '08', '080013', 0, 1),
('001', '001', '001', '08', '080014', 1, 1),
('001', '001', '001', '08', '080015', 2, 1),
('001', '001', '001', '08', '080016', 3, 1),
('001', '001', '001', '08', '080017', 4, 1),
('001', '001', '001', '08', '080018', 5, 1),
('001', '001', '001', '08', '080019', 6, 1),
('001', '001', '001', '09', '090001', 0, 1),
('001', '001', '001', '09', '090002', 0, 1),
('001', '001', '001', '09', '090003', 0, 1),
('001', '001', '001', '09', '090004', 0, 1),
('001', '001', '001', '09', '090005', 0, 1),
('001', '001', '001', '09', '090006', 0, 1),
('001', '001', '001', '09', '090007', 0, 1),
('001', '001', '001', '09', '090008', 1, 1),
('001', '001', '001', '09', '090009', 2, 1),
('001', '001', '001', '10', '100001', 0, 1),
('001', '001', '001', '10', '100002', 0, 1),
('001', '001', '001', '10', '100003', 0, 1),
('001', '001', '001', '10', '100004', 0, 1),
('001', '001', '001', '10', '100005', 0, 1),
('001', '001', '001', '10', '100006', 0, 1),
('001', '001', '001', '10', '100007', 0, 1),
('001', '001', '001', '10', '100008', 0, 1),
('001', '001', '001', '10', '100009', 0, 1),
('001', '001', '001', '10', '100010', 0, 1),
('001', '001', '001', '10', '100011', 0, 1),
('001', '001', '001', '10', '100012', 0, 1),
('001', '001', '001', '10', '100013', 0, 1),
('001', '001', '001', '10', '100014', 0, 1),
('001', '001', '001', '10', '100015', 0, 1),
('001', '001', '001', '10', '100016', 0, 1),
('001', '001', '001', '10', '100017', 0, 1),
('001', '001', '001', '10', '100018', 0, 1),
('001', '001', '001', '10', '100019', 0, 1),
('001', '001', '001', '10', '100020', 0, 1),
('001', '001', '001', '10', '100022', 2, 1),
('001', '001', '001', '11', '110008', 0, 1),
('001', '001', '001', '11', '110009', 0, 1),
('001', '001', '001', '11', '110010', 0, 1),
('001', '001', '001', '11', '110011', 0, 1),
('001', '001', '001', '11', '110012', 0, 1),
('001', '001', '001', '11', '110013', 1, 1),
('001', '001', '001', '11', '110014', 2, 1),
('001', '001', '001', '11', '110015', 3, 1),
('001', '001', '001', '11', '110016', 4, 1),
('001', '001', '001', '11', '110017', 5, 1),
('001', '001', '001', '11', '110018', 6, 1),
('001', '001', '001', '11', '110019', 7, 1),
('001', '001', '001', '11', '110020', 8, 1),
('001', '001', '001', '11', '110021', 9, 1),
('001', '001', '001', '11', '110022', 10, 1),
('001', '001', '001', '11', '110023', 11, 1),
('001', '001', '001', '11', '110024', 12, 1),
('001', '001', '001', '11', '110025', 13, 1),
('001', '001', '001', '11', '110026', 14, 1),
('001', '001', '001', '11', '110030', 15, 1),
('001', '001', '001', '12', '120001', 0, 1),
('001', '001', '001', '12', '120002', 0, 1),
('001', '001', '001', '12', '120003', 0, 1),
('001', '001', '001', '12', '120004', 0, 1),
('001', '001', '001', '12', '120005', 0, 1),
('001', '001', '001', '12', '120006', 0, 1),
('001', '001', '001', '12', '120007', 0, 1),
('001', '001', '001', '12', '120008', 0, 1),
('001', '001', '001', '12', '120011', 0, 1),
('001', '001', '001', '12', '120012', 0, 1),
('001', '001', '001', '12', '120013', 0, 1),
('001', '001', '001', '12', '120014', 0, 1),
('001', '001', '001', '12', '120015', 1, 1),
('001', '001', '001', '12', '120016', 2, 1),
('001', '001', '001', '12', '120017', 3, 1),
('001', '001', '001', '12', '120018', 4, 1),
('001', '001', '001', '12', '120019', 5, 1),
('001', '001', '001', '12', '120020', 6, 1),
('001', '001', '001', '12', '120021', 7, 1),
('001', '001', '001', '12', '120022', 8, 1),
('001', '001', '001', '16', '010001', 3, 1),
('001', '001', '001', '18', '180001', 1, 1),
('001', '001', '001', '18', '180002', 2, 1),
('001', '001', '001', '18', '180003', 3, 1),
('001', '001', '001', '18', '180004', 4, 1),
('001', '001', '001', '18', '180005', 5, 1),
('001', '001', '001', '18', '180006', 6, 1),
('001', '001', '001', '18', '180007', 7, 1),
('001', '001', '001', '18', '180008', 8, 1),
('001', '001', '001', '18', '180009', 9, 1),
('001', '001', '001', '18', '180010', 10, 1),
('001', '001', '001', '18', '180011', 11, 1),
('001', '001', '001', '18', '180013', 13, 1),
('001', '001', '001', '18', '180014', 14, 1),
('001', '001', '001', '18', '180015', 15, 1),
('001', '001', '001', '18', '180016', 16, 1),
('001', '001', '001', '18', '180017', 17, 1),
('001', '001', '001', '18', '180018', 18, 1),
('001', '001', '001', '18', '180019', 19, 1),
('001', '001', '001', '18', '180020', 20, 1),
('001', '001', '001', '18', '180021', 21, 1),
('001', '001', '001', '18', '180022', 22, 1),
('001', '001', '001', '19', '190003', 3, 1),
('001', '001', '001', '19', '190004', 4, 1),
('001', '001', '001', '19', '190005', 5, 1),
('001', '001', '001', '20', '200001', 1, 1),
('001', '001', '001', '20', '200002', 2, 1),
('001', '001', '001', '20', '200003', 3, 1),
('001', '001', '001', '20', '200004', 4, 1),
('001', '001', '001', '20', '200005', 5, 1),
('001', '001', '001', '20', '200006', 6, 1),
('001', '001', '001', '20', '200007', 7, 1),
('001', '001', '001', '20', '200008', 8, 1),
('001', '001', '001', '20', '200009', 9, 1),
('001', '001', '001', '20', '200010', 10, 1),
('001', '001', '001', '20', '200011', 11, 1),
('001', '001', '001', '20', '200012', 12, 1),
('001', '001', '001', '20', '200013', 13, 1),
('001', '001', '001', '20', '200014', 14, 1),
('001', '001', '001', '20', '200015', 15, 1),
('001', '001', '001', '20', '200016', 16, 1),
('001', '001', '001', '20', '200017', 17, 1),
('001', '001', '001', '20', '200018', 18, 1),
('001', '001', '001', '20', '200019', 19, 1),
('001', '001', '001', '20', '200020', 20, 1),
('001', '001', '001', '20', '200021', 21, 1),
('001', '001', '001', '20', '200022', 22, 1),
('001', '001', '001', '21', '210001', 1, 1),
('001', '001', '001', '21', '210002', 2, 1),
('001', '001', '001', '21', '210003', 3, 1),
('001', '001', '001', '21', '210004', 4, 1),
('001', '001', '001', '21', '210005', 5, 1),
('001', '001', '001', '21', '210006', 6, 1),
('001', '001', '001', '21', '210007', 7, 1),
('001', '001', '001', '23', '230001', 1, 1),
('001', '001', '001', '23', '230002', 2, 1),
('001', '001', '001', '23', '230003', 3, 1),
('001', '001', '001', '23', '230004', 4, 1),
('001', '001', '001', '23', '230005', 5, 1),
('001', '001', '001', '23', '230006', 6, 1),
('001', '001', '001', '29', '290001', 1, 1),
('001', '001', '001', '29', '290002', 2, 1),
('001', '001', '001', '29', '290003', 1, 1),
('001', '001', '001', '30', '300001', 1, 1),
('001', '001', '001', '35', '010001', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `productimage`
--

DROP TABLE IF EXISTS `productimage`;
CREATE TABLE `productimage` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `image` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `productimage`
--

INSERT INTO `productimage` (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `image`) VALUES
('001', '001', 'K01', '010028', '001001K01_010028.jpg'),
('001', '001', 'K01', '020022', '001001K01_020022.jpg'),
('001', '001', 'K01', '020024', '001001K01_020024.jpg'),
('001', '001', 'K01', '020025', '001001K01_020025.jpg'),
('001', '001', 'K01', '020027', '001001K01_020027.jpg'),
('001', '001', 'K01', '020028', '001001K01_020028.jpg'),
('001', '001', 'K01', '030041', '001001K01_030041.jpg'),
('001', '001', 'K01', '030042', '001001K01_030042.jpg'),
('001', '001', 'K01', '030043', '001001K01_030043.jpg'),
('001', '001', 'K01', '030045', '001001K01_030045.jpg'),
('001', '001', 'K01', '030047', '001001K01_030047.jpg'),
('001', '001', 'K01', '030050', '001001K01_030050.jpg'),
('001', '001', 'K01', '030051', '001001K01_030051.jpg'),
('001', '001', 'K01', '030054', '001001K01_030054.jpg'),
('001', '001', 'K01', '030055', '001001K01_030055.jpg'),
('001', '001', 'K01', '030056', '001001K01_030056.jpg'),
('001', '001', 'K01', '030057', '001001K01_030057.jpg'),
('001', '001', 'K01', '030059', '001001K01_030059.jpg'),
('001', '001', 'K01', '030060', '001001K01_030060.jpg'),
('001', '001', 'K01', '030061', '001001K01_030061.jpg'),
('001', '001', 'K01', '030062', '001001K01_030062.jpg'),
('001', '001', 'K01', '040042', '001001K01_040042.jpg'),
('001', '001', 'K01', '040044', '001001K01_040044.jpg'),
('001', '001', 'K01', '040045', '001001K01_040045.jpg'),
('001', '001', 'K01', '040047', '001001K01_040047.jpg'),
('001', '001', 'K01', '040048', '001001K01_040048.jpg'),
('001', '001', 'K01', '040050', '001001K01_040050.jpg'),
('001', '001', 'K01', '040051', '001001K01_040051.jpg'),
('001', '001', 'K01', '040052', '001001K01_040052.jpg'),
('001', '001', 'K01', '040054', '001001K01_040054.jpg'),
('001', '001', 'K01', '040055', '001001K01_040055.jpg'),
('001', '001', 'K01', '040058', '001001K01_040058.jpg'),
('001', '001', 'K01', '040059', '001001K01_040059.jpg'),
('001', '001', 'K01', '050041', '001001K01_050041.jpg'),
('001', '001', 'K01', '050042', '001001K01_050042.jpg'),
('001', '001', 'K01', '050043', '001001K01_050043.jpg'),
('001', '001', 'K01', '050044', '001001K01_050044.jpg'),
('001', '001', 'K01', '050045', '001001K01_050045.jpg'),
('001', '001', 'K01', '060042', '001001K01_060042.jpg'),
('001', '001', 'K01', '060043', '001001K01_060043.jpg'),
('001', '001', 'K01', '060044', '001001K01_060044.jpg'),
('001', '001', 'K01', '060045', '001001K01_060045.jpg'),
('001', '001', 'K01', '060046', '001001K01_060046.jpg'),
('001', '001', 'K01', '060047', '001001K01_060047.jpg'),
('001', '001', 'K01', '060048', '001001K01_060048.jpg'),
('001', '001', 'K01', '060049', '001001K01_060049.jpg'),
('001', '001', 'K01', '060050', '001001K01_060050.jpg'),
('001', '001', 'K01', '060051', '001001K01_060051.jpg'),
('001', '001', 'K01', '060052', '001001K01_060052.jpg'),
('001', '001', 'K01', '070061', '001001K01_070061.jpg'),
('001', '001', 'K01', '070064', '001001K01_070064.jpg'),
('001', '001', 'K01', '070067', '001001K01_070067.jpg'),
('001', '001', 'K01', '070069', '001001K01_070069.jpg'),
('001', '001', 'K01', '070072', '001001K01_070072.jpg'),
('001', '001', 'K01', '070076', '001001K01_070076.jpg'),
('001', '001', 'K01', '070077', '001001K01_070077.jpg'),
('001', '001', 'K01', '080031', '001001K01_080031.jpg'),
('001', '001', 'K01', '080032', '001001K01_080032.jpg'),
('001', '001', 'K01', '080035', '001001K01_080035.jpg'),
('001', '001', 'K01', '080036', '001001K01_080036.jpg'),
('001', '001', 'K01', '080041', '001001K01_080041.jpg'),
('001', '001', 'K01', '080043', '001001K01_080043.jpg'),
('001', '001', 'K01', '080044', '001001K01_080044.jpg'),
('001', '001', 'K01', '090035', '001001K01_090035.png'),
('001', '001', 'K01', '090039', '001001K01_090039.jpg'),
('001', '001', 'K01', '090046', '001001K01_090046.jpg'),
('001', '001', 'K01', '100031', '001001K01_100031.jpg'),
('001', '001', 'K01', '100033', '001001K01_100033.jpg'),
('001', '001', 'K01', '100034', '001001K01_100034.jpg'),
('001', '001', 'K01', '100036', '001001K01_100036.jpg'),
('001', '001', 'K01', '100037', '001001K01_100037.jpg'),
('001', '001', 'K01', '100038', '001001K01_100038.jpg'),
('001', '001', 'K01', '100039', '001001K01_100039.jpg'),
('001', '001', 'K01', '100041', '001001K01_100041.jpg'),
('001', '001', 'K01', '100042', '001001K01_100042.jpg'),
('001', '001', 'K01', '120024', '001001K01_120024.jpg'),
('001', '001', 'K01', '120026', '001001K01_120026.jpg'),
('001', '001', 'K01', '120027', '001001K01_120027.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `productpackage`
--

DROP TABLE IF EXISTS `productpackage`;
CREATE TABLE `productpackage` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `Level` int(2) NOT NULL,
  `ChooseQty` int(3) NOT NULL DEFAULT '1',
  `Component` varchar(250) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '[ItemId,SizeId]',
  `BaseItemId` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '[ItemId,SizeId] สินค้าหลักเพื่อกำหนดราคา',
  `Needed` tinyint(1) DEFAULT NULL COMMENT 'ต้องเลือกสินค้าใน level นี้',
  `AutoAppend` tinyint(1) DEFAULT NULL COMMENT 'ต้องใส่ใน package โดยอัตโนมัติ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `productrecommend`
--

DROP TABLE IF EXISTS `productrecommend`;
CREATE TABLE `productrecommend` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ShowOnCategory` varchar(2) COLLATE utf8_unicode_ci NOT NULL COMMENT 'หมวดหมู่',
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL COMMENT 'รายการสินค้า',
  `SeqNo` int(3) DEFAULT NULL COMMENT 'ลำดับในการแสดง'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `productrecommend`
--

INSERT INTO `productrecommend` (`CompanyId`, `BrandId`, `OutletId`, `ShowOnCategory`, `ItemId`, `SeqNo`) VALUES
('001', '001', 'K01', '30', '030001', 2),
('001', '001', 'K01', '30', '030002', 3),
('001', '001', 'K01', '30', '290001', 1),
('001', '001', 'K01', '31', '030001', 2),
('001', '001', 'K01', '31', '060008', 1);

-- --------------------------------------------------------

--
-- Table structure for table `productsetting`
--

DROP TABLE IF EXISTS `productsetting`;
CREATE TABLE `productsetting` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `LocalName` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `EnglishName` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OtherName` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CategoryId` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Category',
  `DepartmentId` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Department',
  `ShowOnCategory` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'แสดงเพิ่มเติมใน Category อื่นๆ',
  `PrintTo` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Print To Printer Vaue = 123',
  `LocalPrint` tinyint(1) DEFAULT NULL COMMENT 'พิมพ์ที่ local printer',
  `KitchenLang` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ภาษาพิมพ์ที่ครัว',
  `ReduceQty` tinyint(1) DEFAULT NULL COMMENT 'ปรับปรุงจำนวน QtyOnHane',
  `QtyOnHand` decimal(6,0) DEFAULT NULL COMMENT 'จำนวนสินค้าที่มีอยู่',
  `StockOut` tinyint(1) DEFAULT NULL COMMENT 'True = Stock Out '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `productsetting`
--

INSERT INTO `productsetting` (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `LocalName`, `EnglishName`, `OtherName`, `CategoryId`, `DepartmentId`, `ShowOnCategory`, `PrintTo`, `LocalPrint`, `KitchenLang`, `ReduceQty`, `QtyOnHand`, `StockOut`) VALUES
('001', '001', 'K01', '010021', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', '01', '2', '01', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010022', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', '01', '2', '01', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010023', 'น้ำมะตูม', 'น้ำมะตูม', 'น้ำมะตูม', '01', '2', '01', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010024', 'น้ำตะไคร้', 'น้ำตะไคร้', 'น้ำตะไคร้', '01', '2', '01', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010025', 'น้ำใบเตย', 'น้ำใบเตย', 'น้ำใบเตย', '01', '2', '01', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010026', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', '01', '2', '01', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010027', 'น้ำพั้นช์', 'น้ำพั้นช์', 'น้ำพั้นช์', '01', '2', '01', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010028', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '01', '2', '01', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '010029', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', '01', '2', '01', '1', 0, '', 0, '0', 1),
('001', '001', 'K01', '010030', 'ชาจีนร้อน', 'ชาจีนร้อน', 'ชาจีนร้อน', '01', '2', '01', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '010031', 'เอส', 'เอส', 'เอส', '01', '2', '01', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '010032', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '01', '2', '01', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '010033', 'โซดา', 'โซดา', 'โซดา', '01', '2', '01', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '010034', 'น้ำแข็ง', 'น้ำแข็ง', 'น้ำแข็ง', '01', '2', '01', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '010035', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', '01', '2', '01', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '010036', 'สตออว์เบอร์รี โซดา', 'สตออว์เบอร์รี โซดา', 'น้ำเก็กฮวย', '01', '2', '01 12', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '010037', 'บลูเบอร์รี โซดา', 'บลูเบอร์รี โซดา', 'น้ำเก็กฮวย', '01', '2', '01 12', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '020021', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020022', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020023', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020024', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020025', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020026', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020027', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020028', 'ปลากะพงขี่พริกหอม', 'ปลากะพงขี่พริกหอม', 'ปลากะพงขี่พริกหอม', '02', '1', '12 02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030041', 'เห็ดตะกร้า', 'เห็ดตะกร้า', 'เห็ดตะกร้า', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030042', 'ข้าวโพดทอด', 'ข้าวโพดทอด', 'ข้าวโพดทอด', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030043', 'ทอดมันปลากราย', 'ทอดมันปลากราย', 'ทอดมันปลากราย', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030044', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030045', 'ปากเป็ดทอด', 'ปากเป็ดทอด', 'ปากเป็ดทอด', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030046', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030047', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030048', 'แคบหมู', 'แคบหมู', 'แคบหมู', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030049', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', '03', '1', '03', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '030050', 'หมูข้าวเม่า', 'หมูข้าวเม่า', 'หมูข้าวเม่า', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030051', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030052', 'ฮ่อยจ๊อ เบบี้', 'ฮ่อยจ๊อ เบบี้', 'ฮ่อยจ๊อ เบบี้', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030053', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030054', 'คอหมูทอด', 'คอหมูทอด', 'คอหมูทอด', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030055', 'หมูยอทอด', 'หมูยอทอด', 'หมูยอทอด', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030056', 'ไก่บ้านทอด(ตัว)', 'ไก่บ้านทอด(ตัว)', 'ไก่บ้านทอด(ตัว)', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030057', 'สามกรอบยำแห้ง', 'สามกรอบยำแห้ง', 'สามกรอบยำแห้ง', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030058', 'เฟรนซ์ฟราย', 'เฟรนซ์ฟราย', 'เฟรนซ์ฟราย', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030059', 'นักเก็ตไก่ไข่เค็ม', 'นักเก็ตไก่ไข่เค็ม', 'นักเก็ตไก่ไข่เค็ม', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030060', 'เอ็นข้อไก่แซ่บ', 'เอ็นข้อไก่แซ่บ', 'เอ็นข้อไก่แซ่บ', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030061', 'ไก่ทอด', 'ไก่ทอด', 'ไก่ทอด', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030062', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', '03', '1', '03 12', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040041', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '04', '1', '04', '2', 0, '', 0, '1', 0),
('001', '001', 'K01', '040042', 'ตำไทย', 'ตำไทย', 'ตำไทย', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040043', 'ตำปู', 'ตำปู', 'ตำปู', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040044', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040045', 'ตำปลาร้า', 'ตำปลาร้า', 'ตำปลาร้า', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040046', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040047', 'ตำมั่วลาว', 'ตำมั่วลาว', 'ตำมั่วลาว', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040048', 'ตำข้าวโพด', 'ตำข้าวโพด', 'ตำข้าวโพด', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040049', 'ตำปูปลาร้า', 'ตำปูปลาร้า', 'ตำปูปลาร้า', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040050', 'ตำไข่เค็ม', 'ตำไข่เค็ม', 'ตำไข่เค็ม', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040051', 'ตำปูม้า', 'ตำปูม้า', 'ตำปูม้า', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040052', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040053', 'ตำหอยดอง', 'ตำหอยดอง', 'ตำหอยดอง', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040054', 'ลาบเป็ด', 'ลาบเป็ด', 'ลาบเป็ด', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040055', 'ลาบหมู', 'ลาบหมู', 'ลาบหมู', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040056', 'ซุปหน่อไม้', 'ซุปหน่อไม้', 'ซุปหน่อไม้', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040057', 'ตับหวาน', 'ตับหวาน', 'ตับหวาน', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040058', 'ตำป่าแตก', 'ตำป่าแตก', 'ตำป่า', '04', '1', '04 12', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '040059', 'ตำเวียงจันทร์', 'ตำเวียงจันทร์', 'ตำลาว', '04', '1', '03 12', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '050041', 'ไข่ฟูปูก้อน', 'ไข่ฟูปูก้อน', 'ไข่ฟูปูก้อน', '05', '1', '05', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '050042', 'ขนมจีนแกงปูก้อน', 'ขนมจีนแกงปูก้อน', 'ขนมจีนแกงปูก้อน', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050043', 'แกงปูก้อน', 'แกงปูก้อน', 'แกงปูก้อน', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050044', 'เนื้อปูก้อนผัดผงกะหรี่', 'เนื้อปูก้อนผัดผงกะหรี่', 'เนื้อปูก้อนผัดผงกะหรี่', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050045', 'เนื้อปูก้อนผัดข้าว', 'เนื้อปูก้อนผัดข้าว', 'เนื้อปูก้อนผัดข้าว', '05', '1', '05', '2', 0, '', 0, '0', 1),
('001', '001', 'K01', '060041', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060042', 'ยำรวมมิตร', 'ยำรวมมิตร', 'ยำรวมมิตร', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060043', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', '06', '1', '06', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '060044', 'ยำปูม้ากุ้งแช่ (ดิบ)', 'ยำปูม้ากุ้งแช่ (ดิบ)', 'ยำปูม้ากุ้งแช่ (ดิบ)', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060045', 'ยำหมูยอไข่แดง', 'ยำหมูยอไข่แดง', 'ยำหมูยอไข่แดง', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060046', 'ยำมาม่า', 'ยำมาม่า', 'ยำมาม่า', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060047', 'ยำปลาดุกฟูลิ้นจี่ย่าง', 'ยำปลาดุกฟูลิ้นจี่ย่าง', 'ยำปลาดุกฟูลิ้นจี่ย่าง', '06', '1', '06', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '060048', 'ยำเขยจ๋า', 'ยำเขยจ๋า', 'ยำเขยจ๋า', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060049', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060050', 'ยำหมึกดำไข่แดง', 'ยำหมึกดำไข่แดง', 'ยำหมึกดำไข่แดง', '06', '1', '12 06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060051', 'ยำซีฟู๊ด (สุก)', 'ยำซีฟู๊ด (สุก)', 'ยำซีฟู๊ด (สุก)', '06', '1', '12 06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060052', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '06', '1', '06 12', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070061', 'แกงส้มปลาแซลมอน', 'แกงส้มปลาแซลมอน', 'แกงส้มปลาแซลมอน', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070062', 'แกงส้มผักรวม', 'แกงส้มผักรวม', 'แกงส้มผักรวม', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070063', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070064', 'แกงเนื้อพริกขี้หนูหอม', 'แกงเนื้อพริกขี้หนูหอม', 'แกงเนื้อพริกขี้หนูหอม', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070065', 'แกงหมูพริกขี้หนูหอม', 'แกงหมูพริกขี้หนูหอม', 'แกงหมูพริกขี้หนูหอม', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070066', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070067', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070068', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070069', 'ต้มแซ่บหมูเด้ง', 'ต้มแซ่บหมูเด้ง', 'ต้มแซ่บหมูเด้ง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070070', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070071', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070072', 'ต้มเปรี้ยวไก่', 'ต้มเปรี้ยวไก่', 'ต้มเปรี้ยวไก่', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070073', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070074', 'โป๊ะแตกน้ำ', 'โป๊ะแตกน้ำ', 'โป๊ะแตกน้ำ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070075', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070076', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070077', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', '07', '1', '07 12', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070078', 'แกงคั่วหอยขม', 'แกงคั่วหอยขม', 'แกงคั่วหอยขม', '07', '1', '07 12', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080031', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080032', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080033', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080034', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080035', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080036', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080038', 'หอยแมลงภู่NZ อบหม้อดิน', 'หอยแมลงภู่NZ อบหม้อดิน', 'หอยแมลงภู่NZ อบหม้อดิน', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080039', 'ผัดคะน้าปลาสลิด', 'ผัดคะน้าปลาสลิด', 'ผัดคะน้าปลาสลิด', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080040', 'ผัดคะน้าปลาเค็ม', 'ผัดคะน้าปลาเค็ม', 'ผัดคะน้าปลาเค็ม', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080041', 'ผัดฉ่าลูกชิ้นปลากราย', 'ผัดฉ่าลูกชิ้นปลากราย', 'ผัดฉ่าลูกชิ้นปลากราย', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080042', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080043', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080044', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090031', 'ข้าวผัดปลาเค็ม', 'ข้าวผัดปลาเค็ม', 'ข้าวผัดปลาเค็ม', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090032', 'ข้าวผัดปลาสลิดกรอบ', 'ข้าวผัดปลาสลิดกรอบ', 'ข้าวผัดปลาสลิดกรอบ', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090033', 'ข้าวผัดหมู', 'ข้าวผัดหมู', 'ข้าวผัดหมู', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090034', 'ข้าวผัดไก่', 'ข้าวผัดไก่', 'ข้าวผัดไก่', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090035', 'ข้าวผัดกุ้ง', 'ข้าวผัดกุ้ง', 'ข้าวผัดกุ้ง', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090036', 'ข้าวราดกระเพราหมู', 'ข้าวราดกระเพราหมู', 'ข้าวราดกระเพราหมู', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090037', 'ข้าวราดกระเพราไก่', 'ข้าวราดกระเพราไก่', 'ข้าวราดกระเพราไก่', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090038', 'ข้าวราดกระเพรากุ้ง', 'ข้าวราดกระเพรากุ้ง', 'ข้าวราดกระเพรากุ้ง', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090039', 'ข้าวราดกระเพราปลาหมึก', 'ข้าวราดกระเพราปลาหมึก', 'ข้าวราดกระเพราปลาหมึก', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090040', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', '09', '1', '09', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '090041', 'ข้าวเหนียวขาว', 'ข้าวเหนียวขาว', 'ข้าวเหนียวขาว', '09', '1', '09', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '090042', 'ขนมจีน', 'ขนมจีน', 'ขนมจีน', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090043', 'ไข่ดาว', 'ไข่ดาว', 'ไข่ดาว', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090044', 'ไข่เจียว', 'ไข่เจียว', 'ไข่เจียว', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090045', 'ไข่เจียวหมูสับ', 'ไข่เจียวหมูสับ', 'ไข่เจียวหมูสับ', '09', '1', '09', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090046', 'ข้าวผัดกุ้งก้ามกราม', 'ข้าวผัดกุ้งก้ามกราม', 'ข้าวผัดกุ้ง', '09', '1', '09 12', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '100031', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '10', '3', '10', '1', 0, '', 0, '-1', 1),
('001', '001', 'K01', '100032', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '10', '3', '10', '1', 0, '', 0, '-1', 1),
('001', '001', 'K01', '100033', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100034', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100035', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100036', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100037', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100038', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100039', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100040', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100041', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', '10', '3', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100042', 'ไอศกรีมช็อกโกแลตลาวา', 'ไอศกรีมช็อกโกแลตลาวา', 'ไอศกรีมทุเรียน', '10', '3', '10 12', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110001', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110002', 'เบียร์สิงห์', 'เบียร์สิงห์', 'เบียร์สิงห์', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110003', 'เบียร์ลีโอ', 'เบียร์ลีโอ', 'เบียร์ลีโอ', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110004', 'เบียร์ช้าง', 'เบียร์ช้าง', 'เบียร์ช้าง', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110007', 'พอลลาเนอร์', 'พอลลาเนอร์', 'พอลลาเนอร์', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110008', 'เบียร์โฮกาเด้น', 'เบียร์โฮกาเด้น', 'เบียร์โฮกาเด้น', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110009', 'เบียร์โฮกาเด้น โรเซ่', 'เบียร์โฮกาเด้น โรเซ่', 'เบียร์โฮกาเด้น โรเซ่', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110010', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', '11', '2', '11', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '110011', 'รีเจนซี่(กลม)', 'รีเจนซี่(กลม)', 'รีเจนซี่(กลม)', '11', '2', '11', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '110012', 'แบล็คเลเบิ้ล (1litre)', 'แบล็คเลเบิ้ล (1litre)', 'แบล็คเลเบิ้ล (1litre)', '11', '2', '11', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '110013', 'เรดเลเบิ้ล (1litre)', 'เรดเลเบิ้ล (1litre)', 'เรดเลเบิ้ล (1litre)', '11', '2', '11', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '110014', 'BLEND 285', 'BLEND 285', 'BLEND 285', '11', '2', '11', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '120024', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '12', '1', '12', '6', 0, '', 0, '0', 1),
('001', '001', 'K01', '120025', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '12', '1', '12', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '120026', 'หมึกน้ำดำ', 'หมึกน้ำดำ', 'หมึกน้ำดำ', '12', '1', '12', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '120027', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '12', '1', '12', '6', 0, '', 0, '0', 0);

-- --------------------------------------------------------

--
-- Table structure for table `productsize`
--

DROP TABLE IF EXISTS `productsize`;
CREATE TABLE `productsize` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `ItemId` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `SizeId` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `SizeLocalName` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Size Name',
  `SizeEnglishName` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Size Name',
  `SizeOtherName` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Size Name',
  `DefaultSize` tinyint(1) DEFAULT NULL,
  `Price` decimal(10,4) DEFAULT NULL COMMENT 'Price Size ',
  `Free` tinyint(1) DEFAULT NULL COMMENT 'รายการฟรี',
  `noService` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด service',
  `noVat` tinyint(1) DEFAULT NULL COMMENT 'ไม่คิด Vat',
  `ReduceQty` tinyint(1) DEFAULT NULL COMMENT 'ปรับปรุงจำนวน QtyOnHane',
  `QtyOnHand` int(6) DEFAULT NULL COMMENT 'จำนวนสินค้าที่มีอยู่',
  `StockOut` tinyint(1) DEFAULT NULL COMMENT 'True = Stock Out '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `productsize`
--

INSERT INTO `productsize` (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `SizeId`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `DefaultSize`, `Price`, `Free`, `noService`, `noVat`, `ReduceQty`, `QtyOnHand`, `StockOut`) VALUES
('001', '001', 'K01', '010021', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010022', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010023', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010024', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010025', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010026', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010027', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010028', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010029', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 1),
('001', '001', 'K01', '010030', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010031', '1', 'แก้ว', 'แก้ว', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010031', '2', 'เหยือก', 'เหยือก', '', 0, '69.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010032', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010033', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010034', '1', 'เล็ก', 'เล็ก', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010034', '2', 'ใหญ่', 'ใหญ่', '', 0, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010034', '3', 'แก้ว', 'แก้ว', '', 0, '2.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010035', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010036', '1', '', '', '', 1, '59.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010037', '1', '', '', '', 1, '59.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020021', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020022', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020023', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020024', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020025', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020026', '1', '', '', '', 1, '125.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020027', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020028', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030041', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030042', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030043', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030044', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030045', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030046', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030047', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030048', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030049', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030050', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030051', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030052', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030053', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030054', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030055', '1', '', '', '', 1, '65.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030056', '1', '', '', '', 1, '220.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030057', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030058', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030059', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030060', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030061', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030062', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040041', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 1, 0),
('001', '001', 'K01', '040042', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040043', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040044', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040045', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040046', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040047', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040048', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040049', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040050', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040051', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040052', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040053', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040054', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040055', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040056', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040057', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040058', '1', '', '', '', 1, '125.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040059', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050041', '1', '', '', '', 1, '290.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050042', '1', '', '', '', 1, '380.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050043', '1', '', '', '', 1, '340.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050044', '1', '', '', '', 1, '380.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050045', '1', 'เล็ก', 'เล็ก', '', 1, '340.0000', 0, 0, 0, 0, 0, 1),
('001', '001', 'K01', '050045', '2', 'ใหญ่', 'ใหญ่', '', 0, '0.0000', 0, 0, 0, 0, 0, 1),
('001', '001', 'K01', '060041', '1', '', '', '', 1, '135.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060042', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060043', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060044', '1', '', '', '', 1, '260.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060045', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060046', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060047', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060048', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060049', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060050', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060051', '1', '', '', '', 1, '280.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060052', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070061', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070062', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070063', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070064', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070065', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070066', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070067', '1', '', '', '', 1, '260.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070068', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070069', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070070', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070071', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070072', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070073', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070074', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070075', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070076', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070077', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070078', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080031', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080032', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080033', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080034', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080035', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080036', '1', '', '', '', 1, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080038', '1', '', '', '', 1, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080039', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080040', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080041', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080042', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080043', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080044', '1', '', '', '', 1, '260.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090031', '1', 'เล็ก', 'เล็ก', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090031', '2', 'ใหญ่', 'ใหญ่', '', 0, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090032', '1', 'เล็ก', 'เล็ก', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090032', '2', 'ใหญ่', 'ใหญ่', '', 0, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090033', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090033', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090034', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090034', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090035', '1', 'เล็ก', 'เล็ก', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090035', '2', 'ใหญ่', 'ใหญ่', '', 0, '195.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090036', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090037', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090038', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090039', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090040', '1', 'จาน', 'จาน', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090040', '2', 'โถ', 'โถ', '', 0, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090041', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090042', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090043', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090044', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090045', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090046', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100031', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, -1, 1),
('001', '001', 'K01', '100032', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, -1, 1),
('001', '001', 'K01', '100033', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100034', '1', '', '', '', 1, '65.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100035', '1', 'ถ้วย', 'ถ้วย', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100035', '2', 'ครึ่งโล', 'ครึ่งโล', '', 0, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100035', '3', 'กก.', 'กก.', '', 0, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100036', '1', '', '', '', 1, '55.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100037', '1', '.', '.', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100037', '2', 'ห่อ', 'ห่อ', '', 0, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100038', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100039', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100040', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100041', '1', 'ถ้วย', 'ถ้วย', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100041', '2', '1/2Km', '1/2Km', '', 0, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100041', '3', '1Km', '1Km', '', 0, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100042', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110001', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110002', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110003', '1', '', '', '', 1, '105.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110004', '1', '', '', '', 1, '105.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110007', '1', '', '', '', 1, '240.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110008', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110009', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110010', '1', '', '', '', 1, '400.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110011', '1', '', '', '', 1, '700.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110012', '1', '', '', '', 1, '2000.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110013', '1', '', '', '', 1, '1200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110014', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120024', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 1),
('001', '001', 'K01', '120025', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120026', '1', '', '', '', 1, '220.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120027', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `runningtext`
--

DROP TABLE IF EXISTS `runningtext`;
CREATE TABLE `runningtext` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `Eng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'อังกฤษ',
  `Tha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ไทย',
  `Chi` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'จีน',
  `Lao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ลาว',
  `Mya` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'พม่า'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `runningtext`
--

INSERT INTO `runningtext` (`CompanyId`, `BrandId`, `OutletId`, `Eng`, `Tha`, `Chi`, `Lao`, `Mya`) VALUES
('001', '001', 'K01', 'Just click share NITTAYA, get free SOMTUM', 'เพียงกดแชร์ ร้านไก่ย่างนิตยา รับสมตำฟรี 1 จาน', '只需點擊即可分享，免費獲得一道菜', 'ພຽງແຕ່ຄລິກທີ່ຈະແບ່ງປັນ, ໄດ້ຮັບອາຫານ 1 ຟຣີ', 'ရုံဝေမျှမယ်နှိပ်ပြီးအခမဲ့ 1 အစိမ်းရောင်သင်္ဘောသီးသုပ်ပန်းကန်လက်ခံရရှိသည်။');

-- --------------------------------------------------------

--
-- Table structure for table `table`
--

DROP TABLE IF EXISTS `table`;
CREATE TABLE `table` (
  `CompanyId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `BrandId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `OutletId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `SystemDate` date NOT NULL,
  `TableNo` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `StartTime` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` varchar(1) COLLATE utf8_unicode_ci DEFAULT '',
  `TableType` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'T=TakeOut',
  `Pax` tinyint(4) DEFAULT NULL COMMENT 'จำนวนคน',
  `CallWaiter` tinyint(1) DEFAULT NULL COMMENT 'เรียกพนักงาน',
  `CallWaiterTime` time DEFAULT NULL,
  `CallCheckBill` tinyint(1) DEFAULT NULL COMMENT 'เรียกเก็บเงิน',
  `CallCheckBillTime` time DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'active or inactive product',
  `active_Device` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'P=POS  S=SelfOrder'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `table`
--

INSERT INTO `table` (`CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `TableNo`, `StartTime`, `Status`, `TableType`, `Pax`, `CallWaiter`, `CallWaiterTime`, `CallCheckBill`, `CallCheckBillTime`, `is_active`, `active_Device`) VALUES
('001', '001', 'K01', '2019-10-30', '001', '12:11', 'N', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '002', '12:31', 'N', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '003', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '004', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '005', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '006', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '007', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '008', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '009', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-30', '010', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S');

--
-- Triggers `table`
--
DROP TRIGGER IF EXISTS `AddCurrentTime`;
DELIMITER $$
CREATE TRIGGER `AddCurrentTime` BEFORE UPDATE ON `table` FOR EACH ROW BEGIN

	DECLARE Api_Url VARCHAR(255) DEFAULT 'curl http://localhost:3000/selforder/tablestatus/';
	DECLARE Param VARCHAR(255);
	DECLARE tStatus VARCHAR(255);
	DECLARE currDateTime VARCHAR(255);
	DECLARE cmd CHAR(255);
	DECLARE result int(10);
	
	
	IF OLD.CallWaiter = 0 AND NEW.CallWaiter <> 0 THEN
		SET NEW.CallWaiterTime = CURRENT_TIME;
	ELSEIF OLD.CallWaiter <> 0 AND NEW.CallWaiter = 0 THEN
		SET NEW.CallWaiterTime = NULL;
	END IF;
	
	
	IF OLD.CallCheckBill = 0 AND NEW.CallCheckBill <> 0 THEN
		SET NEW.CallCheckBillTime = CURRENT_TIME;
	ELSEIF OLD.CallCheckBill <> 0 AND NEW.CallCheckBill = 0 THEN
		SET NEW.CallCheckBillTime = NULL;
	END IF;
	
	
	IF OLD.StartTime <> '' AND NEW.StartTime = '' THEN 
		SET NEW.Pax = 0 ;
		DELETE FROM ordering
		WHERE ordering.CompanyId  = old.CompanyId AND
					ordering.BrandId    = old.BrandId AND
					ordering.OutletId   = old.OutletId AND
					ordering.SystemDate = old.SystemDate  AND
					ordering.TableNo    = old.TableNo AND
					ordering.StartTime  = old.StartTime;
	END IF;


	
	IF (OLD.`Status` = "B" AND  NEW.`Status` = "") AND
		 (OLD.`StartTime` <> "" AND NEW.`StartTime` = "") THEN
	
		
		INSERT INTO `orderheader`( CompanyId,BrandId,OutletId,SystemDate,TableNo,StartTime,TableType,Pax)
		SELECT CompanyId,BrandId,OutletId,SystemDate,TableNo,StartTime,TableType,Pax FROM `table`
		WHERE `table`.CompanyId  = old.CompanyId AND
					`table`.BrandId    = old.BrandId AND
					`table`.OutletId   = old.OutletId AND
					`table`.SystemDate = old.SystemDate  AND
					`table`.TableNo    = old.TableNo AND
					`table`.StartTime  = old.StartTime;
		
		
		INSERT INTO orderhistory 
		SELECT * FROM orderingdetail
		WHERE orderingdetail.CompanyId  = old.CompanyId AND
					orderingdetail.BrandId    = old.BrandId AND
					orderingdetail.OutletId   = old.OutletId AND
					orderingdetail.SystemDate = old.SystemDate  AND
					orderingdetail.TableNo    = old.TableNo AND
					orderingdetail.StartTime  = old.StartTime;
					
					
		
		DELETE FROM orderingdetail
			WHERE orderingdetail.CompanyId  = old.CompanyId AND
						orderingdetail.BrandId    = old.BrandId AND
						orderingdetail.OutletId   = old.OutletId AND
						orderingdetail.SystemDate = old.SystemDate  AND
						orderingdetail.TableNo    = old.TableNo AND
						orderingdetail.StartTime  = old.StartTime;


		
		DELETE FROM ordering
			WHERE ordering.CompanyId  = old.CompanyId AND
						ordering.BrandId    = old.BrandId AND
						ordering.OutletId   = old.OutletId AND
						ordering.SystemDate = old.SystemDate  AND
						ordering.TableNo    = old.TableNo AND
						ordering.StartTime  = old.StartTime;

	END IF;
	
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `test_modifylistcategoryproduct`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `test_modifylistcategoryproduct`;
CREATE TABLE `test_modifylistcategoryproduct` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`CategoryId` varchar(2)
,`CategoryName` varchar(200)
,`ItemId` varchar(8)
,`ItemName` varchar(200)
,`ModiSetId` varchar(2)
,`ModiItemId` varchar(8)
,`ModiItemCode` varchar(11)
,`ModiItemName` char(0)
,`modiLocalName` varchar(250)
,`modiEnglishName` varchar(250)
,`modiOtherName` varchar(250)
,`Price` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `test_productmodicategory`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `test_productmodicategory`;
CREATE TABLE `test_productmodicategory` (
`LocalName` varchar(200)
,`EnglishName` varchar(200)
,`OtherName` varchar(200)
,`ModiSetId` varchar(2)
,`modisetLocalname` varchar(150)
,`modisetEnglishname` varchar(150)
,`modisetOthername` varchar(150)
,`modiLocalName` varchar(150)
,`modiEnglishName` varchar(150)
,`modiOtherName` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `test_productmodiitem`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `test_productmodiitem`;
CREATE TABLE `test_productmodiitem` (
`ItemId` varchar(8)
,`LocalName` varchar(200)
,`EnglishName` varchar(200)
,`OtherName` varchar(200)
,`ModiSetId` varchar(2)
,`modisetLocalname` varchar(150)
,`modisetEnglishname` varchar(150)
,`modisetOthername` varchar(150)
,`modiLocalName` varchar(150)
,`modiEnglishName` varchar(150)
,`modiOtherName` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_category`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_category`;
CREATE TABLE `view_category` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`CategoryId` varchar(2)
,`CategoryName` char(0)
,`LocalName` varchar(100)
,`EnglishName` varchar(100)
,`OtherName` varchar(100)
,`SeqNo` int(3)
,`is_active` int(4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_modifyitem`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_modifyitem`;
CREATE TABLE `view_modifyitem` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`CategoryId` varchar(2)
,`ItemId` varchar(8)
,`ModiSetId` varchar(2)
,`ModiItemId` varchar(8)
,`ModiItemCode` varchar(11)
,`ModiItemName` char(0)
,`modiLocalName` varchar(100)
,`modiEnglishName` varchar(100)
,`modiOtherName` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_modifylistall`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_modifylistall`;
CREATE TABLE `view_modifylistall` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`CategoryId` varchar(2)
,`ItemId` varchar(8)
,`ModiSetId` varchar(2)
,`ModiItemId` varchar(8)
,`ModiItemCode` varchar(11)
,`ModiItemName` char(0)
,`modiLocalName` varchar(250)
,`modiEnglishName` varchar(250)
,`modiOtherName` varchar(250)
,`Price` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_modifyprefix`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_modifyprefix`;
CREATE TABLE `view_modifyprefix` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`CategoryId` varchar(2)
,`ItemId` varchar(8)
,`ModiSetId` varchar(2)
,`ModiItemId` varchar(8)
,`ModiItemCode` varchar(11)
,`EnglishName` varchar(150)
,`LocalName` varchar(150)
,`OtherName` varchar(150)
,`Price` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_orderdetail`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_orderdetail`;
CREATE TABLE `view_orderdetail` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`SystemDate` date
,`TableNo` varchar(4)
,`StartTime` varchar(8)
,`ItemNo` int(3) unsigned
,`ItemId` varchar(8)
,`ReferenceId` decimal(11,8)
,`ItemName` text
,`LocalName` text
,`EnglishName` text
,`OtherName` text
,`SizeId` varchar(2)
,`SizeName` text
,`SizeLocalName` text
,`SizeEnglishName` text
,`SizeOtherName` text
,`OrgSize` varchar(2)
,`DepartmentId` varchar(1)
,`CategoryId` varchar(2)
,`AddModiCode` text
,`TotalAmount` decimal(14,4)
,`Quantity` decimal(8,4)
,`OrgQty` decimal(8,4)
,`UnitPrice` decimal(14,4)
,`Free` tinyint(1)
,`noService` tinyint(1)
,`noVat` tinyint(1)
,`Status` varchar(1)
,`PrintTo` varchar(20)
,`NeedPrint` tinyint(1)
,`LocalPrint` tinyint(1)
,`KitchenLang` varchar(6)
,`Parent` tinyint(1)
,`Child` tinyint(1)
,`OrderDate` date
,`OrderTime` time
,`KitchenNote` text
,`MainItem` tinyint(1)
,`image` varchar(100)
,`TotalAmountSummery` decimal(14,4)
,`Level` int(2) unsigned
,`SubLevel` int(3) unsigned
,`isPackage` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_ordering`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_ordering`;
CREATE TABLE `view_ordering` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`TableNo` varchar(4)
,`ItemNo` int(3) unsigned
,`Level` int(2) unsigned
,`SubLevel` int(3) unsigned
,`ItemId` varchar(8)
,`ItemName` text
,`LocalName` text
,`EnglishName` text
,`OtherName` text
,`SizeName` text
,`SizeLocalName` text
,`SizeEnglishName` text
,`SizeOtherName` text
,`SizeId` varchar(2)
,`OrgSize` varchar(2)
,`DepartmentId` varchar(1)
,`CategoryId` varchar(2)
,`AddModiCode` text
,`TotalAmount` decimal(14,4)
,`Quantity` decimal(8,4)
,`OrgQty` decimal(8,4)
,`UnitPrice` decimal(14,4)
,`Free` tinyint(1)
,`noService` tinyint(1)
,`noVat` tinyint(1)
,`Status` varchar(1)
,`PrintTo` varchar(20)
,`NeedPrint` tinyint(1)
,`LocalPrint` tinyint(1)
,`KitchenLang` varchar(6)
,`Parent` tinyint(1)
,`Child` tinyint(1)
,`OrderDate` date
,`OrderTime` time
,`KitchenNote` text
,`SystemDate` date
,`StartTime` varchar(8)
,`ReferenceId` decimal(11,8)
,`MainItem` tinyint(1)
,`image` varchar(100)
,`TotalAmountSummery` decimal(14,4)
,`CurrentStockout` int(4)
,`isPackage` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_outletsetting`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_outletsetting`;
CREATE TABLE `view_outletsetting` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`MaxQty` int(1)
,`QtyFormat` varchar(36)
,`Locallanguage` char(3)
,`PosTimeOut` int(5)
,`PosTimeStamp` datetime
,`ServerTimeStamp` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_productdata`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_productdata`;
CREATE TABLE `view_productdata` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`ItemId` varchar(8)
,`ItemName` char(0)
,`LocalName` varchar(100)
,`EnglishName` varchar(100)
,`OtherName` varchar(100)
,`CategoryId` varchar(2)
,`DepartmentId` varchar(1)
,`ShowOnCategory` varchar(15)
,`PrintTo` varchar(20)
,`LocalPrint` tinyint(1)
,`KitchenLang` varchar(6)
,`ReduceQty` tinyint(1)
,`QtyOnHand` int(6)
,`StockOut` tinyint(1)
,`image` varchar(100)
,`Price` decimal(12,8)
,`SeqNo` int(3)
,`is_active` int(4)
,`isPackage` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_productrecommend`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_productrecommend`;
CREATE TABLE `view_productrecommend` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`ItemId` varchar(8)
,`ItemName` char(0)
,`LocalName` varchar(100)
,`EnglishName` varchar(100)
,`OtherName` varchar(100)
,`CategoryId` varchar(2)
,`DepartmentId` varchar(1)
,`ShowOnCategory` varchar(15)
,`PrintTo` varchar(20)
,`LocalPrint` tinyint(1)
,`KitchenLang` varchar(6)
,`ReduceQty` tinyint(1)
,`QtyOnHand` int(6)
,`StockOut` tinyint(1)
,`image` varchar(100)
,`Price` decimal(12,8)
,`SeqNo` int(3)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_productsizeall`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_productsizeall`;
CREATE TABLE `view_productsizeall` (
`SizeId` varchar(2)
,`SizeLocalName` varchar(100)
,`SizeEnglishName` varchar(100)
,`SizeOtherName` varchar(100)
,`DefaultSize` tinyint(1)
,`Price` decimal(10,4)
,`Free` tinyint(1)
,`noService` tinyint(1)
,`noVat` tinyint(1)
,`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`ItemId` varchar(8)
,`ReduceQty` tinyint(1)
,`QtyOnHand` int(6)
,`StockOut` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_table`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_table`;
CREATE TABLE `view_table` (
`CompanyId` varchar(4)
,`BrandId` varchar(4)
,`OutletId` varchar(4)
,`SystemDate` date
,`TableNo` varchar(10)
,`StartTime` varchar(8)
,`Status` varchar(1)
,`CanOrder` varchar(1)
,`DineIn` varchar(1)
,`TakeHome` varchar(1)
,`RoomService` varchar(1)
,`Pax` int(4)
,`is_active` int(4)
);

-- --------------------------------------------------------

--
-- Structure for view `check_duplicate`
--
DROP TABLE IF EXISTS `check_duplicate`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `check_duplicate`  AS  select `product`.`CompanyId` AS `CompanyId`,`product`.`BrandId` AS `BrandId`,`product`.`OutletId` AS `OutletId`,`product`.`ItemId` AS `ItemId`,`product`.`LocalName` AS `LocalName`,`product`.`EnglishName` AS `EnglishName`,count(`product`.`ItemId`) AS `duplicate` from `product` group by `product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`ItemId` ;

-- --------------------------------------------------------

--
-- Structure for view `test_modifylistcategoryproduct`
--
DROP TABLE IF EXISTS `test_modifylistcategoryproduct`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `test_modifylistcategoryproduct`  AS  select `modilist`.`CompanyId` AS `CompanyId`,`modilist`.`BrandId` AS `BrandId`,`modilist`.`OutletId` AS `OutletId`,`modilist`.`CategoryId` AS `CategoryId`,`fgetCategoryAndProductName`(`modilist`.`CompanyId`,`modilist`.`BrandId`,`modilist`.`OutletId`,`modilist`.`CategoryId`,'') AS `CategoryName`,`modilist`.`ItemId` AS `ItemId`,`fgetCategoryAndProductName`(`modilist`.`CompanyId`,`modilist`.`BrandId`,`modilist`.`OutletId`,'',`modilist`.`ItemId`) AS `ItemName`,`modilist`.`ModiSetId` AS `ModiSetId`,`modilist`.`ModiItemId` AS `ModiItemId`,concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS `ModiItemCode`,'' AS `ModiItemName`,concat(`modiset`.`LocalName`,`fCheckEmpty`(`modiitem`.`LocalName`,'N/A')) AS `modiLocalName`,concat(`modiset`.`EnglishName`,`fCheckEmpty`(`modiitem`.`EnglishName`,'N/A')) AS `modiEnglishName`,concat(`modiset`.`OtherName`,`fCheckEmpty`(`modiitem`.`OtherName`,`modiitem`.`LocalName`)) AS `modiOtherName`,`modilist`.`Price` AS `Price` from ((`modilist` join `modiitem` on(((`modilist`.`CompanyId` = `modiitem`.`CompanyId`) and (`modilist`.`BrandId` = `modiitem`.`BrandId`) and (`modilist`.`OutletId` = `modiitem`.`OutletId`) and (`modilist`.`ModiItemId` = `modiitem`.`ModiItemId`)))) left join `modiset` on(((`modilist`.`CompanyId` = `modiset`.`CompanyId`) and (`modilist`.`BrandId` = `modiset`.`BrandId`) and (`modilist`.`OutletId` = `modiset`.`OutletId`) and (`modilist`.`ModiSetId` = `modiset`.`ModiSetId`)))) order by `modilist`.`CompanyId`,`modilist`.`BrandId`,`modilist`.`OutletId`,`modilist`.`CategoryId`,`modilist`.`ItemId`,`modilist`.`ModiSetId` ;

-- --------------------------------------------------------

--
-- Structure for view `test_productmodicategory`
--
DROP TABLE IF EXISTS `test_productmodicategory`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `test_productmodicategory`  AS  select `product`.`LocalName` AS `LocalName`,`product`.`EnglishName` AS `EnglishName`,`product`.`OtherName` AS `OtherName`,`modiset`.`ModiSetId` AS `ModiSetId`,`modiset`.`LocalName` AS `modisetLocalname`,`modiset`.`EnglishName` AS `modisetEnglishname`,`modiset`.`OtherName` AS `modisetOthername`,`modiitem`.`LocalName` AS `modiLocalName`,`modiitem`.`EnglishName` AS `modiEnglishName`,`modiitem`.`OtherName` AS `modiOtherName` from (((`product` join `modilist` on(((`product`.`CompanyId` = `modilist`.`CompanyId`) and (`product`.`BrandId` = `modilist`.`BrandId`) and (`product`.`OutletId` = `modilist`.`OutletId`) and (`product`.`CategoryId` = `modilist`.`CategoryId`)))) join `modiitem` on(((`modilist`.`CompanyId` = `modiitem`.`CompanyId`) and (`modilist`.`BrandId` = `modiitem`.`BrandId`) and (`modilist`.`OutletId` = `modiitem`.`OutletId`) and (`modilist`.`ModiItemId` = `modiitem`.`ModiItemId`)))) join `modiset` on(((`modilist`.`CompanyId` = `modiset`.`CompanyId`) and (`modilist`.`BrandId` = `modiset`.`BrandId`) and (`modilist`.`OutletId` = `modiset`.`OutletId`) and (`modilist`.`ModiSetId` = `modiset`.`ModiSetId`)))) ;

-- --------------------------------------------------------

--
-- Structure for view `test_productmodiitem`
--
DROP TABLE IF EXISTS `test_productmodiitem`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `test_productmodiitem`  AS  select `product`.`ItemId` AS `ItemId`,`product`.`LocalName` AS `LocalName`,`product`.`EnglishName` AS `EnglishName`,`product`.`OtherName` AS `OtherName`,`modiset`.`ModiSetId` AS `ModiSetId`,`modiset`.`LocalName` AS `modisetLocalname`,`modiset`.`EnglishName` AS `modisetEnglishname`,`modiset`.`OtherName` AS `modisetOthername`,`modiitem`.`LocalName` AS `modiLocalName`,`modiitem`.`EnglishName` AS `modiEnglishName`,`modiitem`.`OtherName` AS `modiOtherName` from (((`product` join `modilist` on(((`product`.`CompanyId` = `modilist`.`CompanyId`) and (`product`.`BrandId` = `modilist`.`BrandId`) and (`product`.`OutletId` = `modilist`.`OutletId`) and (`product`.`ItemId` = `modilist`.`ItemId`)))) join `modiitem` on(((`modilist`.`CompanyId` = `modiitem`.`CompanyId`) and (`modilist`.`BrandId` = `modiitem`.`BrandId`) and (`modilist`.`OutletId` = `modiitem`.`OutletId`) and (`modilist`.`ModiItemId` = `modiitem`.`ModiItemId`)))) join `modiset` on(((`modilist`.`CompanyId` = `modiset`.`CompanyId`) and (`modilist`.`BrandId` = `modiset`.`BrandId`) and (`modilist`.`OutletId` = `modiset`.`OutletId`) and (`modilist`.`ModiSetId` = `modiset`.`ModiSetId`)))) ;

-- --------------------------------------------------------

--
-- Structure for view `view_category`
--
DROP TABLE IF EXISTS `view_category`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_category`  AS  select `category`.`CompanyId` AS `CompanyId`,`category`.`BrandId` AS `BrandId`,`category`.`OutletId` AS `OutletId`,`category`.`CategoryId` AS `CategoryId`,'' AS `CategoryName`,`fCheckEmpty`(`category`.`LocalName`,'N/A') AS `LocalName`,`fCheckEmpty`(`category`.`EnglishName`,'N/A') AS `EnglishName`,`fCheckEmpty`(`category`.`OtherName`,'N/A') AS `OtherName`,`category`.`SeqNo` AS `SeqNo`,if(isnull(`category`.`is_active`),0,`category`.`is_active`) AS `is_active` from `category` where (`category`.`is_active` = 1) order by `category`.`CompanyId`,`category`.`BrandId`,`category`.`OutletId`,`category`.`SeqNo` ;

-- --------------------------------------------------------

--
-- Structure for view `view_modifyitem`
--
DROP TABLE IF EXISTS `view_modifyitem`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_modifyitem`  AS  select `modilist`.`CompanyId` AS `CompanyId`,`modilist`.`BrandId` AS `BrandId`,`modilist`.`OutletId` AS `OutletId`,`modilist`.`CategoryId` AS `CategoryId`,`modilist`.`ItemId` AS `ItemId`,`modilist`.`ModiSetId` AS `ModiSetId`,`modilist`.`ModiItemId` AS `ModiItemId`,concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS `ModiItemCode`,'' AS `ModiItemName`,`fCheckEmpty`(`modiitem`.`LocalName`,'N/A') AS `modiLocalName`,`fCheckEmpty`(`modiitem`.`EnglishName`,'N/A') AS `modiEnglishName`,`fCheckEmpty`(`modiitem`.`OtherName`,`modiitem`.`LocalName`) AS `modiOtherName` from (`modilist` join `modiitem` on(((`modilist`.`CompanyId` = `modiitem`.`CompanyId`) and (`modilist`.`BrandId` = `modiitem`.`BrandId`) and (`modilist`.`OutletId` = `modiitem`.`OutletId`) and (`modilist`.`ModiItemId` = `modiitem`.`ModiItemId`)))) group by `modilist`.`CompanyId`,`modilist`.`BrandId`,`modilist`.`OutletId`,`modilist`.`CategoryId`,`modilist`.`ItemId`,`modilist`.`ModiItemId` order by `modilist`.`CategoryId`,`modilist`.`ItemId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_modifylistall`
--
DROP TABLE IF EXISTS `view_modifylistall`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_modifylistall`  AS  select `modilist`.`CompanyId` AS `CompanyId`,`modilist`.`BrandId` AS `BrandId`,`modilist`.`OutletId` AS `OutletId`,`modilist`.`CategoryId` AS `CategoryId`,`modilist`.`ItemId` AS `ItemId`,`modilist`.`ModiSetId` AS `ModiSetId`,`modilist`.`ModiItemId` AS `ModiItemId`,concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS `ModiItemCode`,'' AS `ModiItemName`,concat(`modiset`.`LocalName`,`fCheckEmpty`(`modiitem`.`LocalName`,'N/A')) AS `modiLocalName`,concat(`modiset`.`EnglishName`,`fCheckEmpty`(`modiitem`.`EnglishName`,'N/A')) AS `modiEnglishName`,concat(`modiset`.`OtherName`,`fCheckEmpty`(`modiitem`.`OtherName`,`modiitem`.`LocalName`)) AS `modiOtherName`,`modilist`.`Price` AS `Price` from ((`modilist` join `modiitem` on(((`modilist`.`CompanyId` = `modiitem`.`CompanyId`) and (`modilist`.`BrandId` = `modiitem`.`BrandId`) and (`modilist`.`OutletId` = `modiitem`.`OutletId`) and (`modilist`.`ModiItemId` = `modiitem`.`ModiItemId`)))) left join `modiset` on(((`modilist`.`CompanyId` = `modiset`.`CompanyId`) and (`modilist`.`BrandId` = `modiset`.`BrandId`) and (`modilist`.`OutletId` = `modiset`.`OutletId`) and (`modilist`.`ModiSetId` = `modiset`.`ModiSetId`)))) where (`modiitem`.`is_active` = 1) order by `modiset`.`CompanyId`,`modiset`.`BrandId`,`modiset`.`OutletId`,`modilist`.`CategoryId`,`modilist`.`ItemId`,`modiset`.`ModiSetId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_modifyprefix`
--
DROP TABLE IF EXISTS `view_modifyprefix`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_modifyprefix`  AS  select `modilist`.`CompanyId` AS `CompanyId`,`modilist`.`BrandId` AS `BrandId`,`modilist`.`OutletId` AS `OutletId`,`modilist`.`CategoryId` AS `CategoryId`,`modilist`.`ItemId` AS `ItemId`,`modilist`.`ModiSetId` AS `ModiSetId`,`modilist`.`ModiItemId` AS `ModiItemId`,concat('M',`modilist`.`ModiSetId`,`modilist`.`ModiItemId`) AS `ModiItemCode`,`modiset`.`EnglishName` AS `EnglishName`,`modiset`.`LocalName` AS `LocalName`,`modiset`.`OtherName` AS `OtherName`,`modilist`.`Price` AS `Price` from (`modilist` left join `modiset` on(((`modilist`.`CompanyId` = `modiset`.`CompanyId`) and (`modilist`.`BrandId` = `modiset`.`BrandId`) and (`modilist`.`OutletId` = `modiset`.`OutletId`) and (`modilist`.`ModiSetId` = `modiset`.`ModiSetId`)))) order by `modilist`.`CategoryId`,`modilist`.`ItemId`,`modilist`.`ModiItemId`,`modilist`.`ModiSetId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_orderdetail`
--
DROP TABLE IF EXISTS `view_orderdetail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_orderdetail`  AS  select `orderingdetail`.`CompanyId` AS `CompanyId`,`orderingdetail`.`BrandId` AS `BrandId`,`orderingdetail`.`OutletId` AS `OutletId`,`orderingdetail`.`SystemDate` AS `SystemDate`,`orderingdetail`.`TableNo` AS `TableNo`,`orderingdetail`.`StartTime` AS `StartTime`,`orderingdetail`.`ItemNo` AS `ItemNo`,`orderingdetail`.`ItemId` AS `ItemId`,`orderingdetail`.`ReferenceId` AS `ReferenceId`,`orderingdetail`.`ItemName` AS `ItemName`,`orderingdetail`.`LocalName` AS `LocalName`,`orderingdetail`.`EnglishName` AS `EnglishName`,`orderingdetail`.`OtherName` AS `OtherName`,`orderingdetail`.`SizeId` AS `SizeId`,`orderingdetail`.`SizeName` AS `SizeName`,`orderingdetail`.`SizeLocalName` AS `SizeLocalName`,`orderingdetail`.`SizeEnglishName` AS `SizeEnglishName`,`orderingdetail`.`SizeOtherName` AS `SizeOtherName`,`orderingdetail`.`OrgSize` AS `OrgSize`,`orderingdetail`.`DepartmentId` AS `DepartmentId`,`orderingdetail`.`CategoryId` AS `CategoryId`,`orderingdetail`.`AddModiCode` AS `AddModiCode`,`orderingdetail`.`TotalAmount` AS `TotalAmount`,`orderingdetail`.`Quantity` AS `Quantity`,`orderingdetail`.`OrgQty` AS `OrgQty`,`orderingdetail`.`UnitPrice` AS `UnitPrice`,`orderingdetail`.`Free` AS `Free`,`orderingdetail`.`noService` AS `noService`,`orderingdetail`.`noVat` AS `noVat`,`orderingdetail`.`Status` AS `Status`,`orderingdetail`.`PrintTo` AS `PrintTo`,`orderingdetail`.`NeedPrint` AS `NeedPrint`,`orderingdetail`.`LocalPrint` AS `LocalPrint`,`orderingdetail`.`KitchenLang` AS `KitchenLang`,`orderingdetail`.`Parent` AS `Parent`,`orderingdetail`.`Child` AS `Child`,`orderingdetail`.`OrderDate` AS `OrderDate`,`orderingdetail`.`OrderTime` AS `OrderTime`,`orderingdetail`.`KitchenNote` AS `KitchenNote`,`orderingdetail`.`MainItem` AS `MainItem`,`fGetImageURL`(`orderingdetail`.`CompanyId`,`orderingdetail`.`BrandId`,`orderingdetail`.`OutletId`,`orderingdetail`.`ItemId`) AS `image`,`fOrderingDetailItemTotalAmount`(`orderingdetail`.`CompanyId`,`orderingdetail`.`BrandId`,`orderingdetail`.`OutletId`,`orderingdetail`.`SystemDate`,`orderingdetail`.`TableNo`,`orderingdetail`.`StartTime`,`orderingdetail`.`ItemNo`) AS `TotalAmountSummery`,`orderingdetail`.`Level` AS `Level`,`orderingdetail`.`SubLevel` AS `SubLevel`,`orderingdetail`.`isPackage` AS `isPackage` from `orderingdetail` ;

-- --------------------------------------------------------

--
-- Structure for view `view_ordering`
--
DROP TABLE IF EXISTS `view_ordering`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ordering`  AS  select `ordering`.`CompanyId` AS `CompanyId`,`ordering`.`BrandId` AS `BrandId`,`ordering`.`OutletId` AS `OutletId`,`ordering`.`TableNo` AS `TableNo`,`ordering`.`ItemNo` AS `ItemNo`,`ordering`.`Level` AS `Level`,`ordering`.`SubLevel` AS `SubLevel`,`ordering`.`ItemId` AS `ItemId`,`ordering`.`ItemName` AS `ItemName`,`ordering`.`LocalName` AS `LocalName`,`ordering`.`EnglishName` AS `EnglishName`,`ordering`.`OtherName` AS `OtherName`,`ordering`.`SizeName` AS `SizeName`,`ordering`.`SizeLocalName` AS `SizeLocalName`,`ordering`.`SizeEnglishName` AS `SizeEnglishName`,`ordering`.`SizeOtherName` AS `SizeOtherName`,`ordering`.`SizeId` AS `SizeId`,`ordering`.`OrgSize` AS `OrgSize`,`ordering`.`DepartmentId` AS `DepartmentId`,`ordering`.`CategoryId` AS `CategoryId`,`ordering`.`AddModiCode` AS `AddModiCode`,`ordering`.`TotalAmount` AS `TotalAmount`,`ordering`.`Quantity` AS `Quantity`,`ordering`.`OrgQty` AS `OrgQty`,`ordering`.`UnitPrice` AS `UnitPrice`,`ordering`.`Free` AS `Free`,`ordering`.`noService` AS `noService`,`ordering`.`noVat` AS `noVat`,`ordering`.`Status` AS `Status`,`ordering`.`PrintTo` AS `PrintTo`,`ordering`.`NeedPrint` AS `NeedPrint`,`ordering`.`LocalPrint` AS `LocalPrint`,`ordering`.`KitchenLang` AS `KitchenLang`,`ordering`.`Parent` AS `Parent`,`ordering`.`Child` AS `Child`,`ordering`.`OrderDate` AS `OrderDate`,`ordering`.`OrderTime` AS `OrderTime`,`ordering`.`KitchenNote` AS `KitchenNote`,`ordering`.`SystemDate` AS `SystemDate`,`ordering`.`StartTime` AS `StartTime`,`ordering`.`ReferenceId` AS `ReferenceId`,`ordering`.`MainItem` AS `MainItem`,`fGetImageURL`(`ordering`.`CompanyId`,`ordering`.`BrandId`,`ordering`.`OutletId`,`ordering`.`ItemId`) AS `image`,`fOrderingItemTotalAmount`(`ordering`.`CompanyId`,`ordering`.`BrandId`,`ordering`.`OutletId`,`ordering`.`SystemDate`,`ordering`.`TableNo`,`ordering`.`StartTime`,`ordering`.`ItemNo`) AS `TotalAmountSummery`,(select `pd`.`StockOut` from `product` `pd` where ((`pd`.`CompanyId` = `ordering`.`CompanyId`) and (`pd`.`BrandId` = `ordering`.`BrandId`) and (`pd`.`OutletId` = `ordering`.`OutletId`) and (`pd`.`ItemId` = `ordering`.`ItemId`))) AS `CurrentStockout`,`ordering`.`isPackage` AS `isPackage` from `ordering` ;

-- --------------------------------------------------------

--
-- Structure for view `view_outletsetting`
--
DROP TABLE IF EXISTS `view_outletsetting`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_outletsetting`  AS  select `outletsetting`.`CompanyId` AS `CompanyId`,`outletsetting`.`BrandId` AS `BrandId`,`outletsetting`.`OutletId` AS `OutletId`,`outletsetting`.`MaxQty` AS `MaxQty`,substr('999999999',1,`outletsetting`.`MaxQty`) AS `QtyFormat`,`outletsetting`.`Locallanguage` AS `Locallanguage`,`outletsetting`.`PosTimeOut` AS `PosTimeOut`,`outletsetting`.`PosTimeStamp` AS `PosTimeStamp`,`outletsetting`.`ServerTimeStamp` AS `ServerTimeStamp` from `outletsetting` ;

-- --------------------------------------------------------

--
-- Structure for view `view_productdata`
--
DROP TABLE IF EXISTS `view_productdata`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_productdata`  AS  select `product`.`CompanyId` AS `CompanyId`,`product`.`BrandId` AS `BrandId`,`product`.`OutletId` AS `OutletId`,`product`.`ItemId` AS `ItemId`,'' AS `ItemName`,`fCheckEmpty`(`product`.`LocalName`,'N/A') AS `LocalName`,`fCheckEmpty`(`product`.`EnglishName`,'N/A') AS `EnglishName`,`fCheckEmpty`(`product`.`OtherName`,'N/A') AS `OtherName`,`product`.`CategoryId` AS `CategoryId`,`product`.`DepartmentId` AS `DepartmentId`,`product`.`ShowOnCategory` AS `ShowOnCategory`,`product`.`PrintTo` AS `PrintTo`,`product`.`LocalPrint` AS `LocalPrint`,`product`.`KitchenLang` AS `KitchenLang`,`product`.`ReduceQty` AS `ReduceQty`,`product`.`QtyOnHand` AS `QtyOnHand`,`product`.`StockOut` AS `StockOut`,`fGetImageURL`(`product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`ItemId`) AS `image`,(select `getProductDefaultPrice`(`product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`ItemId`)) AS `Price`,`product`.`SeqNo` AS `SeqNo`,if(isnull(`product`.`is_active`),0,`product`.`is_active`) AS `is_active`,`product`.`isPackage` AS `isPackage` from (`product` left join `productimage` on(((`product`.`CompanyId` = `productimage`.`CompanyId`) and (`product`.`BrandId` = `productimage`.`BrandId`) and (`product`.`OutletId` = `productimage`.`OutletId`) and (`product`.`ItemId` = `productimage`.`ItemId`)))) where (`product`.`is_active` = 1) order by `product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`CategoryId`,`product`.`SeqNo`,`product`.`ItemId` ;

-- --------------------------------------------------------

--
-- Structure for view `view_productrecommend`
--
DROP TABLE IF EXISTS `view_productrecommend`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_productrecommend`  AS  select `product`.`CompanyId` AS `CompanyId`,`product`.`BrandId` AS `BrandId`,`product`.`OutletId` AS `OutletId`,`product`.`ItemId` AS `ItemId`,'' AS `ItemName`,`fCheckEmpty`(`product`.`LocalName`,'N/A') AS `LocalName`,`fCheckEmpty`(`product`.`EnglishName`,'N/A') AS `EnglishName`,`fCheckEmpty`(`product`.`OtherName`,'N/A') AS `OtherName`,`product`.`CategoryId` AS `CategoryId`,`product`.`DepartmentId` AS `DepartmentId`,`product`.`ShowOnCategory` AS `ShowOnCategory`,`product`.`PrintTo` AS `PrintTo`,`product`.`LocalPrint` AS `LocalPrint`,`product`.`KitchenLang` AS `KitchenLang`,`product`.`ReduceQty` AS `ReduceQty`,`product`.`QtyOnHand` AS `QtyOnHand`,`product`.`StockOut` AS `StockOut`,`fGetImageURL`(`product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`ItemId`) AS `image`,(select `getProductDefaultPrice`(`product`.`CompanyId`,`product`.`BrandId`,`product`.`OutletId`,`product`.`ItemId`)) AS `Price`,`productrecommend`.`SeqNo` AS `SeqNo` from (`productrecommend` left join `product` on(((`productrecommend`.`CompanyId` = `product`.`CompanyId`) and (`productrecommend`.`BrandId` = `product`.`BrandId`) and (`productrecommend`.`OutletId` = `product`.`OutletId`) and (`productrecommend`.`ItemId` = `product`.`ItemId`)))) where ((`product`.`ItemId` is not null) and (`product`.`is_active` = 1)) order by `productrecommend`.`CompanyId`,`productrecommend`.`BrandId`,`productrecommend`.`OutletId`,`productrecommend`.`SeqNo` ;

-- --------------------------------------------------------

--
-- Structure for view `view_productsizeall`
--
DROP TABLE IF EXISTS `view_productsizeall`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_productsizeall`  AS  select `productsize`.`SizeId` AS `SizeId`,`fCheckEmpty`(`productsize`.`SizeLocalName`,'N/A') AS `SizeLocalName`,`fCheckEmpty`(`productsize`.`SizeEnglishName`,'N/A') AS `SizeEnglishName`,`fCheckEmpty`(`productsize`.`SizeOtherName`,'N/A') AS `SizeOtherName`,`productsize`.`DefaultSize` AS `DefaultSize`,`productsize`.`Price` AS `Price`,`productsize`.`Free` AS `Free`,`productsize`.`noService` AS `noService`,`productsize`.`noVat` AS `noVat`,`productsize`.`CompanyId` AS `CompanyId`,`productsize`.`BrandId` AS `BrandId`,`productsize`.`OutletId` AS `OutletId`,`productsize`.`ItemId` AS `ItemId`,`productsize`.`ReduceQty` AS `ReduceQty`,`productsize`.`QtyOnHand` AS `QtyOnHand`,`productsize`.`StockOut` AS `StockOut` from `productsize` ;

-- --------------------------------------------------------

--
-- Structure for view `view_table`
--
DROP TABLE IF EXISTS `view_table`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_table`  AS  select `table`.`CompanyId` AS `CompanyId`,`table`.`BrandId` AS `BrandId`,`table`.`OutletId` AS `OutletId`,`table`.`SystemDate` AS `SystemDate`,`table`.`TableNo` AS `TableNo`,if(isnull(`table`.`StartTime`),'00:00:00',`table`.`StartTime`) AS `StartTime`,`table`.`Status` AS `Status`,if(((`table`.`StartTime` <> '') and (`table`.`Status` = 'N')),'1','0') AS `CanOrder`,if((isnull(`table`.`TableType`) or (`table`.`TableType` = '')),'1','0') AS `DineIn`,if((`table`.`TableType` = 'T'),'1','0') AS `TakeHome`,if((`table`.`TableType` = 'R'),'1','0') AS `RoomService`,if(isnull(`table`.`Pax`),0,`table`.`Pax`) AS `Pax`,if(isnull(`table`.`is_active`),0,`table`.`is_active`) AS `is_active` from `table` where (`table`.`is_active` = 1) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `banner`
--
ALTER TABLE `banner`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`) USING BTREE;

--
-- Indexes for table `brand`
--
ALTER TABLE `brand`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`) USING BTREE;

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`CategoryId`) USING BTREE,
  ADD KEY `testIndex` (`OutletId`,`CategoryId`) USING BTREE;

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`CompanyId`) USING BTREE;

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`DepartmentId`) USING BTREE;

--
-- Indexes for table `language`
--
ALTER TABLE `language`
  ADD PRIMARY KEY (`id`,`Module`,`Section`,`Caption`) USING BTREE;

--
-- Indexes for table `languagemaster`
--
ALTER TABLE `languagemaster`
  ADD KEY `Code` (`Code`) USING BTREE;

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`CurrentDate`) USING BTREE;

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`Id`,`Tel`,`Email`) USING BTREE;

--
-- Indexes for table `modiitem`
--
ALTER TABLE `modiitem`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ModiItemId`) USING BTREE;

--
-- Indexes for table `modilist`
--
ALTER TABLE `modilist`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`CategoryId`,`ItemId`,`ModiItemId`,`ModiSetId`) USING BTREE;

--
-- Indexes for table `modiset`
--
ALTER TABLE `modiset`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ModiSetId`) USING BTREE;

--
-- Indexes for table `orderheader`
--
ALTER TABLE `orderheader`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`SystemDate`,`TableNo`,`StartTime`) USING BTREE;

--
-- Indexes for table `orderhistory`
--
ALTER TABLE `orderhistory`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`SystemDate`,`TableNo`,`StartTime`,`ItemNo`,`Level`,`SubLevel`,`ItemId`,`ReferenceId`) USING BTREE;

--
-- Indexes for table `ordering`
--
ALTER TABLE `ordering`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`SystemDate`,`TableNo`,`StartTime`,`ItemNo`,`Level`,`SubLevel`,`ItemId`,`ReferenceId`) USING BTREE;

--
-- Indexes for table `orderingdetail`
--
ALTER TABLE `orderingdetail`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`SystemDate`,`TableNo`,`StartTime`,`ItemNo`,`Level`,`SubLevel`,`ItemId`,`ReferenceId`) USING BTREE;

--
-- Indexes for table `outlet`
--
ALTER TABLE `outlet`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`) USING BTREE;

--
-- Indexes for table `outletsetting`
--
ALTER TABLE `outletsetting`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`) USING BTREE,
  ADD KEY `SetLanguage` (`Locallanguage`) USING BTREE;

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ItemId`) USING BTREE;

--
-- Indexes for table `productcontrol`
--
ALTER TABLE `productcontrol`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`CategoryControlId`,`ItemId`) USING BTREE;

--
-- Indexes for table `productimage`
--
ALTER TABLE `productimage`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ItemId`) USING BTREE;

--
-- Indexes for table `productpackage`
--
ALTER TABLE `productpackage`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ItemId`,`Level`) USING BTREE;

--
-- Indexes for table `productrecommend`
--
ALTER TABLE `productrecommend`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ShowOnCategory`,`ItemId`) USING BTREE;

--
-- Indexes for table `productsetting`
--
ALTER TABLE `productsetting`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ItemId`) USING BTREE;

--
-- Indexes for table `productsize`
--
ALTER TABLE `productsize`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`ItemId`,`SizeId`) USING BTREE;

--
-- Indexes for table `runningtext`
--
ALTER TABLE `runningtext`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`) USING BTREE;

--
-- Indexes for table `table`
--
ALTER TABLE `table`
  ADD PRIMARY KEY (`CompanyId`,`BrandId`,`OutletId`,`SystemDate`,`TableNo`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'key', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `language`
--
ALTER TABLE `language`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `outletsetting`
--
ALTER TABLE `outletsetting`
  ADD CONSTRAINT `SetLanguage` FOREIGN KEY (`Locallanguage`) REFERENCES `languagemaster` (`Code`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
