//
//  DCSetStausRequest.m
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCSetStatusRequest.h"

@implementation DCSetStatusRequest

#ifdef DCSETSTATUS_MISSPELLED
- (id)setStatus
{
    return [self setStaus];
}
#endif

@end
