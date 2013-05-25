//
//  DCNewsCell.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsCell.h"
#import "DCAppDelegate.h"

#ifndef GNUSTEP
#import <QuartzCore/QuartzCore.h>
#endif

@implementation DCNewsCell

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
    
    for (UILabel *label in @[self.titleField, self.authorField, self.contentField, self.timeField])
    {
        label.highlighted = self.highlighted;
    }
}

-(UIImage *)makeRoundedImage:(UIImage *)image
                      radius:(CGFloat)radius
{
#ifndef GNUSTEP
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
#else
    return image;
#endif
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
                                 image = [self makeRoundedImage:image radius:5.0];
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
