/**
* SiGG-API-SELF-MANAGEMENT
* selforder master file.
* optimize program.
*/

var pool = require("../../services/pool");  
var tools = require("../../util/tools");

async function routes(fastify, option) {

    fastify.get('/:CODE', async (req, res, async next => { 
        // tools.Logfile('verify parameter',JSON.stringify(req.params));
        // tools.Logfile('verify Code parameter',JSON.stringify(req.params.CODE));
        let arrayCode = await req.params.CODE.split(',');   
        let CompanyId = arrayCode[0];  
        let BrandId = arrayCode[1];  
        let OutletId = arrayCode[2];  
        let SystemDate = arrayCode[3];  
        let TableNo = arrayCode[4];  
        let StartTime = arrayCode[5];  
        if (StartTime == 'undefined') {
            console.log("**************************************************");
            console.log("**************************************************");
            console.log("*******  V E R I F Y  =  NULL VALUE **************");
            console.log("**************************************************");
            console.log("**************************************************");
            res.send("ERROR");
            return;
        }; 

        let cParameter = "'" + CompanyId + "','" + OutletId + "','" + SystemDate + "','" + TableNo + "','" + StartTime + "'";  
        // var sql ="SELECT fCheckCanOrdering("+cParameter+") as IsCanOrder;";  
        let sql = "CALL pCheckCanordering(" + cParameter + ");";  
        // await tools.Logfile('verify Para:'+cParameter, "Sql:"+sql);  
        let TableStatus = '{"IsCanOrder":"0","Status":"","StartTime":"","active_Device":""}';   
        let Obj = {};  
        try {
            const rows = await pool.query(sql);  
            // await tools.Logfile('verify return value',JSON.stringify(rows[0]));   
            if (JSON.stringify(rows[0][0]) !== undefined) {
                // res.send(JSON.stringify(rows[0][0]));  
                Obj = rows[0][0];
            } else {
                // res.send(TableStaus);  
                Obj = JSON.parse(TableStatus);  
            }
            let sql1 = "SELECT MasterFileTimeStamp FROM `outletsetting` "  
            sql1 += " WHERE CompanyId = '"+ CompanyId + "' AND BrandId = '" + BrandId + "' AND OutletId = '" + OutletId + "'"
            let MT = await pool.query(sql1);  
            // console.log(sql1);  
            Obj.MasterFileTimeStamp = MT[0].MasterFileTimeStamp;  
            res.code(200).send(JSON.stringify(Obj));  
        }
        catch (err) {
            console.log(err);   
            tools.Logfile('verify ERROR', err.message);  
        }
        res.code(200).send({Status : 'ERROR'});

    })
)};

module.exports = routes;  