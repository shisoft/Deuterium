//
//  DCUserContact.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@class DCUniversalContact;

@interface DCUserContact : CGIPersistantObject

CGIIdentifierProperty;
@property id user;
@property NSArray *ucs;
@property NSString *name;
@property DCUniversalContact *avatar;

@end
