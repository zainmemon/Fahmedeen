//
//  bayanCell.h
//  Fahmedeen
//
//  Created by Avialdo on 06/01/2016.
//  Copyright © 2016 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bayanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bayanTitle;
@property (weak, nonatomic) IBOutlet UIButton *bayanPlayButton;
- (IBAction)bayanPlayButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *markAsFavouriteButton;
//- (IBAction)markAsFavouriteAction:(id)sender;
//- (IBAction)shareButtonAction:(id)sender;
//@property (weak, nonatomic) IBOutlet UILabel *markUnMarkTitle;
//@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *hiddenButton;

- (void)setDidTapButtonBlock:(void (^)(id sender))didTapButtonBlock;
//- (void)setDidTapMarkButtonBlock:(void (^)(id sender))didTapMarkButtonBlock;
//- (void)setDidTapShareButtonBlock:(void (^)(id sender))didTapShareButtonBlock;



@end
