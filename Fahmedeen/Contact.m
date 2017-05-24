//
//  Contact.m
//  Fahmedeen
//
//  Created by Avialdo on 27/01/2015.
//  Copyright (c) 2015 Zainu Corporation. All rights reserved.
//

#import "Contact.h"
#define METERS_PER_MILE 1609.344

@interface Contact ()
{
    int screenWidth;
    int screenHeight;
}

@end

@implementation Contact

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = 24.828066;
    coordinates.longitude = 67.054882;
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude);
    point.title = @"Masjid Bait-us-salam";
    
    [self.mapView addAnnotation:point];
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 0.75*METERS_PER_MILE, 0.75*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
