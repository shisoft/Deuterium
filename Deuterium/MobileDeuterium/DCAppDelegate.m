//
//  DCAppDelegate.m
//  MobileDeuterium
//
//  Created by Maxthon Chan on 13-5-23.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCAppDelegate.h"
#import "KeychainItemWrapper.h"
#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

dispatch_group_t DCBackgroundTasks;
NSString *const DCUsernameKeychainItemName = @"username";
NSString *const DCDeuteriumKeychainAccessGroup = @"info.maxchan.deuterium";

@interface DCAppDelegate ()

@property BOOL watchdogActiviated;

@end

@implementation DCAppDelegate

+ (instancetype)thisDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (KeychainItemWrapper *)keychainItem
{
    return [[KeychainItemWrapper alloc] initWithIdentifier:DCUsernameKeychainItemName accessGroup:nil];
}

- (void)watchdog;
{
    if (dispatch_group_wait(DCBackgroundTasks, DISPATCH_TIME_NOW))
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if (!self.watchdogActiviated)
        {
            self.watchdogActiviated = YES;
            dispatch_group_notify(DCBackgroundTasks,
                                  dispatch_get_main_queue(),
                                  ^
            {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [DCAppDelegate thisDelegate].watchdogActiviated = NO;
            }
                                  );
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DCBackgroundTasks = dispatch_group_create();
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(watchdog)
                                   userInfo:nil
                                    repeats:YES];
    
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^
    {
        // Set up default connection.
        CGIRemoteConnection *connection = [[CGIRemoteConnection alloc] initWithServerRoot:[NSURL URLWithString:@"https://www.shisoft.net/ajax/"]];
        [connection makeDefaultServerRoot];
        
        // Query keychain for previously stored username and password.
        KeychainItemWrapper *keychainItem = [DCAppDelegate keychainItem];
        
        DCLoginRequest *login = [[DCLoginRequest alloc] init];
        login.user = keychainItem[(__bridge __strong NSString *)(kSecAttrAccount)];
        login.pass = keychainItem[(__bridge __strong NSString *)(kSecValueData)];
        
        if ([login.user length] && [login.pass length])
        {
            DCWrapper *rv = [login login];
            [DCAppDelegate thisDelegate].connected = [rv boolValue];
        }
        else
        {
            [DCAppDelegate thisDelegate].connected = NO;
        }
    }
                         );
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
