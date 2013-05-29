//
//  DCCachedCell.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCCachedCell.h"
#import "DCAppDelegate.h"
#import "DCNewsCell.h"
#import "UIImage+DCUtilities.h"

@implementation DCCachedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadAvatar
{
    NSURL *avatarURL = self.avatarURL;
    self.avatarView.image = nil;
    dispatch_group_async(DCBackgroundTasks,
                         __DCDispatchQueueForHost([avatarURL host]),
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
                             if (!image)
                             {
                                 image = [UIImage imageNamed:@"default-user"];
                             }
                             
                             image = [[image scaledImageToSize:CGSizeMake(68, 68)] roundedImageWithRadius:10]; // Retina!!
                             
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
