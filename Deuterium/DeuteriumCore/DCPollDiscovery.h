//
//  DCPollDiscovery.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface DCPollDiscovery : CGIPersistantObject

@property NSString *t;
@property NSNumber *c;
@property NSDate *lt;
@property NSNumber *th;
@property NSArray *topics;

@end
