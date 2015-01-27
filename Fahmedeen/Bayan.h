//
//  ViewController.h
//  Fahmedeen
//
//  Created by Zainu Corporation on 22/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface Bayan : UIViewController

@property (nonatomic, strong) AudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;


@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
