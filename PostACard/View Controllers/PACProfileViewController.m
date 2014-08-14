//
//  CRProfileViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 5/8/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCard.h"
#import "PACUser.h"
#import "PACDataStore.h"
#import "PACProfileViewController.h"
#import "PACPublishedCardTableViewCell.h"


@interface PACProfileViewController ()
@property (strong, readwrite, nonatomic) UIView *header;
@property (strong, readwrite, nonatomic) UITableView *cardTableView;
@end

@implementation PACProfileViewController

#pragma mark - Navigation Bar

- (void)configureNavigationBar {
    [self configureNavigationItemTitle];
}

- (void)configureNavigationItemTitle {
    [self.navigationController.navigationBar.topItem setTitle:@"Profile"];
}

#pragma mark - Layout

- (void)layout {
    [self drawCardTableView];
}

- (UIView *)header {
    if (!_header) {
        [self setHeader:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100 + self.navigationController.navigationBar.frame.size.height)]];
        [self.header setBackgroundColor:UIColorActualRGB(236.0f, 240.0f, 241.0f)];
        [self drawProfilePicture];
        [self drawNameLabel];
        [self drawEmailLabel];
        [self drawSeparator];
    }
    return _header;
}

- (void)drawProfilePicture {
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, self.header.frame.size.height / 2 - 85 / 2, 85, 85)];
    [profileImageView.layer setCornerRadius:43.0f];
    [profileImageView setClipsToBounds:YES];
    [profileImageView setImage:[PACDataStore sharedStore].loggedInUser.profilePicture];
    [self.header addSubview:profileImageView];
}

- (void)drawNameLabel {
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 20, 0, 0, 0)];
    [nameLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:20.0f]];
    [nameLabel setText:[[PACDataStore sharedStore] loggedInUser].name];
    [nameLabel setTextColor:[UIColor darkGrayColor]];
    [nameLabel sizeToFit];
    [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, self.header.frame.size.height / 2 - nameLabel.frame.size.height / 2 - 10, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [self.header addSubview:nameLabel];
}

- (void)drawEmailLabel {
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 20, 0, 0, 0)];
    [emailLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [emailLabel setText:[[PACDataStore sharedStore] loggedInUser].email];
    [emailLabel setTextColor:[UIColor grayColor]];
    [emailLabel sizeToFit];
    [emailLabel setFrame:CGRectMake(emailLabel.frame.origin.x, self.header.frame.size.height / 2 - emailLabel.frame.size.height / 2 + 15, emailLabel.frame.size.width, emailLabel.frame.size.height)];
    [self.header addSubview:emailLabel];
}

- (void)drawSeparator {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.header.frame.size.height, self.view.frame.size.width, 1)];
    [separator setBackgroundColor:[UIColor lightGrayColor]];
    [self.header addSubview:separator];
}

- (void)drawCardTableView {
    [self setCardTableView:[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
    [self.cardTableView setDataSource:self];
    [self.cardTableView setDelegate:self];
    [self.cardTableView setBackgroundColor:[UIColor clearColor]];
    [self.cardTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.cardTableView];
}

#pragma mark - Table View Delegate / Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PACPublishedCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (cell) {
        [(PACPublishedCardTableViewCell *)cell setCard:nil];
        [(PACPublishedCardTableViewCell *)cell setCard:[PACCard objectWithJSON:@{@"renderedImage": UIImageJPEGRepresentation([UIImage imageNamed:@"PostCardTestImage.png"], 1.0f), @"extendedMessage": @"I wish you a very happy birthday, I hope you have a great birthday and a good party and an overall excellent day."}]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self header].frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 212.0f;
}

#pragma mark - Tab Bar

- (UITabBarItem *)tabBarItem {
    return [[UITabBarItem alloc] initWithTitle:@"Profile" image:[[UIImage imageNamed:PACProfileTabBarIconImage_NotSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:PACProfileTabBarIconImage_Selected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [self configureNavigationBar];
    [self layout];
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
