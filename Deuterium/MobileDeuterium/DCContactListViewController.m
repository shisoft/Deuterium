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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.loaded)
    {
        [self refresh:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

NSString *__DCLatinizedString(NSString *string)
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

NSString *__DCLatinizedStringWithSpaces(NSString *string)
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
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             // FIXME: This is abusive.
                             NSMutableArray *contacts = [NSMutableArray array];
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
                             
                             [contacts sortUsingComparator:^NSComparisonResult(DCUserContact *obj1, DCUserContact *obj2)
                              {
                                  return [obj1.name localizedCompare:obj2.name];
                              }];
                             
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
                             
                             for (NSString *key in self.sections)
                             {
                                 NSMutableArray *array = self.sections[key];
                                 [array sortUsingComparator:^NSComparisonResult(DCUserContact *obj1, DCUserContact *obj2)
                                  {
                                      return [obj1.name localizedCaseInsensitiveCompare:obj2.name];
                                  }];
                             }
                             
                             dispatch_async(dispatch_get_main_queue(),
                                            ^{
                                                [self.tableView reloadData];
                                            });
                             
                             self.loaded = YES;
                         });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headers count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.headers;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sections[self.headers[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headers[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCCachedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"
                                                         forIndexPath:indexPath];
    
    DCUserContact *contact = self.sections[self.headers[indexPath.section]][indexPath.row];
    
    cell.titleField.text = contact.name;
    cell.avatarURL = contact.avatar.avatar;
    [cell loadAvatar];
    
    return cell;
}

#pragma mark - Table view delegate


@end
