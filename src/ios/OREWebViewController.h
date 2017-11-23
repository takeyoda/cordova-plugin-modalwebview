@import UIKit;

@protocol OREModalWebViewControllerDelegate <NSObject>
- (void)oreModalWebViewControllerDidClose;
@end

@interface OREModalWebViewController: UIViewController
@property (nonatomic, weak) __nullable id<OREModalWebViewControllerDelegate> delegate;
- (void)open:(nonnull NSURL*)url;
@end
