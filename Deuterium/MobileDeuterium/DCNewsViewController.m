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

#define refreshButton navigationItem.leftBarButtonItem

@interface DCNewsViewController ()

@property NSMutableArray *newsControllers;

- (IBAction)refresh:(id)sender;

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

- (void)refresh:(id)sender
{
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
                             
                             DCNewsRequest *newsRequest = [[DCNewsRequest alloc] init];
                             newsRequest.count = 25;
                             newsRequest.lastT = [NSDate distantPast];
                             NSArray *news = [newsRequest getWhatzNew];
                             
                             if ([news isKindOfClass:[NSArray class]])
                             {
                                 NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[news count]];
                                 for (DCNews *newsItem in news)
                                 {
                                     DCNewsCellController *controller = [[DCNewsCellController alloc] init];
                                     controller.news = newsItem;
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
                                            });
                         }
                         );
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.newsControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newsCell";
    DCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DCNewsCellController *controller = self.newsControllers[indexPath.row];
    controller.newsCell = cell;
    [controller displayNews];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCNewsCellController *controller = self.newsControllers[indexPath.row];
    
    return [controller heightForCell];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
