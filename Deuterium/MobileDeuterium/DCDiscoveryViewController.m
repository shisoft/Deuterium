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

@interface DCDiscoveryViewController ()

@end

@implementation DCDiscoveryViewController

- (NSArray *)recentNews
{
    DCDiscoveryRequest *discovery = [[DCDiscoveryRequest alloc] init];
    discovery.beforeT = [NSDate distantFuture];
    discovery.lastT = [NSDate distantPast];
    discovery.count = 25;
    discovery.threshold = 0.02;
    discovery.topics = @[];
    return [discovery streamDiscover];
}

- (NSArray *)nextPage
{
    DCDiscoveryRequest *discovery = [[DCDiscoveryRequest alloc] init];
    discovery.beforeT = [[self.newsControllers lastObject] news].publishTime;
    discovery.lastT = [NSDate distantPast];
    discovery.count = 25;
    discovery.threshold = 0.02;
    discovery.topics = @[];
    return [discovery streamDiscover];
}

@end
