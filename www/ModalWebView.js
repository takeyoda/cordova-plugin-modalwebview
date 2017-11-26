var exec = require('cordova/exec');

module.exports = {
  presentModalWebView: function (successCallback, errorCallback, url, title) {
    exec(successCallback, errorCallback, 'ModalWebView', 'presentModalWebView', [url, title]);
  }
};
