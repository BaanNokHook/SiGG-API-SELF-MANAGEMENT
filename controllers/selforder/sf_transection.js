/**
* selforder master file.
* service for manage transection.
*/

var pool = require("../../services/pool");
var tools = require("../../util/tools");

// Input Guest 
exports.inputPax = async function (req, res) {

   tools.Logfile('inputPax parameter', JSON.stringify(req.body));
   let cParameter = await tools.HeaderParamToString(JSON.stringify(req.body));
   let sql = "CALL pInputPax(" + cParameter + ");";

   try {
      await pool.query(sql);
      res.code(200).send(req.body);
   }
   catch (err) {
      // tools.Logfile('inputPax ERROR', err.message); 
      console.log(err.message);
   }
};

// Delete Item&Modify form ordering
exports.orderingItemDelete = async function (req, res) {
   tools.Logfile('orderingItemDelete parameter %%%%% : ', JSON.stringify(req.body));
   let cParameter = await tools.HeaderParamToString(JSON.stringify(req.body));
   let sql = "SELECT fOrderingItemDelete(" + cParameter + ");";

   try {
      await pool.query(sql);
      res.code(200).send(req.body);
   }
   catch (err) { tools.Logfile('orderingItemDelete ERROR', err.message); }
};

// save ordering ( save per 1 item & modifier)
exports.saveOrdering = async function (req, res) {
   let tStartTime = new Date();
   tools.Logfile('saveOrdering Start : ', JSON.stringify(req.body[0][0]));
   var JA_Ordering = req.body;

   // input the sublevel into package for isPackage = 1   : david 20191022
   // ----- order header. ------
   JA_Ordering.forEach(async (obj, index) => {
      var chkLevel = 0;
      var chkItemNo = 0;
      var nRunning = 0;
      // ----- order detail. -----
      for (const i of obj) {
         // Re-Genereat SubLevel : David 20191024
         // if (i.isPackage === 1) {
         if (i.SubLevel === 999) {
            if (i.Level === 0) {      // Package Header 
               i.SubLevel = 0;
            } else {                // Package Detail 
               if (chkItemNo !== i.ItemNo) { nRunning = 0; };
               if (chkLevel !== i.Level) { nRunning = 0; };
               // nRunning = (i.MainItem === 1) ? Math.floor(nRunning) + 1 : nRunning + 0.01;  // sublevel = 1.01
               nRunning += 1;
               i.SubLevel = nRunning;
               chkLevel = i.Level;
               chkItemNo = i.ItemNo;
            }
         }
         // Calculate Total Amount : David 20191025
         if ((i.Free === true) || (i.SubLevel > 0)) {
            if (i.ItemId.substr(0, 1) !== "M") { // Modify in sublevel have price no reset.
               i.TotalAmount = 0;
               i.UnitPrice = 0;
            }
         } else {
            i.TotalAmount = i.Quantity * i.UnitPrice;
         }
         // console.log( 'free,sublevel,totalamount ',i.Free, i.SubLevel, i.TotalAmount);
      }
   });


   // ******************** Save Order Header Loop ********************
   JA_Ordering.forEach(async (obj, index) => {
      let chkitemno = obj[0].ItemNo;
      var ItemNo = '';
      var newItemNo = '';

      if (chkitemno == undefined || chkitemno == 0) {
         let p = obj[0];
         let cParameter = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "','" + p.SystemDate + "','" + p.TableNo + "','" + p.StartTime + "'";
         // let cParameter = await tools.HeaderParamToString(JSON.stringify(obj[0]));
         let SqlNewItem = "SELECT getNewItemNO(" + cParameter + ") as ItemNo;";
         try {
            let row = await pool.query(SqlNewItem);
            ItemNo = row[0].ItemNo;
         } catch (err) { tools.Logfile('saveOrdering Gen New Item', err.message); }
         newItemNo = await ItemNo;
         // console.log("=====> get new ItemNo : ", newItemNo); 
      } else {
         newItemNo = await chkitemno;
         // deltet old data first.
         let cParameter = await tools.HeaderParamToString(JSON.stringify(obj[0]));
         let SqlDelItem = "SELECT fOrderingItemDelete(" + cParameter + ");";
         try {
            let chk = await pool.query(SqlDelItem);
         }
         catch (err) { tools.Logfile('orderingItemDelete ERROR', err.message); }
      };
      // console.log("====> new item no : ", newItemNo);

      // ******************** Save Order Detail Loop ************************
      obj.forEach(async (ordDetail, index) => {
         let chk = await SaveOrderingDetail(ordDetail, newItemNo);
      });

   });
   tools.Logfile('saveOrdering Complete : ', JSON.stringify(req.body[0][0]));
   tools.LogTimeStamp('SaveOrdering : ', JSON.stringify(req.params), tStartTime, new Date());
   res.code(200).send('{"Status":"COMPLETE"}');
};

// Insert Order Detail to database.
SaveOrderingDetail = (pOrdDetail, pItemNo) => {
   // console.log("save ordering : ", JSON.stringify(pOrdDetail));
   let obj = pOrdDetail;
   let ItemNo = pItemNo;
   tools.Logfile('save ordering source : ', JSON.stringify(pOrdDetail));
   // console.log("==>itemNo:", pItemNo, " Name:", pOrdDetail.EnglishName);
   let sql = '';
   sql = "INSERT INTO `ordering` ";
   sql += " (`CompanyId`, `BrandId`, `OutletId`, `TableNo`,`SystemDate`, `StartTime`,";
   sql += " `ItemNo`, `Level`,`SubLevel`,`ItemId`,`ReferenceId`, `ItemName`, `LocalName`, `EnglishName`, `OtherName`,";
   sql += " `SizeName`, `SizeLocalName`, `SizeEnglishName`, `SizeOtherName`, `SizeId`, `OrgSize`, ";
   sql += " `DepartmentId`, `CategoryId`, `AddModiCode`, `TotalAmount`, `Quantity`, `OrgQty`, `UnitPrice`, ";
   sql += " `Free`, `noService`, `noVat`, `Status`, `PrintTo`, `NeedPrint`, `LocalPrint`, `KitchenLang`, ";
   sql += " `Parent`, `Child`, `OrderDate`, `OrderTime`, `KitchenNote`,`MainItem`,`GuestName`,`isPackage`,`is_Device`,`Includetax`) ";
   sql += "VALUES (";
   sql += "'" + checkUndefined(obj.CompanyId, '') + "',";
   sql += "'" + checkUndefined(obj.BrandId, '') + "',";
   sql += "'" + checkUndefined(obj.OutletId, '') + "',";
   sql += "'" + checkUndefined(obj.TableNo, '') + "',";
   sql += "'" + checkUndefined(obj.SystemDate, '') + "',";
   sql += "'" + checkUndefined(obj.StartTime, '') + "',";
   sql += "'" + (ItemNo) + "',";
   sql += "" + checkUndefined(obj.Level, '0') + ",";
   sql += "" + checkUndefined(obj.SubLevel, '0') + ",";
   sql += "'" + checkUndefined(obj.ItemId, '') + "',";
   sql += "'ReferenceId',";
   sql += "'" + checkUndefined(obj.ItemName, '') + "',";
   sql += "'" + checkUndefined(obj.LocalName, '') + "',";
   sql += "'" + checkUndefined(obj.EnglishName, '') + "',";
   sql += "'" + checkUndefined(obj.OtherName, '') + "',";
   sql += "'" + checkUndefined(obj.SizeName, '') + "',";
   sql += "'" + checkUndefined(obj.SizeLocalName, '') + "',";
   sql += "'" + checkUndefined(obj.SizeEnglishName, '') + "',";
   sql += "'" + checkUndefined(obj.SizeOtherName, '') + "',";
   sql += "'" + checkUndefined(obj.SizeId, '') + "',";
   sql += "'',"; //OrgSize  '0' change to empay
   sql += "'" + checkUndefined(obj.DepartmentId, '') + "',";
   sql += "'" + checkUndefined(obj.CategoryId, '') + "',";
   sql += "'" + checkUndefined(obj.AddModiCode, '') + "',"; //AddModiCode
   sql += "'" + (obj.TotalAmount) + "',"; //TotalAmount
   sql += "'" + (obj.Quantity) + "',";//Quantity
   sql += "'" + (obj.OrgQty) + "',";
   sql += "'" + (obj.UnitPrice) + "',";//UnitPrice
   sql += "" + (obj.Free) + ",";//Free
   sql += "" + (obj.noService) + ",";//noService
   sql += "" + (obj.noVat) + ",";//noVat
   sql += "'" + checkUndefined(obj.Status, '*') + "',"; //Status
   sql += "'" + checkUndefined(obj.PrintTo, '') + "',";
   sql += "" + checkUndefined(obj.NeedPrint, '') + ","; //NeedPrint
   sql += "" + checkUndefined(obj.LocalPrint, '') + ",";//localPrint
   sql += "'" + checkUndefined(obj.KitchenLang, '') + "',";//KitchenLang
   sql += "" + checkUndefined(obj.Parent, '') + ",";//Parent
   sql += "" + checkUndefined(obj.Child, '') + ",";//Child
   sql += "CURRENT_DATE(),";
   sql += "CURRENT_TIME(),";
   sql += "'" + checkUndefined(obj.KitchenNote, '') + "',";//KitchenNote
   sql += "" + checkUndefined(obj.MainItem, '0') + ",";// MainItem
   sql += "'" + checkUndefined(obj.GuestName, '') + "',";// GuestName
   sql += "'" + checkUndefined(obj.isPackage, '') + "',";// isPackage
   sql += "'" + checkUndefined(obj.isDevice, '') + "',";// is Device
   sql += "" + checkUndefined(obj.Includetax, '') + "";//Includetax
   sql += " ); ";

   // console.log(sql);
   tools.Logfile('() => save ordering sql : ', sql);

   try {
      pool.query(sql);
   }
   catch (err) { tools.Logfile('OrderDetail ERROR:', err.message); }

};

// check undefined field or empty string in field.
checkUndefined = (MasterObject, DefaultValue) => {
   return (typeof MasterObject === 'undefined' || MasterObject === '' ? DefaultValue : MasterObject);
};


// Move ordering to ordered ( send kitchen )
exports.moveOrderingToOrdered = async function (req, res) {
   tools.Logfile('moveOrderingToOrdered Start : ', JSON.stringify(req.body));
   let cParameter = await tools.HeaderParamToString(JSON.stringify(req.body));
   let obj = { "result": "ERROR" };

   //  Validate Table not Lock by POS3
   let tSql = "SELECT fCheckCanSendOrdering(" + cParameter + ") as CanOrder ;";
   let tStatus = await pool.query(tSql);
   // await tools.Logfile("Table Status : ", JSON.stringify(tStatus[0]));
   if (tStatus[0].CanOrder !== 1) {
      obj.result = "TABLELOCK";
      tools.Logfile("Can't order TABLELOCK: ", JSON.stringify(obj));
      res.code(200).send(JSON.stringify(obj));
      return;
   };

   /** Add UUID to pMoveOrderingToOrderDetail(cParameter, UUID) */
   let sql = "CALL pMoveOrderingToOrderDetail(" + cParameter + ");";

   try {
      await pool.query(sql);
      obj.result = "SUCCESS";
      // res.send(req.body);   
   }
   catch (err) { tools.Logfile('moveOrderingToOrdered ERROR', err.message); }
   // tools.Logfile("Order Success : ", JSON.stringify(obj));
   tools.Logfile('moveOrderingToOrdered Complete : ', JSON.stringify(req.body));
   res.code(200).send(JSON.stringify(obj));

};

// Move ordering to ordered ( send kitchen )
exports.moveOrderingToOrderedByUUID = async function (req, res) {
   tools.Logfile('moveOrderingToOrdered ByUUID Start : ', JSON.stringify(req.body));
   let p = req.body;
   let resUUID = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "','" + p.SystemDate + "','" + p.TableNo + "','" + p.StartTime + "','"+p.isDevice+"'";
   console.log("moveOrderingToOrderedByUUID()=> ", [resUUID, JSON.stringify(req.body)]);
   let cParameter = await tools.HeaderParamToString(JSON.stringify(req.body));
   let obj = { "result": "ERROR" };

   //  Validate Table not Lock by POS3
   let tSql = "SELECT fCheckCanSendOrdering(" + cParameter + ") as CanOrder ;";
   let tStatus = await pool.query(tSql);
   // await tools.Logfile("Table Status : ", JSON.stringify(tStatus[0]));
   /*if (tStatus[0].CanOrder !== 1) {
      obj.result = "TABLELOCK";
      tools.Logfile("Can't order TABLELOCK: ", JSON.stringify(obj));
      res.code(200).send(JSON.stringify(obj));
      return;
   };*/

   /** Add UUID to pMoveOrderingToOrderDetail(cParameter, UUID) */
   let sql = "CALL pMoveOrderingToOrderDetailByUUID(" + resUUID + ");";

   try {
      await pool.query(sql);
      obj.result = "SUCCESS";
      // res.send(req.body);   
   }
   catch (err) { tools.Logfile('moveOrderingToOrderedByUUID ERROR', err.message); }
   // tools.Logfile("Order Success : ", JSON.stringify(obj));
   tools.Logfile('moveOrderingToOrderedByUUID Complete : ', JSON.stringify(req.body));
   res.code(200).send(JSON.stringify(obj));
};

// remove multi item.
exports.RemoveMultiItem = async function (req, res) {
   tools.Logfile('callRemoveMultiItems Start : ', JSON.stringify(req.body));
   var p = req.body;
   var result = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "','" + p.SystemDate + "','" + p.TableNo + "','" + p.StartTime + "'";
   var KeysItems = p.KeysItems.split('|');

   KeysItems.forEach((data, index) => {
      let cParameter = result + "," + data;
      var sql = "SELECT fOrderingItemDelete(" + cParameter + ");";
      try {
         pool.query(sql);
      }
      catch (err) {
         tools.Logfile('orderingItemDelete ERROR', err.message);
         return;
      }
   });
   tools.Logfile('callRemoveMultiItems Complete : ', JSON.stringify(req.body));
   res.code(200).send(req.body);

};

// call check bill (Billing).
exports.CallBilling = async function (req, res) {
   tools.Logfile('callBilling Start : ', JSON.stringify(req.body));
   let cParameter = await tools.HeaderParamToString(JSON.stringify(req.body));
   let sql = "CALL pCallBilling(" + cParameter + ");";
   try {
      await pool.query(sql);
      res.code(200).send('{"Status":"SUCCESS"}');
   }
   catch (err) { tools.Logfile('callBilling ERROR', err.message); }
   tools.Logfile('callBilling Complete : ', JSON.stringify(req.body));
};

// call waiter.
exports.callWaiter = async function (req, res) {
   tools.Logfile('callWaiter Start : ', JSON.stringify(req.body));
   let cParameter = await tools.HeaderParamToString(JSON.stringify(req.body));
   let sql = "CALL pCallWaiter(" + cParameter + ");";

   try {
      await pool.query(sql);
      res.code(200).send('{"Status":"SUCCESS"}');
   }
   catch (err) { tools.Logfile('callWaiter ERROR', err.message); }
   tools.Logfile('callWaiter Compete : ', JSON.stringify(req.body));
};


//******************* Transection  *******************/
exports.getOrderingAll = async function (req, res, next) {
   // tools.Logfile('getorderingall Start : ',JSON.stringify(req.params));

   /**  */
   let sql = ""
   sql += " SELECT * FROM view_ordering";
   sql += " WHERE ";
   sql += " view_ordering.CompanyId = '" + req.params.CompanyId + "' AND ";
   sql += " view_ordering.BrandId = '" + req.params.BrandId + "' AND ";
   sql += " view_ordering.OutletId = '" + req.params.OutletId + "' AND";
   sql += " view_ordering.TableNo = '" + req.params.TableNo + "' AND ";
   sql += " view_ordering.SystemDate = '" + req.params.SystemDate + "' AND ";
   sql += " view_ordering.StartTime = '" + req.params.StartTime + "' ";
   sql += ";";

   try {
      const rows = await pool.query(sql);
      res.code(200).send(JSON.stringify(rows));
   }
   catch (err) { tools.Logfile('getorderingall ERROR', err.message); }

   // tools.Logfile('getorderingall Complete : ',JSON.stringify(req.params));
};


exports.getOrderingAllByUUID = async function (req, res, next) {
   // tools.Logfile('getorderingall Start : ',JSON.stringify(req.params));

   /**  */
   let sql = ""
   sql += " SELECT * FROM view_ordering";
   sql += " WHERE ";
   sql += " view_ordering.CompanyId = '" + req.params.CompanyId + "' AND ";
   sql += " view_ordering.BrandId = '" + req.params.BrandId + "' AND ";
   sql += " view_ordering.OutletId = '" + req.params.OutletId + "' AND";
   sql += " view_ordering.TableNo = '" + req.params.TableNo + "' AND ";
   sql += " view_ordering.SystemDate = '" + req.params.SystemDate + "' AND ";
   sql += " view_ordering.StartTime = '" + req.params.StartTime + "' AND ";
   sql += " view_ordering.isDevice = '" + req.params.isDevice + "' ";
   sql += ";";

   // console.log("getOrderingAllByUUID()=> ", sql);
   try {
      const rows = await pool.query(sql);
      res.code(200).send(JSON.stringify(rows));
   }
   catch (err) { tools.Logfile('getorderingall ERROR', err.message); }
   // tools.Logfile('getorderingall Complete : ',JSON.stringify(req.params));
};

exports.getOrderDetailAll = async function (req, res, next) {
   // tools.Logfile('getorderdetailall Start : ',JSON.stringify(req.params));
   let sql = ""
   sql += " SELECT * FROM view_orderdetail";
   sql += " WHERE ";
   sql += " view_orderdetail.CompanyId = '" + req.params.CompanyId + "' AND ";
   sql += " view_orderdetail.BrandId = '" + req.params.BrandId + "' AND ";
   sql += " view_orderdetail.OutletId = '" + req.params.OutletId + "' AND";
   sql += " view_orderdetail.TableNo = '" + req.params.TableNo + "' AND ";
   sql += " view_orderdetail.SystemDate = '" + req.params.SystemDate + "' AND ";
   sql += " view_orderdetail.StartTime = '" + req.params.StartTime + "'; ";

   try {
      const rows = await pool.query(sql);
      res.code(200).send(JSON.stringify(rows));
   }
   catch (err) { tools.Logfile('getorderdetailall ERROR', err.message); }
   // tools.Logfile('getorderdetailall Complete : ',JSON.stringify(req.params));

};
