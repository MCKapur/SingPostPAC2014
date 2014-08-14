//
//  PACPublishCardViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 12/8/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACPublishCardViewController.h"

static NSString *const CRExtendedMessageTextViewPlaceholderText = @"Add a custom message...";

@interface UITextView (CRUITextViewPlaceholder)
- (BOOL)isPlaceholder;
@end

@implementation UITextView (CRUITextViewPlaceholder)
- (BOOL)isPlaceholder {
    return [self.text isEqualToString:CRExtendedMessageTextViewPlaceholderText];
}
@end

@interface PACPublishCardViewController ()
@property (strong, readwrite, nonatomic) UITextView *textView;
@property (strong, readwrite, nonatomic) UIImage *cardRender;
@end

@implementation PACPublishCardViewController

- (void)drawNavigationItem {
    [self.navigationController.navigationBar.topItem setTitle:@"Publish"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clickedNext)]];
}

- (void)drawTextView {
    [self setTextView:[[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - (self.view.frame.size.width - 40) / 2, 80, self.view.frame.size.width - 40, 150)]];
    [self.textView setText:CRExtendedMessageTextViewPlaceholderText];
    [self.textView setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0f]];
    [self.textView setTextColor:[UIColor lightGrayColor]];
    [self.textView setDelegate:self];
    [self.textView.layer setCornerRadius:10.0f];
    [self.textView setClipsToBounds:YES];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view addSubview:self.textView];
}

#pragma mark - Actions

- (void)clickedNext {
    NSMutableArray *activityItems = [NSMutableArray array];
    [activityItems addObject:[self.textView isPlaceholder]?@"I just shared a card through PostACard!":self.textView.text];
    NSData *compressedImage = UIImageJPEGRepresentation(self.cardRender, 1.0f);
    NSURL *imageURL = [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"image.jpg"]];
    [activityItems addObject:imageURL];
    [compressedImage writeToURL:imageURL atomically:NO];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil
     ];
}

#pragma mark - Text View

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView isPlaceholder]) {
        [textView setText:@""];
        [self.textView setTextColor:[UIColor blackColor]];
    }
}

#pragma mark - Init

- (id)initWithCardRender:(UIImage *)cardRender {
    if (self = [self init]) {
        [self setCardRender:cardRender];
    }
    return self;
}

- (id)init {
    return [super init];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [self.view setBackgroundColor:UIColorActualRGB(245.0f, 245.0f, 245.0f)];
    [self drawNavigationItem];
    [self drawTextView];
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
