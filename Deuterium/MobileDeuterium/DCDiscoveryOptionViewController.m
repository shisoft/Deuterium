//
//  DCDiscoveryOptionViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCDiscoveryOptionViewController.h"

#import "DCAppDelegate.h"
#import <DeuteriumCore/DeuteriumCore.h>

@interface DCDiscoveryOptionViewController ()

@property NSDictionary *interests;
@property NSArray *orderedInterests;
@property NSArray *userInterests;
@property NSMutableArray *currentUserInterests;

@property BOOL loading;

- (IBAction)reset:(id)sender;
- (IBAction)refresh:(id)sender;

@end

@implementation DCDiscoveryOptionViewController

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

    if (DCHasRefreshControl())
    {
        UIRefreshControl *_refreshControl = [[UIRefreshControl alloc] init];
        
        [_refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
        
        self.refreshControl = _refreshControl;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentUserInterests = [[defaults objectForKey:@"DiscoveryAspects"] mutableCopy];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refresh:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.currentUserInterests count] ? self.currentUserInterests : self.userInterests forKey:@"DiscoveryAspects"];
    [defaults synchronize];
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
        return;
    self.loading = YES;
    
    if (DCHasRefreshControl())
    {
        [self.refreshControl beginRefreshing];
    }
    
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             @try
                             {
                                 // Pull global options
                                 
                                 DCGetTopicExplanationsRequest *txq = [[DCGetTopicExplanationsRequest alloc] init];
                                 DCWrapper *txr = [txq getTopicExplanations];
                                 self.interests = txr.d;
                                 
                                 // Sort them.
                                 
                                 self.orderedInterests = [[self.interests allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                     return [self.interests[obj1] compare:self.interests[obj2] options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                                 }];
                                 
                                 // Pull user options
                                 
                                 DCGetUserTopicDistRequest *utdq = [[DCGetUserTopicDistRequest alloc] init];
                                 NSArray *utdx = [utdq getUserTopicDist];
                                 
                                 double sum = 0.0;
                                 for (NSNumber *x in utdx)
                                 {
                                     sum += [x doubleValue];
                                 }
                                 sum /= (double)[utdx count];
                                 
                                 NSMutableArray *utmark = [NSMutableArray array];
                                 for (NSUInteger i = 0; i < [utdx count]; i++)
                                 {
                                     if ([utdx[i] doubleValue] - sum >= 0.02)
                                         [utmark addObject:CGISTR(@"%i", i)];
                                 }
                                 self.userInterests = [utmark copy];
                                 
                                 if (![self.currentUserInterests count])
                                     self.currentUserInterests = utmark;
                             }
                             @finally
                             {
                                 // Clean up
                                 
                                 dispatch_async(dispatch_get_main_queue(),
                                                ^{
                                                    if (DCHasRefreshControl())
                                                    {
                                                        [self.refreshControl endRefreshing];
                                                    }
                                                    
                                                    [self.tableView reloadData];
                                                    self.loading = NO;
                                                });
                             }
                         });
}

- (void)reset:(id)sender
{
    self.currentUserInterests = [self.userInterests mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.orderedInterests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ideaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    id key = self.orderedInterests[indexPath.row];
    cell.textLabel.text = self.interests[key];
    
    if ([self.currentUserInterests containsObject:key])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = self.orderedInterests[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.currentUserInterests containsObject:key])
    {
        [self.currentUserInterests removeObject:key];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        [self.currentUserInterests addObject:key];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView selectRowAtIndexPath:nil
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
}

@end
