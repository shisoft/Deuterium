//
//  DCLoginViewController.m
//  Deuterium
//
//  Created by Maxthon Chan on 13-5-23.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "DCLoginViewController.h"
#import "KeychainItemWrapper.h"
#import "DCAppDelegate.h"

@interface DCLoginViewController () <UITextFieldDelegate>

@property (weak) IBOutlet UITextField *usernameField;
@property (weak) IBOutlet UITextField *passwordField;
@property (weak) IBOutlet UIBarButtonItem *loginButton;

- (IBAction)usernameDidFinish:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation DCLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Query keychain for previously stored username and password.
    KeychainItemWrapper *keychainItem = [DCAppDelegate keychainItem];
    
    self.usernameField.text = keychainItem[(__bridge __strong NSString *)(kSecAttrAccount)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.loginButton.enabled = [self.usernameField.text length] && [self.passwordField.text length];
    
    if ([self.usernameField.text length])
    {
        [self.passwordField becomeFirstResponder];
    }
    else
    {
        [self.usernameField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField)
        [self usernameDidFinish:textField];
    else
        [self login:textField];
    return NO;
}

- (void)usernameDidFinish:(id)sender
{
    [self.passwordField becomeFirstResponder];
}

- (void)login:(id)sender
{
    DCLoginRequest *login = [[DCLoginRequest alloc] init];
    login.user = self.usernameField.text;
    login.pass = self.passwordField.text;
    
    dispatch_group_async(DCBackgroundTasks,
                         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^
    {
        
        if ([login.user length] && [login.pass length])
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^
            {
                [self dismissViewControllerAnimated:YES
                                         completion:nil];
            }
                           );
            KeychainItemWrapper *keychainItem = [DCAppDelegate keychainItem];
            
            keychainItem[(__bridge __strong NSString *)(kSecValueData)] = login.pass;
            keychainItem[(__bridge __strong NSString *)(kSecAttrAccount)] = login.user;
            
            DCWrapper *rv = [login login];
            if ([rv isKindOfClass:[DCWrapper class]])
            {
                [DCAppDelegate thisDelegate].connected = [rv boolValue];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"title", @"")
                                                               message:NSLocalizedString(@"err.no-server", @"")
                                                              delegate:nil
                                                     cancelButtonTitle:NSLocalizedString(@"ui.ok", @"")
                                                     otherButtonTitles:nil] show];
                               });
                [DCAppDelegate thisDelegate].connected = NO;
            }
        }
        else
        {
            [DCAppDelegate thisDelegate].connected = NO;
            dispatch_async(dispatch_get_main_queue(), ^
            {
                if ([self.usernameField.text length])
                {
                    [self.passwordField becomeFirstResponder];
                }
                else
                {
                    [self.usernameField becomeFirstResponder];
                }
            }
                           );
        }
    }
                         );
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
