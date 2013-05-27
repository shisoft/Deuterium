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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.newsControllers count])
    {
        [self refresh:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target actions

- (NSArray *)recentNews
{
    DCNewsRequest *newsRequest = [[DCNewsRequest alloc] init];
    newsRequest.count = 25;
    newsRequest.lastT = [NSDate distantPast];
    return [newsRequest getWhatzNew];
}

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
                                                
                                                [self.tableView reloadData];
                                                [self.tableView setNeedsLayout];
                                                self.loading = NO;
                                            });
                         });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.newsControllers count] + (([self.newsControllers count]) ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.newsControllers count])
    {
        NSString *CellIdentifier = @"newsCell";
        DCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        DCNewsCellController *controller = self.newsControllers[indexPath.row];
        controller.newsCell = cell;
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
    if ([segue.destinationViewController isKindOfClass:[DCNewsDetailViewController class]])
    {
        DCNewsDetailViewController *detailVC = segue.destinationViewController;
        detailVC.news = [self.newsControllers[[self.tableView indexPathForSelectedRow].row] news];
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

- (NSArray *)nextPage
{
    DCNewsRequest *newsRequest = [[DCNewsRequest alloc] init];
    newsRequest.count = 25;
    newsRequest.lastT = [[self.newsControllers lastObject] news].publishTime;
    return [newsRequest getWhatzNew];
}

@end
