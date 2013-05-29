//
//  DCSetStausRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

#import <CoreLocation/CoreLocation.h>

#define DCSETSTATUS_MISSPELLED

@interface DCSetStatusRequest : CGIRemoteObject

@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;
@property CLLocationDegrees lat;
@property CLLocationDegrees lon;
@property NSString *located;
@property NSString *richText;
@property NSString *checkin;


@end

@interface DCSetStatusRequest (DCMethods)

- (id)setStatus;
#ifdef DCSETSTATUS_MISSPELLED
- (id)setStaus __attribute__((deprecated("This is a misspelled function. Will go away any time.")));
#endif

@end
