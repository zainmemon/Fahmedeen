//
//  About.h
//  Fahmedeen
//
//  Created by Avialdo on 27/01/2015.
//  Copyright (c) 2015 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface About : UIViewController
{
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerViewController *moviePlayer;
    
}
-(IBAction)playAudio:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *aboutContent;

@end
