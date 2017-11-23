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
var button = document.getElementById('some_element');
button.addEventListener('click', function() {
  var success = function() {};
  var error = function(msg) {};
  ModalWebView.presentModalWebView(success, error, 'https://www.example.com/');
});
```
