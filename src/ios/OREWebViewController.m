@import WebKit;
#import "OREWebViewController.h"
#import "ORESnackBar.h"

@interface OREModalWebViewController () <WKNavigationDelegate, WKUIDelegate>
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
  if (!self.orientation) {
    self.orientation = UIInterfaceOrientationMaskAll;
  }
  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(_handleClose:)];
  self.navigationItem.leftBarButtonItem = closeButton;
  WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
  webView.translatesAutoresizingMaskIntoConstraints = false;
  // TODO delegate (navigation back/forward)
  self.webView = webView;
  self.webView.navigationDelegate = self;
  self.webView.UIDelegate = self;
  [self.view addSubview:webView];
  NSDictionary *views = NSDictionaryOfVariableBindings(webView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[webView]-(0)-|" options:0 metrics:0 views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[webView]-(0)-|" options:0 metrics:0 views:views]];
 
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

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
  if (!navigationAction.targetFrame) {
    NSURL *url = navigationAction.request.URL;
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
      [[UIApplication sharedApplication] openURL:url];
    } else {
      [webView loadRequest:navigationAction.request];
    }
  }
  return nil;
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.orientation;
}
@end
