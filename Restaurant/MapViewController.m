//
//  MapViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>
- (void)pressToButton: (id)sender;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize coordinates = _coordinates;
@synthesize annotations = _annotations;
@synthesize segment = _segment;
@synthesize location;
@synthesize dataStruct = _dataStruct;
//@synthesize annotationTitle = _annotationTitle;
//@synthesize annotationSubTitle = _annotationSubTitle;
//@synthesize annotationCoordinate = _annotationCoordinate;
@synthesize coordinate = _coordinate;

- (void)pressToButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setCoordinates:(CLLocationCoordinate2D)coordinates
{
    _coordinates = coordinates;
}

- (void)setDataStruct:(RestaurantDataStruct *)dataStruct
{
    _dataStruct = dataStruct;
}

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

-(void)updateMapView
{
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if(self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (IBAction) showAddress
{
    //
    //Скрываем клавиатуру
    //[addressField resignFirstResponder];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    //self.mapView.annotations
    
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    id <MKAnnotation> addAnnotation;
    if(addAnnotation != nil) {
        [self.mapView removeAnnotation:addAnnotation];
        addAnnotation = nil;
    }
    addAnnotation = [[MKPointAnnotation alloc] init];
    addAnnotation.coordinate = self.coordinates;
    if(addAnnotation) [self.mapView addAnnotation:addAnnotation];
    region.span=span;
    region.center=self.coordinates;
        
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1000, 1000);
    [self.mapView setRegion:region animated:TRUE];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return  nil;
    
    NSString *annotationIndentifier = @"PinViewAnnotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIndentifier];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIndentifier];
        
//        [pinView setPinColor:MKPinAnnotationColorGreen];
        [pinView setAnimatesDrop:YES];
        pinView.canShowCallout = YES;
                
        UIButton *iconButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [iconButton setBackgroundImage:self.dataStruct.image forState:UIControlStateNormal];
        
        pinView.leftCalloutAccessoryView = iconButton;
        [iconButton addTarget:self action:@selector(pressToButton:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self showAddress];
    self.mapView.delegate = self;
    
    self.location = [[CLLocationManager alloc]init];
    [location setDelegate:self];
    
    [location setDistanceFilter:kCLDistanceFilterNone];
    [location setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //[self.mapView setShowsUserLocation:YES];
    
    CLLocationCoordinate2D annotLocation;
    annotLocation.latitude = self.coordinates.latitude;
    annotLocation.longitude = self.coordinates.longitude;
    
    NSString *restaurantStreet = self.dataStruct.street;
    NSString *restaurantBuild = [@" " stringByAppendingString:self.dataStruct.build];
    NSString *restaurantAddress = [restaurantStreet stringByAppendingString:restaurantBuild];
    
    MapViewAnnotation *mapAnnotation = [[MapViewAnnotation alloc]initWithTitle:self.dataStruct.name withSubTitle:restaurantAddress withCoordinate:annotLocation];
    
    [self.mapView addAnnotation:mapAnnotation];    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)segmentControlAction:(id)sender
{
    if (_segment.selectedSegmentIndex == 0) {
        self.mapView.mapType = MKMapTypeStandard;
    } else if (_segment.selectedSegmentIndex == 1) {
        self.mapView.mapType = MKMapTypeSatellite;
    } else if (_segment.selectedSegmentIndex == 2) {
        self.mapView.mapType = MKMapTypeHybrid;
    }
}

- (IBAction)userLocation:(id)sender {
    self.location = [[CLLocationManager alloc]init];
    location.delegate = self;
    location.desiredAccuracy = kCLLocationAccuracyBest;
    location.distanceFilter = kCLDistanceFilterNone;
    [location startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
//    MKCoordinateRegion region;
//    region.center = newLocation.coordinate;
//    region.span = span;
    
    //[_mapView setRegion:region animated:TRUE];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 8000, 8000);
    [self.mapView setRegion:region animated:TRUE];
    
    [manager stopUpdatingLocation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
