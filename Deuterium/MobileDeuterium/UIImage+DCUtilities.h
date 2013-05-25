//
//  UIImage+DCUtilities.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-26.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DCUtilities)

- (UIImage *)scaledImageToSize:(CGSize)newSize;
- (UIImage *)roundedImageWithRadius:(CGFloat)radius;

@end
