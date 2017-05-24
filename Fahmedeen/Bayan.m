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
#import "bayanSingleton.h"

@interface Bayan ()

@end

@implementation Bayan
{
    BOOL timeForFavourites;
    NSMutableArray * AllBayans;
    unsigned long previousButton;
    AppDelegate *customAppDelegate;
    NSMutableArray *imageNameArray;
    NSMutableArray *favouritesImageNameArray;
    NSMutableArray *MarkUnMarkTitleArray;
    WebService *BayanListWebServiceObject;
    BOOL timeToPutInSingleton;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    timeToPutInSingleton = false;
    self.tryAgainProperty.hidden = true;
    self.internetText.hidden = true;
    [_progress setHidden:false];
    
    imageNameArray = [[NSMutableArray alloc]init];
    favouritesImageNameArray = [[NSMutableArray alloc]init];
    MarkUnMarkTitleArray = [[NSMutableArray alloc]init];
   
    self.view.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0];
    self.BayanList.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    self.BayanList.bounces = false;
    customAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.currentPlaying.text = customAppDelegate.currentPlayingItem;
    [self updateTime];
    
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    BayanListWebServiceObject = [[WebService alloc] init];
    AllBayans = [[NSMutableArray alloc] init];
    
    if(self.type == nil)
    {
        self.type = @"sunday";
        self.title = @"Sunday Bayanaat";
    }
    
    if(customAppDelegate.currentPlayingItem == nil)
    {
        self.currentPlaying.text = @"No Audio Playing";
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
    
    if([self.type isEqualToString:@""])
    {
        //AllBayans = [[NSUserDefaults standardUserDefaults]objectForKey:@"favouritesArray"];
        AllBayans = customAppDelegate.favouritesList;
        [_progress setHidden:true];
        timeForFavourites = true;
    }
    else
    {
        AllBayans = [[bayanSingleton sharedManager]filterArray:self.type];
        
        if(AllBayans.count > 0)
        {
            timeToPutInSingleton = false;
            [_progress setHidden:true];
            [self.BayanList reloadData];
        }
        else
        {
            timeToPutInSingleton = true;
            [self callWebService];
        }
        
        timeForFavourites = false;
    }

}

-(void)callWebService
{
    self.tryAgainProperty.hidden = true;
    self.internetText.hidden = true;
    
    [_progress setHidden:false];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [_progress startAnimating];
        AllBayans = [BayanListWebServiceObject FilePath:BASEURL BAYAN_PHP_FILE parameterOne:self.type];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            if(AllBayans.count > 0)
            {
                [_progress setHidden:true];
                self.tryAgainProperty.hidden = true;
                self.internetText.hidden = true;
                
                for(int i = 0; i<AllBayans.count; i++)
                {
                    [[bayanSingleton sharedManager]initWithName:[[AllBayans objectAtIndex:i] objectForKey:@"name"] link:[[AllBayans objectAtIndex:i] objectForKey:@"link"] category:self.type];
                }
                
                [self.BayanList reloadData];
                
            }
            else
            {
                [_progress setHidden:true];
                self.tryAgainProperty.hidden = false;
                self.internetText.hidden = false;
                
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

    [self.progress stopAnimating];
    [_progress setHidden:true];
    
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
        
        if([imageNameArray[previousButton] isEqualToString:@"selected_play"])
        {
            imageNameArray[previousButton] = @"pause";
            [self.BayanList reloadData];
        }
        
    }
    else
    {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
        
        [customAppDelegate.audioPlayer pause];
        customAppDelegate.isPaused = FALSE;
        
        if([imageNameArray[previousButton] isEqualToString:@"pause"])
        {
            imageNameArray[previousButton] = @"selected_play";
            [self.BayanList reloadData];
        }
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
    
    CMTime seekTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(customAppDelegate.audioPlayer.currentTime) + value, customAppDelegate.audioPlayer.currentTime.timescale);
    
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
    bayanCell *mycell;
    NSString *CellIdentifier = @"bayanCellIdentifier";
    
    if(mycell == nil)
    {
        mycell = (bayanCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    if(timeForFavourites)
    {
        [favouritesImageNameArray addObject:@"star-filled"];
        [MarkUnMarkTitleArray addObject:@"UnMark From Favourites"];
    }
    else
    {
        [favouritesImageNameArray addObject:@"star"];
        [MarkUnMarkTitleArray addObject:@"Mark As Favourite"];
        for(int i = 0;i<customAppDelegate.favouritesList.count; i++)
        {
            if([[[AllBayans objectAtIndex:indexPath.section] objectForKey:@"name"] isEqualToString:[[customAppDelegate.favouritesList objectAtIndex:i] objectForKey:@"name"]])
               {
                   [favouritesImageNameArray removeLastObject];
                   [favouritesImageNameArray addObject:@"star-filled"];
                   
                   [MarkUnMarkTitleArray removeLastObject];
                   [MarkUnMarkTitleArray addObject:@"UnMark From Favourites"];
                   break;
               }
        }
    }
    
    NSString *bayanName = [[AllBayans objectAtIndex:indexPath.section] objectForKey:@"name"];
    
    [imageNameArray addObject:@"play"];
    
    [mycell setDidTapButtonBlock:^(id sender) {
        
        if ([imageNameArray[indexPath.section] isEqualToString:@"pause"]) {
            
            NSLog(@"1");
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                       forState:UIControlStateNormal];
            
            [customAppDelegate.audioPlayer pause];
            customAppDelegate.isPaused = FALSE;
            imageNameArray[indexPath.section] = @"selected_play";
            
            [self.BayanList reloadData];
        }
        else
        {
            if(![customAppDelegate.currentPlayingItem isEqualToString:[[AllBayans objectAtIndex:indexPath.section] objectForKey:@"name"]])
            {
                NSLog(@"2");
                imageNameArray[previousButton] = @"play";
                imageNameArray[indexPath.section] = @"pause";
                
                previousButton = indexPath.section;
                NSString *filePath = [NSString stringWithFormat:@"http://baitussalam.org/%@",[[AllBayans objectAtIndex:indexPath.section] objectForKey:@"link"]];
                customAppDelegate.currentPlayingItem = [NSString stringWithFormat:@"%@",[[AllBayans objectAtIndex:indexPath.section] objectForKey:@"name"]];
                self.currentPlaying.text = customAppDelegate.currentPlayingItem;
                [self playStream:filePath];
                
                [self.BayanList reloadData];
                
            }
            else
            {
                NSLog(@"3");
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"]
                                           forState:UIControlStateNormal];
                
                [customAppDelegate.audioPlayer play];
                customAppDelegate.isPaused = true;
                imageNameArray[indexPath.section] = @"pause";
                
                [self.BayanList reloadData];
                
            }
            
        }
        
    }];
    
    [mycell setDidTapMarkButtonBlock:^(id sender)
     {
         if([MarkUnMarkTitleArray[indexPath.section] isEqualToString:@"UnMark From Favourites"])
         {
             [customAppDelegate.favouritesList removeObject:[AllBayans objectAtIndex:indexPath.section]];
             
             if(timeForFavourites)
             {
                 [favouritesImageNameArray removeObjectAtIndex:indexPath.section];
                 [MarkUnMarkTitleArray removeObjectAtIndex:indexPath.section];
             }
             else
             {
                 MarkUnMarkTitleArray[indexPath.section] = @"Mark As Favourite";
                 favouritesImageNameArray[indexPath.section] = @"star";
             }
             
         }
         else
         {
             [customAppDelegate.favouritesList addObject:[AllBayans objectAtIndex:indexPath.section]];
             
             if(timeForFavourites)
             {
                 [favouritesImageNameArray removeObjectAtIndex:indexPath.section];
                 [MarkUnMarkTitleArray removeObjectAtIndex:indexPath.section];
             }
             else
             {
                 MarkUnMarkTitleArray[indexPath.section] = @"UnMark From Favourites";
                 favouritesImageNameArray[indexPath.section] = @"star-filled";
             }
         }
         
         [[NSUserDefaults standardUserDefaults]setObject:customAppDelegate.favouritesList forKey:@"favouritesArray"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [self.BayanList reloadData];
         
     }];
    
    
    [mycell setDidTapShareButtonBlock:^(id sender)
     {
         NSString *filePath = [NSString stringWithFormat:@"https://baitussalam.org/bs/live"];
         NSString * message = [NSString stringWithFormat:@"Click on the following link to listen %@\n%@",bayanName,filePath];
         NSLog(@"the message is: %@",message);
         NSArray * shareItems = @[message];
         
         UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
         
         [self presentViewController:avc animated:YES completion:nil];
         
     }];
    
    [[mycell markAsFavouriteButton] setTitle:[MarkUnMarkTitleArray objectAtIndex:indexPath.section] forState:UIControlStateNormal];
    [mycell.bayanPlayButton setBackgroundImage:[UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.section]] forState:UIControlStateNormal];
    mycell.bayanTitle.text = bayanName;
    mycell.bayanPlayButton.tag = indexPath.section;
    
    
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
- (IBAction)tryAgainButtonAction:(id)sender
{
    
    [self callWebService];
}
@end
