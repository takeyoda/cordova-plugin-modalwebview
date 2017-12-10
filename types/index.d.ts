declare namespace CordovaPluginModalWebView {
  interface ModalWebView {
    open(url: string, title: string): void;
    setErrorTextColor(color: number): void; // color: 0xRRGGBB
    setErrorBackgroundColor(color: number): void;
  }
  interface ModalWebViewStatic {
    new (closeCallback?: () => void): ModalWebView;
  }
}

interface Window {
  ModalWebView: CordovaPluginModalWebView.ModalWebViewStatic;
}

declare var ModalWebView: CordovaPluginModalWebView.ModalWebViewStatic;
