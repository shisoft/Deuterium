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

- (NSString *)contentFromNews:(DCNews *)news
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"<div>%@</div>\n", news.content];
    for (DCMedia *media in news.medias)
    {
        [string appendFormat:@"<div style=\"text-align: center;\"><a href=\"%@\"><img src=\"%@\" style=\"max-width: 200px;\"/></a></div>\n", [media.href absoluteString], [media.picThumbnail absoluteString]];
    }
    return string;
}

- (NSString *)stringFromNews:(DCNews *)news
{
    NSMutableString *template = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NewsItem"
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
    
    return template;
}

- (void)loadNews
{
    self.loaded = NO;
    
    NSMutableString *template = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NewsTemplate"
                                                                                                 withExtension:@"html"]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:NULL];
    
    NSMutableString *content = [NSMutableString string];
    
    for (DCNews *news = self.news; ![news isKindOfClass:[NSNull class]]; news = news.refer)
    {
        [content appendString:[self stringFromNews:news]];
    }
    
    NSDictionary *vars = @{
                           @"content":  content
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
