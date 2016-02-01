//
//  ViewController.m
//  Fahmedeen
//
//  Created by Zainu Corporation on 22/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "Bayan.h"
#import "SWRevealViewController.h"
#import "WebService.h"
#import "Constants.h"
#import "bayanCell.h"

@interface Bayan ()

@end

@implementation Bayan
{
    NSArray * AllBayans;
    id previousButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);

    
    self.audioPlayer = [[AVPlayer alloc] init];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [[AVAudioSession sharedInstance] setActive: YES error: nil];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    WebService *BayanList = [[WebService alloc] init];
    AllBayans = [[NSMutableArray alloc] init];
    
    if(self.type == nil)
    {
        self.type = @"tafseer";
        self.title = @"TAFSEER";
    }
    
    NSLog(@"the type is %@", self.type);
    AllBayans = [BayanList FilePath:BASEURL BAYAN_PHP_FILE parameterOne:self.type parameterTwo:@""];
    
    [self.BayanList reloadData];

}


/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
//- (void)setupAudioPlayer:(NSString*)fileName
//{
//    //insert Filename & FileExtension
//    NSString *fileExtension = @"mp3";
//    
//    //init the Player to get file properties to set the time labels
//    [self.audioPlayer initPlayer:fileName fileExtension:fileExtension];
//    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
//    
//    //init the current timedisplay and the labels. if a current time was stored
//    //for this player then take it and update the time display
//    self.timeElapsed.text = @"0:00";
//    
//    self.duration.text = [NSString stringWithFormat:@"-%@",
//                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
//    
//}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer play];
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pause];
        self.isPaused = FALSE;
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
*/

- (void)updateTime {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    float currentTime = CMTimeGetSeconds([self.audioPlayer currentTime]);
    currentTime = currentTime/100;
    self.currentTimeSlider.value = currentTime;
    self.timeElapsed.text = [NSString stringWithFormat:@"%.2f",(float)currentTime];
    self.timeElapsed.text = [self.timeElapsed.text stringByReplacingOccurrencesOfString:@"." withString:@":"];
    
//    if (!self.scrubbing) {
//        self.currentTimeSlider.value = [[self.audioPlayer currentTime] floatValue];
//    }
//    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
//                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
//    
//    self.duration.text = [NSString stringWithFormat:@"-%@",
//                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
//    
//    //When resetted/ended reset the playButton
//    if (![self.audioPlayer isPlaying]) {
//        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
//                                   forState:UIControlStateNormal];
//        [self.audioPlayer pauseAudio];
//        self.isPaused = FALSE;
//    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
*/

//- (IBAction)setCurrentTime:(id)scrubber {
//    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
//    [NSTimer scheduledTimerWithTimeInterval:0.01
//                                     target:self
//                                   selector:@selector(updateTime:)
//                                   userInfo:nil
//                                    repeats:NO];
//    
//    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
//    self.scrubbing = FALSE;
//}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */


//-(void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
//{
//    // Set the title of navigation bar by using the menu items
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    
//    if ([segue.identifier isEqualToString:@"show"]) {
//        Bayan *vendor = (Bayan*)segue.destinationViewController;
//        vendor.title = [[self.menuItems objectAtIndex:indexPath.row] capitalizedString];
//    }
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [AllBayans count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"bayanCellIdentifier";
    
    bayanCell *cell;
    
    if(cell == nil)
    {
        cell = (bayanCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.bayanTitle.text = [[AllBayans objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    [cell.bayanPlayButton addTarget:self action:@selector(playSelectedRadio:) forControlEvents:UIControlEventTouchUpInside];
    cell.bayanPlayButton.tag = indexPath.row;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)playSelectedRadio:(id)sender
{
    if(previousButton != nil)
    {
        UIButton* previousButtonProperties = previousButton;
        [previousButtonProperties setBackgroundImage:[UIImage imageNamed:@"play"] forState:normal];
        previousButtonProperties.enabled = true;
    }
    
    UIButton* tappedButton = sender;
    [tappedButton setBackgroundImage:[UIImage imageNamed:@"selected_play"] forState:normal];
    tappedButton.enabled = false;
    previousButton = sender;
    NSString *filePath = [NSString stringWithFormat:@"http://fahmedeen.org/%@",[[AllBayans objectAtIndex:tappedButton.tag] objectForKey:@"link"]];
    self.currentPlaying.text = [NSString stringWithFormat:@"%@",[[AllBayans objectAtIndex:tappedButton.tag] objectForKey:@"name"]];
    [self playStream:filePath];
}

-(void)playStream:(NSString *) audioPath{
    
    //NSError *error = nil;
    NSURL *urlStream;
    NSString *urlAddress = audioPath;
    urlStream = [[NSURL alloc] initWithString:urlAddress];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlStream options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    self.audioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    //This enables background music playing
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    self.audioPlayer = [AVPlayer playerWithURL:urlStream];
    if(!self.audioPlayer.error){

        float duration = CMTimeGetSeconds([[[self.audioPlayer currentItem]asset]duration]);
        duration = duration/100;
        
        self.duration.text = [NSString stringWithFormat:@"%.2f",(float)duration];
        self.duration.text = [self.duration.text stringByReplacingOccurrencesOfString:@"." withString:@":"];
        self.currentTimeSlider.maximumValue = duration;
        self.isPaused = false;
        [self playAudioPressed:self];
    }
}

-(void)stopStream
{
    [self.audioPlayer pause];
}

- (IBAction)sliderChange:(id)sender
{
    UISlider* slider = sender;
    
    float value = [slider value];
    
//    NSInteger durationSeconds = CMTimeGetSeconds([[[self.audioPlayer currentItem]asset]duration]);
//    float result = durationSeconds * value;
    
    CMTime seekTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.audioPlayer.currentTime) + value, self.audioPlayer.currentTime.timescale);
    //CMTime seekTime = CMTimeMakeWithSeconds(value, 1);
   // float currentTime = CMTimeGetSeconds([self.audioPlayer currentTime]);
    //NSLog(@"the seek time is %f",seekTime);
    
    [self updateTime];
    [self.audioPlayer seekToTime:seekTime];

}
@end
