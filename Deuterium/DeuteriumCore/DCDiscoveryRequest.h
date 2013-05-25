//
//  DCDiscoveryRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@class DCWrapper;

@interface DCDiscoveryRequest : CGIRemoteObject

@property NSDate *beforeT;
@property NSString *count;
@property NSDate *lastT;
@property NSString *threshold;
@property NSArray *topics;

@end

@interface DCDiscoveryRequest (DCMethods)

- (DCWrapper *)streamDiscover;

@end