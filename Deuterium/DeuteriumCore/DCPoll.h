//
//  DCPoll.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CGI>

@protocol DCPollDelegate <NSObject>

- (CGI)

@end

@interface DCPoll : NSObject

@property NSNotificationCenter *pollNotificationCenter;

@end
