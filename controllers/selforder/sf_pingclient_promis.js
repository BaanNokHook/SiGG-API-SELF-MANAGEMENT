var ping = require('ping');
var fs = require('fs');
let config = require('../../config/config.json');
let p = config.OutletSetting;
var outletcode = p.companyId + p.brandId + p.outletId;
// var cOutletFolder = __dirname + '/log/';
var cOutletFolder = '../../log/';
var cFileDate = (new Date().toISOString()).substr(0, 10).replace('-', '').replace('-', '');
var cHostAlive = '';
var hosts = ["192.168.0.45", "192.168.0.56", "192.168.0.55", "192.168.0.65"];
console.clear();
console.log(cFileDate);
main();
// exports.checkClientIpAlive = async (hosts) => { }
// ping1(hosts);
// Promise.all([ping1(hosts)]).then(function(values) {
//     console.log('check1',values);
//     console.log('check2',cHostAlive);
//     writeClientFile(cHostAlive);
//   });

async function main() {
    let a = await pingclient();
    let b = await writeClientFile(a);

    console.log('a-->', a);
}

async function pingclient() {
    let cHostchk = '';
    console.log("HOST1 : ", hosts);
    hosts.forEach(function (host) {
        ping.promise.probe(host)
            .then(function (res) {
                // if (res.stddev != 'unknown') {
                // console.log(res);
                let cPingAlive = 'ip:' + res.numeric_host + ' avg:' + res.avg + ' alive:' + res.alive;
                // console.log(cPingAlive);
                cHostchk += cPingAlive + '\r\n';
                // }
            });
    })
    return  cHostchk;
}

async function writeClientFile(chkHostAlive) {
    // write output file to orderhistory.soh ( Self ORder History)
    let cFileName = cOutletFolder + 'cip' + outletcode + '_' + cFileDate + '.cip';
    console.log('file -->', cFileName);
    console.log('data -->', cHostAlive);
    await fs.writeFileSync(cFileName, chkHostAlive, function (err) {
        if (err) { console.log('write file error : ', err.message); }
    });
}