/**
 * SiGG-API-SELF-MANAGEMENT
 * Admin Management System
 * program for web admin
 */


var fs = require('fs');
const { type } = require('os');
var path = require('path');
var pool = require("../../services/pool.js");

exports.getCompany = async (req, res) => {
    let sql = 'SELECT * FROM `company`';
    pool_process(req, res, sql);
}
exports.getBrand = async (req, res) => {
    let sql = 'SELECT * FROM `brand`';
    pool_process(req, res, sql);
}
exports.getOutlet = async (req, res) => {
    let sql = 'SELECT * FROM `outlet`';
    pool_process(req, res, sql);
}
exports.getOutletSetting = async (req, res) => {
    let sql = 'SELECT CONCAT(CompanyId,BrandId,OutletId) AS KeyId, `outletsetting`.* FROM `outletsetting`';
    pool_process(req, res, sql);
}

exports.postOutletSetting = async (req, res) => {
    // console.log('sub post outlet setting active....');
    // console.log(req.body);
    let sql = postOutletSettingSql(req.body);
    pool_process(req, res, sql);
}
exports.deleteOutletSetting = async (req, res) => {
    // console.log('sub post outlet setting active....');
    console.log('body : ', req.body);
    console.log('params : ', req.params);
}

postOutletSettingSql = (obj) => {
    let sql = '';
    sql = "INSERT INTO `outletsetting`";
    sql += " (`CompanyId`, `BrandId`, `OutletId`, `DatabaseVersion`,`ApiVersion`, `BackEndVersion`,";
    sql += " `FontEndVersion`, `SerialKey`) ";
    sql += "VALUES (";
    sql += "'" + checkUndefined(obj.CompanyId, '') + "',";
    sql += "'" + checkUndefined(obj.BrandId, '') + "',";
    sql += "'" + checkUndefined(obj.OutletId, '') + "',";
    sql += "'" + checkUndefined(obj.DatabaseVersion, '') + "',";
    sql += "'" + checkUndefined(obj.ApiVersion, '') + "',";
    sql += "'" + checkUndefined(obj.BackEndVersion, '') + "',";
    sql += "'" + checkUndefined(obj.FontEndVersion, '') + "',";
    sql += "'" + checkUndefined(obj.SerialKey, '') + "'";
    sql += " ) ";
    sql += " ON DUPLICATE KEY UPDATE ";
    sql += "DatabaseVersion ='" + checkUndefined(obj.DatabaseVersion, '') + "',";
    sql += "ApiVersion ='" + checkUndefined(obj.ApiVersion, '') + "',";
    sql += "BackEndVersion ='" + checkUndefined(obj.BackEndVersion, '') + "',";
    sql += "FontEndVersion ='" + checkUndefined(obj.FontEndVersion, '') + "',";
    sql += "SerialKey ='" + checkUndefined(obj.SerialKey, '') + "'";
    sql += ";"
    console.log(sql);
    return sql;
};

// check undefined field or empty string in field.
checkUndefined = (MasterObject, DefaultValue) => {
    return (typeof MasterObject === 'undefined' || MasterObject === '' ? DefaultValue : MasterObject);   
};   

deleteOutletSettingSql = (obj) => {
    let sql = '';  
    sql += "DELETE FROM `outletsetting` WHERE";  
    sql += "CompanyId = " + obj.CompanyId + " AND ";
    sql += "BrandId = " + obj.BrandId + " AND ";  
    sql += "OutletId = " + obj.OutletId;   
    sql += ";"   
    console.log(sql);  
    return sql;   
}  

pool_process = async (req, res, sql) => {
    try {
        let rows = await pool.query(sql);  
        res.status(200).send(rows);  
    } catch (err) {
        console.log('Error Message:', err.message);  
    }
}