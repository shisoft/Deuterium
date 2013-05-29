//
//  DCImagePickerController.h
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCImagePickerController : NSObject

@property (weak) IBOutlet UIViewController *viewController;
@property (weak) IBOutlet UIBarButtonItem *cameraButton;
@property UIImage *image;

- (IBAction)cameraPressed:(id)sender;
- (void)initializeView;

@end
