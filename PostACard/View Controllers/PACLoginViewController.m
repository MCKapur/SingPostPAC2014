//
//  PACLoginViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACAppDelegate.h"
#import "PACDataStore.h"
#import "PACSocialAuthFacebookClient.h"
#import "PACUser.h"
#import "PACLoginViewController.h"
#import "PACLoginCredentialsViewController.h"
#import "PACSignUpViewController.h"

@interface PACLoginViewController ()
@property (strong, readwrite, nonatomic) UITextField *usernameField;
@property (strong, readwrite, nonatomic) UITextField *passwordField;
@end

@implementation PACLoginViewController

#pragma mark - Navigation

- (void)configureNavigationItem {
    [self.navigationController.navigationBar.topItem setTitle:@"Log In"];
}

#pragma mark - Events

- (void)login:(PACUser *)user {
    [[PACDataStore sharedStore] loginUser:user];
    [[NSNotificationCenter defaultCenter] postNotificationName:PACNotificationLoggedIn object:nil];
}

- (IBAction)clickedLogin {
    [self.navigationController pushViewController:[[PACLoginCredentialsViewController alloc] init] animated:YES];
}

- (IBAction)facebookDialogPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logging In..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [[PACSocialAuthFacebookClient sharedClient] loginWithCompletionHandler:^(NSError *error, PACUser *user) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        if (!error && user) {
            [self login:user];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connect with Facebook - Error" message:error.localizedDescription?error.localizedDescription:@"Unknown Error" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [self.view addSubview:alertView];
        }
    }];
}

- (IBAction)clickedSignUp {
    [self.navigationController pushViewController:[[PACSignUpViewController alloc] init] animated:YES];
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [self configureNavigationItem];
    [super viewDidLoad];
}

#pragma mark - Init

- (id)init {
    return [super init];
}

@end
