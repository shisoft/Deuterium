//
//  DCImagePickerController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DCImagePickerController () <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property UIImagePickerController *imagePicker;
@property UIActionSheet *actionSheet;

@end

@implementation DCImagePickerController

- (void)initializeView
{
    self.cameraButton.enabled =
    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"")
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:
                        NSLocalizedString(@"ui.camera", @""),
                        NSLocalizedString(@"ui.picture-lib", @""), nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        switch (buttonIndex)
        {
            case 0:
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.viewController presentViewController:self.imagePicker
                                                  animated:YES
                                                completion:nil];
                break;
            case 1:
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.viewController presentViewController:self.imagePicker
                                                  animated:YES
                                                completion:nil];
            default:
                break;
        }
    }
    else
    {
        if (self.image)
        {
            self.cameraButton.tintColor = [UIColor blueColor];
        }
        else
        {
            self.cameraButton.tintColor = nil;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = info[UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:self.image.CGImage
                                     metadata:info[UIImagePickerControllerMediaMetadata]
                              completionBlock:nil];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (self.image)
                         {
                             self.cameraButton.tintColor = [UIColor blueColor];
                         }
                         else
                         {
                             self.cameraButton.tintColor = nil;
                         }
                     }];
    
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.image)
    {
        self.cameraButton.tintColor = [UIColor blueColor];
    }
    else
    {
        self.cameraButton.tintColor = nil;
    }
    
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

- (void)cameraPressed:(id)sender
{
    if (!self.image)
    {
        self.cameraButton.tintColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [self.actionSheet showInView:self.viewController.view];
        }
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.viewController presentViewController:self.imagePicker
                                              animated:YES
                                            completion:nil];
        }
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.viewController presentViewController:self.imagePicker
                                              animated:YES
                                            completion:nil];
        }
    }
    else
    {
        self.image = nil;
        if (self.image)
        {
            self.cameraButton.tintColor = [UIColor blueColor];
        }
        else
        {
            self.cameraButton.tintColor = nil;
        }
    }
}

@end
