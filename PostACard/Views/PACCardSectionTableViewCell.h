//
//  PACCardSectionTableViewCell.h
//  PostACard
//
//  Created by Rohan Kapur on 29/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACCardTemplate;

@protocol PACCardSectionTableViewCellDelegate <NSObject>
- (void)userTappedCardTemplateWithHTML:(NSString *)HTML;
@end

@interface PACCardSectionTableViewCell : UITableViewCell <UIWebViewDelegate>

/**
 The card cell's delegate.
 */
@property (strong, readwrite, nonatomic) id<PACCardSectionTableViewCellDelegate> delegate;

/**
 Set the scroll view's cards.
 */
- (void)setCards:(NSArray *)cards;

/**
 Set the table view cell's
 category section.
 */
- (void)setCategory:(NSString *)category;

@end
