//
//  DCPoll.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@class DCPoll;

@protocol DCPollDelegate <NSObject>

@required
- (id)poll:(DCPoll *)poll objectForKey:(NSString *)key;
- (void)poll:(DCPoll *)poll receivedObject:(id)object forKey:(NSString *)key;

@end

@interface DCPoll : NSObject

@property NSTimeInterval interval;
@property NSTimeInterval wait;

+ (instancetype)defaultPoll;

- (void)addDelegate:(id<DCPollDelegate>)delegate forKey:(NSString *)key;
- (void)removeDelegate:(id<DCPollDelegate>)delegate;
- (void)removeKey:(NSString *)key;

- (void)start;
- (void)stop;

@end
