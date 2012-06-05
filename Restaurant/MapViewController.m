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

@interface AddressAnnotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    
    NSString *mTitle;
    NSString *mSubTitle;
}
@end

@implementation MapViewController
@synthesize mapView;
@synthesize coordinates = _coordinates;

-(void)setCoordinates:(CLLocationCoordinate2D)coordinates
{
    _coordinates = coordinates;
}

- (IBAction) showAddress {
    //Скрываем клавиатуру
    //[addressField resignFirstResponder];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    
    region.span=span;
    region.center=self.coordinates;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
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
