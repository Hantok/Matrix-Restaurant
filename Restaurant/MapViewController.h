//
//  MapViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate> 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) NSArray *annotations;


@end