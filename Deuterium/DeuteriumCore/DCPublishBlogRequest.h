//
//  DCPublishBlogRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>
#import <CoreLocation/CoreLocation.h>

@interface DCPublishBlogRequest : CGIRemoteObject

@property NSString *title;
@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;
@property CLLocationDegrees lat;
@property CLLocationDegrees lon;
@property NSString *located;
@property NSString *richText;
@property NSString *checkin;

@end

@interface DCPublishBlogRequest (DCMethods)

- (id)publishBlog;

@end