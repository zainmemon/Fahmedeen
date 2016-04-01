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
@property (strong, nonatomic) IBOutlet UILabel *bayanDate;
- (IBAction)bayanPlayButtonAction:(id)sender;
@end
