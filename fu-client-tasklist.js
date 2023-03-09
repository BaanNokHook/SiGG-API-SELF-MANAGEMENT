/*
* File upload tasklist 
* program for upload tasklist from client to server
* 20190916 David : first program install to Nittaya
* 20190918 David : create function genTaskList_js. 
*/

var request = require('request');
var path = require('path');
var fs = require('fs');
// var cmd = require('node-cmd');
var os = require('os');
const tasklist = require('tasklist');
let config = require('./config/config.json');
let cnf = config.TaskListUpload;
const cTaskName = cnf.TaskName;
const timeInterval = (cnf.IntervalMinute * 1000) * 60;
const cFileType = ".tsk";
let p = config.OutletSetting;
let com = "CompanyId=" + p.companyId;
let brn = "BrandId=" + p.brandId;
let out = "OutletId=" + p.outletId;
let outletCode = com + '&' + brn + '&' + out;
const log_dir = process.cwd() + '/log/';
const cOutletFile = p.companyId + p.brandId + p.outletId;
const cFileName = log_dir + "log" + cOutletFile + cFileType;
// time interval
// console.log('Tasklist upload : ', (timeInterval / 1000) / 60, ' minute', ' ==>', Date());

// Start process.
setInterval(async () => {
  console.clear();
  console.log('Tasklist upload : ', (timeInterval / 1000) / 60, ' minute.');
  console.log('-'.repeat(30));
  let rs = await genTaskList_js();   // gen tasklist by javascript lib.

}, timeInterval);


genTaskList_js = async () => {
  fs.unlink(cFileName, async (err) => { });
  let cMessage = '';
  cMessage += 'SERVER TIME : ' + Date().toString() + '\r\n';
  //-------------------------------------------------------
  let cCpu = os.cpus()[0]
  cMessage += "CPU MODEL   : " + cCpu.model + '\r\n';
  cMessage += "CPU SPEED   : " + cCpu.speed + '\r\n';
  cMessage += 'FREE MEMORY : ' + os.freemem() + '  TOTAL MEMORY : ' + os.totalmem() + '\r\n';
  cMessage += 'USED MEMORY : ' + ((os.totalmem() - os.freemem()) / os.totalmem()) * 100 + ' %' + '\r\n';
  cMessage += 'OS          : ' + os.type() + ' ( ' + os.release() + ' ) \r\n';
  cMessage += 'UP TIME     : ' + os.uptime() + ' Second.' + '\r\n';
  cMessage += 'HOME DIR    : ' + os.homedir() + '\r\n';
  cMessage += 'HOST NAME   : ' + os.hostname() + '\r\n';
  //-------------------------------------------------------
  try {
    let cNIF = os.networkInterfaces();
    // console.log('cNIF.Ethernet ==>',cNIF.Ethernet);
    cMessage += 'IP ADDRESS  : ' + cNIF.Ethernet[1].address + '\r\n';
    cMessage += 'MAC ADDRESS : ' + cNIF.Ethernet[1].mac + '\r\n';
  } catch (error) {
    cMessage += 'IP ADDRESS  : ' + "N/A" + '\r\n';
  }

  //-------------------------------------------------------
  cMessage += '\r\n' + "TASK WATCHING : " + '\r\n';
  const cTaskList = await tasklist(); // get task list.
  try {
    cTaskList.forEach(async (element) => {
      if (cTaskName.includes(element.imageName)) {
        cMessage += 'taskName :' + element.imageName + '  memUsege :' + element.memUsage + '\r\n';
      }
    });
  } catch (error) {

  }
  console.log(cMessage);
  //-------------------------------------------------------
  cMessage += '\r\n' + "ALL TASK RUNNING : " + '\r\n';
  cTaskList.forEach(async (element) => {
    cMessage += JSON.stringify(element) + '\r\n';
  });
  //-------------------------------------------------------
  fs.appendFile(cFileName, cMessage + '\r\n', async (err) => {
    if (!err) {
      let rs = await checkFileUpload();    // upload log file1
    };
  });
  return true;
}

checkFileUpload = async () => {
  // let log_dir = './log';
  fs.readdir(log_dir, (err, files) => {
    // console.log('read dir...');
    if (err) {
      // console.log("not found folder : ",log_dir);
    } else {
      files.forEach(file => {
        // console.log(file);
        // upload log file.
        if (path.extname(file) === cFileType) {
          let cfileUpload = log_dir + file;
          if (fileInRangeUplod(cfileUpload)) {
            // console.log(cfileUpload);
            uploading(cfileUpload);
          }
        }
      });
    }
  });
  return true;
}

uploading = async (cfileUpload) => {
  // let filename = process.argv[2];  // get file from paramiter
  let filename = cfileUpload;
  // let target = cnf.serverUrl + '/' + path.basename(filename) + "?" + outletCode;
  let target = 'http://' + config.Cloud.host + ':' + config.Cloud.port + '/upload/' + path.basename(filename) + "?" + outletCode;
  console.log('file traget => ' + target);
  let rs = fs.createReadStream(filename);
  let ws = request.post(target);

  ws.on('drain', function () {
    // console.log('drain', new Date());
    rs.resume();
  });

  rs.on('end', function () {
    // console.log('file traget => ' + target);
    console.log("end send file =>", filename);
    rs.close();
  });

  ws.on('error', function (err) {
    console.error('error => ' + target + ': ' + err);
  });

  rs.pipe(ws);

}

fileInRangeUplod = async (file) => {
  // check last modify.
  let result = false;
  try {
    const { mtime, ctime } = fs.statSync(file);
    let cDate = new Date();
    let keepDate = 0;
    // check file in range upload
    result = (cDate.getDate() - mtime.getDate() <= keepDate) ? true : false;

  } catch (error) {
    result = false;
  }

  return result;
}
