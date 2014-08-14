//
//  PACCardSelectViewController.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

/**
 The card select view
 controller; where you
 can choose the template
 for your card.
 */

#import "PACCardSectionTableViewCell.h"

@interface PACCardSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PACCardSectionTableViewCellDelegate>

- (id)initWithCurrentContextImage:(UIImage *)currentContextImage;

@end
