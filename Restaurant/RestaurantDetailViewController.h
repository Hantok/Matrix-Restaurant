//  RestaurantDetailViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantDataStruct.h"
#import "GettingCoreContent.h"
#import "Singleton.h"

@interface RestaurantDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *showOnMapButton;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) RestaurantDataStruct *dataStruct;
@property (strong, nonatomic) GettingCoreContent *db;
- (IBAction)tebleReserve:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *restDetAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDetAdress;
@property (weak, nonatomic) IBOutlet UILabel * restDetWorkingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDetWorkingTime;
@property (weak, nonatomic) IBOutlet UILabel *restDetSeatsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDetSeatsNumber;
@property (weak, nonatomic) IBOutlet UILabel *restDetParkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDetParking;
@end
