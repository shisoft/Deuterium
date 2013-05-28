//
//  DCRecentNewsViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-28.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCRecentNewsViewController.h"
#import <DeuteriumCore/DeuteriumCore.h>
#import "DCNewsCell.h"
#import "DCNewsCellController.h"

@interface DCRecentNewsViewController () <DCPollDelegate>

@property BOOL polling;
@property NSUInteger unread;

@end

@implementation DCRecentNewsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[DCPoll defaultPoll] addDelegate:self
                               forKey:@"newsc"];
}

- (NSArray *)recentNews
{
    DCNewsRequest *newsRequest = [[DCNewsRequest alloc] init];
    newsRequest.count = 25;
    newsRequest.lastT = [NSDate distantPast];
    return [newsRequest getWhatzNew];
}

- (NSArray *)nextPage
{
    DCNewsRequest *newsRequest = [[DCNewsRequest alloc] init];
    newsRequest.count = 25;
    newsRequest.lastT = [[self.newsControllers lastObject] news].publishTime;
    return [newsRequest getWhatzNew];
}

- (id)poll:(DCPoll *)poll objectForKey:(NSString *)key
{
    if ([self.newsControllers count])
    {
        DCNewsPoll *poll = [[DCNewsPoll alloc] init];
        poll.dvt = self.unread;
        poll.lt = [self.newsControllers[0] news].publishTime;
        return poll;
    }
    else
    {
        return nil;
    }
}

- (void)poll:(DCPoll *)poll receivedObject:(id)object forKey:(NSString *)key
{
    if ([object respondsToSelector:@selector(integerValue)])
    {
        self.unread = [object integerValue];
    }
    if (self.unread > 0)
    {
        self.navigationController.tabBarItem.badgeValue = CGISTR(@"%i", self.unread);
    }
}

- (void)newsDidUpdate
{
    self.unread = 0;
    self.navigationController.tabBarItem.badgeValue = nil;
    [[DCPoll defaultPoll] repoll];
}

@end
