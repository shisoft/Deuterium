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

@end

@implementation DCDiscoveryViewController

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *currentUserInterests = [defaults objectForKey:@"DiscoveryAspects"];
    if (!currentUserInterests)
        currentUserInterests = @[];
    
    if (![currentUserInterests isEqual:self.currentUserInterests])
    {
        self.currentUserInterests = currentUserInterests;
        self.newsControllers = [NSMutableArray array];
    }
    
    [self.tableView reloadData];
    
    [super viewDidAppear:animated];
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
