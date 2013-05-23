//
//  DCWrapper.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCWrapper.h"

@implementation DCWrapper

@end

@implementation DCWrapper (DCAccessorMethods)

- (NSString *)stringValue
{
    return ([self.d isKindOfClass:[NSString class]]) ? self.d : nil;
}

- (BOOL)boolValue
{
    if ([self.d isKindOfClass:[NSString class]])
    {
        return [self.d isEqualToString:@"+"] || [self.d boolValue];
    }
    else if ([self.d respondsToSelector:@selector(boolValue)])
    {
        return [self.d boolValue];
    }
    else
    {
        return NO;
    }
}

- (id)objectValueWithClass:(Class)class
{
    if ([class conformsToProtocol:@protocol(CGIPersistantObject)])
    {
        return [[class alloc] initWithPersistanceObject:self.d];
    }
    else
    {
        return self.d;
    }
}

@end