//
//  Contact.h
//  Fahmedeen
//
//  Created by Avialdo on 27/01/2015.
//  Copyright (c) 2015 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

@interface Contact : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property(strong,nonatomic) CLLocationManager * locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
