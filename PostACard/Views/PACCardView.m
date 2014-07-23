//
//  PACCardView.m
//  PostACard
//
//  Created by Rohan Kapur on 25/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCardView.h"

@interface PACCardView ()
@property (strong, readwrite, nonatomic) NSString *HTML;
@end

@implementation PACCardView

- (void)setFrame:(CGRect)frame {
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:NO];
    [super setFrame:frame];
}

#pragma mark - Image Renders

- (UIImage *)thumbnailRender {
    UIImage *fullRender = [self fullRender];
    CGSize thumbnailSize = CGSizeMake(fullRender.size.width/8, fullRender.size.height/8);
    CGImageRef fullRenderImageRef = fullRender.CGImage;
    UIGraphicsBeginImageContextWithOptions(thumbnailSize, self.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, thumbnailSize.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, CGRectIntegral(CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)), fullRenderImageRef);
    CGImageRef thumbnailImageRef = CGBitmapContextCreateImage(context);
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    UIGraphicsEndImageContext();
    return thumbnail;
}

- (UIImage *)fullRender {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width, self.bounds.size.height), self.opaque, 0.0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *fullRender = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullRender;
}

#pragma mark - Init

+ (PACCardView *)cardViewWithHTML:(NSString *)HTML {
    return [[self alloc] initWithHTML:HTML];
}

- (id)initWithHTML:(NSString *)HTML {
    if (self = [self init]) {
        [self setHTML:HTML];
    }
    return self;
}

@end
