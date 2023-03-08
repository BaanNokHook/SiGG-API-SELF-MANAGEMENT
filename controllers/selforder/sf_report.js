/**
* SiGG-API-SELF-MANAGEMENT
* selforder master file.
* optimize program.
*/

var pool = require("../../services/pool");  
var tools = require("../../util/tools");  


exports.OrderHistory = async function (req, res, next) {
    // tools.Logfile('getOutletSetting parameter',JSON.stringify(req.params));  

    let cParam = ParamsToString(req.params);  
    let sql = "CALL rptOrderHistory(" + cParam + ")"; 
    try {
        const rows = await pool.query(sql);  
        res.code(200).send(JSON.stringify(rows[0]));  
    }
    catch (err) { tools.LogFile('getOutletSetting ERROR', err.message); }

};

exports.OrderHistory = async function (req, res, next) {
    // tools.Logfile('getOutletString parameter',JSON.stringify(req.params));  

    let cParam = ParamsToString(req.params);  
    let sql = "CALL rptOrderRankingQty(" + cParam + ")";   
    try {
        const rows = await pool.query(sql);  
        res.code(200).send(JSON.stringify(rows[0]));  
    }  
    catch (err) { tools.LogFile('getOutletSetting ERROR', err.message); }  

};  

exports.OrderRankingAmt = async function (req, res, next) {
    // tools.Logfile('getOutletSetting parameter' ,JSON.stringify(req.params));  

    let cParam = ParamsToString(req.params);  
    let sql = "CALL rptOrderRankingAmt(" + cParam + ")"; 
    try {
        const rows = await pool.query(sql);   
        res.code(200).send(JSON.stringify(rows[0]));  
    }
    catch (err) { tools.Logfile('getOutletSetting ERROR', err.message); }

};

ParamsToString = (p) => {
    // this.Logfile("HeaderParamToString : ", cJsonPara);
    let result = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "','" + p.StartDate + "','" + p.EndDate +  "'";
    // if (typeof p.StartDate != "undefined") {
    //     result += ",'" + p.StartDate + "'";   // Item Number
    // };

    return (result);
};