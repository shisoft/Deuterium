//
//  DCGetUserTopicDistRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCGetUserTopicDistRequest : CGIRemoteObject

@end

@interface DCGetUserTopicDistRequest (DCMethods)

- (NSArray *)getUserTopicDist;

@end