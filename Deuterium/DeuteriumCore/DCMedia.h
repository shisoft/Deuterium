//
//  DCMedia.h
//  Deuterium
//
//  Created by John Shi on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <CGIJSONObject/CGIJSONObject.h>

@interface DCMedia : CGIPersistantObject
@property NSString *href;
@property NSString *type;
@property NSString *title;
@property NSString *picThumbnail;
@property NSString *player;
@property NSString *catalog;
@end
