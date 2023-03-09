var express = require('express');
var http = require('http');
var path = require('path');
var fs = require('fs');
var cors = require('cors');
const SOH = require('./controllers/ams/ams_orderhistory.js');
const SOR = require('./controllers/ams/ams_register.js');
const SCTR = require('./controllers/ams/ams_control.js');
var app = express();

app.set('port', process.env.PORT || 8800);

app.use(express.json({
  inflate: true,
  limit: '100Mb',
  reviver: null,
  strict: true,
  type: 'application/json',
  verify: undefined
}));

//enables cors
app.use(cors({
  'allowedHeaders': ['sessionId', 'Content-Type'],
  'exposedHeaders': ['sessionId'],
  'origin': '*',
  'methods': 'GET,HEAD,PUT,PATCH,POST,DELETE',
  'preflightContinue': false
}));


app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*", 'http://192.168.0.45:8100');
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  res.header("Cache-Control", "no-cache , no-store, must-revalidate");
  next();
});


app.use(express.static(path.join(__dirname, 'public-ams')));  // image path: return  filename.

// check status file upload server.
app.get('/status', function (req, res) {
  let respone = {
    Server: "File Upload Server.",
    datetime: new Date().toString(),
    up_time: Math.floor(process.uptime()),
  };
  res.status(200).send(JSON.stringify(respone));
});

// service for uplod file and save it to destination folder.
app.post('/upload/:filename', async (req, res) => {
  // console.log('post params',req.query);
  let filename = path.basename(req.params.filename);
  let p = req.query;
  let outletPath = p.CompanyId + '/' + p.BrandId + '/' + p.OutletId;
  let cFolderUpload = __dirname + '/logserver/' + outletPath + '/';
  // console.log('Targer Folder : ',cFolderUpload);

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
      SOH.soh_process(p.CompanyId, p.BrandId, p.OutletId, filename);
    }
    res.sendStatus(200);
  });
  req.on('close', function () {
    console.log('close => request finished downloading file');
  });
});



// web admin : list file in folder log.
app.get('/listfiles/:CompanyId/:BrandId/:OutletId/:pDate', function (req, res) {
  let logdir = req.params.CompanyId + '/' + req.params.BrandId + '/' + req.params.OutletId + '/'
  let cDirectory = './logserver/' + logdir
  let cDate = req.params.pDate;
  let listfiles = '';
  // console.log("listfile....", cDirectory + cDate);
  if (fs.existsSync(cDirectory)) {
    fs.readdir(cDirectory, function (err, files) {
      if (!err) {
        files.forEach(function (file) {
          if (file.split('.')[1] == 'txt') {
            if (file.substring(13, 21) == cDate) {
              listfiles += file + '|';
            };
          };
        });
        res.send(listfiles);
      }
    });
  } else {
    res.sendStatus(404);
  }
});


// web admin : read the data file and show it on web.
app.get('/logfiledata/:CompanyId/:BrandId/:OutletId/:FileName', function (req, res) {
  let logdir = req.params.CompanyId + '/' + req.params.BrandId + '/' + req.params.OutletId + '/'
  let cDirectory = __dirname + '/logserver/';
  let logfile = cDirectory + logdir + req.params.FileName;
  if (fs.existsSync(logfile)) {
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
});

// query order history
app.get('/getOrderHistory/:CompanyId/:BrandId/:OutletId/:FromDate/:ToDate', function (req, res) {
  SOH.orderhistory(req, res);
});


// Register detail.
app.get('/company', function (req, res) {
  SOR.getCompany(req, res);
});
app.get('/brand', function (req, res) {
  SOR.getBrand(req, res);
});
app.get('/outlet', function (req, res) {
  SOR.getOutlet(req, res);
});
app.get('/outletsetting', function (req, res) {
  SOR.getOutletSetting(req, res);
});

// check update program.
app.get('/checkupdate/:CompanyId/:BrandId/:OutletId', function (req, res) {
  SCTR.getFilesUpdate(req, res);
});


http.createServer(app).listen(app.get('port'), '0.0.0.0', function () {
  console.log(Date());
  console.log('Express server listening on port: ' + app.get('port'));
});