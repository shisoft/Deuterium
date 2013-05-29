//
//  DCNewsItemsViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-28.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsItemsViewController.h"

#import "DCNewsReplyViewController.h"

@interface DCNewsItemsViewController () <UIActionSheetDelegate>

@property BOOL copied;
@property IBOutlet UIActionSheet *actionSheet;
@property NSInteger action;

- (IBAction)morePressed:(id)sender;

@end

@implementation DCNewsItemsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.news.content length])
    {
        self.copied = YES;
        self.news.content = self.news.title;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.copied)
    {
        self.news.content = @"";
    }
    
    [super viewWillDisappear:animated];
}

- (void)morePressed:(id)sender
{
    if (!self.actionSheet)
    {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"")
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:
                            NSLocalizedString(@"ui.reply", @""),
                            NSLocalizedString(@"ui.repost", @""),
                            NSLocalizedString(@"ui.bookmark", @""),
                            NSLocalizedString(@"ui.read-later", @""), nil];
    }
    
    [self.actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        self.action = buttonIndex;
        [self performSegueWithIdentifier:@"reply" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DCNewsReplyViewController class]])
    {
        DCNewsReplyViewController *replyVC = segue.destinationViewController;
        replyVC.news = self.news;
        replyVC.mode = self.action;
    }
    else
    {
        [super prepareForSegue:segue sender:sender];
    }
}

- (NSArray *)recentNews
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (DCNews *news = self.news; [news isKindOfClass:[DCNews class]]; news = news.refer)
        [array addObject:news];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.navigationItem.title = CGISTR(@"%i %@", [array count], NSLocalizedString(@"ui.messages-no", @""));
                   });
    
    return array;
}

- (BOOL)useDetails
{
    return NO;
}

@end
