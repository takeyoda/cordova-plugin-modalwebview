#import "OREModalWebView.h"
#import "OREWebViewController.h"

@interface OREModalWebView () <OREModalWebViewControllerDelegate>
@property(nonatomic, strong) OREModalWebViewController *modalController;
@end

@implementation OREModalWebView
- (void)presentModalWebView:(CDVInvokedUrlCommand*)command {
  NSString* strURL = [[command arguments] objectAtIndex:0];
  NSURL *url = [NSURL URLWithString:strURL];
  OREModalWebViewController *rootController = [[OREModalWebViewController alloc] init];
  rootController.delegate = self;
  self.modalController = rootController;
  UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:rootController];
  
  [self.viewController presentViewController:naviController animated:YES completion:^{
    [rootController open:url];
  }];
  
  CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
  [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void)oreModalWebViewControllerDidClose {
  [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
@end

