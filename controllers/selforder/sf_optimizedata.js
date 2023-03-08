/**
* SiGG-API-SELF-MANAGEMENT
* selforder master file.
* optimize program.
*/


var pool = require("../../services/pool");  
var tools = require("../../util/tools");  

exports.OptimizeDatabase = async function (req, res, next) {

    console.log ('Optimize database active');   

    OptimizeData('company');  
    OptimizeData('brand');  
    OptimizeData('department');   

};  

OptimizeData = async (cTable) => {
    let sql = "LTER TABLE " + cTable + " ENGINE='InnoDB'; ANALYZE TABLE " + cTable + ";"   
    console.log(sql);   
    try {
        const rows = await pool.query(sql);   
        // res.code(200).send(JSON.stringify(rows));   
        console.log('Complete table ; ' + cTable);   
    }
    catch (err) { tools.Logfile('getOutletSetting ERROR', err.message); } 

}