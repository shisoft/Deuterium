//
//  DCReplyViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-29.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsReplyViewController.h"
#import "DCAppDelegate.h"
#import <DeuteriumCore/DeuteriumCore.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DCNewsReplyViewController () <UITextViewDelegate>

@property (weak) IBOutlet UITextView *textView;
@property (weak) IBOutlet UIBarButtonItem *replyButton;
@property (weak) IBOutlet UINavigationItem *titleBar;
@property IBOutlet UIView *accessoryView;
@property IBOutlet UIToolbar *toolBar;
@property (weak) IBOutlet UIBarButtonItem *lengthButton;
@property (weak) UILabel *lengthLabel;

- (IBAction)cancel:(id)sender;
- (IBAction)publish:(id)sender;
- (IBAction)nowPlayingPressed:(id)sender;

@end

@implementation DCNewsReplyViewController

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
    
    NSArray *names = @[
                       NSLocalizedString(@"ui.reply", @""),
                       NSLocalizedString(@"ui.repost", @""),
                       NSLocalizedString(@"ui.bookmark", @""),
                       NSLocalizedString(@"ui.read-later", @"")
                       ];
    
    self.replyButton.title = names[self.mode];
    self.titleBar.title = names[self.mode];
    
    if (!self.accessoryView)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"DCReplyBar" owner:self options:nil];
        self.accessoryView = objects[0];
        
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

- (void)viewDidAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.lengthLabel.text = CGISTR(@"%i", [[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]);
    [self.lengthLabel sizeToFit];
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

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)publish:(id)sender
{
    // Do the job
    if ([self.textView.text length] <= 0)
        return;
    
    NSString *content = self.textView.text;
    
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             switch (self.mode)
                             {
                                 case DCNewsReply:
                                 {
                                     DCQuickReplyRequest *reply = [[DCQuickReplyRequest alloc] init];
                                     reply.ID = self.news.ID;
                                     reply.content = content;
                                     [reply quickReply];
                                     break;
                                 }
                                 case DCNewsRepost:
                                 {
                                     DCRepostRequest *repost = [[DCRepostRequest alloc] init];
                                     repost.ID = self.news.ID;
                                     repost.content = content;
                                     repost.audience = @"";
                                     repost.exceptions = @"";
                                     [repost repost];
                                     break;
                                 }
                                 case DCNewsBookmark:
                                 {
                                     DCAddBookmarkRequest *addbm = [[DCAddBookmarkRequest alloc] init];
                                     addbm.ID = self.news.ID;
                                     addbm.note = content;
                                     addbm.later = @"-";
                                     addbm.svrMark = @"-";
                                     addbm.type = DCBookmarkNews;
                                     break;
                                 }
                                 case DCNewsReadLater:
                                 {
                                     DCAddBookmarkRequest *addbm = [[DCAddBookmarkRequest alloc] init];
                                     addbm.ID = self.news.ID;
                                     addbm.note = content;
                                     addbm.later = @"+";
                                     addbm.svrMark = @"-";
                                     addbm.type = DCBookmarkNews;
                                     break;
                                 }
                             }
                         });
    
    [self cancel:sender];
}

@end
