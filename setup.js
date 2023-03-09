var fs = require('fs');
var path = require('path');

let OUTPUT_PATH = 'D:/fastify-server';

// process.argv is the array that contains command line arguments
// print all arguments using forEach
//# https://www.npmjs.com/package/minimist
let args_text = '';
const args = process.argv.slice(2);
args.forEach((val, index) => {
    args_text+= index+'::'+new Date().getTime()+' > '+val+'\n'; //console.log(`${index}: ${val}`);
});
var argv = require('minimist')(process.argv.slice(2));  //console.dir(argv);
//console.log(process.argv.slice(2));
//--ip=192.168.1.45 --service=3000 --webapp=80
//console.log('Argv:: ',argv);

//Setup Frontend Configuration File
let config = {
    "host":"0.0.0.0",
    "service":3000,
    "webapp":80,
    "connectionLimit": 10000,
    "hostdb": "127.0.0.1",
    "user": "root",
    "password": "Clexpert",
    "database": "selforder",
    "timezone": "UTC",
	  "port" : 3306
};

let FrontEnd = {
    debugging: true,
    CompanyId:"001",
    BrandId:"001",
    OutletId:"001",
    DelayTimeServer: 45,
    mockup: 0,
    API_ENDPOINTS: {
      localhost : {
        production: "false" ,
        apiUrl : "http://127.0.0.1",
        apiRealTime : "http://127.0.0.1:3000"
      },
      production : {
        production: "true" ,
        apiUrl : "http://192.168.1.45",
        apiRealTime : "http://192.168.1.45:3000"
      }
    },
    OTHER:{
      language: "EN",
      app : {
          version : "1.0.0",
          datetime : "20190809-083200",
          codeName : "TableTopMobile",
          teamname : "MOBILE",
          dev :[]
      }
    }
  };



//get ARGV INPUT
let ip      = ''+(argv.ip === '' || argv.ip === undefined ? '' : argv.ip);
let service = ''+(argv.service === '' || argv.service === undefined ? config.service : argv.service);
let webapp  = ''+(argv.webapp === '' || argv.webapp === undefined ? config.webapp : argv.webapp);
let CompanyId = (argv.CompanyId === '' || argv.CompanyId === undefined ? FrontEnd.CompanyId : argv.CompanyId);
CompanyId = ('000' + CompanyId).slice(-3);
let BrandId   = (argv.BrandId === '' || argv.BrandId === undefined ? FrontEnd.BrandId : argv.BrandId);
BrandId = ('000' + BrandId).slice(-3);
let OutletId  = (argv.OutletId === '' || argv.OutletId === undefined ? FrontEnd.OutletId : argv.OutletId);
OutletId = ('000' + OutletId).slice(-3);


config.service = service;
config.webapp = webapp;

//Frontend FIle!
FrontEnd.CompanyId = CompanyId;
FrontEnd.BrandId   = BrandId;
FrontEnd.OutletId  = OutletId;
FrontEnd.DelayTimeServer = 45;
FrontEnd.API_ENDPOINTS.production.apiUrl ='http://'+ip+':'+webapp;
FrontEnd.API_ENDPOINTS.production.apiRealTime ='http://'+ip+':'+service;
FrontEnd.OTHER.app.datetime = '';
FrontEnd.OTHER.app.version = '';
FrontEnd.OTHER.app.codeName = 'TT-TableTop';

//Setup Config Server
fs.unlinkSync(OUTPUT_PATH+'/config.json'); console.log('Remove Default Config file Json.');
let data_config = JSON.stringify(config,null,2);
fs.writeFileSync(OUTPUT_PATH+'/config.json', data_config);

//Setup frontend
fs.unlinkSync(OUTPUT_PATH+'/public/assets/config/production.json'); console.log('Remove Default Config frontend file Json.');
let data_fronend = JSON.stringify(FrontEnd,null,2);
fs.writeFileSync(OUTPUT_PATH+'/public/assets/config/production.json', data_fronend);
console.log('Write file Config Success!');