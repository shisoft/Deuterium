//
//  DCPublishPhotosRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>
#import <CoreLocation/CoreLocation.h>

@interface DCPublishPhotosRequest : CGIRemoteObject

@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;
@property NSString *album;
@property NSData *image;
@property NSString *path;  //Server path (use when 'image' is empty)
@property NSString *linnid; //use for POI in places
@property CLLocationDegrees lat;
@property CLLocationDegrees lon;
@property NSString *located;

@end

@interface DCPublishPhotosRequest (DCMethods)

- (id)publishPhotos;

@end