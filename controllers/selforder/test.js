/**
* SiGG-API-SELF-MANAGEMENT
* selforder master file.
* optimize program.
*/

exports.david = function (req, res, next) { 

    console.log("Hello david......");  
    console.log(req.params);   
    // res.send({"David1":"Hello David"});  
    res.send("Hello David .....");  
};  

exports.david1 = async function (req, res, next) {
    var sum = 7;  

    sum = await sumFor();  
    console.log("sum = ", sum);  
    console.log("Hello david1 .....");   

    res.send({ "David1": "Hello David" })  

};  

function sumFor(){
    var sum = 0;  
    setTimeout(function () {    
        for (let i = 0; i < 3; i++) {  

            console.log("item i = ", i);   
            sum += i;  
            console.log("sum+i = ", sum);   
        }; 
    },  5000)
    return sum;  
}


exports.testPost = function (req, res, next) {
    console.log("Hello product .....");  
    console.log(req.body);   
    // res .send(product:"post product name"});   
    res.send(JSON.stringify(req.body));  

};  


// post public 
exports.testChkPost = async function (req, reply) {  
    console.log("POST : Test Check Post");  

    const accept = await req.accepts()  // Accept object   
    switch (accept.type(['json', 'html'])) { 
        case 'json': 
            reply.type('application/json').send({ hello: 'world' })
            break
        case 'html': 
            reply.type('text/html').send('<b>hello, world!</b>')
            break 
        default: 
            reply.send(Boom.notAcceptable('unacceptable'))  
            break

    }
}