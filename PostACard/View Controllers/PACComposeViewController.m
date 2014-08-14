//
//  PACComposeViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 5/8/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCardSelectViewController.h"
#import "PACComposeViewController.h"
#import "PACAppDelegate.h"

@interface PACComposeViewController ()
@property (strong, readwrite, nonatomic) UIImage *currentContextImage;
@end

@implementation PACComposeViewController

#pragma mark - Tab Bar

- (UITabBarItem *)tabBarItem {
    return [[UITabBarItem alloc] initWithTitle:@"Compose" image:[[UIImage imageNamed:PACCategoriesTabBarIconImage_NotSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:PACCategoriesTabBarIconImage_Selected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

#pragma mark - Navigation Bar

- (void)configureNavigationBar {
    [self configureNavigationItemTitle];
}

- (void)configureNavigationItemTitle {
    [self.navigationController.navigationBar.topItem setTitle:@"Compose"];
}

#pragma mark - Layout

- (void)layout {
    [self drawComposeButton];
}

- (void)drawComposeButton {
    UIButton *composeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 65.0f / 2, self.navigationController.navigationBar.frame.size.height + 80, 65.0f, 47.0f)];
    [composeButton setImage:[UIImage imageNamed:PACComposeIconImage] forState:UIControlStateNormal];
    [composeButton addTarget:self action:@selector(clickedCompose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:composeButton];
    UILabel *composeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, composeButton.frame.origin.y + 80, 0, 0)];
    [composeLabel setText:@"Tap to select an image."];
    [composeLabel setTextColor:[UIColor lightGrayColor]];
    [composeLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:16.0f]];
    [composeLabel sizeToFit];
    [composeLabel setFrame:CGRectMake(self.view.frame.size.width / 2 - composeLabel.frame.size.width / 2, composeLabel.frame.origin.y, composeLabel.frame.size.width, composeLabel.frame.size.height)];
    [composeLabel setUserInteractionEnabled:YES];
    [composeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCompose)]];
    [self.view addSubview:composeLabel];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCompose)]];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentContextImage"]) {
        if (self.currentContextImage)
            [self.navigationController pushViewController:[[PACCardSelectViewController alloc] initWithCurrentContextImage:self.currentContextImage] animated:YES];
    }
}

#pragma mark - Actions

- (void)clickedCompose {
    UIActionSheet *photoSelectActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select A Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", @"Choose From Social", nil];
    [photoSelectActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    [pickerController setAllowsEditing:YES];
    [pickerController setDelegate:self];
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose From Library"]) {
        [pickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose From Social"]) {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (info[UIImagePickerControllerEditedImage])
        [self setCurrentContextImage:info[UIImagePickerControllerEditedImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [((PACAppDelegate *)[UIApplication sharedApplication].delegate).tabBarController setHidesBottomBarWhenPushed:YES];
    [self addObserver:self forKeyPath:@"currentContextImage" options:kNilOptions context:NULL];
    [self layout];
    [self configureNavigationBar];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
