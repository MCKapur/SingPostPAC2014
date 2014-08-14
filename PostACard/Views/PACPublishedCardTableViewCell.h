//
//  PACPublishedCardTableViewCell.h
//  PostACard
//
//  Created by Rohan Kapur on 6/8/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACCard;

@interface PACPublishedCardTableViewCell : UITableViewCell <UIScrollViewDelegate>

/**
 The cell's card object.
 */
@property (strong, readwrite, nonatomic) PACCard *card;

@end
