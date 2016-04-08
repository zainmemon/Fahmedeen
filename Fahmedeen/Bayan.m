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
#import "AppDelegate.h"

@interface Bayan ()

@end

@implementation Bayan
{
    NSArray * AllBayans;
    id previousButton;
    AppDelegate *customAppDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_progress setHidden:false];
    //[_progress setBackgroundColor:[UIColor blackColor]];
    
    self.view.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0];
    self.BayanList.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    self.BayanList.bounces = false;
    customAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.currentPlaying.text = customAppDelegate.currentPlayingItem;
    [self updateTime];
    
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    WebService *BayanList = [[WebService alloc] init];
    AllBayans = [[NSMutableArray alloc] init];
    
    if(self.type == nil)
    {
        self.type = @"tafseer";
        self.title = @"Tafseer";
    }
    
    if(customAppDelegate.currentPlayingItem == nil)
    {
        self.currentPlaying.text = @"Current Playing";
    }
    
    if (customAppDelegate.isPaused)
    {
        [self.timer invalidate];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [_progress startAnimating];
        AllBayans = [BayanList FilePath:BASEURL BAYAN_PHP_FILE parameterOne:self.type parameterTwo:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            if(AllBayans.count > 0)
            {
                [self.BayanList reloadData];
            }
            else
            {
                [self showAlertBoxWithtitle:@"Alert" message:@"There is some problem with your internet connecion. Please try again later"];
            }
            
            [_progress stopAnimating];
            [_progress setHidden:true];
        });
        
    });

}

- (IBAction)playAudioPressed:(id)playButton
{
    [self.timer invalidate];

    if (!customAppDelegate.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"]
                                   forState:UIControlStateNormal];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [customAppDelegate.audioPlayer play];
        customAppDelegate.isPaused = TRUE;
        
    }
    else
    {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
        
        [customAppDelegate.audioPlayer pause];
        customAppDelegate.isPaused = FALSE;
    }
}

- (void)updateTime {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    
    customAppDelegate.duration = CMTimeGetSeconds([[[customAppDelegate.audioPlayer currentItem]asset]duration]);
    if(!isnan(customAppDelegate.duration))
    {
        customAppDelegate.duration = customAppDelegate.duration/100;
        
        self.duration.text = [NSString stringWithFormat:@"%.2f",(float)customAppDelegate.duration];
        self.duration.text = [self.duration.text stringByReplacingOccurrencesOfString:@"." withString:@":"];
        self.currentTimeSlider.maximumValue = customAppDelegate.duration;
    }
    
    customAppDelegate.currentTime = CMTimeGetSeconds([customAppDelegate.audioPlayer currentTime]);
    customAppDelegate.currentTime = customAppDelegate.currentTime/100;
    
    self.currentTimeSlider.value = customAppDelegate.currentTime;
    self.timeElapsed.text = [NSString stringWithFormat:@"%.2f",(float)customAppDelegate.currentTime];
    self.timeElapsed.text = [self.timeElapsed.text stringByReplacingOccurrencesOfString:@"." withString:@":"];
    
    if(isnan(customAppDelegate.currentTime))
    {
        self.timeElapsed.text = @"0:00";
    }
    
    if (customAppDelegate.isPaused)
    {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"]
                                   forState:UIControlStateNormal];
    }
    else
    {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
    }
}


-(void)playStream:(NSString *) audioPath
{
    NSURL *urlStream;
    NSString *urlAddress = audioPath;
    urlStream = [[NSURL alloc] initWithString:urlAddress];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlStream options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    customAppDelegate.audioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    customAppDelegate.audioPlayer = [AVPlayer playerWithURL:urlStream];
    if(!customAppDelegate.audioPlayer.error)
    {
        customAppDelegate.duration = CMTimeGetSeconds([[[customAppDelegate.audioPlayer currentItem]asset]duration]);
        customAppDelegate.duration = customAppDelegate.duration/100;
        
        self.duration.text = [NSString stringWithFormat:@"%.2f",(float)customAppDelegate.duration];
        self.duration.text = [self.duration.text stringByReplacingOccurrencesOfString:@"." withString:@":"];
        self.currentTimeSlider.maximumValue = customAppDelegate.duration;
        customAppDelegate.isPaused = false;
        
        [self playAudioPressed:self];
    }
}

-(void)stopStream
{
    [customAppDelegate.audioPlayer pause];
}

- (IBAction)sliderChange:(id)sender
{
    UISlider* slider = sender;
    
    float value = [slider value];
    
//    NSInteger durationSeconds = CMTimeGetSeconds([[[customAppDelegate.audioPlayer currentItem]asset]duration]);
//    float result = durationSeconds * value;
    
    CMTime seekTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(customAppDelegate.audioPlayer.currentTime) + value, customAppDelegate.audioPlayer.currentTime.timescale);
    //CMTime seekTime = CMTimeMakeWithSeconds(value, 1);
   // float currentTime = CMTimeGetSeconds([customAppDelegate.audioPlayer currentTime]);
    //NSLog(@"the seek time is %f",seekTime);
    
    [self updateTime];
    [customAppDelegate.audioPlayer seekToTime:seekTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [AllBayans count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *bayanName = [[AllBayans objectAtIndex:indexPath.section] objectForKey:@"name"];
    NSLog(bayanName);
    NSArray *myArray = [bayanName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(0"]];
    NSString *CellIdentifier = @"bayanCellIdentifier";
    
    bayanCell *cell;
    
    if(cell == nil)
    {
        cell = (bayanCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    cell.bayanTitle.text = [myArray objectAtIndex:0];
    cell.bayanDate.text = [NSString stringWithFormat:@"(%@",[myArray objectAtIndex:1]];
    [cell.bayanPlayButton addTarget:self action:@selector(playSelectedRadio:) forControlEvents:UIControlEventTouchUpInside];
    cell.bayanPlayButton.tag = indexPath.section;
    
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
    //[[tappedButton viewWithTag:0]setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selected_play"]]];
    
    [tappedButton setBackgroundImage:[UIImage imageNamed:@"selected_play"] forState:normal];
    
    tappedButton.enabled = false;
    previousButton = sender;
    NSString *filePath = [NSString stringWithFormat:@"http://fahmedeen.org/%@",[[AllBayans objectAtIndex:tappedButton.tag] objectForKey:@"link"]];
    customAppDelegate.currentPlayingItem = [NSString stringWithFormat:@"%@",[[AllBayans objectAtIndex:tappedButton.tag] objectForKey:@"name"]];
    self.currentPlaying.text = customAppDelegate.currentPlayingItem;
    [self playStream:filePath];
}


- (CGFloat)tableView:(UITableView*)tableView
heightForHeaderInSection:(NSInteger)section {
    
    return 10.0;
}

-(UIAlertController*)showAlertBoxWithtitle:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Okay"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    return alert;
}
@end
