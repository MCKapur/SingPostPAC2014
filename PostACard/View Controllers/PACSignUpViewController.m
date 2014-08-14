//
//  PACSignUpViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 28/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACUser.h"
#import "PACDataStore.h"
#import "PACSignUpViewController.h"

@interface PACSignUpViewController ()
@property (strong, readwrite, nonatomic) UITextField *nameTextField;
@property (strong, readwrite, nonatomic) UITextField *emailTextField;
@property (strong, readwrite, nonatomic) UITextField *passwordTextField;
@property (strong, readwrite, nonatomic) UITextField *confirmPasswordTextField;
@end

@implementation PACSignUpViewController

#pragma mark - Navigation

- (void)configureNavigationItem {
    [self.navigationController.navigationBar.topItem setTitle:@"Sign Up"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickedDone:)]];
}

#pragma mark - Events

- (void)clickedDone:(UIBarButtonItem *)barButtonItem {
    NSArray *invalidFields = [self invalidFields];
    if (!invalidFields.count) {
        PACUser *user = [PACUser objectWithJSON:@{@"_id": @"0", @"loginProvider": @(PACLoginProviderTypeEmail), @"name": self.nameTextField.text, @"email": self.emailTextField.text, @"loginProvider": self.emailTextField.text, @"registrationDate": [[NSDate date] ISOStringFromNSDate]}];
        [[PACDataStore sharedStore] loginUser:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:PACNotificationLoggedIn object:nil];
    }
    else {
        for (NSNumber *index in invalidFields) {
            
        }
    }
}

#pragma mark - Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleKeyboardReturn:textField];
    return YES;
}

- (void)handleKeyboardReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag < 4) {
        [((UITextField *)[self.view viewWithTag:textField.tag+1]) becomeFirstResponder];
    }
}

#pragma mark - Validation

- (NSArray *)invalidFields {
    return @[];
}

#pragma mark - Layout

- (void)configureLayout {
    [self drawSectionHeader];
    [self layoutFields];
}

- (void)drawSectionHeader {
    UILabel *signupLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 0.0f, 0.0f)];
    [signupLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [signupLabel setTextColor:[UIColor lightGrayColor]];
    [signupLabel setText:@"SIGN UP"];
    [signupLabel sizeToFit];
    [self.view addSubview:signupLabel];
}
     
- (void)layoutFields {
    [self drawNameTextField];
    [self drawEmailTextField];
    [self drawPasswordTextFields];
}

- (void)drawNameTextField {
    [self setNameTextField:[[UITextField alloc] initWithFrame:CGRectMake(30.0f, 120.0f, self.view.frame.size.width - 30.0f, 40.0f)]];
    UIView *namePadding = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.nameTextField.frame.origin.y, self.view.frame.size.width, self.nameTextField.frame.size.height)];
    [namePadding setBackgroundColor:[UIColor whiteColor]];
    [self.nameTextField setBorderStyle:UITextBorderStyleNone];
    [self.nameTextField setTag:1];
    [self.nameTextField setReturnKeyType:UIReturnKeyNext];
    [self.nameTextField setPlaceholder:@"Your Name"];
    [self.nameTextField setBackgroundColor:[UIColor whiteColor]];
    [self.nameTextField setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [self.nameTextField setTextColor:[UIColor darkGrayColor]];
    [self.nameTextField setDelegate:self];
    [self.view addSubview:namePadding];
    [self.view addSubview:self.nameTextField];
}

- (void)drawEmailTextField {
    [self setEmailTextField:[[UITextField alloc] initWithFrame:CGRectMake(30.0f, 180.0f, self.view.frame.size.width - 30.0f, 40.0f)]];
    UIView *emailPadding = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.emailTextField.frame.origin.y, self.view.frame.size.width, self.emailTextField.frame.size.height)];
    [emailPadding setBackgroundColor:[UIColor whiteColor]];
    [self.emailTextField setTag:2];
    [self.emailTextField setBorderStyle:UITextBorderStyleNone];
    [self.emailTextField setPlaceholder:@"Your Email"];
    [self.emailTextField setReturnKeyType:UIReturnKeyNext];
    [self.emailTextField setBackgroundColor:[UIColor whiteColor]];
    [self.emailTextField setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [self.emailTextField setDelegate:self];
    [self.emailTextField setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:emailPadding];
    [self.view addSubview:self.emailTextField];
}

- (void)drawPasswordTextFields {
    [self drawPasswordTextField];
    [self drawConfirmPasswordTextField];
}

- (void)drawPasswordTextField {
    [self setPasswordTextField:[[UITextField alloc] initWithFrame:CGRectMake(30.0f, 240.0f, self.view.frame.size.width - 30.0f, 40.0f)]];
    UIView *passwordPadding = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.passwordTextField.frame.origin.y, self.view.frame.size.width, self.passwordTextField.frame.size.height)];
    [passwordPadding setBackgroundColor:[UIColor whiteColor]];
    [self.passwordTextField setTag:3];
    [self.passwordTextField setBorderStyle:UITextBorderStyleNone];
    [self.passwordTextField setPlaceholder:@"Your Password"];
    [self.passwordTextField setReturnKeyType:UIReturnKeyNext];
    [self.passwordTextField setBackgroundColor:[UIColor whiteColor]];
    [self.passwordTextField setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [self.passwordTextField setTextColor:[UIColor darkGrayColor]];
    [self.passwordTextField setDelegate:self];
    [self.view addSubview:passwordPadding];
    [self.view addSubview:self.passwordTextField];
}

- (void)drawConfirmPasswordTextField {
    [self setConfirmPasswordTextField:[[UITextField alloc] initWithFrame:CGRectMake(30.0f, 290.0f, self.view.frame.size.width - 30.0f, 40.0f)]];
    UIView *confirmPasswordPadding = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.confirmPasswordTextField.frame.origin.y, self.view.frame.size.width, self.confirmPasswordTextField.frame.size.height)];
    [self.nameTextField setTag:4];
    [confirmPasswordPadding setBackgroundColor:[UIColor whiteColor]];
    [self.confirmPasswordTextField setBorderStyle:UITextBorderStyleNone];
    [self.confirmPasswordTextField setPlaceholder:@"Your Password, Once More."];
    [self.confirmPasswordTextField setReturnKeyType:UIReturnKeyDone];
    [self.confirmPasswordTextField setBackgroundColor:[UIColor whiteColor]];
    [self.confirmPasswordTextField setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [self.confirmPasswordTextField setTextColor:[UIColor darkGrayColor]];
    [self.confirmPasswordTextField setDelegate:self];
    [self.view addSubview:confirmPasswordPadding];
    [self.view addSubview:self.confirmPasswordTextField];
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [self.view setBackgroundColor:UIColorActualRGB(236.0f, 240.0f, 241.0f)];
    [self configureNavigationItem];
    [self configureLayout];
    [super viewDidLoad];
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
