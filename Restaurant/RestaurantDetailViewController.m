//
//  RestaurantDetailViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RestaurantDetailViewController ()

@property (nonatomic, strong) UIAlertView *alert;

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
@synthesize alert = _alert;

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
    NSString *phoneNumber = self.dataStruct.phones;
    for (int i = 0; i < phoneNumber.length; i++)
    {
        if ([phoneNumber characterAtIndex:i] == ';')
        {
            phoneNumber = [phoneNumber substringToIndex:i];
            break;
        }
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]]; //@"telprompt://067-412-72-05"];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Calling");
}
- (IBAction)showOnMap:(id)sender {
    [self performSegueWithIdentifier:@"toMap" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMap"])
    {
        NSString *aLatitude = self.dataStruct.latitude;
        NSString *aLongitude = self.dataStruct.longitude;

        aLatitude = [aLatitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
        aLongitude = [aLongitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
        
        CLLocationCoordinate2D location = {.latitude = aLatitude.doubleValue, .longitude =  aLongitude.doubleValue};
        [segue.destinationViewController setCoordinates:location];
        [segue.destinationViewController setDataStruct:self.dataStruct];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.dataStruct.name;
	workTimeDetailLabel.text = self.dataStruct.workingTime;
    telephoneDetailLabel.text = self.dataStruct.phones;
    NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:self.dataStruct.idPicture];
//    NSURL *url = [self.db fetchImageURLbyPictureID:self.dataStruct.idPicture];
    if(dataOfPicture)
    {
        self.dataStruct.image  = [UIImage imageWithData:dataOfPicture]; 
    }
    else 
    {
//        dataOfPicture = [NSData dataWithContentsOfURL:url];
//        [self.db SavePictureToCoreData:self.dataStruct.idPicture toData:dataOfPicture];
        //self.dataStruct.image  = [UIImage imageWithData:dataOfPicture];
    }
    restaurantImage.image = self.dataStruct.image;
    //[self.db SavePictureToCoreData:self.dataStruct.idPicture toData:UIImagePNGRepresentation(cell.productImage.image)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor],(id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    //[self.callButton setBackgroundImage:[UIImage imageNamed:@"Button_orange_rev2.png"] forState:UIControlStateNormal];
    
    //[self.showOnMapButton setBackgroundImage:[UIImage imageNamed:@"Button_black_light_rev2.png"] forState:UIControlStateNormal];
    
    self.callButton.titleLabel.minimumFontSize = 10;
    self.showOnMapButton.titleLabel.minimumFontSize = 10;
    
    CALayer *layerCall = self.callButton.layer;
    [layerCall setCornerRadius:8.0f];
    
    CALayer *layerMap = self.showOnMapButton.layer;
    layerMap.cornerRadius = 8.0f;
    
}

- (IBAction)tebleReserve:(id)sender
{
    self.alert = [[UIAlertView alloc] initWithTitle:@"Sorry.Not suppurting now."
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [self.alert show];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}

- (void) dismiss
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
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
    [self setAlert:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
