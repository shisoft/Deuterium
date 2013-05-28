//
//  DCPublishBlogRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCPublishBlogRequest : CGIRemoteObject

@property NSString *title;
@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;
@property double lat;
@property double lon;
@property char located;
@property char richText;
@property char checkin;

@end

@interface DCPublishBlogRequest (DCMethods)

- (id *)publishBlogRequest;

@end