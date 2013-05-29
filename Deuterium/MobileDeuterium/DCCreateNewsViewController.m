//
//  DCCreateNewsViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCCreateNewsViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <DeuteriumCore/DeuteriumCore.h>
#import "DCImagePickerController.h"
#import "DCLocationPickerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DCCreateNewsViewController () <UITextViewDelegate>

@property (weak) IBOutlet UITextView *textView;
@property IBOutlet UIView *accessoryView;
@property IBOutlet UIToolbar *toolBar;
@property (weak) IBOutlet UIBarButtonItem *typeButton;
@property (weak) IBOutlet UIBarButtonItem *lengthButton;
@property (weak) UILabel *lengthLabel;

// Sub-controllers
@property IBOutlet DCImagePickerController *imagePicker;
@property IBOutlet DCLocationPickerController *locationPicker;

@property BOOL isPost;

- (IBAction)cancel:(id)sender;
- (IBAction)post:(id)sender;
- (IBAction)typeSwitched:(id)sender;
- (IBAction)nowPlayingPressed:(id)sender;

@end

@implementation DCCreateNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillHideNotification
             object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.textView.contentInset = UIEdgeInsetsMake(0, 0, [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height, 0);
                         self.textView.scrollIndicatorInsets = self.textView.contentInset;
                     }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.textView.contentInset = UIEdgeInsetsZero;
                         self.textView.scrollIndicatorInsets = self.textView.contentInset;
                     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.accessoryView)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"DCCreateBar" owner:self options:nil];
        self.accessoryView = objects[0];
        self.imagePicker = objects[1];
        self.locationPicker = objects[2];
        
        [self.imagePicker initializeView];
        [self.locationPicker initializeView];
        
        UILabel *lengthLabel = [[UILabel alloc] init];
        lengthLabel.font = [UIFont systemFontOfSize:17];
        lengthLabel.textColor = [UIColor whiteColor];
        lengthLabel.shadowColor = [UIColor darkGrayColor];
        lengthLabel.shadowOffset = CGSizeMake(-1, -1);
        lengthLabel.text = CGISTR(@"%i", [self.textView.text length]);
        lengthLabel.opaque = NO;
        lengthLabel.backgroundColor = [UIColor clearColor];
        [lengthLabel sizeToFit];
        
        self.lengthLabel = lengthLabel;
        self.lengthButton.customView = lengthLabel;
    }
    
    self.textView.inputAccessoryView = self.accessoryView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.lengthLabel.text = CGISTR(@"%i", [textView.text length]);
    [self.lengthLabel sizeToFit];
}

- (void)typeSwitched:(id)sender
{
    self.isPost = !self.isPost;
    
    if (self.isPost)
    {
        self.typeButton.tintColor = [UIColor blueColor];
    }
    else
    {
        self.typeButton.tintColor = nil;
    }
}

- (void)nowPlayingPressed:(id)sender
{
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    MPMediaItem *item = [iPod nowPlayingItem];
    
    if (item)
    {
        NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
        NSString *artist = [item valueForProperty:MPMediaItemPropertyArtist];
        NSString *string = nil;
        if ([title length] && [artist length])
            string = CGISTR(@"#nowplaying %@ by %@", title, artist);
        else if ([title length])
            string = CGISTR(@"#nowplaying %@", title);
        
        if (string)
        {
            UITextRange *range = [self.textView selectedTextRange];
            if (range)
            {
                [self.textView replaceRange:range withText:string];
            }
            else
            {
                self.textView.text = [self.textView.text stringByAppendingString:string];
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)post:(id)sender
{
    // Do the job.
    
    [self cancel:sender];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
