//
//  DCNewsPoll.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-28.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface DCNewsPoll : CGIPersistantObject

@property NSUInteger dvt;
@property NSString *exceptions;
@property NSDate *lt;
@property NSString *t;
@property NSString *type;

@end
