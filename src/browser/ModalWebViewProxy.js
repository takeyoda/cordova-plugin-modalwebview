module.exports = {
  presentModalWebView: function (success, error, opts) {
    var url = opts[0];
    var title = opts[1];
    var win = window.open(url, '_blank', 'width=800,height=600');
    win.document.title = title;
    success();
  }
};

require('cordova/exec/proxy').add('ModalWebView', module.exports);
