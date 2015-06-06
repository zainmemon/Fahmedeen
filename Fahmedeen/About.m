//
//  About.m
//  Fahmedeen
//
//  Created by Avialdo on 27/01/2015.
//  Copyright (c) 2015 Zainu Corporation. All rights reserved.
//

#import "About.h"

@interface About ()
{
    int screenWidth;
    int screenHeight;
    UIActivityIndicatorView *loader;
}

@end

@implementation About

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loader = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100,100,100,100)];
    [loader setBackgroundColor:[UIColor blackColor]];
    [loader setColor:[UIColor whiteColor]];
    [self.view addSubview:loader];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)playAudio:(id)sender{
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [loader startAnimating];
        
        NSURL *audioFileLocationURL = [NSURL URLWithString:@"http://fahmedeen.org/sunday/EmankaySamraat(08-02-2015).mp3"];
        NSData *soundData = [NSData dataWithContentsOfURL:audioFileLocationURL];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        [audioPlayer play];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [loader stopAnimating];
            
        });
        
    });
    
    
}
@end
