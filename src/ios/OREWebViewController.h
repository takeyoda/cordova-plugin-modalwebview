@import UIKit;

@protocol OREModalWebViewControllerDelegate <NSObject>
- (void)oreModalWebViewControllerDidClose;
@end

@interface OREModalWebViewController: UIViewController
@property (nonatomic, strong) UIColor *errorTextColor;
@property (nonatomic, strong) UIColor *errorBackgroundColor;
@property (nonatomic, weak) __nullable id<OREModalWebViewControllerDelegate> delegate;
@property (nonatomic, assign) UIInterfaceOrientationMask orientation;
- (void)open:(nonnull NSURL*)url;
@end
