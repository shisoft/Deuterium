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
        self.newsCell.authorField.text = NSLocalizedString(@"ui.no-name", @"Unnamed");
    }
    
    // Set up display time:
    NSTimeInterval timediff = fabs([self.news.publishTime timeIntervalSinceNow]);
    if (timediff < 60.0)
    {
        self.newsCell.timeField.text = NSLocalizedString(@"ui.just-now", @"Just now");
    }
    else if (timediff < 3600.0)
    {
        self.newsCell.timeField.text = CGISTR(@"%.0lf %@",
                                              timediff / 60.0,
                                              NSLocalizedString(@"minutes-ago", @"mins ago"));
    }
    else if (timediff < 86400.0)
    {
        self.newsCell.timeField.text = CGISTR(@"%.0lf %@",
                                              timediff / 3600.0,
                                              NSLocalizedString(@"hours-ago", @"hrs ago"));
    }
}

@end
