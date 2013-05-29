//
//  DCAddBookmarkRequest.h
//  Deuterium
//
//  Created by John Shi on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@class DCWrapper;

@interface DCAddBookmarkRequest : CGIRemoteObject

@property id ID;
@property NSString *group;
@property NSString *note;
@property NSString *later;
@property NSString *svrMark;
@property NSInteger type;

@end

@interface DCAddBookmarkRequest (DCMethods)

- (DCWrapper *)addBookmark;

@end
