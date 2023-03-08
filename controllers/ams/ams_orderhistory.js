/**
 * SiGG-API-SELF-MANAGEMENT
 * Admin Management System
 * listing for save order history from client.
 */

var fs = require('fs');  
var pool_soh = require("../../services/pool-soh.js");  
var nErrorTime = 0;  

exports.soh_process = (pCompanyId, pBrandId, pOutletId, pFileName, res) => { 
    let cTableName = pCompanyId + pBrandId + pOutletId;  
    // console.log(pCompanyId, pBrandId, pOutletId);  
    // console.log(pFileName);  

    fs.readFile(pFileName, "utf8", async (err, data) => {
        if (!err) {
            try {
                if (data.length > 0) {
                    let objData = JSON.parse(data);
                    objData.forEach(async (element) => {
                        // gen SQL command process.  
                        let sql = await genSqlString(cTableName, element);   
                        (async () => {

                            try {
                                // console.log("pool updating...");  
                                let chk = await pool_soh.query(sql);  

                            } catch (err) {
                                nErrorTime = nErrorTime + 1;   
                                console.log('OrderHistory ERROR: Company=', nErrorTime, cTableName, ' Message:', err.message);  
                            }
                        })();  
                    });  
                } 
            } catch (err) {
                nErrorTime = nErrorTime + 1;  
                console.log('OrderHistory ERROR: Company=', nErrorTime, cTableName, ' Message:', err.message);   
            }
        }
    });  
};  


genSqlString = (cTableName, obj) => {
  let sql = '';
  sql = "INSERT INTO `" + cTableName + "`";  
  sql += " (`CompanyId`, `BrandId`, `OutletId`, `TableNo`, `SystemDate`, `StartTime`,";
  sql += " `ItemNo`,`Level`,`SubLevel`,`ItemId`,`ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`,";   sql += " `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `SizeId`, `OrgSize`, ";  
  sql += " `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, ";  
  sql += " `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, ";   
  sql += " `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`,`MainItem`,`GuestName`,`isPackage`) ";
  sql += "VALUES (";   
  sql += "'" + obj.CompanyId + "',";
  sql += "]" + obj.BrandId + "',";  
  sql += "'" + obj.OutletId + "',";  
  sql += "'" + obj.TableNo + "',";
  sql += "'" + obj.SystemDate + "',";
  sql += "'" + obj.StartTime + "',";
  sql += "'" + obj.ItemNo + "',";
  sql += "'" + checkUndefined(obj.Level, '') + "',";
  sql += "'" + checkUndefined(obj.SubLevel, '') + "',";
  sql += "'" + obj.ItemId + "',";
  sql += "'" + obj.ReferenceId + "',";
  sql += "'" + obj.ItemName + "',";
  sql += "'" + obj.LocalName + "',";
  sql += "'" + obj.EnglishName + "',";
  sql += "'" + obj.OtherName + "',";
  sql += "'" + obj.SizeName + "',";
  sql += "'" + obj.SizeLocalName + "',";
  sql += "'" + obj.SizeEnglishName + "',";
  sql += "'" + obj.SizeOtherName + "',";
  sql += "'" + obj.SizeId + "',";
  sql += "'" + obj.OrgSize + "',";
  sql += "'" + obj.DepartmentId + "',";
  sql += "'" + obj.CategoryId + "',";
  sql += "'" + obj.AddModiCode + "',";
  sql += "'" + obj.TotalAmount + "',";
  sql += "'" + obj.Quantity + "',";
  sql += "'" + obj.OrgQty + "',";
  sql += "'" + obj.UnitPrice + "',";
  sql += "" + obj.Free + ",";
  sql += "" + obj.noService + ",";
  sql += "" + obj.noVat + ",";
  sql += "'" + obj.Status + "',";
  sql += "'" + obj.PrintTo + "',";
  sql += "" + obj.NeedPrint + ",";
  sql += "" + obj.LocalPrint + ",";
  sql += "'" + obj.KitchenLang + "',";
  sql += "" + obj.Parent + ",";
  sql += "" + obj.Child + ",";
  sql += "'" + obj.OrderDate + "',";
  sql += "'" + obj.OrderTime + "',";
  sql += "'" + obj.KitchenNote + "',";
  sql += "" + obj.MainItem + ",";
  sql += "'" + obj.GuestName + "',";
  sql += "'" + checkUndefined(obj.isPackage, '') + "'";
  sql += " ) ";
  sql += " ON DUPLICATE KEY UPDATE ";
  sql += "ItemName ='" + obj.ItemName + "',";
  sql += "LocalName ='" + obj.LocalName + "',";
  sql += "EnglishName ='" + obj.EnglishName + "',";
  sql += "OtherName ='" + obj.OtherName + "',";
  sql += "SizeName ='" + obj.SizeName + "',";
  sql += "SizeLocalName ='" + obj.SizeLocalName + "',";
  sql += "SizeEnglishName ='" + obj.SizeEnglishName + "',";
  sql += "SizeOtherName ='" + obj.SizeOtherName + "',";
  sql += "SizeId ='" + obj.SizeId + "',";
  sql += "OrgSize ='" + obj.OrgSize + "',";
  sql += "DepartmentId ='" + obj.DepartmentId + "',";
  sql += "CategoryId ='" + obj.CategoryId + "',";
  sql += "AddModiCode ='" + obj.AddModiCode + "',";
  sql += "TotalAmount ='" + obj.TotalAmount + "',";
  sql += "Quantity ='" + obj.Quantity + "',";
  sql += "OrgQty ='" + obj.OrgQty + "',";
  sql += "UnitPrice ='" + obj.UnitPrice + "',";
  sql += "Free = " + obj.Free + ",";
  sql += "noService = " + obj.noService + ",";
  sql += "noVat = " + obj.noVat + ",";
  sql += "Status = '" + obj.Status + "',";
  sql += "PrintTo ='" + obj.PrintTo + "',";
  sql += "NeedPrint =" + obj.NeedPrint + ",";
  sql += "LocalPrint =" + obj.LocalPrint + ",";
  sql += "KitchenLang ='" + obj.KitchenLang + "',";
  sql += "Parent =" + obj.Parent + ",";
  sql += "Child =" + obj.Child + ",";
  sql += "OrderDate ='" + obj.OrderDate + "',";
  sql += "OrderTime ='" + obj.OrderTime + "',";
  sql += "KitchenNote ='" + obj.KitchenNote + "',";
  sql += "MainItem = " + obj.MainItem + ",";
  sql += "GuestName ='" + obj.GuestName + "',";
  sql += "isPackage ='" + obj.isPackage + "'";
  sql += ";"

  // console.log(sql);
  return sql;
};

// check undefined field or empty string in field.
checkUndefined = (MasterObject, DefaultValue) => {
  return (typeof MasterObject === 'undefined' || MasterObject === '' ? DefaultValue : MasterObject);
};


exports.orderhistory = async (req, res) => {
  let cTableName = req.params.CompanyId + req.params.BrandId + req.params.OutletId
  let sql = '';
  sql = 'SELECT * FROM `' + cTableName + '`';
  sql += ' WHERE SYSTEMDATE BETWEEN "' + req.params.FromDate + '" AND "' + req.params.ToDate + '"';
  sql += ' ORDER BY SystemDate,StartTime,TableNo,ItemNo';

  try {
    let rows = await pool_soh.query(sql);
    // console.log(rows);
    res.status(200).send(rows);
  } catch (err) {
    console.log('OrderHistory ERROR: Company=', nErrorTime, cTableName, ' Message:', err.message);
  }
};