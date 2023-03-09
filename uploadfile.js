var http = require('http');
var formidable = require('formidable');
var fs = require('fs');
var path = require('path');
http.createServer(function (req, res) {
    if (req.url == '/fileupload') {
        var form = new formidable.IncomingForm();
        form.parse(req, function (err, fields, files) {
            var oldpath = files.filetoupload.path;
            var newpath = '../uploads/' + files.filetoupload.name;
            console.log('Source Path :',oldpath)
            console.log('Destination Path :',newpath);
            fs.rename(oldpath, newpath, function (err) {
                // if (err) throw err;
                if (err) {
                    console.log(err.message);
                    throw err;
                }
                res.write('File ' + files.filetoupload.name + ' is uploaded and moved to folder uploads success.');
                res.end();
            });
        });
    } else {
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.write('<form action="fileupload" method="post" enctype="multipart/form-data">');
        res.write('<input type="file" name="filetoupload"><br>');
        res.write('<input type="submit">');
        res.write('</form>');
        return res.end();
    } 
}).listen(5000);