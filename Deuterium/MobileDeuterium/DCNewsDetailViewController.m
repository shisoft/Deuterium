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

@interface DCNewsDetailViewController () <UIWebViewDelegate>

@property (weak) IBOutlet UIWebView *webView;
@property BOOL loaded;

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
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(loadNews)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)loadNews
{
    self.loaded = NO;
    
    NSMutableString *template = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NewsTemplate"
                                                                                                 withExtension:@"html"]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:NULL];
    
    DCNewsCellController *newsController = [[DCNewsCellController alloc] init];
    newsController.news = self.news;
    
    NSDictionary *vars = @{
                           @"avatar":   [self.news.authorUC.avatar absoluteString],
                           @"author":   [newsController authorDescription],
                           @"title":    [newsController titleDescription],
                           @"service_c": self.news.svr,
                           @"time":     [newsController timeDescription],
                           @"content":  self.news.content
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
