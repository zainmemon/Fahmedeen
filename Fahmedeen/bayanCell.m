//
//  bayanCell.m
//  Fahmedeen
//
//  Created by Avialdo on 06/01/2016.
//  Copyright © 2016 Zainu Corporation. All rights reserved.
//

#import "bayanCell.h"

@interface bayanCell ()

@property (copy, nonatomic) void (^didTapButtonBlock)(id sender);
//@property (copy, nonatomic) void (^didTapMarkButtonBlock)(id sender);
//@property (copy, nonatomic) void (^didTapShareButtonBlock)(id sender);

@end

@implementation bayanCell

- (IBAction)bayanPlayButtonAction:(id)sender {
    
    //[self.bayanPlayButton setBackgroundImage:[UIImage imageNamed:@"selected_play"] forState:normal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bayanPlayButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.hiddenButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.markAsFavouriteButton addTarget:self action:@selector(didTapMarkButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.shareButton addTarget:self action:@selector(didTapShareButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapButton:(id)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(sender);
    }
}

//- (void)didTapMarkButton:(id)sender {
//    if (self.didTapMarkButtonBlock) {
//        self.didTapMarkButtonBlock(sender);
//    }
//}
//
//- (void)didTapShareButton:(id)sender {
//    if (self.didTapShareButtonBlock) {
//        self.didTapShareButtonBlock(sender);
//    }
//}

//- (IBAction)markAsFavouriteAction:(id)sender {
//}
//- (IBAction)shareButtonAction:(id)sender {
//}
@end
