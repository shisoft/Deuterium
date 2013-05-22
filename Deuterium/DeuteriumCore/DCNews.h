//
//  DCNews.h
//  Deuterium
//
//  Created by John Shi on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class DCUniversalContact;

@interface DCNews : CGIPersistantObject

@property id ID;
@property NSString *content;
@property NSString *title;
@property NSString *href;
@property NSDate *publishTime;
@property DCUniversalContact *authorUC;
@property NSArray *medias;

@end
