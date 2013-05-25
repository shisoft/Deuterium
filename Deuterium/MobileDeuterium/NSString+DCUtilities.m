//
//  NSString+DCUtilities.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-26.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "NSString+DCUtilities.h"

@implementation NSString (DCUtilities)

- (NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
