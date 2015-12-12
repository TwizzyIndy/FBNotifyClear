#import <UIKit/UIKit.h>

@interface UIAlertView (NSCookbook)

-(void) showWithCompletion:(void(^) (UIAlertView* alertView, NSInteger buttonIndex)) completion;

@end