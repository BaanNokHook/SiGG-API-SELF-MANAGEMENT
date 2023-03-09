/* โหลด Express มาใช้งาน */
var express = require('express');
var path = require('path');
var cors = require('cors');


var app = express();

/* ใช้ port 7777 หรือจะส่งเข้ามาตอนรัน app ก็ได้ */
var port = process.env.PORT || 88;

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

//enables cors
app.use(cors({
    'allowedHeaders': ['sessionId', 'Content-Type'],
    'exposedHeaders': ['sessionId'],
    'origin': '*',
    'methods': 'GET,HEAD,PUT,PATCH,POST,DELETE',
    'preflightContinue': false
  }));
  
  app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

  app.use(express.static(path.join(__dirname, 'public')));

/* Routing */
app.get('*', function (req, res) {
    res.sendFile('index.html', { root: 'public' });
});


/* สั่งให้ server ทำการรัน Web Server ด้วย port ที่เรากำหนด */
app.listen(port, function() {
    console.log('Starting node.js on port ' + port);
});