//
//  DCUserContactRequest.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCUserContactRequest : CGIRemoteObject

@property NSString *query;
@property NSString *group;
@property NSUInteger page;

@end

@interface DCUserContactRequest (DCMethods)

- (NSArray *)getContactNames;

@end
