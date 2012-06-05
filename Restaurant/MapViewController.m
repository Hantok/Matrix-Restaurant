//
//  MapViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize coordinates = _coordinates;
@synthesize annotations = _annotations;


-(void)setCoordinates:(CLLocationCoordinate2D)coordinates
{
    _coordinates = coordinates;
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
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.annotations];
    if(self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (IBAction) showAddress {
    //Скрываем клавиатуру
    //[addressField resignFirstResponder];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self showAddress];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
