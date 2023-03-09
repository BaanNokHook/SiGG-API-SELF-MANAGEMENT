
const fs = require('fs');
const path = require('path');
const config = require('./config/config.json');
// let logManage = require('./controllers/ams/ams_client.js');
const nInterval = config.App.healthCheckInterval;
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
        return true
    },
    healthCheckInterval: nInterval
});

fastify.register(require('fastify-static'), {
    // root: path.join(__dirname, '../public'),
    root: path.join(__dirname, config.App.webServer.public),
    // prefix: '/public/', 
})


// routes
// fastify.register(require('./controllers/verify'), { prefix: '/verify' });
// fastify.register(require('./controllers/index'), { prefix: '/selforder' });
fastify.register(require('./controllers/selforder/verify'), { prefix: '/verify' });
fastify.register(require('./controllers/selforder/sf_index'), { prefix: '/selforder' });



fastify.get('/', (req, res) => {
    let respone = {
        Server: "Clexpert Co.,Ltd.",
        datetime: new Date().toString(),
        up_time: Math.floor(process.uptime()),
    };
    res.code(200).send(JSON.stringify(respone));
})


fastify.get('/status', (req, res) => {
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
var port = process.env.PORT || config.App.webServer.port;
fastify.listen(port, '0.0.0.0', function (err, address) {
    if (err) {
        console.log(err);
        process.exit(1);
    } else {
        console.log(`(fastify-server) running on ${address}`);
    }
});