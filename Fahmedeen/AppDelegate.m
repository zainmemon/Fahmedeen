//
//  AppDelegate.m
//  Fahmedeen
//
//  Created by Zainu Corporation on 22/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:1.0f/255.0f green:151.0f/255.0f blue:219.0f/255.0f alpha:1.0]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
         
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];

    // Override point for customization after application launch.
    
    self.audioPlayer = [[AVPlayer alloc] init];
    
    //[[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [Parse setApplicationId:@"pQIcufZCsTQ9GZfLHqibm0wdrJCYorfHIgBGM8ly"
                  clientKey:@"Z5z9skaKL5KrEETkmN3io4w13kp8sgEITGORAQCN"];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            
            if([self.audioPlayer rate] == 0)
            {
                [self.audioPlayer play];
            }
            else
            {
                [self.audioPlayer pause];
            }
            break;
        case UIEventSubtypeRemoteControlPlay:
            [self.audioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self.audioPlayer pause];
            break;
        default:
            break;
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //NSString * phone = [@"a" stringByAppendingString:storedNumber];
    [currentInstallation addUniqueObject:@"ios" forKey:@"channels"];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

@end
