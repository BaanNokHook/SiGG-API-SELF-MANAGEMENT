'user strict';

//CouchDB
var connection = require('nano')('http://admin:C$lexpert@localhost:5984');

connection.db.create('selforder', function(err, body) {
  if (!err) {
    console.log('Connected successfully to CouchDB Server 5984!');
  }
});


module.exports = connection;