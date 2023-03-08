var fs = require('fs');  

exports.dtos = function (cMode) { return getDateTimeString(cmode); };  

exports.LogFile = function (pMode, pMessage) {
    let cPrefix = PrefixFile(pMessage);  
    let cSuffix = SuffixFile(pMessage);  
    // let cFileName = './log/log' + getDateTimeString('D') + '_' + cPrefix + '.txt';  
    let cFileName = './log/log' + cPrefix + '_' + getDateTimeString('D') + '_' + cSuffix + '.txt';   
    let cMessage = getDateTimeString('T') + '#' + pMode + '#' + pMessage + '\n';   
    // console.log(cMessage);  
    fs.appendFile(cFileName, cMessage, (err) => {
        if (err) throw err;  
    }); 
    return pMessage;  
};  

exports.LogTimeStamp = function (pMode, pMessage,pStartTime,pEndTime) {
    let cPrefix = PrefixFile(pMessage);  
    let cFileName = './log/log' + cPrefix + '_' + getDateTimeString('D') + '_Diff.txt';  
    let cDiffTime = diff_minutes(pStartTime,pEndTime);  
    let cMessage = getDateTimeString('T') + '#' + pMode + '==>' + cDiffTime + '\n';
    // console.log(cMessage);  
    fs.appendFile(cFileName, cMessage, (err) => {  
        if (err) throw err;
    });
    return pMessage;
};

// Date Time convert to string by mode request.  
function getDateTimeString(cMode) {
    let cDateFormat = String();

    let currDate = new Date();  
    let cYear = currDate.getFullYear().toString();  
    let cMonth = ('00' + (currDate.getMonth()+1).toString()).substr(-2);
    let cDate = ('00' + currDate.getDate().toString()).substr(-2);
    let cHour = ('00' + currDate.getHours().toString()).substr(-2);
    let cMinute = ('00' + currDate.getMinutes().toString()).substr(-2);
    let cSecond = ('00' + currDate.getSeconds().toString()).substr(-2);
    let cmSecond = '00' + currDate.getMilliseconds().toString();

    if (cMode == 'D') {  // Date  
        cDateFormat = cYear + cMonth + cDate  
    } else if (cMode == 'DH') { // Date Hour  
        cDateFormat = cYear + cMonth + cDate + '_' + cHour;  
    } else if (cMode == 'T') {  // Time
        cDateFormat = cHour + ':' + cMinute + ':' + cSecond;
    } else if (cMode == 'DT') {// Date time  
        cDateFormat = cYear + cMonth + cDate + '_' + cHour + ':' + cMinute + ':' + cSecond;
    } else if (cMode == 'DM') {  // Date time millisccond 
        cDateFormat = cYear + cMonth + cDate + '_' + cHour + ':' + cMinute + ':' + cSecond + '_' + cmSecond;  
    };  

    return cDateFormat;  
};  

// generate prefix file name.
function PrefixFile(pMessage) {
    let result = '';  
    try {
        let p = JSON.parse(pMessage);  
        let com = (typeof p.Company != 'undefined') ? p.CompanyId : '000';  
        let brn = (typeof p.BrandId != 'undefined') ? p.BrandId : '000';   
        let out = (typeof p.OutletId != 'undefined') ? p.OutletId : '000';  
        result = com + brn + out;
    } catch (err) {
        result = "cccbbbooo";  
    }
    return result;  
};

// generate suffix file name.  
function SuffixFile(pMessage){
    let result = '';   
    try {
        let p = JSON.parse(pMessage);  
        let tno = (typeof p.TableNo != 'undefined') ? p.TableNo : '000';
        result = tno;  
    } catch (err) {
        result = "ttt";  
    } 
    return result;  
};  

// difference time to minutes.  
function diff_minutes(dt1, dt2) {
    let result = '';  
    let diff = (dt2.getTime() - dt1.getTime()) / 1000;  
    diff /= 60;  
    // return Math.abs(Math.round(diff));    // return minutes    
    result = String(diff) + '(' + String(dt1.getTime()) + ',' + String(dt2.getTime()) + ')';   
    return result;   
};  


// header parameter cover to string  
exports.HeaderParamToString = function (cJsonPara) {
    // this.Logfile("HeaderParmToString : ", cJsonPara);
    let p = JSON.parse(cJsonPara);
    let result = "'" + p.CompanyId + "','" + p.BrandId + "','" + p.OutletId + "','" + p.SystemDate + "','" + p.TableNo + "','" + p.StartTime + "'";    
    if (typeof p.ItemNo != "undefined") {
        result += "," + p.ItemNo + "'";    // Item Number   
    };  
    if (typeof p.Pax != "undefined") {
        result += ",'" + p.Pax + "'";     // Input Pax  
    };
    if (typeof p.HaveCard != "undefined") {
        result += "," + p.HaveCard + "'";  // Call Billing need input discount or voucher.  
    }return (result);  
};  