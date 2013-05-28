//
//  DCNewsPoll.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-28.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsPoll.h"

@implementation DCNewsPoll

- (void)awakeFromPersistance:(id)persistance
{
    self.t = @"newsc";
    self.exceptions = @"";
    self.type = @"";
}

@end
