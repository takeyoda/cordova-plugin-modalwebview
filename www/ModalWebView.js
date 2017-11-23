var exec = require('cordova/exec');

module.exports = {
  presentModalWebView: function (successCallback, errorCallback, url) {
    exec(successCallback, errorCallback, 'ModalWebView', 'presentModalWebView', [url]);
  }
};
