/*
File upload client.
program for update log or history to cloud server.
20190916 David : first program install to Nittaya
*/


var request = require('request');
var path = require('path');
var fs = require('fs');
var pool = require("./services/pool.js");
let config = require('./config/config.json');
let cnf = config.FileUpload;
const timeInterval = (cnf.IntervalMinute * 1000) * 60;
let p = config.OutletSetting;
let com = "CompanyId=" + p.companyId;
let brn = "BrandId=" + p.brandId;
let out = "OutletId=" + p.outletId;
let outletCode = com + '&' + brn + '&' + out;

// time interval
console.log('File upload log every : ', (timeInterval / 1000) / 60, ' minute', ' ==>', Date());

// Start process.
setInterval(async () => {
  // console.log('Upload Time : ', Date());
  let res_rows = await orderHistoryExport();  // upload history file
  if (res_rows > 0) {
    await checkFileUpload();    // upload log file
  }
}, timeInterval);



function checkFileUpload() {
  // get file from folder.
  // let log_dir = './log/' + p.companyId + '/' + p.brandId + '/' + p.outletId;
  let log_dir = './log';
  fs.readdir(log_dir, (err, files) => {
    if (err) {
      // console.log("not found folder : ",log_dir)
    } else {
      files.forEach(file => {
        // upload log file.
        if ((path.extname(file) === ".txt") || (path.extname(file) === ".soh")) {
          let cfileUpload = log_dir + '/' + file;
          if (fileInRangeUplod(cfileUpload)) {
            // console.log(cfileUpload);
            uploading(cfileUpload);
          }
        }
      });
    }

  });
}


uploading = (cfileUpload) => {
  // let filename = process.argv[2];  // get file from paramiter
  let filename = cfileUpload;
  // let target = cnf.serverUrl + '/' + path.basename(filename) + "?" + outletCode;
  let target = 'http://' + config.Cloud.host + ':' + config.Cloud.port + '/upload/' + path.basename(filename) + "?" + outletCode;
  // console.log('send file =>', filename);
  let rs = fs.createReadStream(filename);
  let ws = request.post(target);

  ws.on('drain', function () {
    // console.log('drain', new Date());
    rs.resume();
  });

  rs.on('end', function () {
    console.log('end send => ' + target);
    // console.log("end send file =>", filename);
    rs.close();
  });

  ws.on('error', function (err) {
    console.error('error => ' + target + ': ' + err);
  });

  rs.pipe(ws);

}

fileInRangeUplod = (file) => {
  // check last modify.
  const { mtime, ctime } = fs.statSync(file)
  let cDate = new Date();
  let keepDate = 0;
  let result = false;

  // check file in range upload
  result = (cDate.getDate() - mtime.getDate() <= keepDate) ? true : false;

  return result
}


orderHistoryExport = async (req, res) => {
  let result = 0;
  let currDate = new Date();
  let com = p.companyId;
  let brn = p.brandId;
  let out = p.outletId;
  let cYear = currDate.getFullYear();
  let cMonth = ('00' + (currDate.getMonth() + 1)).substr(-2);
  let cDate = ('00' + currDate.getDate()).substr(-2);
  let cSystemDate = cYear + "-" + cMonth + "-" + cDate;
  let cFileDate = cYear + cMonth + cDate;

  let sql = ""
  sql += " SELECT * FROM orderhistory";
  sql += " WHERE ";
  sql += " orderhistory.CompanyId = '" + com + "' AND ";
  sql += " orderhistory.BrandId = '" + brn + "' AND ";
  sql += " orderhistory.OutletId = '" + out + "' AND";
  sql += " orderhistory.SystemDate = '" + cSystemDate + "'";

  // console.log("sql : ", sql);
  try {
    const rows = await pool.query(sql);
    // console.log(rows.length);
    if (rows.length > 0) {
      result = rows.length;
      // Create all folder if not exist.
      let outletPath = com + '/' + brn + '/' + out;
      // let cOutletFolder = __dirname + '/log/' + outletPath + '/';
      let cOutletFolder = __dirname + '/log/';
      cOutletFolder.split('/').slice(0, -1).reduce((last, folder) => {
        let folderPath = last ? (last + '/' + folder) : folder
        if (!fs.existsSync(folderPath)) fs.mkdirSync(folderPath)
        return folderPath
      })


      // write output file to orderhistory.soh ( Self ORder History)
      let outletcode = com + brn + out;
      let cFileName = cOutletFolder + 'soh' + outletcode + '_' + cFileDate + '.soh';
      let data = JSON.stringify(rows) + '\r\n' + '\r\n';
      await fs.writeFileSync(cFileName, data, function (err) {
        if (err) { console.log('write file error : ', err.message); }
      });
      // await fs.readFile(cFileName, "utf8", function read(err, data) {
      //   let objData = JSON.parse(data);
      // });
    }
  }
  catch (err) { console.log('export file error : ', err.message); }

  return result;
}

