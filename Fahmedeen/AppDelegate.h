//
//  AppDelegate.h
//  Fahmedeen
//
//  Created by Zainu Corporation on 22/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioSessionDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) NSString *currentPlayingItem;
@property BOOL isPaused;
@property float duration;
@property float currentTime;
@property NSMutableArray *favouritesList;

@end