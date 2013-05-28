//
//  DCAddBookmarkRequest.m
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCAddBookmarkRequest.h"
#import "DCWrapper.h"

@implementation DCAddBookmarkRequest

CGIRemoteMethodClass(addBookmark, DCWrapper); // return bookmark id if success, '*' star if exists.

@end
