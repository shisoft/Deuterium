//
//  DCQuickReplyRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@class DCWrapper;

@interface DCQuickReplyRequest : CGIRemoteObject

@property NSString *content;
@property id ID;

@end

@interface DCQuickReplyRequest (DCMethods)

- (DCWrapper *)quickReply;

@end

