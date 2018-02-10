var exec = require('cordova/exec');

function ModalWebView (onCloseCallback) {
  var successCallback = function () {
    if (typeof onCloseCallback === 'function') {
      onCloseCallback();
    }
  };
  var errorCallback = function (msg) {
    console.log('error: ' + msg);
    successCallback();
  };
  setTimeout(function () {
    exec(successCallback, errorCallback, 'ModalWebView', 'init', []);
  }, 10);
}

ModalWebView.prototype = {
  constructor: ModalWebView,
  open: function (url, title) {
    var successCallback = function () {};
    var errorCallback = function (msg) {};
    exec(successCallback, errorCallback, 'ModalWebView', 'open', [url, title]);
  },
  setErrorTextColor: function (color) { // 0xRRGGBB: number, NOT hex string
    var successCallback = function () {};
    var errorCallback = function (msg) {};
    exec(successCallback, errorCallback, 'ModalWebView', 'setErrorTextColor', [color]);
  },
  setErrorBackgroundColor: function (color) {
    var successCallback = function () {};
    var errorCallback = function (msg) {};
    exec(successCallback, errorCallback, 'ModalWebView', 'setErrorBackgroundColor', [color]);
  },
  setOrientation: function (orientation) {
    var successCallback = function () {};
    var errorCallback = function (msg) {};
    exec(successCallback, errorCallback, 'ModalWebView', 'setOrientation', [orientation]);
  }
};

module.exports = ModalWebView;
