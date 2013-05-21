//
//  CGIPersistantObject.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-21.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CGIPersistanceKeyClass(__key, __class) \
- (Class)classForKey ##__key { return [__class class]; }

@protocol CGIPersistantObject <NSObject>

- (id)initFromPersistanceObject:(id)persistance;
- (id)persistaceObject;

@end

@interface CGIPersistantObject : NSObject <CGIPersistantObject>

- (Class)classForKey:(NSString *)key;

@end

@interface CGIPersistantObject (CGIObjectLifetime)

- (void)awakeFromPersistance:(id)persistance;

@end
