interface ModalWebView {
  presentModalWebView(
    onSuccess: () => void,
    onError: (message: string) => void,
    url: string): void;
}

