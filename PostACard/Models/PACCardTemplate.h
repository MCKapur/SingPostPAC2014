//
//  PACCardTemplate.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACCardView;

#import "PACModelObject.h"

/**
 A PACCardTemplate represents
 the client-side card template
 object.
 */
@interface PACCardTemplate : PACModelObject

/**
 The card template front view.
 */
@property (strong, readonly, nonatomic) PACCardView *frontView;

/**
 The card template back view.
 */
@property (strong, readonly, nonatomic) PACCardView *backView;

/**
 The card template category/theme.
 */
@property (readonly, nonatomic) PACCardTemplateCategory category;

/**
 The card title.
 */
@property (strong, readonly, nonatomic) NSString *title;

/**
 The card template biography.
 */
@property (strong, readonly, nonatomic) NSString *biography;

/**
 The card template's availability
 date.
 */
@property (strong, readonly, nonatomic) NSDate *availabilityDate;

@end