@import WebKit;
#import "OREWebViewController.h"
#import "ORESnackBar.h"

@interface OREModalWebViewController () <WKNavigationDelegate>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UIProgressView *progressView;
@end

@implementation OREModalWebViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  if (!self.errorTextColor) {
    self.errorTextColor = [UIColor blackColor];
  }
  if (!self.errorBackgroundColor) {
    self.errorBackgroundColor = [UIColor whiteColor];
  }
  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(_handleClose:)];
  self.navigationItem.leftBarButtonItem = closeButton;
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
  // webView.translatesAutoresizingMaskIntoConstraints = false;
  // TODO delegate (navigation back/forward)
  self.webView = webView;
  self.webView.navigationDelegate = self;
  [self.view addSubview:webView];
  // webView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true;
  // webView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true;
  // webView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true;
  // webView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true;
 
  [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
  [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

  UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 2, self.view.frame.size.width, 10)];
  progressView.progressViewStyle = UIProgressViewStyleBar;
  self.progressView = progressView;
  [self.navigationController.navigationBar addSubview:progressView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context  {
  if ([keyPath isEqualToString:@"estimatedProgress"]) {
    [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
  } else if ([keyPath isEqualToString:@"loading"]) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = self.webView.isLoading;
    if (self.webView.isLoading) {
      [self.progressView setProgress:0.1f animated:YES];
    } else {
      [self.progressView setProgress:0 animated:NO];
    }
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.webView stopLoading];
}

- (void)open:(nonnull NSURL*)url {
  NSURLRequest *req = [NSURLRequest requestWithURL:url];
  [self.webView loadRequest:req];
}

- (void)_handleClose:(id)sender {
  [self.delegate oreModalWebViewControllerDidClose];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
  ORESnackBar *bar = [ORESnackBar create];
  bar.textColor = self.errorTextColor;
  bar.backgroundColor = self.errorBackgroundColor;
  bar.message = @"通信中に問題が発生しました";
  bar.actionLabel = @"再接続";
  bar.action = ^(id sender) {
    [self.webView reload];
  };
  [bar showInView:self.view duration:ORESnackBarDurationLong];
}
@end
