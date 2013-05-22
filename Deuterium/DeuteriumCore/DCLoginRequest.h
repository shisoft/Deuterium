//
//  DCLoginRequest.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@class DCWrapper;

@interface DCLoginRequest : CGIRemoteObject

@property NSString *user;
@property NSString *pass;

@end

@interface DCLoginRequest (DCMethods)

- (DCWrapper *)login;

@end
