"use strict";
// 命令: phantomjs url2imgs.js 12401
// 调用: Ajax-request
/*
POST / HTTP/1.1
Host: 127.0.0.1:12401
Content-Type: application/json
{
    "url": "https://webcdn.m.qq.com/webapp_myapp/index.html#/",
    "id": "1",
    "ext": "png",
    "timeout": 600,
    "viewport": { "width": 1280, "height": 900 },
    "headers": {
        "Cookie": "",
        "Authorization": ""
    }
}
*/

// Import Common-JS modules
var system = require("system");
var webpage = require("webpage");
// Saved images-dir and http images-url
var imagesDir = ".\\images\\", imagesUrl = "images/";
// Check command-line-args
if (system.args.length !== 2) {
    console.log('Usage: phantomjs url2imgs.js <port-number>');
    phantom.exit(1);
} else {
    var port = system.args[1];
    var server = require('webserver').create();
    var service = server.listen(port, handler);
    if (service) {
        console.log('Web server running on http://127.0.0.1:' + port);
    } else {
        console.log('Error: Could not create web server listening on port ' + port);
        phantom.exit(1);
    }
}

/* Handle request and response */
function handler(request, response) {
    if (request.url !== "/") {
        console.log(request.url, 404);
        response.statusCode = 404;
        response.write('');
        response.close();
        return;
    }
    console.log(request.url);
    var result = request;
    response.headers = {
        'Server': 'phantomjs crawler',
        'Content-Type': 'application/json; charset=utf-8'
    };

    // JSON POST
    if (request.method == "POST" && request.headers["Content-Type"] == "application/json") {
        var input = JSON.parse(request.post);
        result = input;
        if (input.url && input.id) {
            if (!input.ext) input.ext = ".png";
            if (!input.paper) input.paper = {};
            if (!input.headers) input.headers = {};
            if (!input.timeout) input.timeout = 1000;
            if (!input.viewport) input.viewport = { width: 1280, height: 900 };
            RenderUrlToFile (input.url, input.id, input.ext, input.headers, input.viewport, input.paper, input.timeout, function (status, url, file) {
                if (status !== "success") {
                    result = { status: 400, title: "Unable to generate picture", url: url };
                } else {
                    result = { status: 200, title: "OK", url: url, file: file };
                }
                response.statusCode = result.status;
                response.write(JSON.stringify(result));
                response.close();
            });
            return;
        }
    }

    response.statusCode = 200;
    response.write(JSON.stringify(result, null, 4));
    response.close();
}

/*
Render given URL to image
@param URL to render
@param customHeaders
@param viewportSize Screen size
@param paperSize Print paper-size
@param timeout Show web page before render
@param callback Function called after finishing everything
*/
function RenderUrlToFile (url, id, ext, customHeaders, viewportSize, paperSize, timeout, callback) {
    if (ext.indexOf('.') != 0) ext = '.' + ext;
    var page = webpage.create();
    page.loadImages = true;
    page.webSecurityEnabled = false;
    page.javascriptCanOpenWindows = false;
    page.javascriptCanCloseWindows = false;
    page.paperSize = paperSize;
    page.viewportSize = viewportSize;
    page.settings.userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537 (KHTML, like Gecko) Chrome/96 Safari/537 Edg/96";
    page.customHeaders = customHeaders;
    page.onResourceRequested = function (requestData, networkRequest) {
        networkRequest.setHeader("Trace-Image-Id", id + requestData.id);
    };
    page.open(url, function(status) {
        var file = id + ext;
        if (status === "success") {
            return window.setTimeout((function() {
                page.render(imagesDir + file);
                return callback(status, url, imagesUrl + file);
            }), timeout);
        } else {
            return callback(status, url, imagesUrl + file);
        }
    });
}
