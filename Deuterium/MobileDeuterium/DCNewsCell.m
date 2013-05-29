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

NSMutableDictionary *__DCAvatarQueues;

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
    
    for (UILabel *label in @[self.titleField, self.authorField, self.contentField, self.timeField, self.numberLabel])
    {
        label.highlighted = self.highlighted || self.selected;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    for (UILabel *label in @[self.titleField, self.authorField, self.contentField, self.timeField, self.numberLabel])
    {
        label.highlighted = self.highlighted || self.selected;
    }
}

dispatch_queue_t __DCDispatchQueueForHost(NSString *host)
{
    if (!host)
        host = @"";
    
    if (!__DCAvatarQueues)
        __DCAvatarQueues = [NSMutableDictionary dictionary];
    
    if (!__DCAvatarQueues[host])
        __DCAvatarQueues[host] = dispatch_queue_create(CGICSTR(CGISTR(@"info.maxchan.info.avatar.%@",
                                                                      host)),
                                                       0);
    
    return __DCAvatarQueues[host];
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
