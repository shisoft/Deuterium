//
//  DCNewsCell.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSMutableDictionary *__DCAvatarQueues;
extern dispatch_queue_t __DCDispatchQueueForHost(NSString *host);

@interface DCNewsCell : UITableViewCell

@property (weak) IBOutlet UILabel *authorField;
@property (weak) IBOutlet UILabel *timeField;
@property (weak) IBOutlet UILabel *titleField;
@property (weak) IBOutlet UILabel *contentField;
@property (weak) IBOutlet UIImageView *avatarView;
@property (weak) IBOutlet UILabel *numberLabel;
@property (weak) id controller;
@property NSURL *avatarURL;

- (void)loadAvatar;

@end
