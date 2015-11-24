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

@interface FBNotificationsViewController : UIViewController {

	FBNotificationsComponentsAdapter *_adapter;
	FBNotificationsListView *_notificationsListView;

}

- (void)viewDidLoad;

@end

@interface FBNotifyClear : NSObject

+(instancetype) sharedInstance;

@end

@interface AppDelegate

- (BOOL)fbApplication:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;

@end