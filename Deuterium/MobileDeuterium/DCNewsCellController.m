//
//  DCNewsCellController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsCellController.h"

#import "DCNewsCell.h"
#import "DCAppDelegate.h"
#import <DeuteriumCore/DeuteriumCore.h>

@implementation DCNewsCellController

- (void)displayNews
{
    // Set up author name:
    if ([self.news.authorUC.dispName length] && [self.news.authorUC.scrName length])
    {
        self.newsCell.authorField.text = CGISTR(@"%@ (%@)",
                                                self.news.authorUC.dispName,
                                                self.news.authorUC.scrName);
    }
    else if ([self.news.authorUC.dispName length])
    {
        self.newsCell.authorField.text = self.news.authorUC.dispName;
    }
    else if ([self.news.authorUC.scrName length])
    {
        self.newsCell.authorField.text = self.news.authorUC.scrName;
    }
    else
    {
        self.newsCell.authorField.text = NSLocalizedString(@"ui.no-name",
                                                           @"Unnamed");
    }
    
    // Set up display time:
    NSTimeInterval timediff = fabs([self.news.publishTime timeIntervalSinceNow]);
    if (timediff < 60.0)
    {
        self.newsCell.timeField.text = NSLocalizedString(@"ui.just-now",
                                                         @"Just now");
    }
    else if (timediff < 3600.0)
    {
        self.newsCell.timeField.text = CGISTR(@"%.0lf %@",
                                              timediff / 60.0,
                                              NSLocalizedString(@"ui.minutes-ago",
                                                                @"mins ago"));
    }
    else if (timediff < 86400.0)
    {
        self.newsCell.timeField.text = CGISTR(@"%.0lf %@",
                                              timediff / 3600.0,
                                              NSLocalizedString(@"ui.hours-ago",
                                                                @"hrs ago"));
    }
    else if (timediff < 172400.0)
    {
        self.newsCell.timeField.text = NSLocalizedString(@"ui.yesterday",
                                                         @"yesterday");
    }
    else if (timediff < 604800.0)
    {
        self.newsCell.timeField.text = CGISTR(@"%.0lf %@",
                                              timediff / 86400.0,
                                              NSLocalizedString(@"ui.days-ago",
                                                                @"days ago"));
    }
    else if (timediff < 2592000.0)
    {
        self.newsCell.timeField.text = CGISTR(@"%.0lf %@",
                                              timediff / 604800.0,
                                              NSLocalizedString(@"ui.weeks-ago",
                                                                @"days ago"));
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.newsCell.timeField.text = [formatter stringFromDate:self.news.publishTime];
    }
    
    // Set up avatar
    self.newsCell.avatarURL = self.news.authorUC.avatar;
    [self.newsCell loadAvatar];
    
    // Set up title
    if ([self.news.title length])
    {
        self.newsCell.titleField.text = self.news.title;
    }
    else
    {
        self.newsCell.titleField.text = NSLocalizedString(@"ui.no-title",
                                                          @"Untitled");
    }
    
    // Set up contents
    DCSetFrameWidth(self.newsCell.contentField, 280);
    if ([self.news.content length])
    {
        self.newsCell.contentField.text = self.news.content;
    }
    else
    {
        self.newsCell.contentField.text = nil;
    }
    [self.newsCell sizeToFit];
}

- (NSComparisonResult)compare:(DCNewsCellController *)other
{
    switch ([self.news.publishTime compare:other.news.publishTime])
    {
        case NSOrderedAscending:
            return NSOrderedDescending;
            break;
        case NSOrderedDescending:
            return NSOrderedAscending;
            break;
        default:
            return NSOrderedSame;
            break;
    }
}

@end
