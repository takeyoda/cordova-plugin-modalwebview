module.exports = {
  presentModalWebView: function (success, error, opts) {
    var url = opts[0];
    window.open(url, '_blank', 'width=800,height=600');
    success();
  }
};

require('cordova/exec/proxy').add('ModalWebView', module.exports);
