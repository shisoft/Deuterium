//
//  DCRepostRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCRepostRequest : CGIRemoteObject

@property id ID;
@property NSString *content;
@property NSString *exceptions;
@property NSString *audience;

@end

@interface DCRepostRequest (DCMethods)

- (id)repost;

@end