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

- (CGIPersistantObject *)pollObjectForPoll:(DCPoll *)poll;

@end

@interface DCPoll : NSObject

@property NSNotificationCenter *pollNotificationCenter;

@end
