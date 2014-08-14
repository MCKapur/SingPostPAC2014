//
//  PACPublishedCardTableViewCell.m
//  PostACard
//
//  Created by Rohan Kapur on 6/8/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCard.h"
#import "PACPublishedCardTableViewCell.h"

@interface UIImage (BorderRendering)
- (UIImage *)imageWithBorderColor:(UIColor *)color andThickness:(CGFloat)thickness;
@end

@implementation UIImage (BorderRendering)
- (UIImage *)imageWithBorderColor:(UIColor *)color andThickness:(CGFloat)thickness {
    CGSize size = [self size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@interface PACPublishedCardTableViewCell ()
@property (strong, readwrite, nonatomic) UIImageView *cardImageView;
@property (strong, readwrite, nonatomic) UIScrollView *scrollView;
@property (strong, readwrite, nonatomic) UIPageControl *pageControl;
@end

@implementation PACPublishedCardTableViewCell

- (void)setCard:(PACCard *)card {
    _card = card;
    [self drawScrollView];
    [self.cardImageView setImage:[self.card.renderedImage imageWithBorderColor:[UIColor whiteColor] andThickness:10.0f]];
}

- (void)drawScrollView {
    [self.scrollView removeFromSuperview];
    [self setScrollView:[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width * 2, self.frame.size.height)];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setBounces:NO];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setDelegate:self];
    [self.contentView addSubview:self.scrollView];
    // Card Image
    [self setCardImageView:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]];
    [self.scrollView addSubview:self.cardImageView];
    // Card Message
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0f]];
    [textView setTextColor:[UIColor darkGrayColor]];
    [textView setBackgroundColor:[UIColor whiteColor]];
    [textView setEditable:NO];
    [textView setText:self.card.extendedMessage?:@"No message available."];
    [textView sizeToFit];
    [textView setFrame:CGRectMake(self.frame.size.width + (self.frame.size.width / 2 - textView.frame.size.width / 2), self.frame.size.height / 2 - textView.frame.size.height / 2, textView.frame.size.width, textView.frame.size.height)];
    [self.scrollView addSubview:textView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 320, 212)];
        [self setNeedsDisplay];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
