@import UIKit;

typedef void (^ORESnackBarAction)(id);

FOUNDATION_EXPORT NSTimeInterval const ORESnackBarDurationShort;
FOUNDATION_EXPORT NSTimeInterval const ORESnackBarDurationLong;

@interface ORESnackBar: UIView
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *actionLabel;
@property (nonatomic, copy) ORESnackBarAction action;
@property (nonatomic, assign) UIColor *textColor;
+ (instancetype)create;
- (void)showInView:(UIView*)parent duration:(NSTimeInterval)duration;
- (void)dismiss;
@end
