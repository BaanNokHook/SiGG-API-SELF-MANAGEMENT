/**
* SiGG-API-SELF-MANAGEMENT
* selforder master file.
* service for get masterfile.
* 20190918 getProduct sorting by productrecommend.
*/

var pool = require("../../services/pool");
var tools = require("../../util/tools");

// Array variable inmemory loading
let mCategoryData = new Array();   
let mProductData = {};  
let mProductRecommend = new Array();   
let mProductSize = new Array();
let mProductPackage = new Array();  
let mModifyList = new Array();  

exports.getOutletSetting = async function (reg, res, next) {
  // tools.Logfile('getOutletSetting parameter',JSON.stringify(req.params));   
  let p = req.params;   
  let sql = "";  
  sql += " SELECT * FROM view_outletsetting";  
  sql += " WHERE ";  
  sql += " view_outletsetting.CompanyId = '" + p.CompanyId + "' AND ";  
  sql += " view_outletsetting.BrandId = '" + p.BrandId + "' AND ";
  sql += " view_outletsetting.OutletId = '" + p.outletId + "' ";   

  try {
    const rows = await pool.query(sql);   
    res.code(200).send(JSON.stringify(rows));   
  }  
  catch (err) { tools.Logfile('getOutletSetting ERROR', err.messsage); }  

};  

exports.getRounding = async function (req, res, next) {  
    // tools.Logfile('getOutletSetting parameter', JSON.stringify(req.params));  
    let p = req.params;   
    let sql = "";  
    sql += " SELECT * FROM `rounding`";   
    sql += " WHERE ";  
    sql += " CompanyId = '" + p.CompanyId + "' AND ";
    sql += " BrandId = '" + p.BrandId + "' AND ";  
    sql += " OutletId = '" + p.OutletId + "' ";  

    try {
        const rows = await pool.query(sql);  
        res.code(200).send(JSON.stringify(rows)); 
    }
    catch (err) { tools.Logfile('getOutletSetting ERROR', err.message); }   
};  

exports.getOutletTable = async function (req, res, next) {  
   // tools.Logfile('getOutletTable parameter',JSON.stringify(req.params));    
   let p = req.params;  
   let sql = ""   
   sql += " SELECT * FROM `view_table` ";   
   sql += " WHERE ";  
   sql += " CompanyId = '" + p.CompanyId + "' AND ";  
   sql += " BrandId = '" + p.BrandId + "' AND ";   
   sql += " OutletId = '" + p.OutletId + "' ";   
   
   try {
      const rows = await pool.query(sql);   
      res.code(200).send(JSON.stringify(rows));   
   }
   catch (err) { tools.LogFile('getOutletTable ERROR', err.message); }   

};  


exports.getCategory = async function (req, res, next) {
   tools.Logfile('getCategory parameter', JSON.stringify(req.params));   

   let p = req.params;  
   var cCBO = p.CompanyId + p.BrandId + p.OutletId;  

   let sqk = ""
   sql += " SELECT * FROM view_category";  
   sql += " WHERE ";  
   sql += " view_category.CompanyId = '" + p.CompanyId + "' AND ";   
   sql += " view_category.BrandId = '" + p.BrandId + "' AND ";   
   sql += " view_category.OutletId = '" + p.OutletId + "' ";   
   // console.log('mCategoryData[cCBO]-->', mCategoryData[cCBO]);  
   if (mCategoryData[cCBO] === undefined) {
    try {
        console.log(`( $({cCBO} in memory) loading Category...`);   
        const rows = await pool.query(sql);  
        mCategoryData[cCBO] = JSON.stringify(rows);   
    } catch (err) { tools.LogFile('getCategory ERROR', err.message); }
   };
   await res.code(200).send(mCategoryData[cCBO]);   

};


// this function realy used
exports.getProduct = async function (req, res, next) { 
    let tStartTime = new Date().toISOString();  
    tools.LogFile('getProduct Start : ', JSON.stringify(req.params));   
    // define parameter  
    let p = req.params; 
    let cParameter = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "'";  
    let cCBO = p.CompanyId + p.BrandId + p.OutletId;  
    let sql = "CALL pProductShowCategoryList(" + cParameter + ")";  
    
    if (mProductData[cCBO] === undefined) {
        console.log(`( ${cCBO} in memory) loading product...`);  
        try {
            const rows = await pool.query(sql);
            mProductData[cCBO] = JSON.stringify(rows[0]);   
        }  
        catch (err) { tools.LogFile('getProduct ERROR', err.message); }   
    };   

    tools.Logfile('getProduct Complete : ', JSON.stringify(req.params));  
    await res.code(200).send(mProductData[cCBO]);  

};  

exports.getProduct = async function (req, res, next) { 
   let tStartTime = new Date().toISOString();  
   tools.LogFile('getProduct Start : ', JSON.stringify(req.params));   
   // define parameter
   let p = req.params;  
   let cParameter = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "'";  
   let cCBO = p.CompanyId + p.BrandId + p.OutletId;  
   let sql = "CALL pProductShowCategoryList(" + cParameter + ")";   

   if (mProductData[cCBO] === undefined) {
     console.log(`( ${cCBO} in memory) loading product...`);   
     try {
        const rows = await pool.query(sql);  
        mProductData[cCBO] = JSON.stringify(rows[0]);
     }
     catch (err) { tools.Logfile('getProduct ERROR', err.message); }
   };  

   tools.LogFile('getProduct Complete : ', JSON.stringify(req.params));  
   await res.code(200).send(mProductData[cCBO]);   

};  

exports.getProduct_backup_v1 = async function (req, res, next) { 
   let tStartTime = new Date().toISOString();  
   tools.LogFile('getProduct Start : ', JSON.stringify(req.params));  
   let p = req.params;  
   let cCBO = p.CompanyId + p.BrandId + p.OutletId;

   let sql = ""  
   sql += " SELECT * FROM view_productdata";  
   sql += " WHERE ";  
   sql += " view_productdata.CompanyId = '" + p.CompanyId + "' AND ";
   sql += " view_productdata.BrandId = '" + p.BrandId + "' AND ";
   sql += " view_productdata.OutletId = '" + p.OutletId + "' ";

  if (mProductData[cCBO] === undefined) {
    console.log(`( ${cCBO} in memory) loading product...`);
    try {
      const rows = await pool.query(sql);
      mProductData[cCBO] = JSON.stringify(rows);
    } catch (err) { tools.Logfile('getProduct ERROR', err.message); }
  };
  tools.Logfile('getProduct Complete : ', JSON.stringify(req.params));
  await res.code(200).send(mProductData[cCBO]);

};


exports.getProductTest = async function (req, res, next) {
  let tStartTime = new Date().toISOString();
  tools.Logfile('getProduct Start : ', JSON.stringify(req.params));
  let p = req.params;
  let sql = ""
  sql += " SELECT * FROM view_productdata";
  sql += " WHERE ";
  sql += " view_productdata.CompanyId = '" + p.CompanyId + "' AND ";
  sql += " view_productdata.BrandId = '" + p.BrandId + "' AND ";
  sql += " view_productdata.OutletId = '" + p.OutletId + "' ";

  let rows = await pool.query(sql);
  await res.code(200).send(rows);

};

exports.getProductRecommend = async function (req, res, next) {
  // tools.Logfile('getProductRecommend parameter',JSON.stringify(req.params));

  let p = req.params;
  let cCBO = p.CompanyId + p.BrandId + p.OutletId;

  let sql = ""
  sql += " SELECT * FROM view_productrecommend";
  sql += " WHERE ";
  sql += " view_productrecommend.CompanyId = '" + p.CompanyId + "' AND ";
  sql += " view_productrecommend.BrandId = '" + p.BrandId + "' AND ";
  sql += " view_productrecommend.OutletId = '" + p.OutletId + "' ";

  if (mProductRecommend[cCBO] === undefined) {
    try {
      console.log(`( ${cCBO} in memory) loading Product Recommend...`);
      const rows = await pool.query(sql);
      mProductRecommend[cCBO] = JSON.stringify(rows);
    } catch (err) { tools.Logfile('getProductRecommend ERROR', err.message); }
  };
  await res.code(200).send(mProductRecommend[cCBO]);

};


exports.getProductSize = async function (req, res, next) {
  console.log("********** Get Product Size All **************");
  tools.Logfile('getproductsize Start :', JSON.stringify(req.params));

  let p = req.params;
  let cCBO = p.CompanyId + p.BrandId + p.OutletId;

  let sql = ""
  sql += " SELECT * FROM view_productsizeall";
  sql += " WHERE ";
  sql += " view_productsizeall.CompanyId = '" + p.CompanyId + "' AND ";
  sql += " view_productsizeall.BrandId = '" + p.BrandId + "' AND ";
  sql += " view_productsizeall.OutletId = '" + p.OutletId + "' ";

  if (mProductSize[cCBO] === undefined) {
    try {
      console.log(`( ${cCBO} in memory) loading Product Size...`);
      const rows = await pool.query(sql);
      mProductSize[cCBO] = JSON.stringify(rows);

    } catch (err) { tools.Logfile('getproductsize ERROR', err.message); }
  };
  await res.code(200).send(mProductSize[cCBO]);
  tools.Logfile('getproductsize Complete : ', JSON.stringify(req.params));
};



exports.getProductPackage = async function (req, res, next) {
  // console.log('getProductPackage ==> start <==');
  let tStartTime = new Date().toISOString();
  tools.Logfile('getProduct Package Start : ', JSON.stringify(req.params));
  // define paramiter
  let p = req.params;
  let cCBO = p.CompanyId + p.BrandId + p.OutletId;

  let sql = ""
  sql += " SELECT ItemId,Level,ChooseQty,Component,BaseItemId,Needed,AutoAppend FROM productpackage";
  sql += " WHERE ";
  sql += " productpackage.CompanyId = '" + p.CompanyId + "' AND ";
  sql += " productpackage.BrandId = '" + p.BrandId + "' AND ";
  sql += " productpackage.OutletId = '" + p.OutletId + "' ";
  sql += " ORDER BY ItemId,Level ";

  if (mProductPackage[cCBO] === undefined) {
    console.log(`( ${cCBO} in memory) loading product package...`);
    try {
      const rows = await pool.query(sql);
      let result = [];
      if (rows.length > 0) {
        result = await productPackage2Json(rows);
        await ProductPackageAddPrice(result, p);
      }
      mProductPackage[cCBO] = await result;
    }
    catch (err) { tools.Logfile('getProduct ERROR', err.message); }
  };
  tools.Logfile('getProduct Package Complete : ', JSON.stringify(req.params));
  await res.code(200).send(mProductPackage[cCBO]);

};


exports.getProductSubmenu = async function (req, res, next) {
  // console.log('getProductPackage ==> start <==');
  let tStartTime = new Date().toISOString();
  tools.Logfile('getProduct Submenu Start : ', JSON.stringify(req.params));
  // define paramiter
  let p = req.params;
  let cCBO = p.CompanyId + p.BrandId + p.OutletId;

  let sql = ""
  sql += " SELECT `CompanyId`, `BrandId`, `OutletId`, `ItemId`, `Component` FROM view_productsubmenu";
  sql += " WHERE ";
  sql += " view_productsubmenu.CompanyId = '" + p.CompanyId + "' AND ";
  sql += " view_productsubmenu.BrandId = '" + p.BrandId + "' AND ";
  sql += " view_productsubmenu.OutletId = '" + p.OutletId + "' ";
  sql += " ORDER BY ItemId ";

  let rows = await pool.query(sql);
  tools.Logfile('getProduct Submenu Complete : ', JSON.stringify(req.params));
  await res.code(200).send(rows);

};


exports.getModifyListAll = async function (req, res, next) {
  // console.log("********** Get Modify List All **************");
  tools.Logfile('getmodifylistall Start : ', JSON.stringify(req.params));

  let p = req.params;
  let cCBO = p.CompanyId + p.BrandId + p.OutletId;

  let sql = ""
  sql += " SELECT * FROM view_modifylistall";
  sql += " WHERE ";
  sql += " view_modifylistall.CompanyId = '" + p.CompanyId + "' AND ";
  sql += " view_modifylistall.BrandId = '" + p.BrandId + "' AND ";
  sql += " view_modifylistall.OutletId = '" + p.OutletId + "' ";


  if (mModifyList[cCBO] === undefined) {
    try {
      console.log(`( ${cCBO} in memory) loading Modify List...`);
      const rows = await pool.query(sql);
      mModifyList[cCBO] = JSON.stringify(rows);
    } catch (err) { tools.Logfile('getmodifylistall ERROR', err.message); }
  };
  await res.code(200).send(mModifyList[cCBO]);
  tools.Logfile('getmodifylistall Complete : ', JSON.stringify(req.params));
};

exports.resetMasterTable = async function (req, res, next) {
  console.log('resetMasterTable');
  tools.Logfile('resetMasterTable parameter', JSON.stringify(req.params));
  resetMasterFile_InMemory(req);
  updateMasterFileTimeStamp(req);
  res.code(200).send("complete");

};

resetMasterFile_InMemory = (req, res) => {
  // console.log('resetMasterFile_InMemory Start');
  tools.Logfile('resetMasterFile_InMemory parameter', JSON.stringify(req.params));
  let p = req.params;
  let cCBO = p.CompanyId + p.BrandId + p.OutletId;

  try { delete mCategoryData[cCBO]; } catch { };
  try { delete mProductData[cCBO]; } catch { };
  try { delete mProductPackage[cCBO]; } catch { };
  try { delete mProductRecommend[cCBO]; } catch { };
  try { delete mProductSize[cCBO]; } catch { };
  try { delete mModifyList[cCBO]; } catch { };
  console.log(`( ${cCBO}) Reset in membory load.`);
}

updateMasterFileTimeStamp = async (req, res) => {
  // console.log('updateMasterFileTimeStamp Start');
  tools.Logfile('updateMasterFileTimeStamp parameter', JSON.stringify(req.params));
  let p = req.params;
  let cParameter = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "'";
  let sql = "CALL pOutletSetting_MasterFileTimeStamp(" + cParameter + ")";
  try {
    const rows = await pool.query(sql);
    // res.code(200).send(JSON.stringify(rows[0]));
  }
  catch (err) { tools.Logfile('updateMasterFileTimeStamp ERROR', err.message); }

};


productPackage2Json = async (rows) => {
  var result = [];
  var objItem = new Object();
  var chkItem = '';

  for (const em of rows) {
    if (chkItem != em.ItemId) {
      if (chkItem != '') {
        result.push(JSON.parse(JSON.stringify(objItem)));
      }
      objItem.ItemId = em.ItemId;
      objItem.PackageSet = [];
      chkItem = em.ItemId;
    };

    let pk = new Object();
    pk.level = em.Level;
    pk.ChooseQty = {
      Min: em.Needed === 1 ? (em.ChooseQty).toString() : "0",
      Max: (em.ChooseQty).toString()
    };
    // (em.Needed === 1 ? "" : "0-") + (em.ChooseQty).toString() 
    // pk.Component = productPackage2Array( em.Component);
    let emCom = productPackage2Array(em.Component)
    let emBase = productPackage2Array(em.BaseItemId)
    pk.Component = await emCom;
    pk.BaseItemId = await emBase;
    pk.Default = (em.AutoAppend === 1 ? true : false);
    if (em.AutoAppend) {
      pk.ChooseQty.Min = pk.ChooseQty.Max;  // Fix Qty : Max to Min  :david 20191028
    }
    objItem.PackageSet.push(JSON.parse(JSON.stringify(pk)));
    // console.log(objItem);
  };

  // return 
  result.push(JSON.parse(JSON.stringify(objItem)));
  return result;
};

productPackage2Array = (cPack) => new Promise(res => {
  let result = [];
  let pkCom = cPack.split("|");
  for (const em of pkCom) {
    // console.log('element=', element);
    let pkProduct = em.split(",");
    // console.log('pk=', pkProduct[0]);
    if (pkProduct[0] !== '') {
      let objPack = {
        ItemId: pkProduct[0],
        SizeId: pkProduct[1],
        Price: 0,
      }
      result.push(JSON.parse(JSON.stringify(objPack)));
    }
  }
  // console.log('result return :====> ', result);
  return res(result);
});


ProductPackageAddPrice = async (obj, p) => {
  // let p = req.params;

  // getProduct
  let cParameter = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "'";
  let sqlprod = "CALL pProductShowCategoryList(" + cParameter + ")";
  const rows = await pool.query(sqlprod);
  const mProduct = rows[0];

  // getProductPackageDefaultSize
  let sqlPK = '';
  sqlPK += " SELECT product.ItemId,product.LocalName,productsize.DefaultSize,productsize.SizeId,productsize.SizeLocalName  ";
  sqlPK += " FROM `product` LEFT JOIN `productsize` on product.ItemId = productsize.ItemId "
  sqlPK += " WHERE product.isPackage = '1' AND productsize.DefaultSize = '1' AND "
  sqlPK += " `product`.CompanyId = '" + p.CompanyId + "' AND ";
  sqlPK += " `product`.BrandId = '" + p.BrandId + "' AND ";
  sqlPK += " `product`.OutletId = '" + p.OutletId + "' ";
  const mProductPackageSize = await pool.query(sqlPK);


  // getProductSize
  let sql = ""
  sql += " SELECT * FROM view_productsizeall";
  sql += " WHERE ";
  sql += " view_productsizeall.CompanyId = '" + p.CompanyId + "' AND ";
  sql += " view_productsizeall.BrandId = '" + p.BrandId + "' AND ";
  sql += " view_productsizeall.OutletId = '" + p.OutletId + "' ";
  const mProductSize = await pool.query(sql);
  // console.log('product size : ', mProductSize);


  // Put Price into Package object.
  for (const i of obj) {
    // find product object and put it to aComponent 
    const rProduct = mProduct.find((member) => {
      return (member.ItemId === i.ItemId);
    });
    if (rProduct !== undefined) {
      // find default size form product package setting.
      const rProdPkSize = mProductPackageSize.find((member) => {
        return (member.ItemId === i.ItemId);
      });
      if (rProdPkSize !== undefined) {
        i.SizeId = rProdPkSize.SizeId;
      } else {
        i.SizeId = "1";
      }
      searchFieldFromProductSize(i, mProductSize);
      searchFieldFromProduct(i, rProduct);
    };

    // add object package set to main object.
    for (const k of i.PackageSet) {
      // console.log("kkkkk", k.Component);
      for (const n of k.Component) {
        // find product object and put it to aComponent 
        const rProduct = mProduct.find((member) => {
          return (member.ItemId === n.ItemId);
        });
        if (rProduct !== undefined) {
          searchFieldFromProductSize(n, mProductSize);
          searchFieldFromProduct(n, rProduct);
        };
      }

      for (const bp of k.BaseItemId) {
        // n.Price = await searchPriceFromProductSize(n.ItemId, n.SizeId, mProductSize);
        const rProduct = mProduct.find((member) => {
          return (member.ItemId === bp.ItemId);
        });
        if (rProduct !== undefined) {
          searchFieldFromProductSize(bp, mProductSize);
          searchFieldFromProduct(bp, rProduct);
        };
      }
    }
  }
}


searchFieldFromProductSize = async (objItem, mProductSize) => {
  // find product size object
  const rProdSize = mProductSize.find((member) => {
    return ((member.ItemId === objItem.ItemId) && (member.SizeId === objItem.SizeId));
  });
  // add field product size to object
  if (rProdSize !== undefined) {
    objItem.Price = rProdSize.Price;
    objItem.Free = rProdSize.Free;
    objItem.noService = rProdSize.noService;
    objItem.noVat = rProdSize.noVat;
  }
}
searchFieldFromProduct = async (objItem, rProduct) => {
  for (var prop in rProduct) {
    // add all field from product except field "Price"
    if (objItem[prop] !== "Price") {
      objItem[prop] = rProduct[prop];  // add object to item
    }
  };
}

