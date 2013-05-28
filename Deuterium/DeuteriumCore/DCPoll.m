//
//  DCPoll.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCPoll.h"
#import "DCPollRequest.h"
#import "DCWrapper.h"

DCPoll *__defaultPoller;

@interface DCPoll () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableDictionary *_delegates;
    BOOL _go;
    NSURLConnection *_connection;
    NSHTTPURLResponse *_response;
    NSMutableData *_responseData;
    NSUInteger _responseLength;
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
        self.interval = 0.5;
        self.wait = 10.0;
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

static inline NSInteger __DCPollTimeFromTimeInterval(NSTimeInterval iv)
{
    return (NSInteger)(iv * 1000.0);
}

- (void)__poll
{
    if (!_go)
        return;
    
    NSMutableArray *pollObjects = [NSMutableArray arrayWithCapacity:[_delegates count]];
    for (NSString *key in _delegates)
    {
        id<DCPollDelegate> delegate = _delegates[key];
        id object = [delegate poll:self objectForKey:key];
        if ([object conformsToProtocol:@protocol(CGIPersistantObject)])
        {
            object = [object persistaceObject];
        }
        if (object)
        {
            [pollObjects addObject:object];
        }
    }
    
    DCPollRequest *pollRequest = [[DCPollRequest alloc] init];
    pollRequest.d = pollObjects;
    pollRequest.i = __DCPollTimeFromTimeInterval(self.interval);
    pollRequest.w = __DCPollTimeFromTimeInterval(self.wait);
    
    NSData *data = [pollRequest JSONDataWithError:NULL];
    
    if (!data)
        return;
    
    CGIRemoteConnection *conn = [CGIRemoteConnection defaultRemoteConnection];
    
    NSMutableURLRequest *request = [conn URLRequestForMethod:@"Poll"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:@"application/json;charset=utf-8"
   forHTTPHeaderField:@"Content-Type"];
    
    _connection = [NSURLConnection connectionWithRequest:request
                                                delegate:self];
    NSLog(@"poll: ping");
    [_connection start];
}

- (void)__process
{
    NSDictionary *responseObject = [[[DCWrapper alloc] initWithJSONData:_responseData error:NULL] d];
    
    _connection = nil;
    _response = nil;
    _responseLength = 0;
    _responseData = nil;
    
    NSLog(@"poll: pong");
    
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        for (NSString *key in responseObject)
        {
            id<DCPollDelegate> delegate = _delegates[key];
            
            if (delegate)
            {
                [delegate poll:self receivedObject:responseObject[key] forKey:key];
            }
        }
    }
    
    if (_go)
    {
        [self __poll];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = (NSHTTPURLResponse *)response;
    
    if ([_response statusCode] >= 400)
    {
        [_connection cancel];
        _connection = nil;
        [self __poll];
    }
    else
    {
        _responseLength = [[_response allHeaderFields][@"Content-Length"] integerValue];
        _responseData = [NSMutableData dataWithCapacity:_responseLength];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    if ([_responseData length] >= _responseLength)
    {
        [_responseData setLength:_responseLength];
        [self __process];
    }
}

- (void)start
{
    _connection = nil;
    _go = YES;
    [self __poll];
}

- (void)stop
{
    _go = NO;
    if (_connection)
    {
        [_connection cancel];
        _connection = nil;
    }
}

- (void)repoll
{
    if (_connection)
    {
        [_connection cancel];
        _connection = nil;
    }
    [self __poll];
}

@end
