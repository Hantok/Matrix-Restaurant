//
//  MapViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"
#import "RestaurantDataStruct.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, MKAnnotation> {
    NSString *annotationTitle;
    NSString *annotationSubTitle;
    CLLocationCoordinate2D annotationCoordinate;
}

@property (nonatomic, strong) RestaurantDataStruct *dataStruct;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) NSArray *annotations;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) CLLocationManager *location;
//@property (nonatomic, copy) NSString *annotationTitle;
//@property (nonatomic, copy) NSString *annotationSubTitle;
//@property (nonatomic) CLLocationCoordinate2D annotationCoordinate;

//- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title withSubTitle:(NSString *)subTitle;

@end