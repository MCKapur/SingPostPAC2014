//
//  PACLoginCredentialsViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 1/8/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACUser.h"
#import "PACDataStore.h"
#import "PACLoginCredentialsViewController.h"

@interface PACLoginCredentialsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation PACLoginCredentialsViewController

#pragma mark - Navigation

- (void)configureNavigationItem {
    [self.navigationController.navigationBar.topItem setTitle:@"Credentials"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(clickedDone)]];
}
     
- (void)clickedDone {
    if (![self invalidFields].count) {
        [self login];
    }
    else {
        for (NSNumber *index in [self invalidFields]) {
            
        }
    }
}

#pragma mark - Login

- (void)login {
    [[PACDataStore sharedStore] loginUser:[PACUser objectWithJSON:@{@"_id": @"0", @"loginProvider": @(PACLoginProviderTypeEmail), @"name": @"Rohan Kapur", @"loginId": @"me@rohankapur.com", @"email": @"me@rohankapur.com", @"registrationDate": [[NSDate date] ISOStringFromNSDate]}]];
    [[NSNotificationCenter defaultCenter] postNotificationName:PACNotificationLoggedIn object:nil];
}

#pragma mark - Validation

- (NSArray *)invalidFields {
    return @[];
}

#pragma mark - Text Fields

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleTextFieldReturn:textField];
    return YES;
}

- (void)handleTextFieldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag < 2) {
        [(UITextField *)[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    }
}

- (void)configureTextFields {
    [self.emailTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [self configureNavigationItem];
    [self configureTextFields];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
