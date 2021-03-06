//
//  DCNewsDetailViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsDetailViewController.h"
#import <DeuteriumCore/DeuteriumCore.h>
#import "DCNewsCellController.h"
#import "DCNewsReplyViewController.h"

@interface DCNewsDetailViewController () <UIWebViewDelegate, UIActionSheetDelegate>

@property (weak) IBOutlet UIWebView *webView;
@property BOOL loaded;
@property NSTimer *timer;
@property IBOutlet UIActionSheet *actionSheet;
@property NSInteger action;

- (IBAction)morePressed:(id)sender;

@end

@implementation DCNewsDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadNews];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3600
                                                  target:self
                                                selector:@selector(loadNews)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
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
}

- (NSString *)contentFromNews:(DCNews *)news
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"<div>%@</div>\n", news.content];
    for (DCMedia *media in news.medias)
    {
        [string appendFormat:@"<div style=\"text-align: center;\"><a href=\"%@\"><img src=\"%@\" style=\"max-width: 200px;\"/></a></div>\n", [media.href absoluteString], [media.picThumbnail absoluteString]];
    }
    if ([[news.href absoluteString] length])
    {
        [string appendFormat:@"<div class=\"text-align: right;\"><a href=\"%@\">more &gt;</a></div>", [news.href absoluteString]];
    }
    return string;
}

- (void)loadNews
{
    self.loaded = NO;
    
    DCNews *news = self.news;
    
    NSMutableString *template = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NewsTemplate"
                                                                                                 withExtension:@"html"]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:NULL];
    
    DCNewsCellController *newsController = [[DCNewsCellController alloc] init];
    newsController.news = news;
    
    NSDictionary *vars = @{
                           @"avatar":   [news.authorUC.avatar absoluteString],
                           @"author":   [newsController authorDescription],
                           @"title":    [newsController titleDescription],
                           @"service_c": news.svr,
                           @"time":     [newsController timeDescription],
                           @"content":  [self contentFromNews:news]
                           };
    
    for (NSString *var in vars)
    {
        NSString *value = vars[var];
        
        [template replaceOccurrencesOfString:CGISTR(@"$(%@)", [var uppercaseString])
                                  withString:value
                                     options:0
                                       range:NSMakeRange(0, [template length])];
    }
    
    
    [self.webView loadHTMLString:template
                         baseURL:nil];
    self.navigationItem.title = self.news.title;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loaded = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.loaded)
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
