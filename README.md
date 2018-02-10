---
title: ModalWebView
description: Open modal WebView.
---

# cordova-plugin-modalwebview


## Installation

This requires cordova 5.0+

    cordova plugin add https://github.com/takeyoda/cordova-plugin-modalwebview.git

## Usage

```js
var modal = new ModalWebView(function () {
  console.log('modal closed');
});
modal.setErrorTextColor(0xFFFFFF);
modal.setErrorBackgroundColor(0xEE0044);
modal.setOrientation('portrait');
var button = document.getElementById('some_element');
button.addEventListener('click', function() {
  modal.open('https://www.example.com/', 'WebView title');
});
```
