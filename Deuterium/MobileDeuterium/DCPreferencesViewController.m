//
//  DCPreferencesViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-25.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCPreferencesViewController.h"
#import "DCAppDelegate.h"
#import "KeychainItemWrapper.h"

@interface DCPreferencesViewController () <UITextFieldDelegate>

@property (weak) IBOutlet UILabel *usernameLabel;
@property (weak) IBOutlet UITextField *displayNameField;
@property NSString *originalDisplayName;
@property BOOL working;

- (IBAction)refresh:(id)sender;

@end

@implementation DCPreferencesViewController

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
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(refresh:)
                      forControlEvents:UIControlEventValueChanged];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh:self];
}

- (void)refresh:(id)sender
{
    if (self.working)
        return;
    self.working = YES;
    
    if (DCHasRefreshControl())
        [self.refreshControl beginRefreshing];
    
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^
                         {
                             KeychainItemWrapper *keychainItem = [DCAppDelegate keychainItem];
                             NSString *loginName = keychainItem[(__bridge __strong NSString *)(kSecAttrAccount)];
                             dispatch_async(dispatch_get_main_queue(),
                                            ^{
                                                self.usernameLabel.text = loginName;
                                            }
                                            );
                             
                             if (!self.originalDisplayName)
                             {
                                 DCGetUserNicknameRequest *dispNameRequest = [[DCGetUserNicknameRequest alloc] init];
                                 DCWrapper *response = [dispNameRequest getUserNickname];
                                 if ([response isKindOfClass:[DCWrapper class]])
                                 {
                                     dispatch_async(dispatch_get_main_queue(),
                                                    ^{
                                                        self.originalDisplayName = [response stringValue];
                                                        self.displayNameField.text = [response stringValue];
                                                        self.displayNameField.placeholder = [response stringValue];
                                                        self.displayNameField.enabled = YES;
                                                        self.working = NO;
                                                        
                                                        if (DCHasRefreshControl())
                                                            [self.refreshControl endRefreshing];
                                                    });
                                 }
                                 else
                                 {
                                     dispatch_async(dispatch_get_main_queue(),
                                                    ^{
                                                        self.displayNameField.text = NSLocalizedString(@"ui.no-name",
                                                                                                       @"No name");
                                                        self.displayNameField.enabled = NO;
                                                        self.working = NO;
                                                        
                                                        if (DCHasRefreshControl())
                                                            [self.refreshControl endRefreshing];
                                                    });
                                 }
                             }
                             else
                             {
                                 dispatch_async(dispatch_get_main_queue(),
                                                ^{
                                                    self.displayNameField.text = self.originalDisplayName;
                                                    self.displayNameField.enabled = YES;
                                                    self.working = NO;
                                                    
                                                    if (DCHasRefreshControl())
                                                        [self.refreshControl endRefreshing];
                                                });
                             }
                         });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.displayNameField)
    {
        [self.displayNameField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.displayNameField)
    {        
        if (!self.working &&
            ![self.displayNameField.text isEqualToString:self.originalDisplayName] &&
            [self.displayNameField.text length])
        {
            self.working = YES;
            NSString *newName = self.displayNameField.text;
            dispatch_group_async(DCBackgroundTasks,
                                 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                 ^{
                                     DCChangeNicknameRequest *dnUpdate = [[DCChangeNicknameRequest alloc] init];
                                     dnUpdate.nn = newName;
                                     [dnUpdate changeNickname];
                                     self.originalDisplayName = nil;
                                     self.working = NO;
                                     [self refresh:textField];
                                 });
        }
        else
        {
            self.displayNameField.text = self.originalDisplayName;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = [tableView cellForRowAtIndexPath:indexPath].tag;
    
    switch (tag)
    {
        case 50: // Log out (delete keychain item)
        {
            KeychainItemWrapper *keychainItem = [DCAppDelegate keychainItem];
            [keychainItem resetKeychainItem];
            [DCAppDelegate thisDelegate].connected = NO;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"DiscoveryAspects"];
            [defaults synchronize];
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }
    }
}

@end
