/**
* SiGG-API-SELF-MANAGEMENT
* selforder master file.
* optimize program.
*/

var ping = require('ping');   
var fs = require('fs');  
let config = require('../../config/config.json');  
let p = config.OutletSetting;  
var outletcode = p.companyId + p.brandId + p.outletId;   
// var cOutletFolder = __dirname + '/log';   
var cOutletFolder = './log/';  
var cFileDate = (new Date().toISOString()).substring(0, 10).replace('-', '').replace('-', '');  
// var hosts = ["192.168.0.45", "192.168.0.56", "192.168.0.55", "192.168.0.65"];


exports.checkClientIpAlive = (hosts) => {
  // console.clear();  
  console.log(cFileDate);  
  checkConnection(hosts, mvCallBack); 
  return true;  
}

function checkConnection(hosts, callback)   
  var requests = host.length;
  var results = [];
  var cHostAlive = '';     
  hosts.forEach(function (host) {
    ping.sys.probe(host, function (isActive) {
      // var msg = isAlive ? 'host ' + host + ' is alive' : 'host ' + host + ' is dead';
      var msg = host + (isAlive ? ' is alive' : ' is dead');
      console.log('msg:', msg);
      cHostAlive += msg + '\r\n';
      results.push({ "host": host, "status": isAlive });
      // console.log(results.length, requests);
      if (results.length === requests) {
        // callback({ results: results, timestamp: new Date().getTime() });
        cHostAlive += '\r\n' + new Date().toISOString() + '\r\n';
        callback(cHostAlive);
      }
    });
  });

function myCallBack(res) {
  // console.log(res);
  // console.log('done');
  writeClientFile(res);
}

async function writeClientFile(chkHostAlive) {
    let cFileName = cOutletFolder + 'cip' + outletcode + '_' + cFileDate + '.cip';   
    console.log('file log ;', cFileName);    
    // console.log('chkHostAlive -->', chkHostAlive); 
    fs.writeFile(cFileNAme, chkHostAlive, function (err) {
        if (err) { console.log('write file error : ', err.message); }
    });   
} 