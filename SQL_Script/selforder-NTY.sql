-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 24, 2019 at 10:13 AM
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
('001', '001', 'K01', 'banner1_.jpg', 'banner2_.jpg', 'banner3_.jpg', NULL, NULL, '', '', '', '', '', 'Welcome to NITTAYA.', 'ยินดีต้อนรับ นิตยาไก่ย่าง', '歡迎', 'ຍິນດີຕ້ອນຮັບ', 'ကွိုဆို ');

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
('001', '001', 'K01', '01', 'เชลล์ชวนชิม', 'เชลล์ชวนชิม', 'เชลล์ชวนชิม', '1', 0, 1, 0),
('001', '001', 'K01', '02', 'แนะนำ', 'แนะนำ', 'แนะนำ', '1', 0, 1, 0),
('001', '001', 'K01', '03', 'เพื่อสุขภาพ', 'เพื่อสุขภาพ', 'เพื่อสุขภาพ', '1', 0, 1, 0),
('001', '001', 'K01', '04', 'ทอด อบ', 'ทอด อบ', 'ทอด อบ', '1', 0, 1, 0),
('001', '001', 'K01', '05', 'ส้มตำ', 'ส้มตำ', 'ส้มตำ', '1', 0, 1, 0),
('001', '001', 'K01', '06', 'ปลา', 'ปลา', 'ปลา', '1', 6, 1, 0),
('001', '001', 'K01', '07', 'ต้มยำ ทำแกง', 'ต้มยำ ทำแกง', 'ต้มยำ ทำแกง', '1', 0, 1, 0),
('001', '001', 'K01', '08', 'ผัดเผ็ด ผัดผัก', 'ผัดเผ็ด ผัดผัก', 'ผัดเผ็ด ผัดผัก', '1', 0, 1, 0),
('001', '001', 'K01', '09', 'ขนมหวาน ไอศกรีม', 'ขนมหวาน ไอศกรีม', 'ขนมหวาน ไอศกรีม', '3', 0, 1, 0),
('001', '001', 'K01', '10', 'เครื่องดื่ม', 'เครื่องดื่ม', 'เครื่องดื่ม', '2', 0, 1, 0),
('001', '001', 'K01', '11', 'เบียร์', 'เบียร์', 'เบียร์', '2', 0, 1, 0),
('001', '001', 'K01', '12', 'เหล้า', 'เหล้า', 'เหล้า', '2', 0, 1, 0),
('001', '001', 'K01', '13', 'ขนมและเครื่องดื่มหน้าตู้', 'ขนมและเครื่องดื่มหน้าตู้', '', '', 14, 1, 0),
('001', '001', 'K01', '14', 'ของฝาก', 'ของฝาก', '', '', 16, 1, 0),
('001', '001', 'K01', '15', 'เหล้า', 'เหล้า', '', '', 15, 1, 0),
('001', '001', 'K01', '16', 'อาหารเจ', 'อาหารเจ', 'อาหารเจ', '', 10, 1, 0),
('001', '001', 'K01', '19', 'โปรโมรชั่น', 'โปรโมรชั่น', '', '', 17, 1, 0),
('001', '001', 'K01', '20', 'อื่นๆ', 'อื่นๆ', '', '', 18, 1, 0),
('001', '001', 'K01', '21', 'น้ำสมุนไพร', 'น้ำสมุนไพร', '', '', 12, 1, 0),
('001', '001', 'K01', '22', 'ข้าวผัด ข้าวเหนียว ขนมจีน', 'ข้าวผัด ข้าวเหนียว ขนมจีน', '', '', 1, 1, 0),
('001', '001', 'K01', '23', 'จัดเลี้ยง', 'จัดเลี้ยง', '', '', 19, 1, 0),
('001', '001', 'K01', '24', 'บัตรของขวัญ', 'บัตรของขวัญ', '', '', 20, 1, 0),
('001', '001', 'K01', '25', 'บุหรี่', 'บุหรี่', '', '', 21, 1, 0),
('001', '001', 'K01', '32', 'โปรโมชั่นไก่่', 'โปรโมชั่นไก่่', '', '', 26, 1, 0),
('001', '001', 'K01', '34', 'สมนาคุณ', 'สมนาคุณ', '', '', 27, 1, 0),
('001', '001', 'K01', '35', 'จานยำ', 'จานยำ', 'จานยำ', '', 1, 1, 0);

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

--
-- Dumping data for table `log`
--

INSERT INTO `log` (`CurrentDate`, `CompanyId`, `BrandId`, `OutletId`, `SystemDate`, `ErrorNo`, `ErrorMessage`, `TableNo`, `ItemId`, `ItemName`, `localName`, `EnglishName`, `OtherName`, `TotalAmount`, `Quantity`, `UnitPrice`) VALUES
('0000-00-00 00:00:00', '001', '001', '001', '2019-03-27', NULL, NULL, 'H05', '010002', 'สุกี้ยากี้ไก่', 'สุกี้ยากี้ไก่', NULL, NULL, '99.0000', '1.0000', '99.0000'),
('2019-05-17 11:28:30', '001', '2514', '356', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('2019-05-17 11:32:09', NULL, 'sss', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('2019-05-17 11:32:44', NULL, NULL, NULL, NULL, '001', 'file not found', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('2019-05-30 17:07:59', '001', '001', '001', '2019-02-25', '32', 'test david', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
('001', '001', 'K01', '', '010001', '1', 'A001', '10.00'),
('001', '001', 'K01', '', '010001', '2', 'A001', '10.00'),
('001', '001', 'K01', '', '010001', '3', 'A001', '-10.00'),
('001', '001', 'K01', '', '010001', '4', 'A001', '-10.00'),
('001', '001', 'K01', '', '020002', '3', 'A001', '10.00'),
('001', '001', 'K01', '', '020002', '1', 'A009', '10.00'),
('001', '001', 'K01', '', '020002', '2', 'A009', '10.00'),
('001', '001', 'K01', '', '020002', '4', 'A009', '10.00'),
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
-- Table structure for table `mytableevents`
--

DROP TABLE IF EXISTS `mytableevents`;
CREATE TABLE `mytableevents` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `randome_string` varchar(255) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

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
		
		DECLARE pTotalAmount decimal(14,4) DEFAULT 0;
		
		IF NEW.Free = 1 THEN
			SET NEW.TotalAmount = 0;	
		ELSE
			SELECT SUM( NEW.Quantity * NEW.UnitPrice ) INTO  pTotalAmount;
			SET NEW.TotalAmount = pTotalAmount;
		END IF;

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `NewOrderTransection`;
DELIMITER $$
CREATE TRIGGER `NewOrderTransection` BEFORE INSERT ON `ordering` FOR EACH ROW BEGIN
	
  DECLARE VITEM decimal(12,8);
	
	DECLARE pTotalAmount decimal(14,4) DEFAULT 0;
	
  SET VITEM = getItemReferenceId();
  SET NEW.ReferenceId = VITEM;
	
	
	
	IF NEW.Free = 1 THEN
		SET NEW.TotalAmount = 0;	
	ELSE
		SELECT SUM( NEW.Quantity * NEW.UnitPrice ) INTO  pTotalAmount;
		SET NEW.TotalAmount = pTotalAmount;
	END IF;
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
('001', '001', 'K01', '2019-10-22', '004', '15:30', 501, 0, 0, '060001', '24.17231617', 'ลาบเป็ด', 'ลาบเป็ด', 'ลาบเป็ด', 'ลาบเป็ด', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '06', '', '100.0000', '1.0000', '0.0000', '100.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '09:54:45', '', 1, '', 0),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 502, 0, 0, '060002', '996.51336191', 'ลาบปลาดุก', 'ลาบปลาดุก', 'ลาบปลาดุก', 'ลาบปลาดุก', '1', 'N/A', 'N/A', 'N/A', 'N/A', '', '1', '06', '', '100.0000', '1.0000', '0.0000', '100.0000', 0, 0, 0, '*', '2', 1, 0, '', 0, 0, '2019-10-24', '09:54:47', '', 1, '', 0),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 503, 0, 0, '190001', '680.28139651', 'โปรเปิดร้านสุดคุ้ม', 'โปรเปิดร้านสุดคุ้ม', 'โปรเปิดร้านสุดคุ้ม', 'N/A', '0', '', '', '', '', '', '1', '19', '', '199.0000', '1.0000', '0.0000', '199.0000', 0, 0, 0, '*', '5', 1, 0, '', 1, 0, '2019-10-24', '09:55:04', '', 1, '', 1),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 503, 1, 1, '010001', '217.44104218', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '1', '', '', '', '', '', '1', '01', '', '0.0000', '0.0000', '0.0000', '100.0000', 0, 0, 0, '*', '6', 1, 0, '', 0, 1, '2019-10-24', '09:55:04', '', 1, '', 0),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 503, 2, 1, '030003', '452.62010967', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '1', '', '', '', '', '', '1', '03', '', '0.0000', '0.0000', '0.0000', '350.0000', 0, 0, 0, '*', '6', 1, 0, '', 0, 1, '2019-10-24', '09:55:04', '', 1, '', 0),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 503, 3, 1, '040002', '377.22622649', 'ข้าวโพดทอด', 'ข้าวโพดทอด', 'ข้าวโพดทอด', 'ข้าวโพดทอด', '1', '', '', '', '', '', '1', '04', '', '80.0000', '1.0000', '0.0000', '80.0000', 0, 0, 0, '*', '6', 1, 0, '', 0, 1, '2019-10-24', '09:55:04', '', 1, '', 0),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 503, 3, 2, '040003', '110.06252692', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', '1', '', '', '', '', '', '1', '04', '', '90.0000', '1.0000', '0.0000', '90.0000', 0, 0, 0, '*', '6', 1, 0, '', 0, 1, '2019-10-24', '09:55:04', '', 1, '', 0),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 503, 4, 1, '140094', '760.78175951', 'น้ำพริก (กระปุก)', 'น้ำพริก (กระปุก)', 'น้ำพริก (กระปุก)', 'N/A', '1', '', '', '', '', '', '4', '14', '', '45.0000', '1.0000', '0.0000', '45.0000', 0, 0, 0, '*', '', 1, 0, '', 0, 1, '2019-10-24', '09:55:04', '', 1, '', 0);

--
-- Triggers `orderingdetail`
--
DROP TRIGGER IF EXISTS `TrigerInsertOrderDetail`;
DELIMITER $$
CREATE TRIGGER `TrigerInsertOrderDetail` BEFORE DELETE ON `orderingdetail` FOR EACH ROW BEGIN











				
END
$$
DELIMITER ;

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
('001', '001', 'K01', 9, 'Tha', 60, '2019-09-10 12:39:07', '2019-09-10 12:39:07', '2019-10-22 17:57:51', '0000-00-00 00:00:00', '001 Database', '001 API', '001 Back', '001 Font', '001 Serial Key');

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
('001', '001', 'K01', '010001', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '01', '1', '01', '6', 0, '', 0, 1, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010002', '(เจ)ตำผลไม้รวม', '(เจ)ตำผลไม้รวม', '', '01', '1', '01', '4', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '010003', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010004', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010005', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010006', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '01', '1', '01', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010007', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010008', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010009', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010010', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010012', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', '', '01', '1', '01', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010013', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '01', '1', '01', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010014', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '010015', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '010016', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', '', '01', '1', '01', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '020002', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020003', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020004', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020005', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', '02', '1', '02 04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020006', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020007', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020008', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020009', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020010', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020011', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020012', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020013', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '02', '1', '02', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020014', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '02', '1', '02', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020015', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', '02', '1', '02', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '020020', 'แคบหมู', 'แคบหมู', 'แคบหมู', '02', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030002', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030003', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030004', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030005', 'ปลาทับทิมทอดน้ำปลา', 'ปลาทับทิมทอดน้ำปลา', 'ปลาทับทิมทอดน้ำปลา', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030006', 'ปลาทับทิมราดน้ำปลาพริกขี้หนูหอ', 'ปลาทับทิมราดน้ำปลาพริกขี้หนูหอ', 'ปลาทับทิมราดน้ำปลาพริกขี้หนูหอ', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030007', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030008', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030009', 'ตำลาว', 'ตำลาว', 'ตำลาว', '03', '1', '03', '4', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030010', 'ตำโคราช', 'ตำโคราช', 'ตำโคราช', '03', '1', '03', '4', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030011', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030012', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030015', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030018', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', '03', '1', '03', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030020', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030021', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030022', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030023', 'เนื้อปลากะพงผัดพริกไทยดำ', 'เนื้อปลากะพงผัดพริกไทยดำ', 'เนื้อปลากะพงผัดพริกไทยดำ', '03', '1', '03', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030024', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', '03', '1', '03', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030025', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', '03', '1', '03', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '030026', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', '', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '030027', 'หอยแมลงภู่NZอบหม้อดิน', 'หอยแมลงภู่NZอบหม้อดิน', '', '03', '1', '03', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '030028', 'กะพงผัดฉ่า(ตัว)', 'กะพงผัดฉ่า(ตัว)', '', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '030030', 'ตำมั่ว', 'ตำมั่ว', '', '05', '1', '05', '4', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '030031', 'ปลากะพงริมสวน', 'ปลากะพงริมสวน', '', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '030032', 'ทับทิมนึ่งมะนาว', 'ทับทิมนึ่งมะนาว', 'ทับทิมนึ่งมะนาว', '03', '1', '03', '6', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '030033', 'ปลาทับทิมริมสวน', 'ปลาทับทิมริมสวน', '', '03', '1', '03', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '040001', 'รวมมิตรตะกร้า', 'รวมมิตรตะกร้า', 'รวมมิตรตะกร้า', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040002', 'ข้าวโพดทอด', 'ข้าวโพดทอด', 'ข้าวโพดทอด', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040003', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040004', 'หมึกตะกร้า', 'หมึกตะกร้า', 'หมึกตะกร้า', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040005', 'กุ้งตะกร้า', 'กุ้งตะกร้า', 'กุ้งตะกร้า', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040006', 'เห็ดตะกร้า', 'เห็ดตะกร้า', 'เห็ดตะกร้า', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040007', 'ไข่ฟูปูหอม', 'ไข่ฟูปูหอม', 'ไข่ฟูปูหอม', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040008', 'ไข่เจียวไข่มดแดง', 'ไข่เจียวไข่มดแดง', 'ไข่เจียวไข่มดแดง', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040009', 'ไข่มดแดงคั่วไข่', 'ไข่มดแดงคั่วไข่', 'ไข่มดแดงคั่วไข่', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040010', 'ไข่อบหม้อดิน', 'ไข่อบหม้อดิน', 'ไข่อบหม้อดิน', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040011', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040012', 'ปากเป็ดทอด', 'ปากเป็ดทอด', 'ปากเป็ดทอด', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040014', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040015', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040016', 'ลาบขนมจีน', 'ลาบขนมจีน', '', '04', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '040017', 'ลาบหมูทอด', 'ลาบหมูทอด', 'ลาบหมูทอด', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040018', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040019', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '04', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040020', 'หมูข้าวเม่า', 'หมูข้าวเม่า', 'หมูข้าวเม่า', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040021', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040022', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040023', 'หอยจ๊อ เบบี้', 'หอยจ๊อ เบบี้', 'หอยจ๊อ เบบี้', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040024', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040025', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '040026', 'ไก่ตะกร้า(ปีก)', 'ไก่ตะกร้า(ปีก)', '', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '040027', 'ไข่ดาว', 'ไข่ดาว', '', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '040028', 'ไข่เจียว', 'ไข่เจียว', '', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '040029', 'ไข่เจียวหมูสับ', 'ไข่เจียวหมูสับ', '', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '040030', 'ไข่เจียวกุ้งสับ', 'ไข่เจียวกุ้งสับ', '', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '040031', 'ไข่เจียวปู', 'ไข่เจียวปู', '', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '040034', 'คอหมูย่าง', 'คอหมูย่าง', '', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '040035', 'ทอดมันปลากราย', 'ทอดมันปลากราย', '', '04', '1', '04', '6', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '040036', 'น้ำพริกหนุ่ม (ถ้วย)', 'น้ำพริกหนุ่ม (ถ้วย)', '', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '040037', 'น้ำพริกหนุ่ม ผักลวก แคบ', 'น้ำพริกหนุ่ม ผักลวก แคบ', 'น้ำพริกหนุ่ม ผักลวก แคบ', '04', '1', '04', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '050001', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '05', '1', '05', '2', 0, '', 0, 1, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050002', 'ตำไทย', 'ตำไทย', 'ตำไทย', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050003', 'ตำปู', 'ตำปู', 'ตำปู', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050004', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050005', 'ตำลาว', 'ตำลาว', '', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050006', 'ตำตะกร้า', 'ตำตะกร้า', 'ตำตะกร้า', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050007', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050008', 'ตำมั่วลาว', 'ตำมั่วลาว', 'ตำมั่วลาว', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050009', 'ตำซั่วไทย', 'ตำซั่วไทย', 'ตำซั่วไทย', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050010', 'ตำซั่วลาว', 'ตำซั่วลาว', 'ตำซั่วลาว', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050011', 'ตำมะม่วง', 'ตำมะม่วง', 'ตำมะม่วง', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050012', 'ตำข้าวโพด', 'ตำข้าวโพด', 'ตำข้าวโพด', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050014', 'ตำปูปลาร้า', 'ตำปูปลาร้า', 'ตำปูปลาร้า', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050015', 'ตำไข่เค็ม', 'ตำไข่เค็ม', 'ตำไข่เค็ม', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050016', 'ตำปูม้า', 'ตำปูม้า', 'ตำปูม้า', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050017', 'ส้มตำหมูคั่วน้ำปลา', 'ส้มตำหมูคั่วน้ำปลา', 'ส้มตำหมูคั่วน้ำปลา', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050018', 'ตำแครอท', 'ตำแครอท', 'ตำแครอท', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050019', 'ตำหอยดอง', 'ตำหอยดอง', 'ตำหอยดอง', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050020', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '050021', 'ตำโคราช', 'ตำโคราช', '', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '050022', 'ตำป่า', 'ตำป่า', '', '05', '1', '05', '4', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '050023', 'ตำผลไม้', 'ตำผลไม้', '', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '050024', 'ตำถั่วฝักยาวปู', 'ตำถั่วฝักยาวปู', '', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '050025', 'ตำถั่วฝักยาวปู-ปลาร้า', 'ตำถั่วฝักยาวปู-ปลาร้า', '', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '050026', 'ยำปูม้า', 'ยำปูม้า', '', '05', '1', '05', '4', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '050028', 'ตำแตง', 'ตำแตง', 'ตำแตง', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '050029', 'ส้มตำคอหมูย่าง', 'ส้มตำคอหมูย่าง', 'ส้มตำคอหมูย่าง', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '050030', 'ส้มตำปลาดุกฟู', 'ส้มตำปลาดุกฟู', '', '05', '1', '05', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '060001', 'ลาบเป็ด', 'ลาบเป็ด', 'ลาบเป็ด', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060002', 'ลาบปลาดุก', 'ลาบปลาดุก', 'ลาบปลาดุก', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060003', 'ลาบหมู', 'ลาบหมู', 'ลาบหมู', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060004', 'ลาบไก่', 'ลาบไก่', 'ลาบไก่', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060005', 'ลาบหมูทอด', 'ลาบหมูทอด', 'ลาบหมูทอด', '06', '1', '06', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060006', 'ลาบปลาหมึก', 'ลาบปลาหมึก', 'ลาบปลาหมึก', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060007', 'ลาบเห็ดสามอย่าง', 'ลาบเห็ดสามอย่าง', 'ลาบเห็ดสามอย่าง', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060008', 'หมูน้ำตก', 'หมูน้ำตก', 'หมูน้ำตก', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060010', 'ซุปหน่อไม้', 'ซุปหน่อไม้', 'ซุปหน่อไม้', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060011', 'ตับหวาน', 'ตับหวาน', 'ตับหวาน', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060012', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060013', 'ยำปลาดุกฟู', 'ยำปลาดุกฟู', 'ยำปลาดุกฟู', '06', '1', '06', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060014', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060015', 'ยำรวมมิตร', 'ยำรวมมิตร', 'ยำรวมมิตร', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060016', 'ยำตะไคร้กุ้งกรอบ', 'ยำตะไคร้กุ้งกรอบ', 'ยำตะไคร้กุ้งกรอบ', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060018', 'ยำหมูย่างยอดมะพร้าว', 'ยำหมูย่างยอดมะพร้าว', 'ยำหมูย่างยอดมะพร้าว', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060019', 'ยำผักหวานกรอบ', 'ยำผักหวานกรอบ', 'ยำผักหวานกรอบ', '06', '1', '06', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060020', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', '06', '1', '06', '6', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '060021', 'ลาบวุ้นเส้น', 'ลาบวุ้นเส้น', '', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '060022', 'หมึกมะนาว', 'หมึกมะนาว', '', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '060023', 'ลาบกุ้ง', 'ลาบกุ้ง', '', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '060024', 'ลาบเห็ดโคน', 'ลาบเห็ดโคน', '', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '060025', 'ลาบเห็ดฟาง', 'ลาบเห็ดฟาง', '', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '060026', 'ยำเห็ดสามอย่าง', 'ยำเห็ดสามอย่าง', 'ยำเห็ดสามอย่าง', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '060027', 'หมูมะนาว', 'หมูมะนาว', '', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '060028', 'ยำไข่มดแดง', 'ยำไข่มดแดง', '', '06', '1', '06', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '070001', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070002', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070003', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070004', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070005', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070006', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070007', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070008', 'ต้มเปรี้ยวไก่บ้านคั่ว', 'ต้มเปรี้ยวไก่บ้านคั่ว', 'ต้มเปรี้ยวไก่บ้านคั่ว', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070009', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070010', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070011', 'แกงป่าเนื้อเคี่ยว', 'แกงป่าเนื้อเคี่ยว', 'แกงป่าเนื้อเคี่ยว', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '070012', 'แกงส้มกุ้งใหญ่', 'แกงส้มกุ้งใหญ่', 'แกงส้มกุ้งใหญ่', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070013', 'แกงส้มกุ้งเล็ก', 'แกงส้มกุ้งเล็ก', 'แกงส้มกุ้งเล็ก', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070014', 'แกงส้มผักรวม', 'แกงส้มผักรวม', 'แกงส้มผักรวม', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070015', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070016', 'แกงปู', 'แกงปู', 'แกงปู', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070018', 'แกงป่าหมู', 'แกงป่าหมู', 'แกงป่าหมู', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '070019', 'แกงป่าโครงอ่อน', 'แกงป่าโครงอ่อน', 'แกงป่าโครงอ่อน', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '070020', 'แกงป่าลูกชิ้นปลากราย', 'แกงป่าลูกชิ้นปลากราย', 'แกงป่าลูกชิ้นปลากราย', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '070021', 'แกงลาวเห็ดเผาะ', 'แกงลาวเห็ดเผาะ', 'แกงลาวเห็ดเผาะ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070022', 'แกงลาวเห็ดเผาะไข่มดแดง', 'แกงลาวเห็ดเผาะไข่มดแดง', 'แกงลาวเห็ดเผาะไข่มดแดง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070023', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070024', 'ต้มยำโป๊ะแตกน้ำ', 'ต้มยำโป๊ะแตกน้ำ', 'ต้มยำโป๊ะแตกน้ำ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070025', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070026', 'แกงเขียวหวานหมู', 'แกงเขียวหวานหมู', 'แกงเขียวหวานหมู', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070027', 'แกงเขียวหวานไก่', 'แกงเขียวหวานไก่', 'แกงเขียวหวานไก่', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070028', 'แกงเขียวหวานเนื้อ', 'แกงเขียวหวานเนื้อ', 'แกงเขียวหวานเนื้อ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070029', 'แกงเขียวหวานลูกชิ้นปลากราย', 'แกงเขียวหวานลูกชิ้นปลากราย', 'แกงเขียวหวานลูกชิ้นปลากราย', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070030', 'แกงอ่อมหมู', 'แกงอ่อมหมู', 'แกงอ่อมหมู', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070031', 'แกงอ่อมไก่', 'แกงอ่อมไก่', 'แกงอ่อมไก่', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070032', 'แกงอ่อมเนื้อ', 'แกงอ่อมเนื้อ', 'แกงอ่อมเนื้อ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070033', 'โรตี แกงเขียวหวานไก่', 'โรตี แกงเขียวหวานไก่', 'โรตี แกงเขียวหวานไก่', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '070034', 'โรตี แกงเขียวหวานเนื้อ', 'โรตี แกงเขียวหวานเนื้อ', 'โรตี แกงเขียวหวานเนื้อ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '070035', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070036', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070037', 'ต้มยำรวมมิตร', 'ต้มยำรวมมิตร', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '070038', 'แกงเนื้อพริกขี้หนูหอม', 'แกงเนื้อพริกขี้หนูหอม', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '070039', 'แกงคั่วหอยขม', 'แกงคั่วหอยขม', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '070040', 'แกงเขียวหวานไก่+ขนมจีน', 'แกงเขียวหวานไก่+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '070041', 'โรตีแกงเขียวหวานหมู', 'โรตีแกงเขียวหวานหมู', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '070042', 'โรตีแกงเขียวหวานปลากราย', 'โรตีแกงเขียวหวานปลากราย', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '070043', 'โรตีแกงเขียวหวานกุ้ง', 'โรตีแกงเขียวหวานกุ้ง', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '070044', 'แกงเขียวหวานเนื้อ+ขนมจีน', 'แกงเขียวหวานเนื้อ+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '070045', 'แกงเขียวหวานหมู+ขนมจีน', 'แกงเขียวหวานหมู+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '070046', 'เขียวหวานปลากราย+ขนมจีน', 'เขียวหวานปลากราย+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '070047', 'แกงเขียวหวานกุ้ง+ขนมจีน', 'แกงเขียวหวานกุ้ง+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '070048', 'แกงป่าไก่', 'แกงป่าไก่', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '070049', 'แกงป่าปลากระพง', 'แกงป่าปลากระพง', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '070050', 'แกงลาวผักหวานไข่มดแดง', 'แกงลาวผักหวานไข่มดแดง', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '070052', 'แกงจืดเต้าหู้หมูสับ', 'แกงจืดเต้าหู้หมูสับ', 'แกงจืดเต้าหู้หมูสับ', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '070053', 'แกงลาวเห็ดสามอย่าง', 'แกงลาวเห็ดสามอย่าง', 'แกงลาวเห็ดสามอย่าง', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '070054', 'ต้มแซ่บหมูเด้ง', 'ต้มแซ่บหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '070055', 'ต้มเปรี้ยวหมูเด้ง', 'ต้มเปรี้ยวหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '070056', 'แกงป่าหมูเด้ง', 'แกงป่าหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '070057', 'แกงเขียวหวานหมูเด้ง', 'แกงเขียวหวานหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '080001', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '080002', 'ผัดฉ่าเห็ด 3 อย่าง', 'ผัดฉ่าเห็ด 3 อย่าง', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '080003', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '080004', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '080005', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '080006', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '080007', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '080008', 'ผัดผักยอดดอย', 'ผัดผักยอดดอย', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '080009', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '080010', 'ขนมจีนผัด', 'ขนมจีนผัด', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '080011', 'ผัดฉ่าลูกชิ้นปลากราย', 'ผัดฉ่าลูกชิ้นปลากราย', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '080012', 'หอยแมลงภู่ผัดฉ่า', 'หอยแมลงภู่ผัดฉ่า', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '080013', 'หอยแมลงภู่อบหม้อดิน', 'หอยแมลงภู่อบหม้อดิน', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '080014', 'ผัดฉ่าเห็ดโคนญี่ปุ่น', 'ผัดฉ่าเห็ดโคนญี่ปุ่น', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '080015', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '080016', 'ผัดคะน้าปลาสลิด', 'ผัดคะน้าปลาสลิด', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '080017', 'ผัดคะน้าปลาเค็ม', 'ผัดคะน้าปลาเค็ม', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '080018', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '080019', 'ดอกขจรไข่กรอบ', 'ดอกขจรไข่กรอบ', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '080020', 'ผัดฉ่าทะเล', 'ผัดฉ่าทะเล', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '080021', 'กระเพราเนื้อตุ๋น', 'กระเพราเนื้อตุ๋น', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '080022', 'ปลาหมึกผัดผงกะหรี่', 'ปลาหมึกผัดผงกะหรี่', 'ปลาหมึกผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '080023', 'กุ้งผัดผงกะหรี่', 'กุ้งผัดผงกะหรี่', 'กุ้งผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '080024', 'ทะเลผัดผงกะหรี่', 'ทะเลผัดผงกะหรี่', 'ทะเลผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 16, 1, 0),
('001', '001', 'K01', '080025', 'กระเพราปลาหมึก', 'กระเพราปลาหมึก', 'กระเพราปลาหมึก', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 17, 1, 0),
('001', '001', 'K01', '080026', 'กระเพรากุ้ง', 'กระเพรากุ้ง', 'กระเพรากุ้ง', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 18, 1, 0),
('001', '001', 'K01', '080027', 'กระเพราหมู', 'กระเพราหมู', 'กระเพราหมู', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 19, 1, 0),
('001', '001', 'K01', '080028', 'กะเพราไก่', 'กะเพราไก่', 'กะเพราไก่', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 20, 1, 0),
('001', '001', 'K01', '080029', 'ผัดมะเขือยาว', 'ผัดมะเขือยาว', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 21, 1, 0),
('001', '001', 'K01', '080030', 'ผัดฉ่าหมูเด้ง', 'ผัดฉ่าหมูเด้ง', '', '08', '1', '08', '2', 0, '', 0, 0, 0, '', '', '', 22, 1, 0),
('001', '001', 'K01', '090001', 'ทับทิมกรอบ', 'ทับทิมกรอบ', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090002', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090003', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090004', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090005', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090006', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090007', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090008', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090009', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090010', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '090011', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '090012', 'ไอศกรีมสตอเบอร์รี่', 'ไอศกรีมสตอเบอร์รี่', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '090013', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '090014', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '090015', 'ไอศกรีมทุเรียน+กล้วย', 'ไอศกรีมทุเรียน+กล้วย', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '090016', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '090017', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '090018', 'ไอศกรีมช็อคโกแลต+กล้วย', 'ไอศกรีมช็อคโกแลต+กล้วย', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '090019', 'เยลลี่', 'เยลลี่', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '090020', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '090024', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '090025', 'บัวลอยเผือก', 'บัวลอยเผือก', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '090026', 'พุดดิ้งมะพร้าวอ่อน', 'พุดดิ้งมะพร้าวอ่อน', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '100001', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100002', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100003', 'ชาเย็น', 'ชาเย็น', 'ชาเย็น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100005', 'ชาดำเย็น', 'ชาดำเย็น', 'ชาดำเย็น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100006', 'ชามะนาว', 'ชามะนาว', 'ชามะนาว', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100008', 'แตงโมปั่น', 'แตงโมปั่น', 'แตงโมปั่น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100010', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100011', 'กาแฟเย็นปั่น', 'กาแฟเย็นปั่น', 'กาแฟเย็นปั่น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100012', 'ชาเย็นปั่น', 'ชาเย็นปั่น', 'ชาเย็นปั่น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100013', 'น้ำแดงโซดา', 'น้ำแดงโซดา', 'น้ำแดงโซดา', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100014', 'น้ำเขียวโซดา', 'น้ำเขียวโซดา', 'น้ำเขียวโซดา', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100016', 'ชาจีนร้อน', 'ชาจีนร้อน', 'ชาจีนร้อน', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100020', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '10', '2', '10', '', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100021', 'โซดา', 'โซดา', 'โซดา', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100022', 'น้ำแข็ง', 'น้ำแข็ง', 'น้ำแข็ง', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100023', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100024', 'ผ้าเย็น', 'ผ้าเย็น', 'ผ้าเย็น', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '100025', 'เอส', 'เอส', '', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '100027', 'น้ำมะนาว', 'น้ำมะนาว', '', '10', '2', '10', '1', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '110001', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '110002', 'เบียร์สิงห์', 'เบียร์สิงห์', 'เบียร์สิงห์', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '110003', 'เบียร์ลีโอ', 'เบียร์ลีโอ', 'เบียร์ลีโอ', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '110005', 'U Beer 620ml.', 'U Beer 620ml.', '', '11', '3', '11', '1', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '110006', 'เบียร์ช้าง คลาสสิค', 'เบียร์ช้าง คลาสสิค', '', '11', '2', '11', '1', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '120002', 'แบล็คเลเบิ้ล (1litre)', 'แบล็คเลเบิ้ล (1litre)', '', '12', '2', '12', '5', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '120003', 'เรดเลเบิ้ล (1litre)', 'เรดเลเบิ้ล (1litre)', '', '12', '2', '12', '5', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '120004', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', '12', '2', '12', '5', 0, '', 0, 0, 0, '', '', '', 0, 1, 0),
('001', '001', 'K01', '120007', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', '', '12', '2', '12', '5', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '120008', 'รีเจนซี่(กลม)', 'รีเจนซี่(กลม)', '', '12', '2', '12', '5', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '120015', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '120023', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', '', '09', '3', '09', '1', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '120024', 'ไอศกรีมข้าวไรซ์ฯ 1/2 โล', 'ไอศกรีมข้าวไรซ์ฯ 1/2 โล', '', '09', '3', '12', '', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '130001', 'พุดดิ้ง', 'พุดดิ้ง', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '130002', 'เต้าหู้นมสด', 'เต้าหู้นมสด', '', '13', '3', '13', '1', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '130003', 'พายบลูเบอร์รี่', 'พายบลูเบอร์รี่', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '130004', 'วุ้นเฟื่องฟ้า (กะทิ)', 'วุ้นเฟื่องฟ้า (กะทิ)', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '130005', 'ลอดช่องชาเขียว', 'ลอดช่องชาเขียว', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '130006', 'สละลอยแก้ว(ห่อ)', 'สละลอยแก้ว(ห่อ)', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '130008', 'เต้าทึง', 'เต้าทึง', '', '13', '3', '13', '1', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '130009', 'ลูกจาก', 'ลูกจาก', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '130010', 'ขนมเค้ก', 'ขนมเค้ก', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '130013', 'ลูกตาล', 'ลูกตาล', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '130014', 'คัพเค้ก', 'คัพเค้ก', '', '13', '3', '13', '5', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '140001', 'กล้วยม้วน', 'กล้วยม้วน', 'กล้วยม้วน', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '140003', 'เมอแรงค์', 'เมอแรงค์', 'เมอแรงค์', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '140004', 'ข้าวเกรียบกุ้ง', 'ข้าวเกรียบกุ้ง', 'ข้าวเกรียบกุ้ง', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '140006', 'คาราเมลคอนแฟรก', 'คาราเมลคอนแฟรก', 'คาราเมลคอนแฟรก', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '140007', 'ข้าวตังจอมพล', 'ข้าวตังจอมพล', 'ข้าวตังจอมพล', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '140008', 'น้ำพริกกระเช้า 4 ตลับ', 'น้ำพริกกระเช้า 4 ตลับ', 'น้ำพริกกระเช้า 4 ตลับ', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '140020', 'มะขามคลุก(ใหญ่)', 'มะขามคลุก(ใหญ่)', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 20, 1, 0),
('001', '001', 'K01', '140021', 'มะขามคลุก(เล็ก)', 'มะขามคลุก(เล็ก)', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 21, 1, 0),
('001', '001', 'K01', '140023', 'ทองม้วน (กะทิสด)', 'ทองม้วน (กะทิสด)', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 23, 1, 0),
('001', '001', 'K01', '140024', 'กล้วยฉาบ', 'กล้วยฉาบ', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 24, 1, 0),
('001', '001', 'K01', '140025', 'ขนมผิง', 'ขนมผิง', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 25, 1, 0),
('001', '001', 'K01', '140026', 'น้ำผึ้งเดือนห้า', 'น้ำผึ้งเดือนห้า', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 26, 1, 0),
('001', '001', 'K01', '140028', 'กล้วยตาก', 'กล้วยตาก', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 28, 1, 0),
('001', '001', 'K01', '140032', 'น้ำพริก 3 กระปุกเล็ก', 'น้ำพริก 3 กระปุกเล้ก', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 32, 1, 0),
('001', '001', 'K01', '140033', 'น้ำพริก 6 กระปุกเล็ก', 'น้ำพริก 6 กระปุกเล็ก', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 33, 1, 0),
('001', '001', 'K01', '140035', 'น้ำพริกชุด 2 กระปุก', 'น้ำพริกชุด 2 กระปุก', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 35, 1, 0),
('001', '001', 'K01', '140036', 'น้ำพริกชุด 6 กระปุก', 'น้ำพริกชุด 6 กระปุก', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 36, 1, 0),
('001', '001', 'K01', '140037', 'น้ำพริกชุด 3 กระปุก', 'น้ำพริกชุด 3 กระปุก', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 37, 1, 0),
('001', '001', 'K01', '140039', 'มะขามไร้เมล็ด', 'มะขามไร้เมล็ด', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 39, 1, 0),
('001', '001', 'K01', '140041', 'กล้วยอบ Solar Dried Banana', 'กล้วยอบ Solar Dried Banana', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 41, 1, 0),
('001', '001', 'K01', '140042', 'กล้วยน้ำหว้าตาก', 'กล้วยน้ำหว้าตาก', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 42, 1, 0),
('001', '001', 'K01', '140044', 'กระเทียมเจียว', 'กระเทียมเจียว', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 44, 1, 0),
('001', '001', 'K01', '140045', 'หอมเจียว', 'หอมเจียว', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 45, 1, 0),
('001', '001', 'K01', '140046', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 46, 1, 0),
('001', '001', 'K01', '140047', 'บ๊วยหวาน', 'บ๊วยหวาน', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 47, 1, 0),
('001', '001', 'K01', '140048', 'พุทราจีน', 'พุทราจีน', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 48, 1, 0),
('001', '001', 'K01', '140049', 'บ๊วยน้ำผึ้ง', 'บ๊วยน้ำผึ้ง', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 49, 1, 0),
('001', '001', 'K01', '140061', 'ข้าวคั่วคุณชาย 250g', 'ข้าวคั่วคุณชาย 250g', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 61, 1, 0),
('001', '001', 'K01', '140072', 'โรตีโอ่ง', 'โรตีโอ่ง', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 72, 1, 0),
('001', '001', 'K01', '140073', 'หมี่กรอบ', 'หมี่กรอบ', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 73, 1, 0),
('001', '001', 'K01', '140074', 'ชุดถุงของขวัญ 6กป', 'ชุดถุงของขวัญ 6กป', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 74, 1, 0),
('001', '001', 'K01', '140075', 'ชุดถุงของขวัญ 3กป', 'ชุดถุงของขวัญ 3กป', '', '14', '4', '14', '5', 0, '', 0, 0, 0, '', '', '', 75, 1, 0),
('001', '001', 'K01', '140078', 'น้ำพริกเผา(กระปุก)180 กรัม', 'น้ำพริกเผา(กระปุก)180 กรัม', '', '14', '1', '14', '5', 0, '', 0, 0, 0, '', '', '', 50, 1, 0),
('001', '001', 'K01', '140079', 'กระเช้าน้ำพริกคลุกข้าว 3กป', 'กระเช้าน้ำพริกคลุกข้าว 3กป', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 78, 1, 0),
('001', '001', 'K01', '140080', 'กระเช้าน้ำพริกคลุกข้าว 5กป', 'กระเช้าน้ำพริกคลุกข้าว 5กป', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 79, 1, 0),
('001', '001', 'K01', '140081', 'ชุดของขวัญ 3 กระปุก', 'ชุดของขวัญ 3 กระปุก', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 80, 1, 0),
('001', '001', 'K01', '140082', 'ชุดของขวัญ 6 กระปุก', 'ชุดของขวัญ 6 กระปุก', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 81, 1, 0),
('001', '001', 'K01', '140083', 'กระเช้า 4 ตลับ', 'กระเช้า 4 ตลับ', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 82, 1, 0),
('001', '001', 'K01', '140084', 'กระเช้า 6 ตลับ', 'กระเช้า 6 ตลับ', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 83, 1, 0),
('001', '001', 'K01', '140093', 'น้ำพริก (ซอง)', 'น้ำพริก (ซอง)', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 92, 1, 0),
('001', '001', 'K01', '140094', 'น้ำพริก (กระปุก)', 'น้ำพริก (กระปุก)', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 93, 1, 0),
('001', '001', 'K01', '140095', 'ครองแครง', 'ครองแครง', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 94, 1, 0),
('001', '001', 'K01', '140096', 'ชีสสับปะรด', 'ชีสสับปะรด', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 94, 1, 0),
('001', '001', 'K01', '140097', 'กล้วยอบ OTOP 200g', 'กล้วยอบ OTOP 200g', '', '14', '4', '14', '', 0, '', 0, 0, 0, '', '', '', 95, 1, 0),
('001', '001', 'K01', '150001', 'Black Label (700ml)', 'Black Label (700ml)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '150002', 'Red Label (1 Litre)', 'Red Label (1 Litre)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '150003', 'Regency (700ml)', 'Regency (700ml)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '150004', 'Regency (350ml)', 'Regency (350ml)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '150005', '100 PIPERS', '100 PIPERS', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '150006', 'เบลน285', 'เบลน285', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '150007', 'แสงโสม(แบน)', 'แสงโสม(แบน)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '150008', 'แสงโสม(กลม)', 'แสงโสม(กลม)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '150009', 'Chivas (700ml)', 'Chivas (700ml)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '150017', 'Red Label (700ml)', 'Red Label (700ml)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 17, 1, 0),
('001', '001', 'K01', '150018', 'Black Label (1Litre)', 'Black Label (1Litre)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 18, 1, 0),
('001', '001', 'K01', '150019', 'Blend 285 (1 Litre)', 'Blend 285 (1 Litre)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 19, 1, 0),
('001', '001', 'K01', '150020', 'Blend 285 (700ml)', 'Blend 285 (700ml)', '', '15', '4', '15', '5', 0, '', 0, 0, 0, '', '', '', 20, 1, 0),
('001', '001', 'K01', '190001', 'โปรเปิดร้านสุดคุ้ม', 'โปรเปิดร้านสุดคุ้ม', '', '19', '1', '19', '5', 0, '', 0, 0, 0, '', '', '', 1, 1, 1),
('001', '001', 'K01', '190002', 'โปรปลากะพงเขียวหวาน', 'โปรปลากะพงเขียวหวาน', '', '19', '1', '19', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '190003', 'ถุงผ้า', 'ถุงผ้า', '', '19', '4', '19', '', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '190005', 'ปฏิทิน', 'ปฏิทิน', '', '19', '4', '19', '', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '190007', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'ไอศกรีมข้าวไรซ์เบอรรี่', '', '19', '4', '19', '', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '190008', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', '', '19', '1', '19', '4', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '190009', 'AIS ส้มตำปู (ฟรี)', 'AIS ส้มตำปู (ฟรี)', '', '19', '1', '19', '4', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '190015', 'ส้มตำไทย(ฟรี Rabbit)', 'ส้มตำไทย(ฟรี Rabbit)', '', '19', '1', '19', '4', 0, '', 0, 0, 0, '', '', '', 15, 1, 0);
INSERT INTO `product` (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `LocalName`, `EnglishName`, `OtherName`, `CategoryId`, `DepartmentId`, `ShowOnCategory`, `PrintTo`, `LocalPrint`, `KitchenLang`, `ReduceQty`, `QtyOnHand`, `StockOut`, `LocalDescription`, `EnglishDescription`, `OtherDescription`, `SeqNo`, `is_active`, `isPackage`) VALUES
('001', '001', 'K01', '200001', 'น้ำจิ้มซีฟู้ด', 'น้ำจิ้มซีฟู้ด', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '200002', 'แตงกวาสไลด์', 'แตงกวาสไลด์', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '200003', 'มะนาวสไลด์', 'มะนาวสไลด์', '', '20', '4', '20', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '200004', 'เพิ่มน้ำยำปลาดุกฟู', 'เพิ่มน้ำยำปลาดุกฟู', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '200005', 'เพิ่มน้ำราดน้ำปลา', 'เพิ่มน้ำราดน้ำปลา', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '200006', 'เพิ่มน้ำแกงส้ม', 'เพิ่มน้ำแกงส้ม', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '200007', 'เพิ่มน้ำราดปลากระชาย', 'เพิ่มน้ำราดปลากระชาย', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '200008', 'เพิ่มชุดกระชายกรอบ', 'เพิ่มชุดกระชายกรอบ', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '200009', 'เพิ่มชุดผักแกงส้ม', 'เพิ่มชุดผักแกงส้ม', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '200010', 'เพิ่มเห็ดเผาะ(ถ้วย)', 'เพิ่มเห็ดเผาะ(ถ้วย)', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '200011', 'เพิ่มไข่มดแดง(ถ้วย)', 'เพิ่มไข่มดแดง(ถ้วย)', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '200012', 'เพิ่มน้ำราดปลาริมสวน(ถ้วย)', 'เพิ่มน้ำราดปลาริมสวน(ถ้วย)', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '200013', 'เพิ่มน้ำราดปลาน้ำตก(ถ้วย)', 'เพิ่มน้ำราดปลาน้ำตก(ถ้วย)', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '200014', 'เพิ่มน้ำปลาพริกขี้หนูหอม.', 'เพิ่มน้ำปลาพริกขี้หนูหอม.', '.', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '200015', 'แจ่วพริกสด', 'แจ่วพริกสด', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '200016', 'ชุดน้ำพริกผักลวก', 'ชุดน้ำพริกผักลวก', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 16, 1, 0),
('001', '001', 'K01', '200017', 'ผักลวกแป๊ะซะ', 'ผักลวกแป๊ะซะ', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 17, 1, 0),
('001', '001', 'K01', '200018', 'น้ำพริกหนุ่ม (โล)', 'น้ำพริกหนุ่ม (โล)', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 18, 1, 0),
('001', '001', 'K01', '200019', 'น้ำพริกหนุ่ม (ถ้วย)', 'น้ำพริกหนุ่ม (ถ้วย)', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 19, 1, 0),
('001', '001', 'K01', '200020', 'น้ำพริกหนุ่ม (ขีด)', 'น้ำพริกหนุ่ม (ขีด)', '', '20', '1', '20', '2', 0, '', 0, 0, 0, '', '', '', 20, 1, 0),
('001', '001', 'K01', '200021', 'เพิ่มชะอมไข่', 'เพิ่มชะอมไข่', '', '20', '4', '20', '2', 0, '', 0, 0, 0, '', '', '', 21, 1, 0),
('001', '001', 'K01', '200023', 'ผักลวก (ปลาเผา)', 'ผักลวก (ปลาเผา)', '', '20', '4', '20', '2', 0, '', 0, 0, 0, '', '', '', 23, 1, 0),
('001', '001', 'K01', '210001', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', '', '21', '2', '21', '5', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '210002', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', '', '21', '2', '21', '5', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '210003', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', '', '21', '2', '21', '5', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '210004', 'น้ำมะตูม', 'น้ำมะตูม', '', '21', '2', '21', '5', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '210005', 'น้ำใบเตย', 'น้ำใบเตย', '', '21', '2', '21', '5', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '210006', 'น้ำตะไคร้', 'น้ำตะไคร้', '', '21', '2', '21', '5', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '210007', 'น้ำพั้นช์', 'น้ำพั้นช์', '', '21', '2', '21', '5', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '220001', 'ข้าวผัดมันกุ้งก้ามกราม', 'ข้าวผัดมันกุ้งก้ามกราม', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '220002', 'ข้าวผัดแหนม', 'ข้าวผัดแหนม', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '220003', 'ข้าวผัดแหนมปลาเค็ม', 'ข้าวผัดแหนมปลาเค็ม', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '220004', 'ข้าวผัดปลาเค็ม', 'ข้าวผัดปลาเค็ม', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '220005', 'ข้าวผัดปลาสลิด', 'ข้าวผัดปลาสลิด', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '220006', 'ข้าวผัดหน่อกะลา', 'ข้าวผัดหน่อกะลา', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '220007', 'ข้าวผัดหมู', 'ข้าวผัดหมู', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 7, 1, 0),
('001', '001', 'K01', '220008', 'ข้าวผัดไก่', 'ข้าวผัดไก่', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 8, 1, 0),
('001', '001', 'K01', '220009', 'ข้าวผัดปลาหมึก', 'ข้าวผัดปลาหมึก', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 9, 1, 0),
('001', '001', 'K01', '220010', 'ข้าวผัดกุ้ง', 'ข้าวผัดกุ้ง', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 10, 1, 0),
('001', '001', 'K01', '220011', 'ข้าวผัดปู', 'ข้าวผัดปู', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '220012', 'ข้าวราดกระเพราหมู', 'ข้าวราดกระเพราหมู', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 12, 1, 0),
('001', '001', 'K01', '220013', 'ข้าวราดกระเพราไก่', 'ข้าวราดกระเพราไก่', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 13, 1, 0),
('001', '001', 'K01', '220014', 'ข้าวราดกระเพรากุ้ง', 'ข้าวราดกระเพรากุ้ง', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 14, 1, 0),
('001', '001', 'K01', '220015', 'ข้าวราดกระเพราปลาหมึก', 'ข้าวราดกระเพราปลาหมึก', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 15, 1, 0),
('001', '001', 'K01', '220016', 'ข้าวราดกระเพราเนื้อตุ๋น', 'ข้าวราดกระเพราเนื้อตุ๋น', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 16, 1, 0),
('001', '001', 'K01', '220017', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', '', '22', '1', '22', '', 0, '', 0, 0, 0, '', '', '', 17, 1, 0),
('001', '001', 'K01', '220018', 'ข้าวเหนียวขาว', 'ข้าวเหนียวขาว', '', '22', '1', '22', '', 0, '', 0, 0, 0, '', '', '', 18, 1, 0),
('001', '001', 'K01', '220019', 'ข้าวเหนียวดำ', 'ข้าวเหนียวดำ', '', '22', '1', '22', '', 0, '', 0, 0, 0, '', '', '', 19, 1, 0),
('001', '001', 'K01', '220020', 'ขนมจีน', 'ขนมจีน', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 20, 1, 0),
('001', '001', 'K01', '220021', 'โรตี', 'โรตี', '', '22', '1', '22', '1', 0, '', 0, 0, 0, '', '', '', 21, 1, 0),
('001', '001', 'K01', '220022', 'หมี่ลวก', 'หมี่ลวก', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 22, 1, 0),
('001', '001', 'K01', '220023', 'ข้าวผัดไข่', 'ข้าวผัดไข่', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 23, 1, 0),
('001', '001', 'K01', '220024', 'ไข่ดาว', 'ไข่ดาว', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 24, 1, 0),
('001', '001', 'K01', '220025', 'ข้าวผัดรวมมิตร', 'ข้าวผัดรวมมิตร', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 25, 1, 0),
('001', '001', 'K01', '220026', 'ข้าวราดกะเพารวมมิตร', 'ข้าวราดกะเพารวมมิตร', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 26, 1, 0),
('001', '001', 'K01', '220027', 'ข้าวต้มกุ้ง', 'ข้าวต้มกุ้ง', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 27, 1, 0),
('001', '001', 'K01', '220028', 'ข้าวต้มหมู', 'ข้าวต้มหมู', '', '22', '1', '22', '2', 0, '', 0, 0, 0, '', '', '', 28, 1, 0),
('001', '001', 'K01', '230002', 'ค่าไฟ', 'ค่าไฟ', '', '23', '4', '23', '5', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '230003', 'คาราโอเกะ', 'คาราโอเกะ', '', '23', '4', '23', '5', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '230006', 'ค่าห้อง', 'ค่าห้อง', '', '23', '4', '23', '5', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '230011', 'ออกจะบอก', 'ออกจะบอก', '', '23', '4', '23', '123456', 0, '', 0, 0, 0, '', '', '', 11, 1, 0),
('001', '001', 'K01', '240005', 'GV 2000 (แถมฟรี)', 'GV 2000 (แถมฟรี)', '', '24', '4', '24', '', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '240006', 'GV ชุด A (10,000บาท)', 'GV ชุด A (10,000บาท)', '', '24', '4', '24', '', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '240007', 'GV ชุด B (5,000บาท)', 'GV ชุด B (5,000บาท)', '', '24', '4', '24', '', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '240008', 'GV 500 (แถมฟรี)', 'GV 500 (แถมฟรี)', '', '24', '4', '24', '', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '250001', 'มารโบโล่ (ขาว)', 'มารโบโล่ (ขาว)', '', '25', '4', '25', '', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '250002', 'มารโบโล่ (แดง)', 'มารโบโล่ (แดง)', '', '25', '4', '25', '', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '250003', 'มารโบโล่ (เขียว)', 'มารโบโล่ (เขียว)', '', '25', '4', '25', '', 0, '', 0, 0, 0, '', '', '', 3, 1, 0),
('001', '001', 'K01', '250004', 'กรองทิพย์', 'กรองทิพย์', '', '25', '4', '25', '', 0, '', 0, 0, 0, '', '', '', 4, 1, 0),
('001', '001', 'K01', '250005', 'สายฝน', 'สายฝน', '', '25', '4', '25', '', 0, '', 0, 0, 0, '', '', '', 5, 1, 0),
('001', '001', 'K01', '250006', 'ไฟแช็ค', 'ไฟแช็ค', '', '25', '4', '25', '', 0, '', 0, 0, 0, '', '', '', 6, 1, 0),
('001', '001', 'K01', '350001', 'ยำหมูยอไข่แดง', 'ยำหมูยอไข่แดง', '', '35', '1', '35', '2', 0, '', 0, 0, 0, '', '', '', 1, 1, 0),
('001', '001', 'K01', '350002', 'ยำปูม้ากุ้งแช่ (ดิบ)', 'ยำปูม้ากุ้งแช่ (ดิบ)', '', '35', '1', '35', '2', 0, '', 0, 0, 0, '', '', '', 2, 1, 0),
('001', '001', 'K01', '350003', 'ยำซีฟู๊ด (ลวก)', 'ยำซีฟู๊ด (ลวก)', '', '35', '1', '35', '2', 0, '', 0, 0, 0, '', '', '', 3, 1, 0);

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
('001', '001', '001', '010001', '001001001_010001.jpg'),
('001', '001', '001', '020003', '001001001_020003.jpg'),
('001', '001', '001', '020004', '001001001_020004.jpg'),
('001', '001', '001', '020005', '001001001_020005.jpg'),
('001', '001', '001', '020006', '001001001_020006.jpg'),
('001', '001', '001', '020007', '001001001_020007.jpg'),
('001', '001', '001', '020008', '001001001_020008.jpg'),
('001', '001', '001', '020009', '001001001_020009.jpg'),
('001', '001', '001', '020010', '001001001_020010.jpg'),
('001', '001', '001', '020011', '001001001_020011.jpg'),
('001', '001', '001', '020012', '001001001_020012.jpg'),
('001', '001', '001', '020013', '001001001_020013.jpg'),
('001', '001', '001', '020014', '001001001_020014.jpg'),
('001', '001', '001', '020015', '001001001_020015.jpg'),
('001', '001', '001', '020017', '001001001_020017.jpg'),
('001', '001', '001', '020019', '001001001_020019.jpg'),
('001', '001', '001', '030001', '001001001_030001.jpg'),
('001', '001', '001', '030002', '001001001_030002.jpg'),
('001', '001', '001', '030003', '001001001_030003.jpg'),
('001', '001', '001', '030004', '001001001_030004.jpg'),
('001', '001', '001', '030005', '001001001_030005.jpg'),
('001', '001', '001', '030006', '001001001_030006.jpg'),
('001', '001', '001', '030008', '001001001_030008.jpg'),
('001', '001', '001', '030011', '001001001_030011.jpg'),
('001', '001', '001', '030012', '001001001_030012.jpg'),
('001', '001', '001', '030013', '001001001_030013.jpg'),
('001', '001', '001', '030014', '001001001_030014.jpg'),
('001', '001', '001', '030015', '001001001_030015.jpg'),
('001', '001', '001', '030017', '001001001_030017.jpg'),
('001', '001', '001', '030018', '001001001_030018.jpg'),
('001', '001', '001', '030023', '001001001_030023.jpg'),
('001', '001', '001', '030024', '001001001_030024.jpg'),
('001', '001', '001', '030025', '001001001_030025.jpg'),
('001', '001', '001', '030026', '001001001_030026.jpg'),
('001', '001', '001', '030027', '001001001_030027.jpg'),
('001', '001', '001', '040004', '001001001_040004.jpg'),
('001', '001', '001', '040005', '001001001_040005.jpg'),
('001', '001', '001', '040010', '001001001_040010.jpg'),
('001', '001', '001', '040011', '001001001_040011.jpg'),
('001', '001', '001', '050002', '001001001_050002.jpg'),
('001', '001', '001', '050003', '001001001_050003.jpg'),
('001', '001', '001', '050004', '001001001_050004.jpg'),
('001', '001', '001', '050005', '001001001_050005.jpg'),
('001', '001', '001', '050007', '001001001_050007.jpg'),
('001', '001', '001', '050008', '001001001_050008.jpg'),
('001', '001', '001', '050009', '001001001_050009.jpg'),
('001', '001', '001', '050012', '001001001_050012.jpg'),
('001', '001', '001', '060001', '001001001_060001.jpg'),
('001', '001', '001', '060002', '001001001_060002.jpg'),
('001', '001', '001', '060005', '001001001_060005.jpg'),
('001', '001', '001', '060006', '001001001_060006.jpg'),
('001', '001', '001', '060008', '001001001_060008.jpg'),
('001', '001', '001', '060009', '001001001_060009.jpg'),
('001', '001', '001', '060013', '001001001_060013.jpg'),
('001', '001', '001', '060014', '001001001_060014.jpg'),
('001', '001', '001', '070001', '001001001_070001.jpg'),
('001', '001', '001', '070002', '001001001_070002.jpg'),
('001', '001', '001', '070003', '001001001_070003.jpg'),
('001', '001', '001', '070004', '001001001_070004.jpg'),
('001', '001', '001', '070005', '001001001_070005.jpg'),
('001', '001', '001', '070009', '001001001_070009.jpg'),
('001', '001', '001', '070010', '001001001_070010.jpg'),
('001', '001', '001', '070011', '001001001_070011.jpg'),
('001', '001', '001', '070013', '001001001_070013.jpg'),
('001', '001', '001', '070014', '001001001_070014.jpg'),
('001', '001', '001', '070015', '001001001_070015.jpg'),
('001', '001', '001', '070016', '001001001_070016.jpg'),
('001', '001', '001', '070018', '001001001_070018.jpg'),
('001', '001', '001', '070022', '001001001_070022.jpg'),
('001', '001', '001', '070024', '001001001_070024.jpg'),
('001', '001', '001', '070028', '001001001_070028.jpg'),
('001', '001', '001', '080001', '001001001_080001.jpg'),
('001', '001', '001', '080002', '001001001_080002.jpg'),
('001', '001', '001', '080003', '001001001_080003.jpg'),
('001', '001', '001', '080004', '001001001_080004.jpg'),
('001', '001', '001', '080011', '001001001_080011.jpg'),
('001', '001', '001', '080012', '001001001_080012.jpg'),
('001', '001', '001', '090001', '001001001_090001.jpg'),
('001', '001', '001', '090002', '001001001_090002.jpg'),
('001', '001', '001', '090003', '001001001_090003.jpg'),
('001', '001', '001', '100001', '001001001_100001.jpg'),
('001', '001', '001', '100002', '001001001_100002.jpg'),
('001', '001', '001', '100003', '001001001_100003.jpg'),
('001', '001', '001', '100005', '001001001_100005.jpg'),
('001', '001', '001', '100008', '001001001_100008.jpg'),
('001', '001', '001', '100011', '001001001_100011.jpg'),
('001', '001', '001', '100013', '001001001_100013.jpg'),
('001', '001', '001', '100014', '001001001_100014.jpg'),
('001', '001', '001', '100017', '001001001_100017.jpg'),
('001', '001', '001', '110001', '001001001_110001.jpg'),
('001', '001', '001', '110003', '001001001_110003.jpg'),
('001', '001', '001', '110005', '001001001_110005.jpg'),
('001', '001', '001', '110007', '001001001_110007.jpg'),
('001', '001', '001', '120002', '001001001_120002.jpg'),
('001', '001', '001', '120003', '001001001_120003.jpg'),
('001', '001', '001', '120004', '001001001_120004.jpg'),
('001', '001', '001', '120005', '001001001_120005.jpg'),
('001', '001', '001', '120006', '001001001_120006.jpg'),
('001', '001', '001', '120011', '001001001_120011.jpg'),
('001', '001', '001', '180001', '001001001_180001.jpg'),
('001', '001', '001', '200004', '001001001_200004.jpg'),
('001', '001', '001', '210002', '001001001_210002.jpg'),
('001', '001', '001', '210004', '001001001_210004.jpg'),
('001', '001', '001', '210006', '001001001_210006.jpg'),
('001', '001', '001', '290001', '001001001_290001.jpg'),
('002', '001', '001', '020004', '002001001_020004.jpg'),
('002', '001', '001', '020005', '002001001_020005.jpg'),
('002', '001', '001', '020006', '002001001_020006.jpg'),
('002', '001', '001', '020009', '002001001_020009.jpg'),
('002', '001', '001', '020010', '002001001_020010.jpg'),
('002', '001', '001', '020011', '002001001_020011.jpg'),
('002', '001', '001', '020012', '002001001_020012.jpg'),
('002', '001', '001', '020015', '002001001_020015.jpg'),
('002', '001', '001', '020017', '002001001_020017.jpg'),
('002', '001', '001', '020018', '002001001_020018.jpg'),
('002', '001', '001', '020019', '002001001_020019.jpg'),
('002', '001', '001', '020029', '002001001_020029.jpg'),
('002', '001', '001', '020030', '002001001_020030.jpg'),
('002', '001', '001', '020034', '002001001_020034.jpg'),
('002', '001', '001', '020064', '002001001_020064.jpg'),
('002', '001', '001', '020066', '002001001_020066.jpg'),
('002', '001', '001', '020074', '002001001_020074.jpg'),
('002', '001', '001', '020076', '002001001_020076.jpg'),
('002', '001', '001', '070001', '002001001_070001.jpg'),
('002', '001', '001', '070002', '002001001_070002.jpg'),
('002', '001', '001', '070004', '002001001_070004.jpg'),
('002', '001', '001', '070005', '002001001_070005.jpg'),
('002', '001', '001', '070006', '002001001_070006.jpg'),
('002', '001', '001', '080001', '002001001_080001.jpg'),
('002', '001', '001', '080002', '002001001_080002.jpg'),
('002', '001', '001', '080003', '002001001_080003.jpg'),
('002', '001', '001', '080004', '002001001_080004.jpg'),
('002', '001', '001', '080007', '002001001_080007.jpg'),
('002', '001', '001', '080008', '002001001_080008.jpg'),
('002', '001', '001', '080009', '002001001_080009.jpg'),
('002', '001', '001', '080010', '002001001_080010.jpg'),
('002', '001', '001', '080011', '002001001_080011.jpg'),
('002', '001', '001', '080012', '002001001_080012.jpg'),
('002', '001', '001', '080014', '002001001_080014.jpg'),
('002', '001', '001', '080015', '002001001_080015.jpg'),
('002', '001', '001', '080016', '002001001_080016.jpg'),
('002', '001', '001', '150004', '002001001_150004.jpg'),
('002', '001', '001', '150005', '002001001_150005.jpg'),
('002', '001', '001', '150006', '002001001_150006.jpg'),
('002', '001', '001', '150008', '002001001_150008.jpg'),
('002', '001', '001', '150010', '002001001_150010.jpg'),
('002', '001', '001', '150011', '002001001_150011.jpg'),
('002', '001', '001', '150014', '002001001_150014.jpg'),
('002', '001', '001', '150016', '002001001_150016.jpg'),
('002', '001', '001', '150017', '002001001_150017.jpg'),
('002', '001', '001', '160100', '002001001_160100.jpg'),
('002', '001', '001', '180008', '002001001_180008.jpg'),
('002', '001', '001', '180009', '002001001_180009.jpg'),
('002', '001', '001', '180010', '002001001_180010.jpg'),
('002', '001', '001', '180011', '002001001_180011.jpg'),
('002', '001', '001', '180013', '002001001_180013.jpg'),
('002', '001', '001', '180014', '002001001_180014.jpg'),
('002', '001', '001', '180015', '002001001_180015.jpg'),
('002', '001', '001', '180017', '002001001_180017.jpg'),
('002', '001', '001', '180018', '002001001_180018.jpg'),
('002', '001', '001', '180019', '002001001_180019.jpg'),
('002', '001', '001', '180020', '002001001_180020.jpg'),
('002', '001', '001', '180021', '002001001_180021.jpg'),
('002', '001', '001', '180023', '002001001_180023.jpg'),
('002', '001', '001', '180024', '002001001_180024.jpg'),
('002', '001', '001', '180025', '002001001_180025.jpg'),
('002', '001', '001', '180027', '002001001_180027.jpg'),
('002', '001', '001', '180028', '002001001_180028.jpg'),
('002', '001', '001', '180029', '002001001_180029.jpg'),
('002', '001', '001', '180034', '002001001_180034.jpg');

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

--
-- Dumping data for table `productpackage`
--

INSERT INTO `productpackage` (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `Level`, `ChooseQty`, `Component`, `BaseItemId`, `Needed`, `AutoAppend`) VALUES
('001', '001', 'K01', '190001', 1, 1, '010001,1|020002,1|020003,1|020004,1', '', 0, 1),
('001', '001', 'K01', '190001', 2, 1, '030003,1|030002,1', '', 1, 0),
('001', '001', 'K01', '190001', 3, 2, '040002,1|040003,1|040004,1|040005,1|040006', '040002,1', 1, NULL),
('001', '001', 'K01', '190001', 4, 1, '140094,1', '', NULL, 1);

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
('001', '001', 'K01', '010001', 'ไก่ตะกร้า', 'ไก่ตะกร้า', 'ไก่ตะกร้า', '01', '1', '01', '6', 0, '', 0, '1', 0),
('001', '001', 'K01', '010002', '(เจ)ตำผลไม้รวม', '(เจ)ตำผลไม้รวม', '', '01', '1', '01', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '010003', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', 'ยำพะโล้ไข่เค็ม', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010004', 'ขนมจีนผัด', 'ขนมจีนผัด', 'ขนมจีนผัด', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010005', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', 'ขี้เมาปลาดุกกรอบ', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010006', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', 'ทอดมันหน่อกะลา', '01', '1', '01', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '010007', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', 'แกงหมู พริกขี้หนูหอม', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010008', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', 'แกงเนื้อ พริกขี้หนูหอม', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010009', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', 'แกงส้มปลาแซลมอนผักรวม', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010010', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่NZผัดฉ่า', 'หอยแมลงภู่นิวซีแลนด์ผัดฉ่า', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010012', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงราดน้ำปลาพริกขี้หนูหอม', '', '01', '1', '01', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '010013', 'ปูจ๋า', 'ปูจ๋า', 'ปูจ๋า', '01', '1', '01', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '010014', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', 'ขนมจีน-แกงปู', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010015', 'มันกุ้งผัดขนมจีน', 'มันกุ้งผัดขนมจีน', '', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '010016', 'แกงส้มแตงโมอ่อน', 'แกงส้มแตงโมอ่อน', '', '01', '1', '01', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020002', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020003', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', 'ยำแหนมคลุกข้าวทอด', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020004', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020005', 'ไส้อั่ว', 'ไส้อั่ว', 'ไส้อั่ว', '02', '1', '02 04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020006', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020007', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020008', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020009', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020010', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020011', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020012', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020013', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '02', '1', '02', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '020014', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '02', '1', '02', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '020015', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', '02', '1', '02', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '020020', 'แคบหมู', 'แคบหมู', 'แคบหมู', '02', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030002', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', 'ปลาทับทิมราดซอสพริกไทยดำ', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030003', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', 'ปลาทับทิมทอดกระเทียม', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030004', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', 'ปลาทับทิมเกยตื้น', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030005', 'ปลาทับทิมทอดน้ำปลา', 'ปลาทับทิมทอดน้ำปลา', 'ปลาทับทิมทอดน้ำปลา', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030006', 'ปลาทับทิมราดน้ำปลาพริกขี้หนูหอ', 'ปลาทับทิมราดน้ำปลาพริกขี้หนูหอ', 'ปลาทับทิมราดน้ำปลาพริกขี้หนูหอ', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030007', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', 'ปลาทับทิมยำมะม่วง', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030008', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', 'ปลาทับทิมยำแอปเปิ้ล', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030009', 'ตำลาว', 'ตำลาว', 'ตำลาว', '03', '1', '03', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '030010', 'ตำโคราช', 'ตำโคราช', 'ตำโคราช', '03', '1', '03', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '030011', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', 'ปลากะพงนึ่งมะนาว', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030012', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', 'ปลากะพงทอดน้ำปลา', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030015', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', 'ปลากะพงราดพริก', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030018', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', 'ปลากะพงต้มยำแห้ง', '03', '1', '03', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '030020', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', 'เนื้อปลากะพงทอด ยำมะม่วง', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030021', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', 'เนื้อปลากะพงทอด ยำแอปเปิ้ล', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030022', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', 'เนื้อปลากะพงทอด ยำตะไคร้', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030023', 'เนื้อปลากะพงผัดพริกไทยดำ', 'เนื้อปลากะพงผัดพริกไทยดำ', 'เนื้อปลากะพงผัดพริกไทยดำ', '03', '1', '03', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '030024', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', 'เนื้อปลากะพงผัดฉ่า', '03', '1', '03', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '030025', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', 'ส้มตำเนื้อปลากะพงทอด', '03', '1', '03', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '030026', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', 'ปลากะพงทอดน้ำปลาพริกขี้หนูหอม', '', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030027', 'หอยแมลงภู่NZอบหม้อดิน', 'หอยแมลงภู่NZอบหม้อดิน', '', '03', '1', '03', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '030028', 'กะพงผัดฉ่า(ตัว)', 'กะพงผัดฉ่า(ตัว)', '', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030030', 'ตำมั่ว', 'ตำมั่ว', '', '05', '1', '05', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '030031', 'ปลากะพงริมสวน', 'ปลากะพงริมสวน', '', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030032', 'ทับทิมนึ่งมะนาว', 'ทับทิมนึ่งมะนาว', 'ทับทิมนึ่งมะนาว', '03', '1', '03', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '030033', 'ปลาทับทิมริมสวน', 'ปลาทับทิมริมสวน', '', '03', '1', '03', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040001', 'รวมมิตรตะกร้า', 'รวมมิตรตะกร้า', 'รวมมิตรตะกร้า', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040002', 'ข้าวโพดทอด', 'ข้าวโพดทอด', 'ข้าวโพดทอด', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040003', 'หมูตะกร้า', 'หมูตะกร้า', 'หมูตะกร้า', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040004', 'หมึกตะกร้า', 'หมึกตะกร้า', 'หมึกตะกร้า', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040005', 'กุ้งตะกร้า', 'กุ้งตะกร้า', 'กุ้งตะกร้า', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040006', 'เห็ดตะกร้า', 'เห็ดตะกร้า', 'เห็ดตะกร้า', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040007', 'ไข่ฟูปูหอม', 'ไข่ฟูปูหอม', 'ไข่ฟูปูหอม', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040008', 'ไข่เจียวไข่มดแดง', 'ไข่เจียวไข่มดแดง', 'ไข่เจียวไข่มดแดง', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040009', 'ไข่มดแดงคั่วไข่', 'ไข่มดแดงคั่วไข่', 'ไข่มดแดงคั่วไข่', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040010', 'ไข่อบหม้อดิน', 'ไข่อบหม้อดิน', 'ไข่อบหม้อดิน', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040011', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', 'ทอดมันกุ้ง', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040012', 'ปากเป็ดทอด', 'ปากเป็ดทอด', 'ปากเป็ดทอด', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040014', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', 'เนื้อแดดเดียว', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040015', 'หมูแดดเดียว', 'หมูแดดเดียว', 'หมูแดดเดียว', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040016', 'ลาบขนมจีน', 'ลาบขนมจีน', '', '04', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040017', 'ลาบหมูทอด', 'ลาบหมูทอด', 'ลาบหมูทอด', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040018', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', 'เม็ดมะม่วงทอด', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040019', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', 'เป็ดคั่วกระเพรากรอบ', '04', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040020', 'หมูข้าวเม่า', 'หมูข้าวเม่า', 'หมูข้าวเม่า', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040021', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', 'หมูคั่วน้ำปลา', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040022', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', 'ชุดน้ำพริกหนุ่ม+ไส้อั่ว', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040023', 'หอยจ๊อ เบบี้', 'หอยจ๊อ เบบี้', 'หอยจ๊อ เบบี้', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040024', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', 'กุ้งอบวุ้นเส้น', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040025', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', 'กุ้งกระเบื้อง', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040026', 'ไก่ตะกร้า(ปีก)', 'ไก่ตะกร้า(ปีก)', '', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040027', 'ไข่ดาว', 'ไข่ดาว', '', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040028', 'ไข่เจียว', 'ไข่เจียว', '', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040029', 'ไข่เจียวหมูสับ', 'ไข่เจียวหมูสับ', '', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040030', 'ไข่เจียวกุ้งสับ', 'ไข่เจียวกุ้งสับ', '', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040031', 'ไข่เจียวปู', 'ไข่เจียวปู', '', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040034', 'คอหมูย่าง', 'คอหมูย่าง', '', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040035', 'ทอดมันปลากราย', 'ทอดมันปลากราย', '', '04', '1', '04', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '040036', 'น้ำพริกหนุ่ม (ถ้วย)', 'น้ำพริกหนุ่ม (ถ้วย)', '', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '040037', 'น้ำพริกหนุ่ม ผักลวก แคบ', 'น้ำพริกหนุ่ม ผักลวก แคบ', 'น้ำพริกหนุ่ม ผักลวก แคบ', '04', '1', '04', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050001', 'ตำกุ้งแช่', 'ตำกุ้งแช่', 'ตำกุ้งแช่', '05', '1', '05', '2', 0, '', 0, '1', 0),
('001', '001', 'K01', '050002', 'ตำไทย', 'ตำไทย', 'ตำไทย', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050003', 'ตำปู', 'ตำปู', 'ตำปู', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050004', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', 'ตำไทยใส่ปู', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050005', 'ตำลาว', 'ตำลาว', '', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050006', 'ตำตะกร้า', 'ตำตะกร้า', 'ตำตะกร้า', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050007', 'ตำมั่วไทย', 'ตำมั่วไทย', 'ตำมั่วไทย', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050008', 'ตำมั่วลาว', 'ตำมั่วลาว', 'ตำมั่วลาว', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050009', 'ตำซั่วไทย', 'ตำซั่วไทย', 'ตำซั่วไทย', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050010', 'ตำซั่วลาว', 'ตำซั่วลาว', 'ตำซั่วลาว', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050011', 'ตำมะม่วง', 'ตำมะม่วง', 'ตำมะม่วง', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050012', 'ตำข้าวโพด', 'ตำข้าวโพด', 'ตำข้าวโพด', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050014', 'ตำปูปลาร้า', 'ตำปูปลาร้า', 'ตำปูปลาร้า', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050015', 'ตำไข่เค็ม', 'ตำไข่เค็ม', 'ตำไข่เค็ม', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050016', 'ตำปูม้า', 'ตำปูม้า', 'ตำปูม้า', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050017', 'ส้มตำหมูคั่วน้ำปลา', 'ส้มตำหมูคั่วน้ำปลา', 'ส้มตำหมูคั่วน้ำปลา', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050018', 'ตำแครอท', 'ตำแครอท', 'ตำแครอท', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050019', 'ตำหอยดอง', 'ตำหอยดอง', 'ตำหอยดอง', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050020', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', 'ตำหน่อไม้ปู', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050021', 'ตำโคราช', 'ตำโคราช', '', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050022', 'ตำป่า', 'ตำป่า', '', '05', '1', '05', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '050023', 'ตำผลไม้', 'ตำผลไม้', '', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050024', 'ตำถั่วฝักยาวปู', 'ตำถั่วฝักยาวปู', '', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050025', 'ตำถั่วฝักยาวปู-ปลาร้า', 'ตำถั่วฝักยาวปู-ปลาร้า', '', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050026', 'ยำปูม้า', 'ยำปูม้า', '', '05', '1', '05', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '050028', 'ตำแตง', 'ตำแตง', 'ตำแตง', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050029', 'ส้มตำคอหมูย่าง', 'ส้มตำคอหมูย่าง', 'ส้มตำคอหมูย่าง', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '050030', 'ส้มตำปลาดุกฟู', 'ส้มตำปลาดุกฟู', '', '05', '1', '05', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060001', 'ลาบเป็ด', 'ลาบเป็ด', 'ลาบเป็ด', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060002', 'ลาบปลาดุก', 'ลาบปลาดุก', 'ลาบปลาดุก', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060003', 'ลาบหมู', 'ลาบหมู', 'ลาบหมู', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060004', 'ลาบไก่', 'ลาบไก่', 'ลาบไก่', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060005', 'ลาบหมูทอด', 'ลาบหมูทอด', 'ลาบหมูทอด', '06', '1', '06', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '060006', 'ลาบปลาหมึก', 'ลาบปลาหมึก', 'ลาบปลาหมึก', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060007', 'ลาบเห็ดสามอย่าง', 'ลาบเห็ดสามอย่าง', 'ลาบเห็ดสามอย่าง', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060008', 'หมูน้ำตก', 'หมูน้ำตก', 'หมูน้ำตก', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060010', 'ซุปหน่อไม้', 'ซุปหน่อไม้', 'ซุปหน่อไม้', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060011', 'ตับหวาน', 'ตับหวาน', 'ตับหวาน', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060012', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', 'กุ้งแช่น้ำปลา', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060013', 'ยำปลาดุกฟู', 'ยำปลาดุกฟู', 'ยำปลาดุกฟู', '06', '1', '06', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '060014', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', 'ยำวุ้นเส้น', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060015', 'ยำรวมมิตร', 'ยำรวมมิตร', 'ยำรวมมิตร', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060016', 'ยำตะไคร้กุ้งกรอบ', 'ยำตะไคร้กุ้งกรอบ', 'ยำตะไคร้กุ้งกรอบ', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060018', 'ยำหมูย่างยอดมะพร้าว', 'ยำหมูย่างยอดมะพร้าว', 'ยำหมูย่างยอดมะพร้าว', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060019', 'ยำผักหวานกรอบ', 'ยำผักหวานกรอบ', 'ยำผักหวานกรอบ', '06', '1', '06', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '060020', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', 'ยำดอกขจรกรอบ', '06', '1', '06', '6', 0, '', 0, '0', 0),
('001', '001', 'K01', '060021', 'ลาบวุ้นเส้น', 'ลาบวุ้นเส้น', '', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060022', 'หมึกมะนาว', 'หมึกมะนาว', '', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060023', 'ลาบกุ้ง', 'ลาบกุ้ง', '', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060024', 'ลาบเห็ดโคน', 'ลาบเห็ดโคน', '', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060025', 'ลาบเห็ดฟาง', 'ลาบเห็ดฟาง', '', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060026', 'ยำเห็ดสามอย่าง', 'ยำเห็ดสามอย่าง', 'ยำเห็ดสามอย่าง', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060027', 'หมูมะนาว', 'หมูมะนาว', '', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '060028', 'ยำไข่มดแดง', 'ยำไข่มดแดง', '', '06', '1', '06', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070001', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', 'ต้มยำเนื้อปลากะพง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070002', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', 'ต้มยำกุ้งใหญ่', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070003', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', 'ต้มยำกุ้งเล็ก', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070004', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', 'ต้มยำเห็ดสามอย่าง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070005', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', 'ต้มโคล้งปลาสลิด', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070006', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', 'ต้มโคล้งปลาดุกย่าง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070007', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', 'ต้มแซ่บโครงอ่อน', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070008', 'ต้มเปรี้ยวไก่บ้านคั่ว', 'ต้มเปรี้ยวไก่บ้านคั่ว', 'ต้มเปรี้ยวไก่บ้านคั่ว', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070009', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', 'ต้มเปรี้ยวโครงอ่อน', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070010', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', 'ต้มแซ่บเนื้อเคี่ยว', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070011', 'แกงป่าเนื้อเคี่ยว', 'แกงป่าเนื้อเคี่ยว', 'แกงป่าเนื้อเคี่ยว', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070012', 'แกงส้มกุ้งใหญ่', 'แกงส้มกุ้งใหญ่', 'แกงส้มกุ้งใหญ่', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070013', 'แกงส้มกุ้งเล็ก', 'แกงส้มกุ้งเล็ก', 'แกงส้มกุ้งเล็ก', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070014', 'แกงส้มผักรวม', 'แกงส้มผักรวม', 'แกงส้มผักรวม', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070015', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', 'แกงส้มชะอมทอด', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070016', 'แกงปู', 'แกงปู', 'แกงปู', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070018', 'แกงป่าหมู', 'แกงป่าหมู', 'แกงป่าหมู', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070019', 'แกงป่าโครงอ่อน', 'แกงป่าโครงอ่อน', 'แกงป่าโครงอ่อน', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070020', 'แกงป่าลูกชิ้นปลากราย', 'แกงป่าลูกชิ้นปลากราย', 'แกงป่าลูกชิ้นปลากราย', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070021', 'แกงลาวเห็ดเผาะ', 'แกงลาวเห็ดเผาะ', 'แกงลาวเห็ดเผาะ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070022', 'แกงลาวเห็ดเผาะไข่มดแดง', 'แกงลาวเห็ดเผาะไข่มดแดง', 'แกงลาวเห็ดเผาะไข่มดแดง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070023', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', 'แกงคั่วเห็ดเผาะ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070024', 'ต้มยำโป๊ะแตกน้ำ', 'ต้มยำโป๊ะแตกน้ำ', 'ต้มยำโป๊ะแตกน้ำ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070025', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', 'โป๊ะแตกแห้ง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070026', 'แกงเขียวหวานหมู', 'แกงเขียวหวานหมู', 'แกงเขียวหวานหมู', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070027', 'แกงเขียวหวานไก่', 'แกงเขียวหวานไก่', 'แกงเขียวหวานไก่', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070028', 'แกงเขียวหวานเนื้อ', 'แกงเขียวหวานเนื้อ', 'แกงเขียวหวานเนื้อ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070029', 'แกงเขียวหวานลูกชิ้นปลากราย', 'แกงเขียวหวานลูกชิ้นปลากราย', 'แกงเขียวหวานลูกชิ้นปลากราย', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070030', 'แกงอ่อมหมู', 'แกงอ่อมหมู', 'แกงอ่อมหมู', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070031', 'แกงอ่อมไก่', 'แกงอ่อมไก่', 'แกงอ่อมไก่', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070032', 'แกงอ่อมเนื้อ', 'แกงอ่อมเนื้อ', 'แกงอ่อมเนื้อ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070033', 'โรตี แกงเขียวหวานไก่', 'โรตี แกงเขียวหวานไก่', 'โรตี แกงเขียวหวานไก่', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070034', 'โรตี แกงเขียวหวานเนื้อ', 'โรตี แกงเขียวหวานเนื้อ', 'โรตี แกงเขียวหวานเนื้อ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070035', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', 'แกงจืดเต้าหู้หมูสับสาหร่าย', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070036', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', 'แกงจืดปลาหมึกยัดไส้', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070037', 'ต้มยำรวมมิตร', 'ต้มยำรวมมิตร', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070038', 'แกงเนื้อพริกขี้หนูหอม', 'แกงเนื้อพริกขี้หนูหอม', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070039', 'แกงคั่วหอยขม', 'แกงคั่วหอยขม', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070040', 'แกงเขียวหวานไก่+ขนมจีน', 'แกงเขียวหวานไก่+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070041', 'โรตีแกงเขียวหวานหมู', 'โรตีแกงเขียวหวานหมู', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070042', 'โรตีแกงเขียวหวานปลากราย', 'โรตีแกงเขียวหวานปลากราย', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070043', 'โรตีแกงเขียวหวานกุ้ง', 'โรตีแกงเขียวหวานกุ้ง', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070044', 'แกงเขียวหวานเนื้อ+ขนมจีน', 'แกงเขียวหวานเนื้อ+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070045', 'แกงเขียวหวานหมู+ขนมจีน', 'แกงเขียวหวานหมู+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070046', 'เขียวหวานปลากราย+ขนมจีน', 'เขียวหวานปลากราย+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070047', 'แกงเขียวหวานกุ้ง+ขนมจีน', 'แกงเขียวหวานกุ้ง+ขนมจีน', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070048', 'แกงป่าไก่', 'แกงป่าไก่', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070049', 'แกงป่าปลากระพง', 'แกงป่าปลากระพง', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070050', 'แกงลาวผักหวานไข่มดแดง', 'แกงลาวผักหวานไข่มดแดง', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070052', 'แกงจืดเต้าหู้หมูสับ', 'แกงจืดเต้าหู้หมูสับ', 'แกงจืดเต้าหู้หมูสับ', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070053', 'แกงลาวเห็ดสามอย่าง', 'แกงลาวเห็ดสามอย่าง', 'แกงลาวเห็ดสามอย่าง', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070054', 'ต้มแซ่บหมูเด้ง', 'ต้มแซ่บหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070055', 'ต้มเปรี้ยวหมูเด้ง', 'ต้มเปรี้ยวหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070056', 'แกงป่าหมูเด้ง', 'แกงป่าหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '070057', 'แกงเขียวหวานหมูเด้ง', 'แกงเขียวหวานหมูเด้ง', '', '07', '1', '07', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080001', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', 'เห็ดหูหนูผัดไข่', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080002', 'ผัดฉ่าเห็ด 3 อย่าง', 'ผัดฉ่าเห็ด 3 อย่าง', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080003', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', 'ผักหวานผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080004', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', 'ชาโยเต้ผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080005', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', 'ดอกขจรผัดน้ำมันหอย', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080006', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', 'เนื้อปูผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080007', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', 'เนื้อปูผัดพริกไทยดำ', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080008', 'ผัดผักยอดดอย', 'ผัดผักยอดดอย', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080009', 'กะหล่ำฉ่าน้ำปลา', 'กะหล่ำฉ่าน้ำปลา', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080010', 'ขนมจีนผัด', 'ขนมจีนผัด', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080011', 'ผัดฉ่าลูกชิ้นปลากราย', 'ผัดฉ่าลูกชิ้นปลากราย', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080012', 'หอยแมลงภู่ผัดฉ่า', 'หอยแมลงภู่ผัดฉ่า', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080013', 'หอยแมลงภู่อบหม้อดิน', 'หอยแมลงภู่อบหม้อดิน', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080014', 'ผัดฉ่าเห็ดโคนญี่ปุ่น', 'ผัดฉ่าเห็ดโคนญี่ปุ่น', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080015', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', 'เห็ดโคนญี่ปุ่นน้ำมันหอย', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080016', 'ผัดคะน้าปลาสลิด', 'ผัดคะน้าปลาสลิด', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080017', 'ผัดคะน้าปลาเค็ม', 'ผัดคะน้าปลาเค็ม', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080018', 'ผักหวานไข่กรอบ', 'ผักหวานไข่กรอบ', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080019', 'ดอกขจรไข่กรอบ', 'ดอกขจรไข่กรอบ', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080020', 'ผัดฉ่าทะเล', 'ผัดฉ่าทะเล', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080021', 'กระเพราเนื้อตุ๋น', 'กระเพราเนื้อตุ๋น', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080022', 'ปลาหมึกผัดผงกะหรี่', 'ปลาหมึกผัดผงกะหรี่', 'ปลาหมึกผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080023', 'กุ้งผัดผงกะหรี่', 'กุ้งผัดผงกะหรี่', 'กุ้งผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080024', 'ทะเลผัดผงกะหรี่', 'ทะเลผัดผงกะหรี่', 'ทะเลผัดผงกะหรี่', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080025', 'กระเพราปลาหมึก', 'กระเพราปลาหมึก', 'กระเพราปลาหมึก', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080026', 'กระเพรากุ้ง', 'กระเพรากุ้ง', 'กระเพรากุ้ง', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080027', 'กระเพราหมู', 'กระเพราหมู', 'กระเพราหมู', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080028', 'กะเพราไก่', 'กะเพราไก่', 'กะเพราไก่', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080029', 'ผัดมะเขือยาว', 'ผัดมะเขือยาว', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '080030', 'ผัดฉ่าหมูเด้ง', 'ผัดฉ่าหมูเด้ง', '', '08', '1', '08', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '090001', 'ทับทิมกรอบ', 'ทับทิมกรอบ', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090002', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', 'กระท้อนลอยแก้ว', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090003', 'สละลอยแก้ว', 'สละลอยแก้ว', 'สละลอยแก้ว', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090004', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', 'โรตีนม + น้ำตาล', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090005', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', 'โรตีนม + ช็อคโกแลต', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090006', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', 'ไอศกรีมทอด วนิลา', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090007', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', 'ไอศรีมมะพร้าวน้ำหอม', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090008', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', 'เฉาก๊วยโบราณ', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090009', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', 'กล้วยไข่เชื่อม', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090010', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', 'ไอศกรีมกล้วยไข่เชื่อม', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090011', 'ไอศกรีมทุเรียน', 'ไอศกรีมทุเรียน', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090012', 'ไอศกรีมสตอเบอร์รี่', 'ไอศกรีมสตอเบอร์รี่', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090013', 'ไอศกรีมวนิลา', 'ไอศกรีมวนิลา', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090014', 'ไอศกรีมช็อคโกแลต', 'ไอศกรีมช็อคโกแลต', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090015', 'ไอศกรีมทุเรียน+กล้วย', 'ไอศกรีมทุเรียน+กล้วย', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090016', 'ไอศกรีมสตอเบอร์รี่+กล้วย', 'ไอศกรีมสตอเบอร์รี่+กล้วย', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090017', 'ไอศกรีมวนิลา+กล้วย', 'ไอศกรีมวนิลา+กล้วย', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090018', 'ไอศกรีมช็อคโกแลต+กล้วย', 'ไอศกรีมช็อคโกแลต+กล้วย', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090019', 'เยลลี่', 'เยลลี่', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090020', 'ลอดช่องน้ำกะทิ', 'ลอดช่องน้ำกะทิ', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090024', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', 'ไอศกรีมข้าวไรท์+กล้วย', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090025', 'บัวลอยเผือก', 'บัวลอยเผือก', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '090026', 'พุดดิ้งมะพร้าวอ่อน', 'พุดดิ้งมะพร้าวอ่อน', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100001', 'กาแฟร้อน', 'กาแฟร้อน', 'กาแฟร้อน', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100002', 'กาแฟเย็น', 'กาแฟเย็น', 'กาแฟเย็น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100003', 'ชาเย็น', 'ชาเย็น', 'ชาเย็น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100005', 'ชาดำเย็น', 'ชาดำเย็น', 'ชาดำเย็น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100006', 'ชามะนาว', 'ชามะนาว', 'ชามะนาว', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100008', 'แตงโมปั่น', 'แตงโมปั่น', 'แตงโมปั่น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100010', 'มะนาวปั่น', 'มะนาวปั่น', 'มะนาวปั่น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100011', 'กาแฟเย็นปั่น', 'กาแฟเย็นปั่น', 'กาแฟเย็นปั่น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100012', 'ชาเย็นปั่น', 'ชาเย็นปั่น', 'ชาเย็นปั่น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100013', 'น้ำแดงโซดา', 'น้ำแดงโซดา', 'น้ำแดงโซดา', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100014', 'น้ำเขียวโซดา', 'น้ำเขียวโซดา', 'น้ำเขียวโซดา', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100016', 'ชาจีนร้อน', 'ชาจีนร้อน', 'ชาจีนร้อน', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100020', 'น้ำดื่ม', 'น้ำดื่ม', 'น้ำดื่ม', '10', '2', '10', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '100021', 'โซดา', 'โซดา', 'โซดา', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100022', 'น้ำแข็ง', 'น้ำแข็ง', 'น้ำแข็ง', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100023', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', 'น้ำแข็งแช่ไวน์', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100024', 'ผ้าเย็น', 'ผ้าเย็น', 'ผ้าเย็น', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100025', 'เอส', 'เอส', '', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '100027', 'น้ำมะนาว', 'น้ำมะนาว', '', '10', '2', '10', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110001', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', 'เบียร์ไฮเนเก้น', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110002', 'เบียร์สิงห์', 'เบียร์สิงห์', 'เบียร์สิงห์', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110003', 'เบียร์ลีโอ', 'เบียร์ลีโอ', 'เบียร์ลีโอ', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110005', 'U Beer 620ml.', 'U Beer 620ml.', '', '11', '3', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '110006', 'เบียร์ช้าง คลาสสิค', 'เบียร์ช้าง คลาสสิค', '', '11', '2', '11', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '120002', 'แบล็คเลเบิ้ล (1litre)', 'แบล็คเลเบิ้ล (1litre)', '', '12', '2', '12', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '120003', 'เรดเลเบิ้ล (1litre)', 'เรดเลเบิ้ล (1litre)', '', '12', '2', '12', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '120004', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', 'ฮันเดรดไพเพอร์', '12', '2', '12', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '120007', 'รีเจนซี่(แบน)', 'รีเจนซี่(แบน)', '', '12', '2', '12', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '120008', 'รีเจนซี่(กลม)', 'รีเจนซี่(กลม)', '', '12', '2', '12', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '120015', 'ไอศกรีมข้าวไรซ์ฯ', 'ไอศกรีมข้าวไรซ์ฯ', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '120023', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', 'ไอศกรีมมะพร้าว+กล้วยไข่เชื่อม', '', '09', '3', '09', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '120024', 'ไอศกรีมข้าวไรซ์ฯ 1/2 โล', 'ไอศกรีมข้าวไรซ์ฯ 1/2 โล', '', '09', '3', '12', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '130001', 'พุดดิ้ง', 'พุดดิ้ง', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130002', 'เต้าหู้นมสด', 'เต้าหู้นมสด', '', '13', '3', '13', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '130003', 'พายบลูเบอร์รี่', 'พายบลูเบอร์รี่', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130004', 'วุ้นเฟื่องฟ้า (กะทิ)', 'วุ้นเฟื่องฟ้า (กะทิ)', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130005', 'ลอดช่องชาเขียว', 'ลอดช่องชาเขียว', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130006', 'สละลอยแก้ว(ห่อ)', 'สละลอยแก้ว(ห่อ)', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130008', 'เต้าทึง', 'เต้าทึง', '', '13', '3', '13', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '130009', 'ลูกจาก', 'ลูกจาก', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130010', 'ขนมเค้ก', 'ขนมเค้ก', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130013', 'ลูกตาล', 'ลูกตาล', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '130014', 'คัพเค้ก', 'คัพเค้ก', '', '13', '3', '13', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140001', 'กล้วยม้วน', 'กล้วยม้วน', 'กล้วยม้วน', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140003', 'เมอแรงค์', 'เมอแรงค์', 'เมอแรงค์', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140004', 'ข้าวเกรียบกุ้ง', 'ข้าวเกรียบกุ้ง', 'ข้าวเกรียบกุ้ง', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140006', 'คาราเมลคอนแฟรก', 'คาราเมลคอนแฟรก', 'คาราเมลคอนแฟรก', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140007', 'ข้าวตังจอมพล', 'ข้าวตังจอมพล', 'ข้าวตังจอมพล', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140008', 'น้ำพริกกระเช้า 4 ตลับ', 'น้ำพริกกระเช้า 4 ตลับ', 'น้ำพริกกระเช้า 4 ตลับ', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140020', 'มะขามคลุก(ใหญ่)', 'มะขามคลุก(ใหญ่)', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140021', 'มะขามคลุก(เล็ก)', 'มะขามคลุก(เล็ก)', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140023', 'ทองม้วน (กะทิสด)', 'ทองม้วน (กะทิสด)', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140024', 'กล้วยฉาบ', 'กล้วยฉาบ', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140025', 'ขนมผิง', 'ขนมผิง', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140026', 'น้ำผึ้งเดือนห้า', 'น้ำผึ้งเดือนห้า', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140028', 'กล้วยตาก', 'กล้วยตาก', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140032', 'น้ำพริก 3 กระปุกเล็ก', 'น้ำพริก 3 กระปุกเล้ก', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140033', 'น้ำพริก 6 กระปุกเล็ก', 'น้ำพริก 6 กระปุกเล็ก', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140035', 'น้ำพริกชุด 2 กระปุก', 'น้ำพริกชุด 2 กระปุก', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140036', 'น้ำพริกชุด 6 กระปุก', 'น้ำพริกชุด 6 กระปุก', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140037', 'น้ำพริกชุด 3 กระปุก', 'น้ำพริกชุด 3 กระปุก', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140039', 'มะขามไร้เมล็ด', 'มะขามไร้เมล็ด', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140041', 'กล้วยอบ Solar Dried Banana', 'กล้วยอบ Solar Dried Banana', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140042', 'กล้วยน้ำหว้าตาก', 'กล้วยน้ำหว้าตาก', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140044', 'กระเทียมเจียว', 'กระเทียมเจียว', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140045', 'หอมเจียว', 'หอมเจียว', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140046', 'บ๊วย 3 รส', 'บ๊วย 3 รส', '.', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140047', 'บ๊วยหวาน', 'บ๊วยหวาน', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140048', 'พุทราจีน', 'พุทราจีน', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140049', 'บ๊วยน้ำผึ้ง', 'บ๊วยน้ำผึ้ง', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140061', 'ข้าวคั่วคุณชาย 250g', 'ข้าวคั่วคุณชาย 250g', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140072', 'โรตีโอ่ง', 'โรตีโอ่ง', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140073', 'หมี่กรอบ', 'หมี่กรอบ', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140074', 'ชุดถุงของขวัญ 6กป', 'ชุดถุงของขวัญ 6กป', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140075', 'ชุดถุงของขวัญ 3กป', 'ชุดถุงของขวัญ 3กป', '', '14', '4', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140078', 'น้ำพริกเผา(กระปุก)180 กรัม', 'น้ำพริกเผา(กระปุก)180 กรัม', '', '14', '1', '14', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '140079', 'กระเช้าน้ำพริกคลุกข้าว 3กป', 'กระเช้าน้ำพริกคลุกข้าว 3กป', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140080', 'กระเช้าน้ำพริกคลุกข้าว 5กป', 'กระเช้าน้ำพริกคลุกข้าว 5กป', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140081', 'ชุดของขวัญ 3 กระปุก', 'ชุดของขวัญ 3 กระปุก', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140082', 'ชุดของขวัญ 6 กระปุก', 'ชุดของขวัญ 6 กระปุก', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140083', 'กระเช้า 4 ตลับ', 'กระเช้า 4 ตลับ', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140084', 'กระเช้า 6 ตลับ', 'กระเช้า 6 ตลับ', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140093', 'น้ำพริก (ซอง)', 'น้ำพริก (ซอง)', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140094', 'น้ำพริก (กระปุก)', 'น้ำพริก (กระปุก)', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140095', 'ครองแครง', 'ครองแครง', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140096', 'ชีสสับปะรด', 'ชีสสับปะรด', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '140097', 'กล้วยอบ OTOP 200g', 'กล้วยอบ OTOP 200g', '', '14', '4', '14', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '150001', 'Black Label (700ml)', 'Black Label (700ml)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150002', 'Red Label (1 Litre)', 'Red Label (1 Litre)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150003', 'Regency (700ml)', 'Regency (700ml)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150004', 'Regency (350ml)', 'Regency (350ml)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150005', '100 PIPERS', '100 PIPERS', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150006', 'เบลน285', 'เบลน285', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150007', 'แสงโสม(แบน)', 'แสงโสม(แบน)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150008', 'แสงโสม(กลม)', 'แสงโสม(กลม)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150009', 'Chivas (700ml)', 'Chivas (700ml)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150017', 'Red Label (700ml)', 'Red Label (700ml)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150018', 'Black Label (1Litre)', 'Black Label (1Litre)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150019', 'Blend 285 (1 Litre)', 'Blend 285 (1 Litre)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '150020', 'Blend 285 (700ml)', 'Blend 285 (700ml)', '', '15', '4', '15', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '190001', 'โปรเปิดร้านสุดคุ้ม', 'โปรเปิดร้านสุดคุ้ม', '', '19', '1', '19', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '190002', 'โปรปลากะพงเขียวหวาน', 'โปรปลากะพงเขียวหวาน', '', '19', '1', '19', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '190003', 'ถุงผ้า', 'ถุงผ้า', '', '19', '4', '19', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '190005', 'ปฏิทิน', 'ปฏิทิน', '', '19', '4', '19', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '190007', 'ไอศกรีมข้าวไรซ์เบอรรี่', 'ไอศกรีมข้าวไรซ์เบอรรี่', '', '19', '4', '19', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '190008', 'AIS ส้มตำไทย (ฟรี)', 'AIS ส้มตำไทย (ฟรี)', '', '19', '1', '19', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '190009', 'AIS ส้มตำปู (ฟรี)', 'AIS ส้มตำปู (ฟรี)', '', '19', '1', '19', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '190015', 'ส้มตำไทย(ฟรี Rabbit)', 'ส้มตำไทย(ฟรี Rabbit)', '', '19', '1', '19', '4', 0, '', 0, '0', 0),
('001', '001', 'K01', '200001', 'น้ำจิ้มซีฟู้ด', 'น้ำจิ้มซีฟู้ด', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200002', 'แตงกวาสไลด์', 'แตงกวาสไลด์', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200003', 'มะนาวสไลด์', 'มะนาวสไลด์', '', '20', '4', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200004', 'เพิ่มน้ำยำปลาดุกฟู', 'เพิ่มน้ำยำปลาดุกฟู', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200005', 'เพิ่มน้ำราดน้ำปลา', 'เพิ่มน้ำราดน้ำปลา', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200006', 'เพิ่มน้ำแกงส้ม', 'เพิ่มน้ำแกงส้ม', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200007', 'เพิ่มน้ำราดปลากระชาย', 'เพิ่มน้ำราดปลากระชาย', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200008', 'เพิ่มชุดกระชายกรอบ', 'เพิ่มชุดกระชายกรอบ', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200009', 'เพิ่มชุดผักแกงส้ม', 'เพิ่มชุดผักแกงส้ม', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200010', 'เพิ่มเห็ดเผาะ(ถ้วย)', 'เพิ่มเห็ดเผาะ(ถ้วย)', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200011', 'เพิ่มไข่มดแดง(ถ้วย)', 'เพิ่มไข่มดแดง(ถ้วย)', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200012', 'เพิ่มน้ำราดปลาริมสวน(ถ้วย)', 'เพิ่มน้ำราดปลาริมสวน(ถ้วย)', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200013', 'เพิ่มน้ำราดปลาน้ำตก(ถ้วย)', 'เพิ่มน้ำราดปลาน้ำตก(ถ้วย)', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200014', 'เพิ่มน้ำปลาพริกขี้หนูหอม.', 'เพิ่มน้ำปลาพริกขี้หนูหอม.', '.', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200015', 'แจ่วพริกสด', 'แจ่วพริกสด', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200016', 'ชุดน้ำพริกผักลวก', 'ชุดน้ำพริกผักลวก', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200017', 'ผักลวกแป๊ะซะ', 'ผักลวกแป๊ะซะ', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200018', 'น้ำพริกหนุ่ม (โล)', 'น้ำพริกหนุ่ม (โล)', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200019', 'น้ำพริกหนุ่ม (ถ้วย)', 'น้ำพริกหนุ่ม (ถ้วย)', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200020', 'น้ำพริกหนุ่ม (ขีด)', 'น้ำพริกหนุ่ม (ขีด)', '', '20', '1', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200021', 'เพิ่มชะอมไข่', 'เพิ่มชะอมไข่', '', '20', '4', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '200023', 'ผักลวก (ปลาเผา)', 'ผักลวก (ปลาเผา)', '', '20', '4', '20', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '210001', 'น้ำเก็กฮวย', 'น้ำเก็กฮวย', '', '21', '2', '21', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '210002', 'น้ำกระเจี๊ยบ', 'น้ำกระเจี๊ยบ', '', '21', '2', '21', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '210003', 'น้ำอัญชัญมะนาว', 'น้ำอัญชัญมะนาว', '', '21', '2', '21', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '210004', 'น้ำมะตูม', 'น้ำมะตูม', '', '21', '2', '21', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '210005', 'น้ำใบเตย', 'น้ำใบเตย', '', '21', '2', '21', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '210006', 'น้ำตะไคร้', 'น้ำตะไคร้', '', '21', '2', '21', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '210007', 'น้ำพั้นช์', 'น้ำพั้นช์', '', '21', '2', '21', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '220001', 'ข้าวผัดมันกุ้งก้ามกราม', 'ข้าวผัดมันกุ้งก้ามกราม', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220002', 'ข้าวผัดแหนม', 'ข้าวผัดแหนม', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220003', 'ข้าวผัดแหนมปลาเค็ม', 'ข้าวผัดแหนมปลาเค็ม', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220004', 'ข้าวผัดปลาเค็ม', 'ข้าวผัดปลาเค็ม', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220005', 'ข้าวผัดปลาสลิด', 'ข้าวผัดปลาสลิด', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220006', 'ข้าวผัดหน่อกะลา', 'ข้าวผัดหน่อกะลา', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220007', 'ข้าวผัดหมู', 'ข้าวผัดหมู', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220008', 'ข้าวผัดไก่', 'ข้าวผัดไก่', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220009', 'ข้าวผัดปลาหมึก', 'ข้าวผัดปลาหมึก', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220010', 'ข้าวผัดกุ้ง', 'ข้าวผัดกุ้ง', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220011', 'ข้าวผัดปู', 'ข้าวผัดปู', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220012', 'ข้าวราดกระเพราหมู', 'ข้าวราดกระเพราหมู', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220013', 'ข้าวราดกระเพราไก่', 'ข้าวราดกระเพราไก่', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220014', 'ข้าวราดกระเพรากุ้ง', 'ข้าวราดกระเพรากุ้ง', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220015', 'ข้าวราดกระเพราปลาหมึก', 'ข้าวราดกระเพราปลาหมึก', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220016', 'ข้าวราดกระเพราเนื้อตุ๋น', 'ข้าวราดกระเพราเนื้อตุ๋น', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220017', 'ข้าวหอมมะลิ', 'ข้าวหอมมะลิ', '', '22', '1', '22', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '220018', 'ข้าวเหนียวขาว', 'ข้าวเหนียวขาว', '', '22', '1', '22', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '220019', 'ข้าวเหนียวดำ', 'ข้าวเหนียวดำ', '', '22', '1', '22', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '220020', 'ขนมจีน', 'ขนมจีน', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220021', 'โรตี', 'โรตี', '', '22', '1', '22', '1', 0, '', 0, '0', 0),
('001', '001', 'K01', '220022', 'หมี่ลวก', 'หมี่ลวก', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220023', 'ข้าวผัดไข่', 'ข้าวผัดไข่', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220024', 'ไข่ดาว', 'ไข่ดาว', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220025', 'ข้าวผัดรวมมิตร', 'ข้าวผัดรวมมิตร', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220026', 'ข้าวราดกะเพารวมมิตร', 'ข้าวราดกะเพารวมมิตร', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220027', 'ข้าวต้มกุ้ง', 'ข้าวต้มกุ้ง', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '220028', 'ข้าวต้มหมู', 'ข้าวต้มหมู', '', '22', '1', '22', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '230002', 'ค่าไฟ', 'ค่าไฟ', '', '23', '4', '23', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '230003', 'คาราโอเกะ', 'คาราโอเกะ', '', '23', '4', '23', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '230006', 'ค่าห้อง', 'ค่าห้อง', '', '23', '4', '23', '5', 0, '', 0, '0', 0),
('001', '001', 'K01', '230011', 'ออกจะบอก', 'ออกจะบอก', '', '23', '4', '23', '123456', 0, '', 0, '0', 0),
('001', '001', 'K01', '240005', 'GV 2000 (แถมฟรี)', 'GV 2000 (แถมฟรี)', '', '24', '4', '24', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '240006', 'GV ชุด A (10,000บาท)', 'GV ชุด A (10,000บาท)', '', '24', '4', '24', '', 0, '', 0, '0', 0);
INSERT INTO `productsetting` (`CompanyId`, `BrandId`, `OutletId`, `ItemId`, `LocalName`, `EnglishName`, `OtherName`, `CategoryId`, `DepartmentId`, `ShowOnCategory`, `PrintTo`, `LocalPrint`, `KitchenLang`, `ReduceQty`, `QtyOnHand`, `StockOut`) VALUES
('001', '001', 'K01', '240007', 'GV ชุด B (5,000บาท)', 'GV ชุด B (5,000บาท)', '', '24', '4', '24', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '240008', 'GV 500 (แถมฟรี)', 'GV 500 (แถมฟรี)', '', '24', '4', '24', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '250001', 'มารโบโล่ (ขาว)', 'มารโบโล่ (ขาว)', '', '25', '4', '25', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '250002', 'มารโบโล่ (แดง)', 'มารโบโล่ (แดง)', '', '25', '4', '25', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '250003', 'มารโบโล่ (เขียว)', 'มารโบโล่ (เขียว)', '', '25', '4', '25', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '250004', 'กรองทิพย์', 'กรองทิพย์', '', '25', '4', '25', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '250005', 'สายฝน', 'สายฝน', '', '25', '4', '25', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '250006', 'ไฟแช็ค', 'ไฟแช็ค', '', '25', '4', '25', '', 0, '', 0, '0', 0),
('001', '001', 'K01', '350001', 'ยำหมูยอไข่แดง', 'ยำหมูยอไข่แดง', '', '35', '1', '35', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '350002', 'ยำปูม้ากุ้งแช่ (ดิบ)', 'ยำปูม้ากุ้งแช่ (ดิบ)', '', '35', '1', '35', '2', 0, '', 0, '0', 0),
('001', '001', 'K01', '350003', 'ยำซีฟู๊ด (ลวก)', 'ยำซีฟู๊ด (ลวก)', '', '35', '1', '35', '2', 0, '', 0, '0', 0);

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
('001', '001', 'K01', '010001', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 1, 0),
('001', '001', 'K01', '010002', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010003', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010004', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010005', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010006', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010007', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010008', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010009', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010010', '1', '', '', '', 1, '195.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010012', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010013', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010014', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010015', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '010016', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020002', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020003', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020004', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020005', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020006', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020007', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020008', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020009', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020010', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020011', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020012', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020013', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020014', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020015', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '020020', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030002', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030003', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030004', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030005', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030006', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030007', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030008', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030009', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030010', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030011', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030012', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030015', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030018', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030020', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030021', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030022', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030023', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030024', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030025', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030026', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030027', '1', '', '', '', 1, '195.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030028', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030030', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030031', '1', '', '', '', 1, '410.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030032', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '030033', '1', '', '', '', 1, '350.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040001', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040002', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040003', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040004', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040005', '1', '', '', '', 1, '250.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040006', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040007', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040008', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040009', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040010', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040011', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040012', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040014', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040015', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040016', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040017', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040018', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040019', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040020', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040021', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040022', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040023', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040024', '1', '', '', '', 1, '260.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040025', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040026', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040027', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040028', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040029', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040030', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040031', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040034', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040035', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040036', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '040037', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050001', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 1, 0),
('001', '001', 'K01', '050002', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050003', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050004', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050005', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050006', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050007', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050008', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050009', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050010', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050011', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050012', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050014', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050015', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050016', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050017', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050018', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050019', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050020', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050021', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050022', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050023', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050024', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050025', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050026', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050028', '1', '', '', '', 1, '75.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050029', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '050030', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060001', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060002', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060003', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060004', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060005', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060006', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060007', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060008', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060010', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060011', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060012', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060013', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060014', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060015', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060016', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060018', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060019', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060020', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060021', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060022', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060023', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060024', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060025', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060026', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060027', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '060028', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070001', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070002', '1', '', '', '', 1, '250.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070003', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070004', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070005', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070006', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070007', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070008', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070009', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070010', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070011', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070012', '1', '', '', '', 1, '250.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070013', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070014', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070015', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070016', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070018', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070019', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070020', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070021', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070022', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070023', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070024', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070025', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070026', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070027', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070028', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070029', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070030', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070031', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070032', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070033', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070034', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070035', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070036', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070037', '1', '', '', '', 1, '250.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070038', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070039', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070040', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070041', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070042', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070043', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070044', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070045', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070046', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070047', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070048', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070049', '1', '', '', '', 1, '140.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070050', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070052', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070053', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070054', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070055', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070056', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '070057', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080001', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080002', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080003', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080004', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080005', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080006', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080007', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080008', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080009', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080010', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080011', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080012', '1', '', '', '', 1, '195.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080013', '1', '', '', '', 1, '195.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080014', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080015', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080016', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080017', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080018', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080019', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080020', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080021', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080022', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080023', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080024', '1', '', '', '', 1, '250.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080025', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080026', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080027', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080028', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080029', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '080030', '1', '', '', '', 1, '150.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090001', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090002', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090003', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090004', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090005', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090006', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090007', '1', 'ถ้วย', 'ถ้วย', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090007', '2', 'ครึ่งโล', 'ครึ่งโล', '', 0, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090007', '3', 'กก.', 'กก.', '', 0, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090008', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090009', '1', '.', '.', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090009', '2', 'ห่อ', 'ห่อ', '', 0, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090010', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090011', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090012', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090013', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090014', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090015', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090016', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090017', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090018', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090019', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090020', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090024', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090025', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '090026', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100001', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100002', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100003', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100005', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100006', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100008', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100010', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100011', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100012', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100013', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100014', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100016', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100020', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100021', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100022', '1', 'เล็ก', 'เล็ก', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100022', '2', 'ใหญ่', 'ใหญ่', '', 0, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100022', '3', 'แก้ว', 'แก้ว', '', 0, '2.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100023', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100024', '1', '', '', '', 1, '10.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100025', '1', 'แก้ว', 'แก้ว', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100025', '2', 'เหยือก', 'เหยือก', '', 0, '69.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '100027', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110001', '1', '', '', '', 1, '120.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110002', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110003', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110005', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '110006', '1', '', '', '', 1, '85.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120002', '1', '', '', '', 1, '2000.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120003', '1', '', '', '', 1, '1200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120004', '1', '', '', '', 1, '550.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120007', '1', '', '', '', 1, '400.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120008', '1', '', '', '', 1, '700.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120015', '1', 'ถ้วย', 'ถ้วย', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120015', '2', '1/2Km', '1/2Km', '', 0, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120015', '3', '1Km', '1Km', '', 0, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120023', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '120024', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130001', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130002', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130003', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130004', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130005', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130006', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130008', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130009', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130010', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130013', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '130014', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140001', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140003', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140004', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140006', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140007', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140008', '1', '', '', '', 1, '400.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140020', '1', '', '', '', 1, '180.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140021', '1', '', '', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140023', '1', '', '', '', 1, '70.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140024', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140025', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140026', '1', '', '', '', 1, '170.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140028', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140032', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140033', '1', '', '', '', 1, '200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140035', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140036', '1', '', '', '', 1, '220.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140037', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140039', '1', '', '', '', 1, '270.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140041', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140042', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140044', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140045', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140046', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140047', '1', '', '', '', 1, '55.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140048', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140049', '1', '', '', '', 1, '55.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140061', '1', '', '', '', 1, '35.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140072', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140073', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140074', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140075', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140078', '1', '', '', '', 1, '65.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140079', '1', '', '', '', 1, '319.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140080', '1', '', '', '', 1, '499.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140081', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140082', '1', '', '', '', 1, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140083', '1', '', '', '', 1, '750.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140084', '1', '', '', '', 1, '1200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140093', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140094', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140095', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140096', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '140097', '1', '', '', '', 1, '45.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150001', '1', '', '', '', 1, '1700.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150002', '1', '', '', '', 1, '1200.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150003', '1', '', '', '', 1, '750.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150004', '1', '', '', '', 1, '400.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150005', '1', '', '', '', 1, '550.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150006', '1', '', '', '', 1, '340.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150007', '1', '', '', '', 1, '230.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150008', '1', '', '', '', 1, '290.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150009', '1', '', '', '', 1, '1600.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150017', '1', '', '', '', 1, '900.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150018', '1', '', '', '', 1, '2000.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150019', '1', '', '', '', 1, '500.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '150020', '1', '', '', '', 1, '360.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190001', '1', '', '', '', 1, '199.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190002', '1', '', '', '', 1, '299.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190003', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190005', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190007', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190008', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190009', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '190015', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200001', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200002', '1', '', '', '', 1, '10.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200003', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200004', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200005', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200006', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200007', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200008', '1', '', '', '', 1, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200009', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200010', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200011', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200012', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200013', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200014', '1', '', '', '', 1, '50.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200015', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200016', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200017', '1', '', '', '', 1, '30.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200018', '1', '', '', '', 1, '450.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200019', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200020', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200021', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '200023', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '210001', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '210002', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '210003', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '210004', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '210005', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '210006', '1', '', '', '', 1, '25.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '210007', '1', '', '', '', 1, '40.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220001', '1', '', '', '', 1, '130.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220002', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220002', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220003', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220003', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220004', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220004', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220005', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220005', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220006', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220006', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220007', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220007', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220008', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220008', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220009', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220009', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220010', '1', 'เล็ก', 'เล็ก', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220010', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220011', '1', 'เล็ก', 'เล็ก', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220011', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220012', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220013', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220014', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220015', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220016', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220017', '1', 'จาน', 'จาน', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220017', '2', 'โถ', 'โถ', '', 0, '60.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220018', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220019', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220020', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220021', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220022', '1', '', '', '', 1, '20.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220023', '1', 'เล็ก', 'เล็ก', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220023', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220024', '1', '', '', '', 1, '15.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220025', '1', 'เล็ก', 'เล็ก', '', 1, '90.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220025', '2', 'ใหญ่', 'ใหญ่', '', 0, '190.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220026', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220027', '1', '', '', '', 1, '100.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '220028', '1', '', '', '', 1, '80.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '230002', '1', '', '', '', 1, '500.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '230003', '1', '', '', '', 1, '3500.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '230006', '1', '', '', '', 1, '300.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '230011', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '240005', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '240006', '1', '', '', '', 1, '10000.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '240007', '1', '', '', '', 1, '5000.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '240008', '1', '', '', '', 1, '0.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '250001', '1', '', '', '', 1, '145.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '250002', '1', '', '', '', 1, '145.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '250003', '1', '', '', '', 1, '145.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '250004', '1', '', '', '', 1, '110.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '250005', '1', '', '', '', 1, '95.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '250006', '1', '', '', '', 1, '10.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '350001', '1', '', '', '', 1, '160.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '350002', '1', '', '', '', 1, '260.0000', 0, 0, 0, 0, 0, 0),
('001', '001', 'K01', '350003', '1', '', '', '', 1, '280.0000', 0, 0, 0, 0, 0, 0);

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
('001', '001', 'K01', '2019-10-22', '001', '13:36', 'N', '', 1, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '002', '13:36', 'N', '', 2, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '003', '14:10', 'N', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '004', '15:30', 'N', '', 5, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '005', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '006', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '007', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '008', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '009', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S'),
('001', '001', 'K01', '2019-10-22', '010', '', '', '', 0, 0, NULL, 0, NULL, 1, 'S');

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
,`Level` int(2) unsigned
,`SubLevel` int(3) unsigned
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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ordering`  AS  select `ordering`.`CompanyId` AS `CompanyId`,`ordering`.`BrandId` AS `BrandId`,`ordering`.`OutletId` AS `OutletId`,`ordering`.`TableNo` AS `TableNo`,`ordering`.`ItemNo` AS `ItemNo`,`ordering`.`ItemId` AS `ItemId`,`ordering`.`ItemName` AS `ItemName`,`ordering`.`LocalName` AS `LocalName`,`ordering`.`EnglishName` AS `EnglishName`,`ordering`.`OtherName` AS `OtherName`,`ordering`.`SizeName` AS `SizeName`,`ordering`.`SizeLocalName` AS `SizeLocalName`,`ordering`.`SizeEnglishName` AS `SizeEnglishName`,`ordering`.`SizeOtherName` AS `SizeOtherName`,`ordering`.`SizeId` AS `SizeId`,`ordering`.`OrgSize` AS `OrgSize`,`ordering`.`DepartmentId` AS `DepartmentId`,`ordering`.`CategoryId` AS `CategoryId`,`ordering`.`AddModiCode` AS `AddModiCode`,`ordering`.`TotalAmount` AS `TotalAmount`,`ordering`.`Quantity` AS `Quantity`,`ordering`.`OrgQty` AS `OrgQty`,`ordering`.`UnitPrice` AS `UnitPrice`,`ordering`.`Free` AS `Free`,`ordering`.`noService` AS `noService`,`ordering`.`noVat` AS `noVat`,`ordering`.`Status` AS `Status`,`ordering`.`PrintTo` AS `PrintTo`,`ordering`.`NeedPrint` AS `NeedPrint`,`ordering`.`LocalPrint` AS `LocalPrint`,`ordering`.`KitchenLang` AS `KitchenLang`,`ordering`.`Parent` AS `Parent`,`ordering`.`Child` AS `Child`,`ordering`.`OrderDate` AS `OrderDate`,`ordering`.`OrderTime` AS `OrderTime`,`ordering`.`KitchenNote` AS `KitchenNote`,`ordering`.`SystemDate` AS `SystemDate`,`ordering`.`StartTime` AS `StartTime`,`ordering`.`ReferenceId` AS `ReferenceId`,`ordering`.`MainItem` AS `MainItem`,`fGetImageURL`(`ordering`.`CompanyId`,`ordering`.`BrandId`,`ordering`.`OutletId`,`ordering`.`ItemId`) AS `image`,`fOrderingItemTotalAmount`(`ordering`.`CompanyId`,`ordering`.`BrandId`,`ordering`.`OutletId`,`ordering`.`SystemDate`,`ordering`.`TableNo`,`ordering`.`StartTime`,`ordering`.`ItemNo`) AS `TotalAmountSummery`,`ordering`.`Level` AS `Level`,`ordering`.`SubLevel` AS `SubLevel`,`ordering`.`isPackage` AS `isPackage` from `ordering` ;

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
-- Indexes for table `mytableevents`
--
ALTER TABLE `mytableevents`
  ADD PRIMARY KEY (`id`) USING BTREE;

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
-- AUTO_INCREMENT for table `mytableevents`
--
ALTER TABLE `mytableevents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

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
