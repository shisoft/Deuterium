//
//  DCWrapper.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

extern NSString *const DCDefaultTrue;
extern NSString *const DCDefaultFalse;

@interface DCWrapper : CGIPersistantObject

@property id d;

@end

@interface DCWrapper (DCAccessorMethods)

- (NSString *)stringValue;
- (BOOL)boolValue;
- (id)objectValueWithClass:(Class)class;

@end
