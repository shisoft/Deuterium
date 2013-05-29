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
#import "NSString+DCUtilities.h"

@implementation DCNewsCellController

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(heartbeat:)
                                                     name:DCHeartbeatNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)heartbeat:(NSNotification *)notification
{
    self.newsCell.timeField.text = [self timeDescription];
}

- (NSString *)timeDescription
{
    // Set up display time:
    NSTimeInterval timediff = fabs([self.news.publishTime timeIntervalSinceNow]);
    if (timediff < 60.0)
    {
        return NSLocalizedString(@"ui.just-now",
                                 @"Just now");
    }
    else if (timediff < 3600.0)
    {
        return CGISTR(@"%.0lf %@",
                      timediff / 60.0,
                      NSLocalizedString(@"ui.minutes-ago",
                                        @"mins ago"));
    }
    else if (timediff < 86400.0)
    {
        return CGISTR(@"%.0lf %@",
                      timediff / 3600.0,
                      NSLocalizedString(@"ui.hours-ago",
                                        @"hrs ago"));
    }
    else if (timediff < 172400.0)
    {
        return NSLocalizedString(@"ui.yesterday",
                                 @"yesterday");
    }
    else if (timediff < 604800.0)
    {
        return CGISTR(@"%.0lf %@",
                      timediff / 86400.0,
                      NSLocalizedString(@"ui.days-ago",
                                        @"days ago"));
    }
    else if (timediff < 2592000.0)
    {
        return CGISTR(@"%.0lf %@",
                      timediff / 604800.0,
                      NSLocalizedString(@"ui.weeks-ago",
                                        @"days ago"));
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        return [formatter stringFromDate:self.news.publishTime];
    }
}

- (NSString *)authorDescription
{
    // Set up author name:
    if ([self.news.authorUC.dispName length] && [self.news.authorUC.scrName length])
    {
        return CGISTR(@"%@ (%@)",
                      self.news.authorUC.dispName,
                      self.news.authorUC.scrName);
    }
    else if ([self.news.authorUC.dispName length])
    {
        return self.news.authorUC.dispName;
    }
    else if ([self.news.authorUC.scrName length])
    {
        return self.news.authorUC.scrName;
    }
    else
    {
        return NSLocalizedString(@"ui.no-name",
                                 @"Unnamed");
    }
}

- (NSString *)titleDescription
{
    // Set up title
    if ([self.news.title length])
    {
        return self.news.title;
    }
    else
    {
        return NSLocalizedString(@"ui.no-title",
                                 @"Untitled");
    }
}

- (NSString *)contentDescription
{
    if ([self.news.content length])
    {
        return [[[[self.news.content stringByStrippingHTML] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else
    {
        return nil;
    }
}

- (void)displayNews
{
    DCNewsCell *newsCell = self.newsCell;
    
    newsCell.authorField.text = [self authorDescription];
    
    newsCell.timeField.text = [self timeDescription];
    
    // Set up avatar
    newsCell.avatarURL = self.news.authorUC.avatar;
    [newsCell loadAvatar];
    
    newsCell.titleField.text = [self titleDescription];
    
    // Set up contents
    DCSetFrameWidth(newsCell.contentField, 280);
    newsCell.contentField.text = [self contentDescription];
    
    CGRect frame = newsCell.contentField.frame;
    frame.size.height = newsCell.frame.size.height - frame.origin.x - 3;
    newsCell.contentField.frame = frame;
    
    NSUInteger n = 0;
    for (DCNews *news = self.news;
         [news isKindOfClass:[DCNews class]];
         news = news.refer)
        n++;
    
    if (n > 1)
    {
        newsCell.numberLabel.text = CGISTR(@"%i", n);
        newsCell.numberLabel.hidden = NO;
    }
    else
    {
        newsCell.numberLabel.hidden = YES;
    }
    
    [newsCell setNeedsDisplay];
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

- (CGFloat)heightForCell
{
    return 44 + [[self contentDescription] sizeWithFont:[UIFont systemFontOfSize:13]
                                      constrainedToSize:CGSizeMake(275.0, 100.0)
                                          lineBreakMode:NSLineBreakByWordWrapping].height;
}

- (BOOL)isEqual:(DCNewsCellController *)object
{
    return [self.news isEqual:object.news];
}

@end
