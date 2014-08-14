//
//  PACCardTemplate.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACModelObject.h"

/**
 A PACCardTemplate represents
 the client-side card template
 object.
 */
@interface PACCardTemplate : PACModelObject

/**
 The card's HTML.
 */
@property (strong, readonly, nonatomic) NSString *HTML;

/**
 The card template category/theme.
 */
@property (readonly, nonatomic) NSString *category;

/**
 The card template's availability
 date.
 */
@property (strong, readonly, nonatomic) NSDate *availabilityDate;

@end