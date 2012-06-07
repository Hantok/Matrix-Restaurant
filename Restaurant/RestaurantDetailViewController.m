//
//  RestaurantDetailViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "MapViewController.h"

@interface RestaurantDetailViewController ()

@end

@implementation RestaurantDetailViewController
@synthesize callButton;
@synthesize showOnMapButton;
@synthesize workTimeLabel;
@synthesize workTimeDetailLabel;
@synthesize telephoneLabel;
@synthesize telephoneDetailLabel;
@synthesize restaurantImage;
@synthesize dataStruct = _dataStruct;
@synthesize db = _db;

- (GettingCoreContent *)db
{
    if(!_db) _db = [[GettingCoreContent alloc] init];
    return _db;
}

- (void)setDataStruct:(RestaurantDataStruct *)dataStruct
{
    _dataStruct = dataStruct;
}

- (IBAction)callToRestaurant:(id)sender 
{
    NSURL *url = [NSURL URLWithString:@"telprompt://067-412-72-05"];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Calling");
}
- (IBAction)showOnMap:(id)sender {
    [self performSegueWithIdentifier:@"toMap" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CLLocationCoordinate2D location = {.latitude = self.dataStruct.latitude, .longitude =  self.dataStruct.longitude};
    [segue.destinationViewController setCoordinates:location];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	workTimeDetailLabel.text = self.dataStruct.workingTime;
    telephoneDetailLabel.text = self.dataStruct.phones;
    NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:self.dataStruct.idPicture];
    NSURL *url = [self.db fetchImageURLbyPictureID:self.dataStruct.idPicture];
    if(dataOfPicture)
    {
        self.dataStruct.image  = [UIImage imageWithData:dataOfPicture]; 
    }
    else 
    {
        dataOfPicture = [NSData dataWithContentsOfURL:url];
        [self.db SavePictureToCoreData:self.dataStruct.idPicture toData:dataOfPicture];
        self.dataStruct.image  = [UIImage imageWithData:dataOfPicture];
    }
    restaurantImage.image = self.dataStruct.image;
    //[self.db SavePictureToCoreData:self.dataStruct.idPicture toData:UIImagePNGRepresentation(cell.productImage.image)];
    
}

- (void)viewDidUnload
{
    [self setCallButton:nil];
    [self setShowOnMapButton:nil];
    [self setWorkTimeLabel:nil];
    [self setWorkTimeDetailLabel:nil];
    [self setTelephoneLabel:nil];
    [self setTelephoneDetailLabel:nil];
    [self setRestaurantImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
