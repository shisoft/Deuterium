//
//  DCNews.h
//  Deuterium
//
//  Created by John Shi on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class DCUniversalContact;
@class CLLocation;

@interface DCNews : CGIPersistantObject

CGIIdentifierProperty;
@property NSString *content;
@property NSString *title;
@property NSString *href;
@property CLLocation *location;
@property NSDate *publishTime;
@property DCUniversalContact *authorUC;
@property NSArray *medias;
@property NSString *lang;
@property DCNews *refer;
@property NSString *svr;
@property NSString *type;


@end
