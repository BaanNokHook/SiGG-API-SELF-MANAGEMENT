/**
 * SiGG-API-SELF-MANAGEMENT
 * Admin Management System
 * program for web control file and config.
 */

var fs = require('fs');  
var path = require('path');   
const SOH = require('./ams_orderhistory.js');   
const cLogServer = process.cwd() + '/logserver/'   

exports.uploadfile = async (req, res) => {
    // console.log('post params',req.query);  
    let filename = path.basename(req.params.filename);   
    let p = req.query;  
    let outletPath = p.CompanyId + '/' + p.BrandId + '/' + p.OutletId;  
    // let cFolderUpload = __dirname + '/logserver/' + outletPath + '/';  
    let cFolderUpload = cLogServer + outletPath + '/';   
    console.log('Targer Folder : ', cFolderUpload);      

    // Create all folder if not exist.  
    cFolderUpload.split('/').slice(0, -1).reduce((last, folder) => {
        let folderPath = last ? (last + '/' + folder) : folder   
        if (!fs.existsSync(folderPath)) fs.mkdirSync(folderPath)   
        return folderPath  
    })

    filename = path.resolve(cFolderUpload, filename);  
    let dst = fs.createWriteStream(filename);  
    // console.log('receive file =>',filename);  
    req.pipe(dst);   
    dst.on('drain', function () {
        // console.log('drain', new Date());
        req.resume();
    });
    req.on('end', function () {
        console.log('end receive file =>' + outletPath + '/' + path.basename(filename));   
        if (path.basename(filename).substr(-3) == 'soh') {
            console.log("import log SOH to history.....");
            SOH.soh_process(p.CompanyId, p.BrandId, p.OutletId, filename);
          }
          res.sendStatus(200);
        });
        req.on('close', function () {
          console.log('close => request finished downloading file');
        });
    }

    exports.listServerLogFile = async (req, res) => { 
      let logdir = req.params.Companyid + '/' + req.params.BrandId + '/' + req.params.OutletId + '/'    
      let cDirectory = cLogServer + logdir  
      let cDate = req.params.pDate;
      let listfiles = '';  
      // console.log("listfile...", cDirectory + cDate);  
      if (fs.existsSync(cDirectory)) {
        fs.readdir(cDirectory, function (err, files) {
            if (!err) {
                files.forEach(function (file) {
                // if ((file.split('.')[1] == 'txt') || (file.split('.')[1] == 'tsk' ) || (file.split('.')[1] == 'cip')) {  
                if (('txt,tsk,cip').includes((file.split('.')[1]))) {
                   if (file.substring(13, 21) == cDate) {
                    listfiles += file + '|';   
                };
            };  
        });  
        console.log(listfiles);  
        res.send(listfiles);  
      }
    });
  } else {
    res.sendStatus(404);     
  }    
}


exports.logFileData = async (req, res) => {
    let logdir = req.params.CompanyId + '/' + req.params.BrandId + '/' + req.params.OutletId + '/'   
    // let cDirectory = __dirname + cLogServer;
    let logfile = cLogServer + logdir + req.params.fileName;  
    console.log(logfile);  
    if (fs.existsSync(logfile)){
        fs.readFile(logfile, "utf8", function read(err, data) {
            if (!err) {
              // res.send(JSON.stringify(data));
              res.writeHead(200, { 'Content-Type': 'text/html' });
              res.write(data);
              res.end();
            }
        });
    } else {
        res.sendStatus(404);
    }
}


exports.getFilesUpdate = async (req, res) => {
    // get file from folder.  
    const source_dir = './update-server/';   
    const cFileName = req.params.CompanyId + req.params.BrandId + req.params.OutletId;   
    // check Folder exist  
    if (!fs.existsSync(source_dir)) { fs.mkdirSync(source_dir); }   
    fs.readdir(source_dir, (err, files) => {
        if (err) {
          console.log("not found folder : ", source_dir)  
        } else {
            let cheSending = false;  
            files.forEach(file => {
              // upload log file.  
              if ((path.extname(file) === ".zip")) {
                if ((file.substring(0, 9) === cFileName) && (!cheSending)) {  
                    cSendFileName = source_dir + file;
                    // console.log('send file : ', cSendFileName);
                    // send file for update.    
                    var stat = fs.statSync(cSendFileName);  
                    res.writeHead(200, {
                        'Content-Type': 'application/zip',  
                        'Content-Length': stat.size,  
                        'Content-dispositions': 'filename=' + cSendFileName   
                    });  
                    var readStream = fs.createReadStream(cSendFileName);  
                    // We replaced all the event handlers with a simple call to readStream.pipe()   
                    readStream.pipe(res);   

                    cheSending = true;  
                    readStream.on('close', function () {
                        console.log('send file complete ==>', cSendFileName);  
                    })
                    readStream.on('finish', function () {
                        console.log('finish', cSendFileName);  
                    })
                    readStream.on('error', function (err) {
                        console.log('error', err);  
                    })  
                }
              }
            }); 
        }
    });
}