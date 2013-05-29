//
//  DCLocationPickerController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCLocationPickerController.h"
#import "DCAppDelegate.h"

@interface DCLocationPickerController () <CLLocationManagerDelegate>

@property BOOL locating;
@property CLLocationManager *locationManager;

@end

@implementation DCLocationPickerController

- (void)initializeView
{
    self.locationButton.enabled = [CLLocationManager locationServicesEnabled];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)locationPressed:(id)sender
{
    if (!self.location)
    {
        if (!self.locating)
        {
            self.locating = YES;
            [self.locationManager startUpdatingLocation];
            dispatch_group_enter(DCBackgroundTasks);
            self.locationButton.tintColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];
        }
        else
        {
            [self.locationManager stopUpdatingLocation];
            dispatch_group_leave(DCBackgroundTasks);
            if (self.location)
            {
                self.locationButton.tintColor = [UIColor blueColor];
            }
            else
            {
                self.locationButton.tintColor = nil;
            }
        }
    }
    else
    {
        self.location = nil;
        if (self.location)
        {
            self.locationButton.tintColor = [UIColor blueColor];
        }
        else
        {
            self.locationButton.tintColor = nil;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.location = nil;
    self.locating = NO;
    dispatch_group_leave(DCBackgroundTasks);
    if (self.location)
    {
        self.locationButton.tintColor = [UIColor blueColor];
    }
    else
    {
        self.locationButton.tintColor = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if (fabs([[location timestamp] timeIntervalSinceNow]) <= 300)
    {
        self.location = location;
        self.locating = NO;
        [self.locationManager stopUpdatingLocation];
        dispatch_group_leave(DCBackgroundTasks);
        if (self.location)
        {
            self.locationButton.tintColor = [UIColor blueColor];
        }
        else
        {
            self.locationButton.tintColor = nil;
        }
    }
}

@end
