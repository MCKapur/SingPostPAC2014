//
//  PACCardPreviewViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACPublishCardViewController.h"
#import "PACCardPreviewViewController.h"

@interface UIView (CRUIViewCaptureAsImage)
- (UIImage *)captureAsImage;
@end

@implementation UIView (CRUIViewCaptureAsImage)
- (UIImage *)captureAsImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@interface PACCardPreviewViewController ()
@property (strong, readwrite, nonatomic) NSString *currentText;
@property (strong, readwrite, nonatomic) NSString *HTML;
@property (strong, readwrite, nonatomic) UIWebView *webView;
@end

@implementation PACCardPreviewViewController

#pragma mark - Navigation

- (void)configureNavigationItem {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStyleDone target:self action:@selector(publish)]];
    [self.navigationController.navigationBar.topItem setTitle:@"Preview"];
}

#pragma mark - Actions

- (void)publish {
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    UIImage *cardRender = [self.view captureAsImage];
    [self.navigationController pushViewController:[[PACPublishCardViewController alloc] initWithCardRender:cardRender] animated:YES];
}

#pragma mark - View Lifecycle

- (void)viewWillDisappear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [self configureWebView];
    [self configureNavigationItem];
    [super viewDidLoad];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - Web View

- (void)configureWebView {
    [self setWebView:[[UIWebView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - self.view.frame.size.height / 2 + 32, self.view.frame.size.width / 2 - 84, self.view.frame.size.height, 400)]];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setUserInteractionEnabled:YES];
    [self.webView setDataDetectorTypes:UIDataDetectorTypeAll];
    [self.webView.scrollView setScrollEnabled:NO];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    [self.webView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    [self.webView loadHTMLString:self.HTML baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL retVal = YES;
    if ([request.URL.description isEqualToString:@"http://pac-text-url-scheme.com/"]) {
        retVal = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Custom Text" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView setDelegate:self];
        [alertView show];
        [alertView becomeFirstResponder];
        [[alertView textFieldAtIndex:0] becomeFirstResponder];
    }
    return retVal;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView cancelButtonIndex] != buttonIndex) {
        [self setHTML:[self.HTML stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"class=\"PACTEXT\">%@</a>", self.currentText] withString:[NSString stringWithFormat:@"class=\"PACTEXT\">%@</a>", [alertView textFieldAtIndex:0].text]]];
        [self setCurrentText:[alertView textFieldAtIndex:0].text];
        [self.webView loadHTMLString:self.HTML baseURL:nil];
    }
}

#pragma mark - Init

- (id)initWithHTML:(NSString *)HTML {
    if (self = [self init]) {
        [self setHTML:HTML];
        [self setCurrentText:@"Happy birthday to you!"];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end
