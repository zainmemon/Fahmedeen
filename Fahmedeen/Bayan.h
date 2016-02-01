//
//  ViewController.h
//  Fahmedeen
//
//  Created by Zainu Corporation on 22/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface Bayan : UIViewController<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>


@property (nonatomic, strong) AVPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *currentPlaying;

@property (weak, nonatomic) NSString *type;
@property BOOL isPaused;

@property NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet UITableView *BayanList;
<<<<<<< HEAD
- (IBAction)sliderChange:(id)sender;
=======
@property (weak, nonatomic) NSString *bayanCategory;
>>>>>>> origin/master

@end
