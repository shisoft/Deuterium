//
//  DCGetUserNicknameRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@class DCWrapper;

@interface DCGetUserNicknameRequest : CGIRemoteObject

@end

@interface DCGetUserNicknameRequest (DCMethods)

- (DCWrapper *)getUserNickname;

@end
