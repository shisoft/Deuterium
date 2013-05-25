//
//  DCNewsCell.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCNewsCell : UITableViewCell

@property (weak) IBOutlet UILabel *authorField;
@property (weak) IBOutlet UILabel *timeField;
@property (weak) IBOutlet UILabel *titleField;
@property (weak) IBOutlet UILabel *contentField;
@property (weak) IBOutlet UIImageView *avatarView;
@property NSURL *avatarURL;

- (void)loadAvatar;

@end
