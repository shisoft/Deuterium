//
//  DCReplyViewController.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCNews;

typedef NS_ENUM(NSUInteger, DCNewsReplyMode)
{
    DCNewsReply,
    DCNewsRepost,
    DCNewsBookmark
};

@interface DCNewsReplyViewController : UIViewController

@property DCNews *news;
@property DCNewsReplyMode mode;

@end
