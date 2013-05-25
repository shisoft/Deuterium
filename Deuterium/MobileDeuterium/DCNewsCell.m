//
//  DCNewsCell.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsCell.h"
#import "DCAppDelegate.h"
#import "UIImage+DCUtilities.h"

@implementation DCNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)selected animated:(BOOL)animated
{
    [super setHighlighted:selected animated:animated];
    
    for (UILabel *label in @[self.titleField, self.authorField, self.contentField, self.timeField])
    {
        label.highlighted = self.highlighted || self.selected;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    for (UILabel *label in @[self.titleField, self.authorField, self.contentField, self.timeField])
    {
        label.highlighted = self.highlighted || self.selected;
    }
}

- (void)loadAvatar
{
    NSURL *avatarURL = self.avatarURL;
    self.avatarView.image = nil;
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             NSURLRequest *request = [NSURLRequest requestWithURL:avatarURL];
                             
                             NSURLCache *cache = [NSURLCache sharedURLCache];
                             NSCachedURLResponse *cachedResponse = [cache cachedResponseForRequest:request];
                             if (!cachedResponse)
                             {
                                 NSURLResponse *response = nil;
                                 NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                                      returningResponse:&response
                                                                                  error:NULL];
                                 if (data)
                                 {
                                     cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response
                                                                                               data:data];
                                     [cache storeCachedResponse:cachedResponse
                                                     forRequest:request];
                                 }
                             }
                             
                             UIImage *image = [UIImage imageWithData:[cachedResponse data]];
                             if (image)
                             {
                                 image = [[image scaledImageToSize:CGSizeMake(68, 68)] roundedImageWithRadius:5]; // Retina!!
                             }
                             
                             dispatch_async(dispatch_get_main_queue(),
                                            ^{
                                                if ([avatarURL isEqual:self.avatarURL])
                                                {
                                                    self.avatarView.image = image;
                                                }
                                            });
                         });
}

@end
