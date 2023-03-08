'user strict';

var mysql = require('mysql')  

var pool = mysql.createPool({
    connectionLimit: 100,  
    host: '127.0.0.1',  
    user: 'root',  
    password: 'Clexpert',  
    database: 'demo'
})
pool.getConnection((err, connection) => {
    if (err) {
        if (err.code === 'PROTOCOL_CONNECTION_LOST') { 
            console.error('Database Demo connection was closed.')
        }
        if (err.code === 'ER_CON_COUNT_ERROR') {
            console.error('Database Demo has too many connections.')
        }
        if (err.code === 'ECONNREFUSED') {
            console.error('Database Demo connection was refused.')
        }
    }
    if (connection) connection.release() 
    return 
})

module.exports = pool  