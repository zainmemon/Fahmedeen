//
//  YMCAudioPlayer.m
//  AudioPlayerTemplate
//
//  Created by ymc-thzi on 13.08.13.
//  Copyright (c) 2013 ymc-thzi. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer
{
    UIActivityIndicatorView *loader;
}

/*
 * Init the Player with Filename and FileExtension
 */
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension
{
    loader = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140,200,40,50)];
    [loader setBackgroundColor:[UIColor grayColor]];
    [loader setColor:[UIColor whiteColor]];
    [self.view addSubview:loader];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [loader startAnimating];
        NSURL *audioFileLocationURL = [NSURL URLWithString:@"http://fahmedeen.org/sunday/EmankaySamraat(08-02-2015).mp3"];
        NSData *soundData = [NSData dataWithContentsOfURL:audioFileLocationURL];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        [self.audioPlayer play];
        //NSString *subString = [@"" substringToIndex:rangeOfYourString.location];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            //[loader stopAnimating];
            
        });
        
    });

    }

/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [self.audioPlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.audioPlayer pause];
}

/*
 * get playingState
 */
- (BOOL)isPlaying {
    return [self.audioPlayer isPlaying];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(float)value {
    [self.audioPlayer setCurrentTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [self.audioPlayer currentTime];
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    return [self.audioPlayer duration];
}


@end
