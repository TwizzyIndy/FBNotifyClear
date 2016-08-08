#import <UIKit/UIKit.h>
#include <Foundation/Foundation.h>


@interface FBNotificationsView : UIView {

	UITableView* _tableView;

}

@property (readonly,nonatomic) UITableView* tableView;

-(void) layoutSubviews;

@end

@interface FBUpdateAnnouncingTableView : UITableView {

}

- (void)endUpdates;
- (void)beginUpdates;

@end

@protocol FBAlertViewCoordinatorProtocol <NSObject>
- (unsigned long long)showAlertViewWithTitle:(NSString *)arg1 message:(NSString *)arg2 configuration:(void (^)(UIAlertView *))arg3 completion:(void (^)(UIAlertView *, long long, _Bool))arg4 cancelButtonTitle:(NSString *)arg5 otherButtonTitles:(NSString *)arg6;
@end


@interface FBAlertViewCoordinator : NSObject <UIAlertViewDelegate, FBAlertViewCoordinatorProtocol>
{
    
}

+ (id)sharedCoordinator;
- (id)alertViewWithTitle:(id)arg1 message:(id)arg2 delegate:(id)arg3 cancelButtonTitle:(id)arg4 otherButtonTitlesCollection:(id)arg5;
- (id)alertViewWithTitle:(id)arg1 message:(id)arg2 delegate:(id)arg3 cancelButtonTitle:(id)arg4 otherButtonTitles:(id)arg5;
- (void)alertView:(id)arg1 clickedButtonAtIndex:(long long)arg2;
- (void)alertView:(id)arg1 didDismissWithButtonIndex:(long long)arg2;

@end

@interface FBNotificationsListView : UIView {
	FBUpdateAnnouncingTableView* _tableView;
}

@property(readonly, nonatomic) FBUpdateAnnouncingTableView *tableView;

- (id)initWithFrame:(struct CGRect)arg1 separatorStyle:(long long)arg2;

@end

@interface FBNotificationsComponentsAdapter : NSObject {
	NSArray* _notifications;
	NSMutableDictionary *_enqueuedNotifications;
}

@property(readonly, copy, nonatomic) NSArray *notifications;

- (void)_cleanupCurrentTableView;
- (void)reloadData;


@end

@interface FBMemNotificationStoriesEdge : NSObject

@end

@interface FBNotificationsViewController : UIViewController {

	FBNotificationsComponentsAdapter *_adapter;
	FBNotificationsListView *_notificationsListView;
	FBMemNotificationStoriesEdge *_chevronNotification;

}

- (void)viewDidLoad;

@end

@interface FBNotifyClear : NSObject

+(instancetype) sharedInstance;

@end

@interface AppDelegate

- (BOOL)fbApplication:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;

@end