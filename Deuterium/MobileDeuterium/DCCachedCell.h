//
//  DCCachedCell.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCCachedCell : UITableViewCell

@property NSURL *avatarURL;
@property (weak) IBOutlet UIImageView *avatarView;
@property (weak) IBOutlet UILabel *titleField;

- (void)loadAvatar;

@end
