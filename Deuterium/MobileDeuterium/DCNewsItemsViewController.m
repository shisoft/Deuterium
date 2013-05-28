//
//  DCNewsItemsViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-28.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsItemsViewController.h"

@interface DCNewsItemsViewController ()

@property BOOL copied;

@end

@implementation DCNewsItemsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.news.content length])
    {
        self.copied = YES;
        self.news.content = self.news.title;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.copied)
    {
        self.news.content = @"";
    }
    
    [super viewDidDisappear:animated];
}

- (NSArray *)recentNews
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (DCNews *news = self.news; [news isKindOfClass:[DCNews class]]; news = news.refer)
        [array addObject:news];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.navigationItem.title = CGISTR(@"%i %@", [array count], NSLocalizedString(@"ui.messages-no", @""));
                   });
    
    return array;
}

- (BOOL)useDetails
{
    return NO;
}

@end
