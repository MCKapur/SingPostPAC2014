//
//  PACCardSectionTableViewCell.m
//  PostACard
//
//  Created by Rohan Kapur on 29/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCardTemplate.h"
#import "PACCardSectionTableViewCell.h"

@interface PACCardSectionTableViewCell ()
@property (strong, nonatomic) UILabel *categoryNameLabel;
@property (strong, nonatomic) UIScrollView *cardSelectScrollView;
@end

@implementation PACCardSectionTableViewCell

- (void)setCategory:(NSString *)category {
    [self.categoryNameLabel setText:category];
    [self.categoryNameLabel sizeToFit];
}

- (void)setCards:(NSArray *)cards {
    [self configureScrollViewWithCards:cards];
}

#pragma mark - Scroll View

- (void)configureScrollViewWithCards:(NSArray *)cards {
    [self.cardSelectScrollView setContentSize:CGSizeMake(cards.count * 240 - 7, self.cardSelectScrollView.frame.size.height)];
    [self.cardSelectScrollView setShowsHorizontalScrollIndicator:NO];
    [self.cardSelectScrollView setShowsVerticalScrollIndicator:NO];
    [self.cardSelectScrollView setScrollsToTop:NO];
    [self.cardSelectScrollView setBounces:NO];
    [self.cardSelectScrollView setBackgroundColor:[UIColor clearColor]];
    for (NSInteger i = 0; i < cards.count; i++) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake((240 * i) + 9, self.cardSelectScrollView.frame.size.height / 2 - 108 - 12, 216, 123)];
        [webView.scrollView setUserInteractionEnabled:NO];
        [webView setScalesPageToFit:YES];
        [webView setDelegate:self];
        [webView setContentMode:UIViewContentModeScaleAspectFit];
        [self.cardSelectScrollView addSubview:webView];
        [webView loadHTMLString:((PACCardTemplate *)cards[i]).HTML baseURL:nil];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedWebView:)];
        [webView addGestureRecognizer:gestureRecognizer];
    }
}

#pragma mark - Web View

- (void)userTappedWebView:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userTappedCardTemplateWithHTML:)]) {
        [self.delegate userTappedCardTemplateWithHTML:[((UIWebView *)gestureRecognizer.view) stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = webView.frame.size;
    float rw = ((float)viewSize.width) / ((float)contentSize.width);
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;
}

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCategoryNameLabel:[[UILabel alloc] initWithFrame:CGRectMake(9, 10, 0, 0)]];
        [self.categoryNameLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
        [self.categoryNameLabel setTextColor:[UIColor darkGrayColor]];
        [self setCardSelectScrollView:[[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, 242)]];
        UIView *darkLine = [[UIView alloc] initWithFrame:CGRectMake(9, 29, 306, 1)];
        [darkLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.categoryNameLabel];
        [self.contentView addSubview:darkLine];
        [self.contentView addSubview:self.cardSelectScrollView];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
