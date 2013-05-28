//
//  DCSetStausRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCSetStausRequest : CGIRemoteObject

@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;
@property double lat;
@property double lon;
@property char located;
@property char richText;
@property char checkin;


@end

@interface DCSetStausRequest (DCMethods)

- (id *)setStausRequest;

@end
