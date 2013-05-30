//
//  DCNewsViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCNewsViewController.h"
#import "DCNewsCellController.h"
#import "DCNewsCell.h"
#import "DCAppDelegate.h"
#import "DCNewsDetailViewController.h"

@interface DCNewsViewController ()

@property BOOL loading;

- (IBAction)refresh:(id)sender;
- (IBAction)loadMore:(id)sender;

@end

@implementation DCNewsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up refresh control if system supports it, otherwise add a button.
    
    if ([self newsCanUpdate])
    {
        if (DCHasRefreshControl())
        {
            UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
            
            [_refreshControl addTarget:self
                                action:@selector(refresh:)
                      forControlEvents:UIControlEventValueChanged];
            
            self.refreshControl = _refreshControl;
        }
        else
        {
            UIBarButtonItem *_refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                            target:self
                                                                                            action:@selector(refresh:)];
            
            self.refreshButton = _refreshButton;
        }
    }
    
    NSString *cacheFile = CGISTR(@"%@/Library/Caches/%@/%@.plist", NSHomeDirectory(), [[NSBundle mainBundle] bundleIdentifier], NSStringFromClass([self class]));
    self.newsControllers = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFile];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cachePurged:)
                                                 name:DCCachePurgedNotification
                                               object:nil];
}    

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cachePurged:(NSNotification *)aNotification
{
    self.realData = NO;
    self.newsControllers = nil;
    [self.tableView reloadData];
    self.navigationController.tabBarItem.badgeValue = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.newsControllers count] || !self.realData)
    {
        [self refresh:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             NSString *cacheFile = CGISTR(@"%@/Library/Caches/%@/%@.plist", NSHomeDirectory(), [[NSBundle mainBundle] bundleIdentifier], NSStringFromClass([self class]));
                             [NSKeyedArchiver archiveRootObject:self.newsControllers toFile:cacheFile];
                         });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target actions

- (void)refresh:(id)sender
{
    if (self.loading)
    {
        return;
    }
    self.loading = YES;
    
    if (DCHasRefreshControl())
    {
        [self.refreshControl beginRefreshing];
    }
    else
    {
        self.refreshButton.enabled = NO;
    }
    
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             if (!self.newsControllers)
                             {
                                 self.newsControllers = [NSMutableArray arrayWithCapacity:25];
                             }
                             
                             NSArray *news = [self recentNews];
                             
                             if ([news isKindOfClass:[NSArray class]])
                             {
                                 NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[news count]];
                                 for (DCNews *newsItem in news)
                                 {
                                     DCNewsCellController *controller = [[DCNewsCellController alloc] init];
                                     controller.news = newsItem;
                                     if (![controllers containsObject:controller])
                                         [controllers addObject:controller];
                                 }
                                 
                                 self.newsControllers = controllers;
                                 
                                 dispatch_async(dispatch_get_main_queue(),
                                                ^{
                                                    [self.tableView reloadData];
                                                });
                             }
                             
                             // Clean up
                             
                             dispatch_async(dispatch_get_main_queue(),
                                            ^{
                                                if (DCHasRefreshControl())
                                                {
                                                    [self.refreshControl endRefreshing];
                                                }
                                                else
                                                {
                                                    self.refreshButton.enabled = YES;
                                                }
                                                
                                                [self newsDidUpdate];
                                                
                                                [self.tableView reloadData];
                                                [self.tableView setNeedsLayout];
                                                self.loading = NO;
                                                self.realData = YES;
                                            });
                         });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.newsControllers count] + (([self.newsControllers count] && [self newsCanPage]) ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.newsControllers count])
    {
        NSString *CellIdentifier = @"newsCell";
        DCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSUInteger index = indexPath.row;
        DCNewsCellController *controller = self.newsControllers[index];
        controller.newsCell = cell;
        if ([cell.controller respondsToSelector:@selector(setNewsCell:)])
            [cell.controller setNewsCell:nil];
        cell.controller = controller;
        [controller displayNews];
        
        return cell;
    }
    else
    {
        NSString *CellIdentifier = @"loadingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [self loadMore:self];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.newsControllers count])
    {
        DCNewsCellController *controller = self.newsControllers[indexPath.row];
        return [controller heightForCell];
    }
    else
    {
        return 44;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setNews:)])
    {
        [segue.destinationViewController setNews:[self.newsControllers[self.tableView.indexPathForSelectedRow.row] news]];
    }
}

- (void)loadMore:(id)sender
{
    if (self.loading || ![self.newsControllers count])
    {
        return;
    }
    self.loading = YES;
    
    if (DCHasRefreshControl())
    {
        [self.refreshControl beginRefreshing];
    }
    else
    {
        self.refreshButton.enabled = NO;
    }
    
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             if (!self.newsControllers)
                             {
                                 self.newsControllers = [NSMutableArray arrayWithCapacity:25];
                             }
                             
                             NSArray *news = [self nextPage];
                             
                             if ([news isKindOfClass:[NSArray class]])
                             {
                                 NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[news count]];
                                 for (DCNews *newsItem in news)
                                 {
                                     DCNewsCellController *controller = [[DCNewsCellController alloc] init];
                                     controller.news = newsItem;
                                     if (![controllers containsObject:controller])
                                         [controllers addObject:controller];
                                 }
                                 
                                 [self.newsControllers addObjectsFromArray:controllers];
                                 
                                 dispatch_async(dispatch_get_main_queue(),
                                                ^{
                                                    [self.tableView reloadData];
                                                });
                             }
                             
                             // Clean up
                             
                             dispatch_async(dispatch_get_main_queue(),
                                            ^{
                                                if (DCHasRefreshControl())
                                                {
                                                    [self.refreshControl endRefreshing];
                                                }
                                                else
                                                {
                                                    self.refreshButton.enabled = YES;
                                                }
                                                
                                                [self.tableView reloadData];
                                                [self.tableView setNeedsLayout];
                                                self.loading = NO;
                                            });
                         });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath)
    {
        DCNews *news = [self.newsControllers[indexPath.row] news];
        if ([news.refer isKindOfClass:[DCNews class]] && self.useDetails)
            [self performSegueWithIdentifier:@"details" sender:self];
        else
            [self performSegueWithIdentifier:@"contents" sender:self];
    }
}

- (void)newsDidUpdate
{
    // eh
}

- (BOOL)newsCanPage
{
    return [self respondsToSelector:@selector(nextPage)];
}

- (BOOL)newsCanUpdate
{
    return [self respondsToSelector:@selector(recentNews)];
}

- (BOOL)useDetails
{
    return YES;
}

@end
