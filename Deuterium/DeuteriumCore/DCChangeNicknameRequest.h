//
//  DCChangeNicknameRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCChangeNicknameRequest : CGIRemoteObject

@property NSString *nn;

@end

@interface DCChangeNicknameRequest (DCMethods)

- (id *)changeNickname;

@end