@import Foundation;
#import <Cordova/CDVPlugin.h>

@interface OREModalWebView : CDVPlugin
- (void)presentModalWebView:(CDVInvokedUrlCommand*)command;
@end
