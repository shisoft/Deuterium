//
//  DCUserContactLink.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface DCUserContactLink : CGIPersistantObject

CGIIdentifierProperty;
@property id svr;
@property id uc;
@property id user;

@end
