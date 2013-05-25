//
//  DCPollRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@class DCWrapper;

@interface DCPollRequest : CGIRemoteObject


@property NSArray *d;
@property NSNumber *i;
@property NSNumber *w;

@end

@interface DCPollRequest (DCMethods)

- (DCWrapper *)Poll;

@end
