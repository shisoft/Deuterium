//
//  DCAppDelegate.h
//  MobileDeuterium
//
//  Created by Maxthon Chan on 13-5-23.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DeuteriumCore/DeuteriumCore.h>

@class KeychainItemWrapper;

extern dispatch_group_t DCBackgroundTasks;
extern NSString *const DCUsernameKeychainItemName;
extern NSString *const DCDeuteriumKeychainAccessGroup;

@interface DCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL connected;

+ (instancetype)thisDelegate;
+ (KeychainItemWrapper *)keychainItem;

@end
