declare namespace CordovaPluginModalWebView {
  interface ModalWebView {
    open(url: string, title: string): void;
    setErrorTextColor(color: number): void; // color: 0xRRGGBB
    setErrorBackgroundColor(color: number): void;
    setOrientation(orientation: string): void; // "portrait", "landscape", "default"
  }
  interface ModalWebViewStatic {
    new (closeCallback?: () => void): ModalWebView;
  }
}

interface Window {
  ModalWebView: CordovaPluginModalWebView.ModalWebViewStatic;
}

declare var ModalWebView: CordovaPluginModalWebView.ModalWebViewStatic;
