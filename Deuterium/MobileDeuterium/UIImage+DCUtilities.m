//
//  UIImage+DCUtilities.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-26.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "UIImage+DCUtilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (DCUtilities)

- (UIImage*)scaledImageToSize:(CGSize)newSize
{
#ifndef GNUSTEP
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( self.size.width > self.size.height ) {
        scaleFactor = self.size.width / self.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = self.size.height / self.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
#else
    return self;
#endif
}

-(UIImage *)roundedImageWithRadius:(CGFloat)radius
{
#ifndef GNUSTEP
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    imageLayer.contents = (id) self.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(self.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
#else
    return self;
#endif
}

@end
