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
}

@end

@implementation About

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
