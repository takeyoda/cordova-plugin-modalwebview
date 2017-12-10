#import "ORESnackBar.h"

NSTimeInterval const ORESnackBarDurationShort = 5.0;
NSTimeInterval const ORESnackBarDurationLong = 3.0;

static const int ORESnackBarHeight = 50;

@interface ORESnackBar ()
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) NSLayoutConstraint *yPositionConstraint;
@end

@implementation ORESnackBar
+ (instancetype)create {
  UINib *nib = [UINib nibWithNibName:@"ORESnackBar" bundle:nil];
  ORESnackBar *bar = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
  bar.translatesAutoresizingMaskIntoConstraints = NO;
  return bar;
}
//- (instancetype)init {
//  self = [super initWithFrame:CGRectZero];
//  self.translatesAutoresizingMaskIntoConstraints = NO;
//  [self _setup];
//  return self;
//}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.actionButton addTarget:self action:@selector(_handleAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showInView:(UIView*)parent duration:(NSTimeInterval)duration {
  if (self.superview) {
    return;
  }
  self.messageLabel.textColor = self.textColor;
  self.messageLabel.text = self.message;
  [self.actionButton setTitle:self.actionLabel forState:UIControlStateNormal];
  [parent addSubview:self];
  NSDictionary *views = @{@"bar": self};
  NSArray *hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[bar]-(0)-|" options:0 metrics:nil views:views];
  NSLayoutConstraint *vconstraint = [NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:ORESnackBarHeight];
  self.yPositionConstraint = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parent
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1
                                                            constant:ORESnackBarHeight];
  [parent addConstraints:hconstraints];
  [parent addConstraint:vconstraint];
  [parent addConstraint:self.yPositionConstraint];
  [NSLayoutConstraint activateConstraints:hconstraints];
  vconstraint.active = YES;
  self.yPositionConstraint.active = YES;
  [parent layoutIfNeeded];
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    self.yPositionConstraint.constant = 0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
      [parent layoutIfNeeded];
    } completion:^(BOOL finished) {
      dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
      __weak ORESnackBar *weakSelf = self;
      dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
        __strong ORESnackBar *strongSelf = weakSelf;
        [strongSelf dismiss];
      });
    }];
  }];
}

- (void)dismiss {
  if (!self.superview) {
    return;
  }
  self.yPositionConstraint.constant = ORESnackBarHeight;
  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    [self.superview layoutIfNeeded];
  } completion:^(BOOL finished) {
    if (finished) {
      [self removeFromSuperview];
      self.yPositionConstraint = nil;
    }
  }];
}

- (void)dealloc {
  self.action = nil;
}

/*
- (void)_setup {
  self.backgroundColor = [UIColor yellowColor]; // TODO
  UILabel *message = [[UILabel alloc] initWithFrame:CGRectZero]; {
    message.translatesAutoresizingMaskIntoConstraints = false;
    message.text = self.message;
    message.backgroundColor = [UIColor redColor]; // TODO
  }
  UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom]; {
    action.translatesAutoresizingMaskIntoConstraints = false;
    [action setTitle:self.actionLabel forState:UIControlStateNormal];
    [action addTarget:self action:@selector(_handleReload:) forControlEvents:UIControlEventTouchUpInside];
    [action setBackgroundColor:[UIColor blueColor]]; // TODO
  }
  [self addSubview:message];
  [self addSubview:action];

  NSDictionary *views = NSDictionaryOfVariableBindings(message, action);
 
  NSArray *hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[message]-(5)-[action]-(5)-|" options:0 metrics:nil views:views];
  NSLayoutConstraint *vconstraint1 = [NSLayoutConstraint constraintWithItem:message
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:0];
  NSLayoutConstraint *vconstraint2 = [NSLayoutConstraint constraintWithItem:action
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:0];
  [self addConstraints:hconstraints];
  [self addConstraint:vconstraint1];
  [self addConstraint:vconstraint2];
  [NSLayoutConstraint activateConstraints:hconstraints];
  vconstraint1.active = YES;
  vconstraint2.active = YES;
}
*/

- (void)_handleAction:(id)sender {
  __strong ORESnackBarAction action = self.action;
  if (action) {
    action(sender);
  }
}

@end
