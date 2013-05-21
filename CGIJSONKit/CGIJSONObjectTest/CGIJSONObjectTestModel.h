//
//  CGIJSONObjectTestModel.h
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-21.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface CGIJSONObjectTestModel : CGIPersistantObject

@property id objectAnonymous;
@property NSArray *arrayUntagged;
@property NSArray *arrayTagged
@property int intAnonymous;

@end
