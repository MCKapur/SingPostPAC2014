//
//  PACCard.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCardTemplate.h"

@class PACCardView;
@class PACUser;

/**
 A PACCard represents a client
 side card object.
 */
@interface PACCard : PACModelObject

/**
 The card's rendered image.
 */
@property (strong, readonly, nonatomic) UIImage *renderedImage;

/**
 The card publisher.
 */
@property (strong, readonly, nonatomic) PACUser *publisher;

/**
 The card's publish date.
 */
@property (strong,  readonly, nonatomic) NSDate *publishDate;

/**
 An extended message to the
 recipient.
 */
@property (strong, readonly, nonatomic) NSString *extendedMessage;

@end
