const path = require('path');
let config = require('./config/config.json'); //get config
const cnf = config.App.webApp; 

// import
const fastify = require('fastify')({ logger: false, http2: false });
fastify.register(require('fastify-formbody'));
fastify.register(require('fastify-accepts'));
fastify.register(require('fastify-compress'));
fastify.register(require('fastify-cors'), {
    'origin': true,
    'method': 'GET,HEAD,PUT,PATCH,POST,DELETE'
});


// healthCheck under-pressure 
fastify.register(require('under-pressure'), {
    maxEventLoopDelay: 1000,
    message: 'Under pressure!',
    retryAfter: 50,
    healthCheck: async function () {
        // console.log("Memory Usage : ",fastify.memoryUsage())
        return true
    },
    healthCheckInterval: 5000
});

//  const webpath = 'public';
const webpath = cnf.webPath;
fastify.register(require('fastify-static'), {
    root: path.join(__dirname, webpath),
    // prefix: '/public/', 
})

fastify.get('/', (req, res) => { res.code(200).sendFile('index.html'); })
fastify.get('/splashscreen', (req, res) => { res.code(200).sendFile('index.html'); })
fastify.get('/ordering', (req, res) => { res.code(200).sendFile('index.html'); })
// all access send file index.html
// fastify.get('/', (req, res) => {
//     console.log("get requirement", webpath);
//     // res.sendFile(path.join(__dirname, webpath, '/index.html'));
//     // res.sendFile('/index.html', { root: path.join(__dirname, webpath) });
//     res.sendFile('index.html');

//     // res.sendFile('index.html', { root: path.join(__dirname, webpath) });

// })

// all access send file index.html
// fastify.get('/splashscreen', (req, res) => {
//     console.log("get splashscreen", webpath);
//     // res.sendFile(path.join(__dirname, webpath, '/index.html'));
//     // res.sendFile('/index.html', { root: path.join(__dirname, webpath) });
//     res.sendFile('index.html');

//     // res.sendFile('index.html', { root: path.join(__dirname, webpath) });

// })

// check status server
fastify.get('/status', (req, res) => {
    console.log("get status", webpath);
    let respone = {
        Server: "Clexpert Co.,Ltd.",
        datetime: new Date().toString(),
        up_time: Math.floor(process.uptime()),
    };
    res.code(200).send(JSON.stringify(respone));
});


// fastify.addHook('onRequest', (request, reply, done) => {
//     // some code
//     console.log("on onRequest",request.params);
//     done()
// })


// listening port
// var port = process.env.PORT || config['webapp'];
var port = process.env.PORT || cnf.port;
fastify.listen(port, cnf.host, function (err, address) {
    if (err) {
        console.log(err);
        process.exit(1);
    } else {
        console.log(`(fastify-webapp) running on ${address}`);
    }
});

