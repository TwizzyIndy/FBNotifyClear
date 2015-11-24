
#import "FBNotifyClear.h"


#define kPrefPath @"/private/var/mobile/Library/Preferences/com.twizzyindy.fbnotifyclear.setting.plist"

@implementation FBNotifyClear

+(instancetype) sharedInstance {

	static FBNotifyClear* __sharedInstance;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{

		__sharedInstance = [[self alloc] init];

	});

	return __sharedInstance;

}

@end

static BOOL isTweakOn;

// init preferences setting

static void initPref() {

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:kPrefPath];
    isTweakOn = [[dict objectForKey:@"isEnabled"] boolValue];

}

%hook FBNotificationsViewController

- (void)viewDidLoad {

    %orig;

    if( isTweakOn ){

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearTapped)];
    
    }

}

%new
-(void)clearTapped {
    
    UIAlertController* alert = [[UIAlertController alertControllerWithTitle:@"FBNotifyClear" message:@"Clear all cached notifications ?" preferredStyle:UIAlertControllerStyleAlert] init];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        FBNotificationsComponentsAdapter* adapter = MSHookIvar<FBNotificationsComponentsAdapter*> (self, "_adapter");
        FBNotificationsListView* notificationsListView = MSHookIvar<FBNotificationsListView*>(self, "_notificationsListView");

        NSArray* notifications;
        object_getInstanceVariable(adapter, "_notifications", (void**) &notifications);
        
        NSMutableDictionary* enqueuedNotifications;
        object_getInstanceVariable(adapter, "_enqueuedNotifications", (void**) &enqueuedNotifications);



        HBLogInfo(@"\n\nFBNotifyClear: _notifications : %@\n\n", notifications );
        HBLogInfo(@"\n\nFBNotifyClear: _enqueuedNotifications : %@\n\n", enqueuedNotifications );

        [notificationsListView.tableView beginUpdates];

        [adapter _cleanupCurrentTableView];

        [notificationsListView.tableView endUpdates];


        // delete cache

        // get Cache dir ..
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* dirCache = [NSString stringWithFormat:@"%@", [paths objectAtIndex:0]];
        HBLogInfo(@"dirCache = %@", dirCache);

        
        NSFileManager* fileMan = [NSFileManager defaultManager];
        
        // get files and folders in Cache dir
        
        NSArray* itemsInCacheFolder = [ fileMan contentsOfDirectoryAtPath:dirCache error:nil];
        
        for (int y = 0; y < itemsInCacheFolder.count; y++) {
            
            // if found a dir named, "_store_"
            
            if ([[itemsInCacheFolder objectAtIndex:y] hasPrefix:@"_store_"]) {
                
                // get dir link for _store_ folder
                
                NSString* storeFolder = [itemsInCacheFolder objectAtIndex:y];
                NSString* dirStoreFolder = [NSString stringWithFormat:@"%@/%@", dirCache, storeFolder];
                HBLogInfo(@"dirStoreFolder = %@", dirStoreFolder);
                
                // get files and folders in _store_ folder
                
                NSArray* itemsInStoreFolder = [fileMan contentsOfDirectoryAtPath:dirStoreFolder error:nil];
                
                for (int i=0; i < itemsInStoreFolder.count; i++) {
                    
                    // if found a dir named as "default_diskcache_"
                    
                    if([[itemsInStoreFolder objectAtIndex:i] hasPrefix:@"default_diskcache_"]) {
                        
                        // find and get dir link for default_diskcache_ folder
                        
                        NSString* defaultDiskCacheFolder = [itemsInStoreFolder objectAtIndex:i];
                        NSString* dirDefaultDiskCacheFolder = [NSString stringWithFormat:@"%@/%@", dirStoreFolder, defaultDiskCacheFolder];
                        HBLogInfo(@"dirDefaultDiskCacheFolder = %@", dirDefaultDiskCacheFolder);

                        // get files and folders in default_diskcache_ folder
                        
                        NSArray* itemsInDefaultDiskCacheFolder = [fileMan contentsOfDirectoryAtPath:dirDefaultDiskCacheFolder error:nil];
                        
                        for (int j=0; j < [itemsInDefaultDiskCacheFolder count]; j++) {
                            
                            // get files in default_diskcache
                            NSString* strNotification = [[NSString alloc]initWithString:@"notifications"];
                            
                            // get files contains 'notifications' for delete
                            // it could be better for upcoming versions

                            if ([[itemsInDefaultDiskCacheFolder objectAtIndex:j] containsString:strNotification]) {
                                
                                NSString* dirNotiFiles = [NSString stringWithFormat:@"%@/%@", dirDefaultDiskCacheFolder, [itemsInDefaultDiskCacheFolder objectAtIndex:j]];
                                HBLogInfo(@"dirNotiFiles : %@", dirNotiFiles);

                                if([fileMan fileExistsAtPath:dirNotiFiles isDirectory:0]) {
                                    [fileMan removeItemAtPath:dirNotiFiles error:nil];
                                    
                                    HBLogInfo(@"Deleted");

                                    //notifications = [NSArray array];

                                    [adapter reloadData];
                                    [notificationsListView.tableView reloadData];
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
        }




        
    }];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
       
        
    }];
    
    [alert addAction:actionOK];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];

}

%end

%hook AppDelegate
- (BOOL)fbApplication:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {

    //[[[UIAlertView alloc] initWithTitle:@"FBNotifyCleanup" message:@"Test" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

    return %orig;
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL, (CFNotificationCallback)initPref, CFSTR("com.twizzyindy.fbnotifyclear.setting.changed"),
                                    NULL, CFNotificationSuspensionBehaviorCoalesce);

    initPref();

    // NSMutableDictionary* pref = [[NSMutableDictionary alloc] initWithContentsOfFile:kPrefPath];
    
    if( isTweakOn ){
        %init();
    }
}