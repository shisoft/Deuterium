//
//  DCUserServices.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface DCUserServices : CGIPersistantObject

CGIIdentifierProperty;
@property NSString *account;
@property NSString *gate;

@end
