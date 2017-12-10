@import Foundation;
#import <Cordova/CDVPlugin.h>

@interface OREModalWebView : CDVPlugin
- (void)init:(CDVInvokedUrlCommand *)command; // TODO method name
- (void)open:(CDVInvokedUrlCommand *)command;
- (void)setErrorTextColor:(CDVInvokedUrlCommand *)command;
- (void)setErrorBackgroundColor:(CDVInvokedUrlCommand *)command;
@end
