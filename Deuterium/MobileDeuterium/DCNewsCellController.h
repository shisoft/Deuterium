//
//  DCNewsCellController.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCNews, DCNewsCell;

@interface DCNewsCellController : NSObject

@property (weak) DCNews *news;
@property (weak) DCNewsCell *newsCell;

- (NSComparisonResult)compare:(DCNewsCellController *)other;
- (void)displayNews;

@end
