//
//  DCDiscoveryRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCDiscoveryRequest : CGIRemoteObject

@property NSDate *beforeT;
@property NSUInteger count;
@property NSDate *lastT;
@property double threshold;
@property NSArray *topics;

@end

@interface DCDiscoveryRequest (DCMethods)

- (NSArray *)streamDiscover;

@end