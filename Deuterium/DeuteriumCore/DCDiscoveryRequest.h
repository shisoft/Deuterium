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

@property NSString *beforeT;
@property NSString *count;
@property NSString *lastT;
@property NSString *threshold;
@property NSArray *topics;

@end

@interface DCDiscoveryRequest (DCMethods)

- (DCWrapper *)StreamDiscover;

@end
