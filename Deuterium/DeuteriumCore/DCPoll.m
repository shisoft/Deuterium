//
//  DCPoll.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCPoll.h"

DCPoll *__defaultPoller;

@interface DCPoll () <NSURLConnectionDelegate>
{
    NSMutableDictionary *_delegates;
    BOOL _go;
    NSURLConnection *_connection;
}

@end

@implementation DCPoll


+ (instancetype)defaultPoll
{
    if (!__defaultPoller)
        __defaultPoller = [[self alloc] init];
    return __defaultPoller;
}

- (id)init
{
    if (self = [super init])
    {
        _delegates = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addDelegate:(id<DCPollDelegate>)delegate forKey:(NSString *)key
{
    _delegates[key] = delegate;
}

- (void)removeKey:(NSString *)key
{
    [_delegates removeObjectForKey:key];
}

- (void)removeDelegate:(id<DCPollDelegate>)delegate
{
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[_delegates count]];
    for (NSString *key in _delegates)
    {
        if ([_delegates[key] isEqual:delegate])
        {
            [keys addObject:key];
        }
    }
    [_delegates removeObjectsForKeys:keys];
}

- (void)start
{
    
}

- (void)stop
{
    
}

@end
