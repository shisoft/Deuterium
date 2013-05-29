//
//  DCLocationPickerController.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DCLocationPickerController : NSObject

@property (weak) IBOutlet UIBarButtonItem *locationButton;
@property (weak) IBOutlet UIViewController *viewController;
@property CLLocation *location;

- (IBAction)locationPressed:(id)sender;
- (void)initializeView;

@end
