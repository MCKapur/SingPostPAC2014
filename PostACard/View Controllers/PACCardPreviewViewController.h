//
//  PACCardPreviewViewController.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

/**
 The card preview view controller;
 a fullscreen interface for users
 to view and interact with their
 created card, before publishing
 and sending it.
 */
@interface PACCardPreviewViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>

/**
 Returns a newly initialized
 PACCardPreviewViewController with
 the card HTML.
 */
- (id)initWithHTML:(NSString *)HTML;

@end
