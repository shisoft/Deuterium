//
//  DCContactListViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-30.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCContactListViewController.h"
#import "DCAppDelegate.h"
#import <DeuteriumCore/DeuteriumCore.h>
#import "DCCachedCell.h"
#import "NSString+Pinyin.h"

@interface DCContactListViewController ()

@property NSArray *headers;
@property NSMutableDictionary *sections;

@property BOOL loading;
@property BOOL loaded;

- (IBAction)refresh:(id)sender;

@end

@implementation DCContactListViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cachePurged:)
                                                 name:DCCachePurgedNotification
                                               object:nil];
}

- (void)cachePurged:(NSNotification *)aNotification
{
    self.sections = nil;
    self.loaded = NO;
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.loaded)
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
                             NSString *cacheFile = DCCacheFile();
                             [NSKeyedArchiver archiveRootObject:self.sections toFile:cacheFile];
                         });
}

static inline NSString *__DCLatinizedString(NSString *string)
{
    string = [string pinyinTransliteration];
    
    static NSMutableCharacterSet *accepted;
    if (!accepted)
    {
        accepted = [[NSMutableCharacterSet alloc] init];
        [accepted formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
        [accepted formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    }
    
    NSData *washer = [string dataUsingEncoding:NSASCIIStringEncoding
                          allowLossyConversion:YES];
    NSString *washed = [[NSString alloc] initWithData:washer
                                             encoding:NSASCIIStringEncoding];
    
    NSString *out = [[washed componentsSeparatedByCharactersInSet:[accepted invertedSet]] componentsJoinedByString:@""];
    return out;
}

static inline NSString *__DCLatinizedStringWithSpaces(NSString *string)
{
    string = [string pinyinTransliteration];
    
    static NSMutableCharacterSet *accepted;
    if (!accepted)
    {
        accepted = [[NSMutableCharacterSet alloc] init];
        [accepted formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
        [accepted formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
        [accepted formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    NSData *washer = [string dataUsingEncoding:NSASCIIStringEncoding
                          allowLossyConversion:YES];
    NSString *washed = [[NSString alloc] initWithData:washer
                                             encoding:NSASCIIStringEncoding];
    
    NSString *out = [[washed componentsSeparatedByCharactersInSet:[accepted invertedSet]] componentsJoinedByString:@""];
    return out;
}

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
                             
                             NSString *cacheFile = DCCacheFile();
                             self.sections = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFile];
                             NSMutableArray *contacts = nil;
                             
                             if (!self.headers)
                             {
                                 NSMutableArray *headers = [NSMutableArray arrayWithCapacity:27];
                                 NSString *headersString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#";
                                 
                                 for (NSUInteger i = 0; i < [headersString length]; i++)
                                 {
                                     [headers addObject:CGISTR(@"%C", [headersString characterAtIndex:i])];
                                 }
                                 
                                 self.headers = [headers copy];
                             }
                             
                             if (!self.sections || self.loaded)
                             {
                                 // FIXME: This is abusive.
                                 contacts = [NSMutableArray array];
                                 NSUInteger page = 0;
                                 
                                 DCUserContactRequest *request = [[DCUserContactRequest alloc] init];
                                 request.query = @"";
                                 request.group = @"";
                                 
                                 NSArray *responseArray = nil;
                                 
                                 do
                                 {
                                     request.page = page;
                                     responseArray = [request getContactNames];
                                     
                                     if ([responseArray isKindOfClass:[NSArray class]])
                                     {
                                         [contacts addObjectsFromArray:responseArray];
                                         page++;
                                     }
                                     else
                                     {
                                         responseArray = @[];
                                     }
                                 } while ([responseArray count]);
                                 
                                 self.sections = [NSMutableDictionary dictionary];
                                 
                                 for (DCUserContact *contact in contacts)
                                 {
                                     NSString *latinized = __DCLatinizedString(contact.name);
                                     NSString *header = ([latinized length]) ? [[latinized substringToIndex:1] uppercaseString] : @"#";
                                     if (![header length] ||
                                         ![[NSCharacterSet letterCharacterSet] characterIsMember:[header characterAtIndex:0]])
                                     {
                                         header = @"#";
                                     }
                                     NSMutableArray *headerArray = self.sections[header];
                                     
                                     if (headerArray)
                                     {
                                         [headerArray addObject:contact];
                                     }
                                     else
                                     {
                                         self.sections[header] = [@[contact] mutableCopy];
                                     }
                                 }
                                 
                                 [NSKeyedArchiver archiveRootObject:self.sections toFile:cacheFile];
                             }
                             
                             for (NSString *key in self.sections)
                             {
                                 NSMutableArray *array = self.sections[key];
                                 [array sortUsingComparator:^NSComparisonResult(DCUserContact *obj1, DCUserContact *obj2)
                                  {
                                      return [obj1.name localizedCaseInsensitiveCompare:obj2.name];
                                  }];
                             }
                             
                             self.loaded = YES;
                             
                             dispatch_async(dispatch_get_main_queue(),
                                            ^{
                                                self.loading = NO;
                                                
                                                if (DCHasRefreshControl())
                                                {
                                                    [self.refreshControl endRefreshing];
                                                }
                                                [self.tableView reloadData];
                                            });
                         });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.loaded) ? [self.headers count] : 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return (self.loaded) ? self.headers : nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (self.loaded) ? [self.sections[self.headers[section]] count] : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (self.loaded) ? CGISTR(@"%@ (%i)", self.headers[section], [self.sections[self.headers[section]] count]) : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.loaded)
    {
        DCCachedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"
                                                             forIndexPath:indexPath];
        
        DCUserContact *contact = self.sections[self.headers[indexPath.section]][indexPath.row];
        
        cell.titleField.text = contact.name;
        cell.avatarURL = contact.avatar.avatar;
        [cell loadAvatar];
        
        return cell;
    }
    else
    {
        return [tableView dequeueReusableCellWithIdentifier:@"loadingCell"
                                               forIndexPath:indexPath];
    }
}

#pragma mark - Table view delegate


@end
