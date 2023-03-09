/*
File upload - client update .
program for get scrit update from server.
20190916 David : first program install to Nittaya
*/

var http = require('http');
var fs = require('fs');
var cmd = require('node-cmd');
const config = require('./config/config.json');
let p = config.OutletSetting;
let com = p.companyId;
let brn = p.brandId;
let out = p.outletId;

// const ServierIp = 'http://192.168.0.45:8100'
const ServerUrl = 'http://' + config.Cloud.host + ':' + config.Cloud.port;
const url = ServerUrl + '/checkupdate/' + com + '/' + brn + '/' + out;

// file download.
const cDestPath = './update-client/';
const cZipFile = cDestPath + com + brn + out + '.zip';
const cRunFile = 'auto.bat';
// check Folder exist
if (!fs.existsSync(cDestPath)) { fs.mkdirSync(cDestPath); }
// delete file first.
cmd.get('PowerShell Remove-Item ' + cDestPath + cRunFile, (err, data) => { });

// download file.
const ws = fs.createWriteStream(cZipFile);

const request = http.get(url, function (response) {

  // console.log(file);
  console.log(response.headers["content-disposition"]);
  response.pipe(ws);

  response.on('end', function () {
    // extrace file.
    const cUnzipFile = 'PowerShell Expand-Archive -LiteralPath ' + cZipFile + ' -DestinationPath ' + cDestPath + ' -Force';
    // console.log('unzip : ', cUnzipFile);
    cmd.get(cUnzipFile, (err, data) => {
      // run file.
      const cRunCommand = 'PowerShell Start-Process -FilePath' + cDestPath + cRunFile + ' -WorkingDirectory' + cDestPath;
      // console.log('run command :', cRunCommand);
      cmd.get(cRunCommand, (err, data) => {
        // console.log('start command:', data);
      });
    })
  });
});

// set time out 1 minute. (60x1000)
request.setTimeout(60 * 1000, function () {
  // handle timeout here
  console.log('Not found data for update.')
  process.exit(1);
});



