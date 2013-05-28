//
//  DCInitialViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-23.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCInitialViewController.h"

#import "DCAppDelegate.h"
#import <DeuteriumCore/DeuteriumCore.h>

@interface DCInitialViewController ()

@property (weak) IBOutlet UIImageView *imageView;

@end

@implementation DCInitialViewController

- (void)viewWillAppear:(BOOL)animated
{
    // Relocate the image view
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.imageView.frame = CGRectMake(0.0, -20.0, screenSize.width, screenSize.height);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) // iPad
    {
        
    }
    else // iPhones
    {
        if (self.view.frame.size.height > 500.0) // iPhone 5
        {
            self.imageView.image = [UIImage imageNamed:@"Default-568h"];
        }
        else
        {
            self.imageView.image = [UIImage imageNamed:@"Default"];
        }
    }
}

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
