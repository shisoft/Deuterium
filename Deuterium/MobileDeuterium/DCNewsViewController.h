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

- (NSArray *)recentNews;
- (NSArray *)nextPage;

@end
