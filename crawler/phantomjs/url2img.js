"use strict";
// 命令: phantomjs url2img.js "https://webcdn.m.qq.com/webapp_myapp/index.html#/"
// Import Common-JS modules
var system = require("system");
// Saved images-dir
var imagesDir = ".\\images\\";
// Screen size
var viewportSize = { width: 1300, height: 900 };
var timeout = 1000;
// Print paper-size
var paperSize = {
    // format: 'A4',
    // margin: { left: '1cm', right: '1cm', top: '10px', bottom: '10px' }
};
// Custom headers
var customHeaders = {
    "Host": "webcdn.m.qq.com",
    "Upgrade-Insecure-Requests": "1",
    "Accept-Encoding": "gzip, deflate, br",
    "Cache-Control": "max-age=0",
    "Cookie": "",
    "Authorization": ""
};
// Custom user-agent
var userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537 (KHTML, like Gecko) Chrome/96 Safari/537 Edg/96";
var onResourceRequested = function (requestData, networkRequest) {
    // console.log("Requested '" + requestData.url + "' " + JSON.stringify(requestData));
    // networkRequest.setHeader('Authorization', customHeaders.Authorization);
};
// Check command-line-args
if (system.args.length == 1) {
    console.log("Usage: phantomjs url2img.js [url1, url2, ...]");
    phantom.exit();
} else {
    var arrayOfUrls = Array.prototype.slice.call(system.args, 1);
    RenderUrlsToFile(arrayOfUrls, (function(status, url, file) {
        if (status !== "success") {
            return console.log("Unable to render '" + url + "'");
        } else {
            return console.log("Rendered '" + url + "' at '" + file + "'");
        }
    }), phantom.exit);
}

/*
Render given urls to images
@param array of URLs to render
@param callbackPerUrl Function called after finishing each URL, including the last URL
@param callbackFinal Function called after finishing everything
*/
function RenderUrlsToFile (urls, callbackPerUrl, callbackFinal) {
    var getFilename, next, page, retrieve;
    var urlIndex = 0;
    var webpage = require("webpage");
    getFilename = function() {
        return imagesDir + urlIndex + ".png";
    };
    next = function(status, url, file) {
        page.close();
        callbackPerUrl(status, url, file);
        return retrieve();
    };
    retrieve = function() {
        if (urls.length > 0) {
            urlIndex++;
            var url = urls.shift();
            page = webpage.create();
            page.loadImages = true;
            page.webSecurityEnabled = false;
            page.javascriptCanOpenWindows = false;
            page.javascriptCanCloseWindows = false;
            page.paperSize = paperSize;
            page.viewportSize = viewportSize;
            page.settings.userAgent = userAgent;
            page.customHeaders = customHeaders;
            page.onResourceRequested = onResourceRequested;
            return page.open(url, function(status) {
                var file = getFilename();
                if (status === "success") {
                    return window.setTimeout((function() {
                        page.render(file);
                        return next(status, url, file);
                    }), timeout);
                } else {
                    return next(status, url, file);
                }
            });
        } else {
            return callbackFinal();
        }
    };
    return retrieve();
}
