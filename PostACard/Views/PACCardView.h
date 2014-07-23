//
//  PACCardView.h
//  PostACard
//
//  Created by Rohan Kapur on 25/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

/**
 A PACCardView stores
 data used to construct/
 display the web interface
 of a card.
 */
@interface PACCardView : UIWebView

/**
 The card layout in HTML.
 */
@property (strong, readonly, nonatomic) NSString *HTML;

/**
 Render a thumbnail image
 of the card.
 */
- (UIImage *)thumbnailRender;

/**
 Render a full size image
 of the card.
 */
- (UIImage *)fullRender;

/**
 Returns a newly initialized
 PACCardView with the card HTML.
 */
+ (PACCardView *)cardViewWithHTML:(NSString *)HTML;

/**
 Returns a newly initialized
 PACCardView with the card HTML.
 */
- (id)initWithHTML:(NSString *)HTML;

@end
