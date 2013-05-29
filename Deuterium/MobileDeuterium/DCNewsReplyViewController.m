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

@interface DCNewsReplyViewController () <UITextViewDelegate>

@property (weak) IBOutlet UITextView *textView;
@property (weak) IBOutlet UIBarButtonItem *replyButton;
@property (weak) IBOutlet UINavigationItem *titleBar;

- (IBAction)cancel:(id)sender;
- (IBAction)publish:(id)sender;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *names = @[
                       NSLocalizedString(@"ui.reply", @""),
                       NSLocalizedString(@"ui.repost", @""),
                       NSLocalizedString(@"ui.bookmark", @"")
                       ];
    
    self.replyButton.title = names[self.mode];
    self.titleBar.title = names[self.mode];
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
                                     
                                 }
                             }
                         });
    
    [self cancel:sender];
}

@end
