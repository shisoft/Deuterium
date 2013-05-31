//
//  DCAppDelegate.h
//  MobileDeuterium
//
//  Created by Maxthon Chan on 13-5-23.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DeuteriumCore/DeuteriumCore.h>

#define DCCacheFile() CGISTR(@"%@/Library/Caches/%@/%@.plist", NSHomeDirectory(), [[NSBundle mainBundle] bundleIdentifier], NSStringFromClass([self class]));

static inline BOOL DCHasRefreshControl(void)
{
    return ((NSClassFromString(@"UIRefreshControl")) ? YES : NO);
}

static inline void DCSetFrameWidth(UIView *view, CGFloat newWidth)
{
    CGRect rect = view.frame;
    rect.size.width = newWidth;
    view.frame = rect;
}

@class KeychainItemWrapper;

extern dispatch_group_t DCBackgroundTasks;
extern NSString *const DCUsernameKeychainItemName;
extern NSString *const DCDeuteriumKeychainAccessGroup;
extern NSString *const DCHeartbeatNotification;
extern NSString *const DCCachePurgedNotification;

@interface DCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL connected;

+ (instancetype)thisDelegate;
+ (KeychainItemWrapper *)keychainItem;

@end
