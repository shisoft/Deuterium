//
//  DCDiscoveryViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCDiscoveryViewController.h"
#import <DeuteriumCore/DeuteriumCore.h>
#import "DCAppDelegate.h"
#import "DCNewsCell.h"
#import "DCNewsCellController.h"
#import "DCDiscoveryOptionViewController.h"

@interface DCDiscoveryViewController ()

@property NSArray *currentUserInterests;

@property BOOL doLoad;

@end

@implementation DCDiscoveryViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentUserInterests = [defaults objectForKey:@"DiscoveryAspects"];
    
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (NSArray *)recentNews
{
    DCDiscoveryRequest *discovery = [[DCDiscoveryRequest alloc] init];
    discovery.beforeT = [NSDate distantFuture];
    discovery.lastT = [NSDate distantPast];
    discovery.count = 25;
    discovery.threshold = 0.02;
    discovery.topics = self.currentUserInterests;
    return [discovery streamDiscover];
}

- (NSArray *)nextPage
{
    DCDiscoveryRequest *discovery = [[DCDiscoveryRequest alloc] init];
    discovery.beforeT = [[self.newsControllers lastObject] news].publishTime;
    discovery.lastT = [NSDate distantPast];
    discovery.count = 25;
    discovery.threshold = 0.02;
    discovery.topics = self.currentUserInterests;
    return [discovery streamDiscover];
}

@end
