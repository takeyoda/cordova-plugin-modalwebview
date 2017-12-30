#import "OREModalWebView.h"
#import "OREWebViewController.h"

// AARRGGBB
#define ARGB(c) [UIColor colorWithRed:(((c)>>16)&0xFF)/255.0 \
green:(((c)>>8)&0xFF)/255.0 \
blue:(((c)>>0)&0xFF)/255.0 \
alpha:(((c)>>24)&0xFF)/255.0]

@interface OREModalWebView () <OREModalWebViewControllerDelegate>
@property(nonatomic, strong) OREModalWebViewController *modalController;
@property(nonatomic, copy) NSString *callbackId;
@property(nonatomic, strong) UIColor *_errorTextColor;
@property(nonatomic, strong) UIColor *_errorBackgroundColor;
@end

@implementation OREModalWebView
- (void)init:(CDVInvokedUrlCommand*)command {
  self.callbackId = command.callbackId;
}
- (void)open:(CDVInvokedUrlCommand*)command {
  NSString *strURL = [[command arguments] objectAtIndex:0];
  NSString *title = [[command arguments] objectAtIndex:1];
  NSURL *url = [NSURL URLWithString:strURL];
  OREModalWebViewController *rootController = [[OREModalWebViewController alloc] init];
  rootController.delegate = self;
  rootController.title = title;
  rootController.errorTextColor = self._errorTextColor;
  rootController.errorBackgroundColor = self._errorBackgroundColor;
  self.modalController = rootController;
  UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:rootController];
  
  [self.viewController presentViewController:naviController animated:YES completion:^{
    [rootController open:url];
  }];
  
  CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void)oreModalWebViewControllerDidClose {
  [self.viewController dismissViewControllerAnimated:YES completion:nil];

  if (self.callbackId) {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
  }
}
- (void)setErrorTextColor:(CDVInvokedUrlCommand *)command {
  NSNumber *colorRGB = [[command arguments] objectAtIndex:0];
  self._errorTextColor = ARGB(0xFF000000 | [colorRGB integerValue]);
}
- (void)setErrorBackgroundColor:(CDVInvokedUrlCommand *)command {
  NSNumber *colorRGB = [[command arguments] objectAtIndex:0];
  self._errorBackgroundColor = ARGB(0xFF000000 | [colorRGB integerValue]);
}
- (void)onReset {
  [super onReset];
  self.callbackId = nil;
}
@end
