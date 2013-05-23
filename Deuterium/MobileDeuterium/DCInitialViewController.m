//
//  DCInitialViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-23.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCInitialViewController.h"

#import "DCAppDelegate.h"

@interface DCInitialViewController ()

@end

@implementation DCInitialViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^
    {
        dispatch_group_wait(DCBackgroundTasks, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(),
                       ^
        {
            if ([DCAppDelegate thisDelegate].connected)
            {
                [self performSegueWithIdentifier:@"main" sender:self];
            }
            else
            {
                [self performSegueWithIdentifier:@"login" sender:self];
            }
        }
                       );
    }
                   );
}

@end
