//
//  DCNewsRequest.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONRemoteObject/CGIJSONRemoteObject.h>

@interface DCNewsRequest : CGIRemoteObject

@property NSUInteger count;
@property NSDate *lastT;
@property NSString *type;
@property NSString *exceptions;

@end

@interface DCNewsRequest (DCMethods)

- (NSArray *)getWhatzNew;

@end
