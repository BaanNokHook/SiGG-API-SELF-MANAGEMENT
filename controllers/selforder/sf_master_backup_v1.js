var pool = require("../../services/pool");
var tools = require("../../util/tools");

// Array variable inmemory loading
let mCategoryData = new Array();  
let mProductData = new Array();  
let mProductRecommend = new Array();
let mProductSize = new Array();  
let mModifyList = new Array(); 
let product_sort = new Array();  

exports.getOutletSetting = async function (req, res, next) {
    // tools.Logfile('getOutletSetting parameter',JSON.stringify(req.params));
    let sql = "";  
    sql += " SELECT * FROM view_outletsetting";   
    sql += " WHERE ";  
    sql += " view_outletsetting.CompanyId = '" + req.params.CompanyId + "' AND ";   
    sql += " view_outletsetting.BrandId = '" + req.params.BrandId + "' AND ";   
    sql += " view_outletsetting.OutletId = '" + req.params.OutletId + "' ";   

    try {
        const rows = await pool.query(sql); 
        res.code(200).send(JSON.stringify(rows));  
    }
    catch (err) { tools.Logfile('getOutletSetting ERROR', err.message); }  

};  

exports.getCategory = async function (req, res, next) {
    // tools.Logfile('getOutletTable parameter',JSON.stringify(req.params));  
    let sql = "" 
    sql += " SELECT * FROM `view_table` ";  
    sql += " WHERE ";  
    sql += " CompanyId = '" + req.params.CompanyId + "' AND ";   
    sql += " BrandId = '" + req.params.BrandId +  "' AND ";
    sql += " OutletId = '" + req.params.OutletId + "' ";  

    try {
        const rows = await pool.query(sql);  
        res.code(200).send(JSON.stringify(rows));  
    }
    catch (err) { tools.Logfile('getOutletTable ERROR', err.message); }
};  

exports.getCategory = async function (req, res, next) {
    tools.Logfile('getCategory parameter', JSON.stringify(req.params));   


    let sql = "" 
    sql += " SELECT * FROM view_Category";  
    sql += " WHERE ";  
    sql += " view_category.CompanyId = '" + req.params.CompanyId + "' AND ";  
    sql += " view_category.BrandId = '" + req.params.BrandId + "' AND ";  
    sql += " view_category.outletId = '" + req.params.OutletId + "' ";   

    let Comp = parseInt(req.params.CompanyId);   
    let Bran = parseInt(req.params.BrandId);  
    let Olet = parseInt(req.params.OutletId);   
    if (mCategoryData[Comp] == null) { mCategoryData[Comp] = new Array(); }
    if (mCategoryData[Comp][Bran] == null) { mCategoryData[Comp][Bran] = new Array(); }
    if (mCategoryData[Comp][Bran][Olet] == null) { mCategoryData[Comp][Bran][Olet] = new Array(); }

    if (mCategoryData[Comp][Bran][Olet].length == 0) {
        try {
            console.log("(in memory) loading Category...");   
            const rows = await pool.query(sql);  
            mCategoryData[Comp][Bran][Olet] = JSON.stringify(rows);   
        } catch (err) { tools.Logfile('getCategory ERROR', err.message); }   
    };  
    await res.code(200).send(mCategoryData[Comp][Bran][Olet]);
};


exports.getProduct = async function (req, res, next) {
    let tStartTime = new Date();   
    tools.Logfile('getProduct Start : ', JSON.stringify(req.params));   
    // define parameter  
    let p = req.params;  
    let cParameter = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "'";   
    let sql = "CALL pProductShowCategoryList(" + cParameter + ")";   


    // inmemory loading.
    let Comp = parseInt(req.params.CompanyId);  
    let Bran = parseInt(req.params.BrandId);  
    let Olet = parseInt(req.params.OutletId);
    if (mProductData[Comp] == null) { mProductData[Comp] = new Array(); }
    if (mProductData[Comp][Bran] == null) { mProductData[Comp][Bran] = new Array(); }
    if (mProductData[Comp][Bran][Olet] == null) { mProductData[Comp][Bran][Olet] = new Array(); }

    if (mProductData[Comp][Bran][Olet].length == 0) {
        console.log('(in memory) loading product...', req.params.CompanyId + ',' + req.params.BrandId + ',' + req.params.OutletId);
        try {
            const rows = await pool.query(sql);
            mProductData[Comp][Bran][Olet] = JSON.stringify(rows[0]);
        }
        catch (err) { tools.Logfile('getProduct ERROR', err.message); }
    };
    tools.Logfile('getProduct Complete : ', JSON.stringify(req.params));
    await res.code(200).send(mProductData[Comp][Bran][Olet]);

};



exports.getProduct_back = async function (req, res, next) {
    let tStartTime = new Date();
    tools.Logfile('getProduct Start : ', JSON.stringify(req.params));

    // let sql = ""
    // sql += " SELECT * FROM view_productdata";
    // sql += " WHERE ";
    // sql += " view_productdata.CompanyId = '" + req.params.CompanyId + "' AND ";
    // sql += " view_productdata.BrandId = '" + req.params.BrandId + "' AND ";
    // sql += " view_productdata.OutletId = '" + req.params.OutletId + "' ";

    let Comp = parseInt(req.params.CompanyId);
    let Bran = parseInt(req.params.BrandId);
    let Olet = parseInt(req.params.OutletId);
    if (mProductData[Comp] == null) { mProductData[Comp] = new Array(); }
    if (mProductData[Comp][Bran] == null) { mProductData[Comp][Bran] = new Array(); }
    if (mProductData[Comp][Bran][Olet] == null) { mProductData[Comp][Bran][Olet] = new Array(); }


    if (mProductData[Comp][Bran][Olet].length == 0) {
        console.log('(in memory) loading product...', req.params.CompanyId + ',' + req.params.BrandId + ',' + req.params.OutletId);
        try {
            // const rows = await pool.query(sql);
            // mProductData[Comp][Bran][Olet] = JSON.stringify(rows);

            await (async () => {
                console.log('test1');
                let rows = await getProductSequence(req);
                let aaa = await rows;
                console.log('test2', aaa);
                mProductData[Comp][Bran][Olet] = JSON.stringify(rows);
                console.log('test3', product_sort);

            })();


            // await Promise.all([getProductSequence(req)]).then(console.log('test4',product_sort));

            console.log('test5', product_sort);
            console.log('test6', mProductData[Comp][Bran][Olet]);

            // let rows = await getProductSequence(req);
            // console.log('api return :', await rows);
            // mProductData[Comp][Bran][Olet] = JSON.stringify(rows);

        } catch (err) {
            console.log(err.message);
            tools.Logfile('getProduct ERROR', err.message);
        }

    };
    tools.Logfile('getProduct Complete : ', JSON.stringify(req.params));
    await res.code(200).send(mProductData[Comp][Bran][Olet]);

};


getProductSequence = async (req) => {

    console.log('start query');
    product_sort = [];
    let sql_cat = "";
    sql_cat += " SELECT CategoryId FROM view_category";
    sql_cat += " WHERE "; 6
    sql_cat += " view_category.CompanyId = '" + req.params.CompanyId + "' AND ";
    sql_cat += " view_category.BrandId = '" + req.params.BrandId + "' AND ";
    sql_cat += " view_category.OutletId = '" + req.params.OutletId + "' AND";
    sql_cat += " view_category.CategoryId > '28'";

    await (async () => {
        let cat = await pool.query(sql_cat);
        await getProductGroup(req, cat);
        await console.log('product_sort main:', JSON.stringify(product_sort));
    })();

    // await cat.forEach(async (catId) => {
    //     // console.log(catId);
    //     let sql_prod = ""
    //     sql_prod += " SELECT * FROM view_productdata";
    //     sql_prod += " WHERE ";
    //     sql_prod += " view_productdata.CompanyId = '" + req.params.CompanyId + "' AND ";
    //     sql_prod += " view_productdata.BrandId = '" + req.params.BrandId + "' AND ";
    //     sql_prod += " view_productdata.OutletId = '" + req.params.OutletId + "' AND";
    //     sql_prod += " POSITION('" + catId.CategoryId + "' IN  view_productdata.ShowOnCategory) ";
    //     // console.log(sql_prod);
    //     const prod = await pool.query(sql_prod);
    //     // console.log("prod", prod);
    //     await prod.forEach(async (element) => {
    //         await product_sort.push(element);
    //     });
    //     // console.log('product_sort:', JSON.stringify(product_sort));
    // });


    // return product_sort;


}

getProductGroup = async (req, cat) => {
    await cat.forEach(async (catId) => {
        // console.log(catId);
        let sql_prod = ""
        sql_prod += " SELECT * FROM view_productdata";
        sql_prod += " WHERE ";
        sql_prod += " view_productdata.CompanyId = '" + req.params.CompanyId + "' AND ";
        sql_prod += " view_productdata.BrandId = '" + req.params.BrandId + "' AND ";
        sql_prod += " view_productdata.OutletId = '" + req.params.OutletId + "' AND";
        sql_prod += " POSITION('" + catId.CategoryId + "' IN  view_productdata.ShowOnCategory) ";
        // console.log(sql_prod);
        const prod = await pool.query(sql_prod);
        // console.log("prod", prod);
        await prod.forEach(async (element) => {
            // product_sort.push(element);
            product_sort.push({ "A": "BB" });
            console.log('product_sort in:', JSON.stringify(product_sort));
        });
        console.log('product_sort out:', JSON.stringify(product_sort));
    });
    await console.log('product_sort return:', JSON.stringify(product_sort));
    return product_sort;
}




exports.getProductTest = async function (req, res, next) {
    let tStartTime = new Date();
    tools.Logfile('getProduct Start : ', JSON.stringify(req.params));

    let sql = ""
    sql += " SELECT * FROM view_productdata";
    sql += " WHERE ";
    sql += " view_productdata.CompanyId = '" + req.params.CompanyId + "' AND ";
    sql += " view_productdata.BrandId = '" + req.params.BrandId + "' AND ";
    sql += " view_productdata.OutletId = '" + req.params.OutletId + "' ";

    let rows = await pool.query(sql);
    await res.code(200).send(rows);

};


exports.getProductRecommend = async function (req, res, next) {
    // tools.Logfile('getProductRecommend parameter',JSON.stringify(req.params));

    let sql = ""
    sql += " SELECT * FROM view_productrecommend";
    sql += " WHERE ";
    sql += " view_productrecommend.CompanyId = '" + req.params.CompanyId + "' AND ";
    sql += " view_productrecommend.BrandId = '" + req.params.BrandId + "' AND ";
    sql += " view_productrecommend.OutletId = '" + req.params.OutletId + "' ";

    let Comp = parseInt(req.params.CompanyId);
    let Bran = parseInt(req.params.BrandId);
    let Olet = parseInt(req.params.OutletId);
    if (mProductRecommend[Comp] == null) { mProductRecommend[Comp] = new Array(); }
    if (mProductRecommend[Comp][Bran] == null) { mProductRecommend[Comp][Bran] = new Array(); }
    if (mProductRecommend[Comp][Bran][Olet] == null) { mProductRecommend[Comp][Bran][Olet] = new Array(); }



    if (mProductRecommend[Comp][Bran][Olet].length == 0) {
        try {
            console.log("(in memory) loading Product Recommend...");
            const rows = await pool.query(sql);
            mProductRecommend[Comp][Bran][Olet] = JSON.stringify(rows);
        } catch (err) { tools.Logfile('getProductRecommend ERROR', err.message); }
    };
    await res.code(200).send(mProductRecommend[Comp][Bran][Olet]);

};

exports.getProductSize = async function (req, res, next) {
    console.log("********** Get Product Size All **************");
    tools.Logfile('getproductsize Start :', JSON.stringify(req.params));

    let sql = ""
    sql += " SELECT * FROM view_productsizeall";
    sql += " WHERE ";
    sql += " view_productsizeall.CompanyId = '" + req.params.CompanyId + "' AND ";
    sql += " view_productsizeall.BrandId = '" + req.params.BrandId + "' AND ";
    sql += " view_productsizeall.OutletId = '" + req.params.OutletId + "' ";

    let Comp = parseInt(req.params.CompanyId);
    let Bran = parseInt(req.params.BrandId);
    let Olet = parseInt(req.params.OutletId);
    if (mProductSize[Comp] == null) { mProductSize[Comp] = new Array(); }
    if (mProductSize[Comp][Bran] == null) { mProductSize[Comp][Bran] = new Array(); }
    if (mProductSize[Comp][Bran][Olet] == null) { mProductSize[Comp][Bran][Olet] = new Array(); }


    if (mProductSize[Comp][Bran][Olet].length == 0) {
        try {
            console.log("(in memory) loading Product Size...");
            const rows = await pool.query(sql);
            mProductSize[Comp][Bran][Olet] = JSON.stringify(rows);
        } catch (err) { tools.Logfile('getproductsize ERROR', err.message); }
    };
    await res.code(200).send(mProductSize[Comp][Bran][Olet]);
    tools.Logfile('getproductsize Complete : ', JSON.stringify(req.params));
};

exports.getModifyListAll = async function (req, res, next) {
    console.log("********** Get Modify List All **************");
    tools.Logfile('getmodifylistall Start : ', JSON.stringify(req.params));
    let sql = ""
    sql += " SELECT * FROM view_modifylistall";
    sql += " WHERE ";
    sql += " view_modifylistall.CompanyId = '" + req.params.CompanyId + "' AND ";
    sql += " view_modifylistall.BrandId = '" + req.params.BrandId + "' AND ";
    sql += " view_modifylistall.OutletId = '" + req.params.OutletId + "' ";

    let Comp = parseInt(req.params.CompanyId);
    let Bran = parseInt(req.params.BrandId);
    let Olet = parseInt(req.params.OutletId);
    if (mModifyList[Comp] == null) { mModifyList[Comp] = new Array(); }
    if (mModifyList[Comp][Bran] == null) { mModifyList[Comp][Bran] = new Array(); }
    if (mModifyList[Comp][Bran][Olet] == null) { mModifyList[Comp][Bran][Olet] = new Array(); }


    if (mModifyList[Comp][Bran][Olet].length == 0) {
        try {
            console.log("(in memory) loading Modify List...");
            const rows = await pool.query(sql);
            mModifyList[Comp][Bran][Olet] = JSON.stringify(rows);
        } catch (err) { tools.Logfile('getmodifylistall ERROR', err.message); }
    };
    await res.code(200).send(mModifyList[Comp][Bran][Olet]);
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
    let Comp = parseInt(p.CompanyId);
    let Bran = parseInt(p.BrandId);
    let Olet = parseInt(p.OutletId);

    try { mCategoryData[Comp][Bran][Olet] = []; } catch { };
    try { mProductData[Comp][Bran][Olet] = []; } catch { };
    try { mProductRecommend[Comp][Bran][Olet] = []; } catch { };
    try { mProductSize[Comp][Bran][Olet] = []; } catch { };
    try { mModifyList[Comp][Bran][Olet] = []; } catch { };
}

updateMasterFileTimeStamp = async (req, res) => {
    // console.log('updateMasterFileTimeStamp Start');
    tools.Logfile('updateMasterFileTimeStamp parameter', JSON.stringify(req.params));
    let p = req.params;
    let cParameter = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "'";
    let sql = "CALL pOutletSetting_MasterFileTimeStamp(" + cParameter + ")";
    try {
        const rows = await pool.query(sql);
        res.code(200).send(JSON.stringify(rows[0]));
    }
    catch (err) { tools.Logfile('getBanner ERROR', err.message); }

};