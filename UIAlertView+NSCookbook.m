#include "UIAlertView+NSCookbook.h"
#include <objc/runtime.h>

@interface NSCBAlertWrapper : NSObject

@property (copy) void(^completionBlock)(UIAlertView* alertView, NSInteger buttonIndex);

@end

@implementation NSCBAlertWrapper

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {

	if(self.completionBlock)
		self.completionBlock(alertView, buttonIndex);
}

-(void)alertViewCancel:(UIAlertView*)alertView {

	if(self.completionBlock)
		self.completionBlock(alertView, alertView.cancelButtonIndex);
}

@end

static const char kNSCBAlertWrapper;

@implementation UIAlertView (NSCookbook) 

#pragma mark - Class Public

-(void) showWithCompletion:(void(^) (UIAlertView* alertView, NSInteger buttonIndex)) completion {

	NSCBAlertWrapper* alertWrapper = [[NSCBAlertWrapper alloc] init];
	alertWrapper.completionBlock = completion;
	self.delegate = alertWrapper;

	objc_setAssociatedObject(self, &kNSCBAlertWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	[self show];
}

@end