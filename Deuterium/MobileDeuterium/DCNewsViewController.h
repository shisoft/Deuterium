//
//  DCNewsViewController.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

#define refreshButton navigationItem.leftBarButtonItem

@interface DCNewsViewController : UITableViewController

@property NSMutableArray *newsControllers;
@property BOOL realData;

- (void)newsDidUpdate;
- (BOOL)newsCanUpdate;
- (BOOL)newsCanPage;
- (BOOL)useDetails;

@end

@interface DCNewsViewController (DCOverridables)

- (NSArray *)recentNews;
- (NSArray *)nextPage;

@end
