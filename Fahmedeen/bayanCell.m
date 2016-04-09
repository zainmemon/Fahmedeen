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

@end

@implementation bayanCell

- (IBAction)bayanPlayButtonAction:(id)sender {
    
    //[self.bayanPlayButton setBackgroundImage:[UIImage imageNamed:@"selected_play"] forState:normal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bayanPlayButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapButton:(id)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(sender);
    }
}

@end
