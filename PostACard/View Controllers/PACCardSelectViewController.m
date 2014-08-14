//
//  PACCardSelectViewController.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "Base64.h"
#import "PACDataStore.h"
#import "PACCard.h"
#import "PACCardSectionTableViewCell.h"
#import "PACCardSelectViewController.h"
#import "PACCardPreviewViewController.h"
#import "PACAppDelegate.h"

@interface PACCardSelectViewController ()
/**
 The card select table view.
 */
@property (strong, readwrite, nonatomic) UITableView *cardSelectTableView;
@property (strong, readwrite, nonatomic) UIImage *currentContextImage;
@end

@implementation PACCardSelectViewController

#pragma mark - Table View

- (void)configureTableView {
    [self setCardSelectTableView:[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain]];
    [self.cardSelectTableView setBackgroundColor:[UIColor clearColor]];
    [self.cardSelectTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.cardSelectTableView];
}

- (void)refreshTableView {
    [self.cardSelectTableView setDelegate:self];
    [self.cardSelectTableView setDataSource:self];
    [self.cardSelectTableView reloadData];
    [self.cardSelectTableView setNeedsDisplay];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[PACDataStore sharedStore] dynamicCategories].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *HTML = @"<html style='min-width: 100%; max-width: 100%;'><head><meta name='viewport' content='width=568px; height=320px'/></head><body style='padding:0;margin:0;border:0;'><div style='width:568px;height:320px;background-color:#3498db;'><img class='pac-url-image-scheme' src='http://3mcollision.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/s/t/striping_color-97-Medium-Dark-Gray.jpg' height='100px' width='100px' style='border-radius:100px; margin-top: 10%; margin-left: 37%;' class='PACIMAGE'/><a style='text-decoration: none; color: black; font-family: Helvetica-Bold; color: dark-gray; font-size: 25px; text-align: center; margin-top: 10%; margin-left: -31%; margin-top: 35%; position: absolute;' href='http://pac-text-url-scheme.com' class='PACTEXT'>Happy birthday to you!</a></div></body></html>";
    PACCardTemplate *card = [PACCardTemplate objectWithJSON:@{@"HTML": HTML, @"category":[[PACDataStore sharedStore] dynamicCategories][indexPath.row], @"title": @"Cool Card", @"availabilityDate": [[NSDate date] ISOStringFromNSDate]}];
    static NSString *CellIdentifier = @"CellIdentifier";
    PACCardSectionTableViewCell *cell = (PACCardSectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[PACCardSectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCategory:[[PACDataStore sharedStore] dynamicCategories][indexPath.row]];
    [cell setCards:@[card, card, card, card]];
    [cell setDelegate:self];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170.0f;
}

#pragma mark - Cell Delegate

- (void)userTappedCardTemplateWithHTML:(NSString *)HTML {
    [Base64 initialize];
    NSString *strEncoded = [Base64 encode:UIImageJPEGRepresentation(self.currentContextImage, 1.0f)];
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"img class=\"pac-url-image-scheme\" src=\"[^\"]*)\"" options:NSRegularExpressionCaseInsensitive error:&error];
//    NSString *modifiedHTML = [regex stringByReplacingMatchesInString:HTML options:0 range:NSMakeRange(0, [HTML length]) withTemplate:[NSString stringWithFormat:@"img class='pac-url-image-scheme' src='data:image/jpg;base64,%@'", strEncoded]];
    [self.navigationController pushViewController:[[PACCardPreviewViewController alloc] initWithHTML:[HTML stringByReplacingOccurrencesOfString:@"img class=\"pac-url-image-scheme\" src=\"http://3mcollision.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/s/t/striping_color-97-Medium-Dark-Gray.jpg\"" withString:[NSString stringWithFormat:@"img class='pac-url-image-scheme' src='data:image/jpg;base64,%@'", strEncoded]]] animated:YES];
}

#pragma mark - Navigation

- (void)configureNavigationItem {
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController.navigationBar.topItem setTitle:@"Select"];
}

#pragma mark - View Lifecycle

- (id)initWithCurrentContextImage:(UIImage *)currentContextImage {
    if (self = [self init]) {
        [self setCurrentContextImage:currentContextImage];
    }
    return self;
}

- (id)init {
    return [super init];
}

- (void)viewDidLoad {
    [self.view setBackgroundColor:UIColorActualRGB(245.0f, 245.0f, 245.0f)];
    [self configureTableView];
    [self refreshTableView];
    [self configureNavigationItem];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshTableView];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
