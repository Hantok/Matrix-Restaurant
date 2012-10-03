//
//  RestaurantDataStruct.h
//  Restaurant
//
//  Created by Bogdan Geleta on 31.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDataStruct : NSObject

@property (nonatomic) NSString *restaurantId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *idPicture;
@property (strong, nonatomic) NSString *workingTime;
@property (strong, nonatomic) NSString *subwayStation;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *build;
@property (strong, nonatomic) NSString *additionalAddressInfo;
@property (strong, nonatomic) NSString *additionalContactInfo;
@property (strong, nonatomic) NSString *phones;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *parking;
@property (strong, nonatomic) NSString *terrace;
@property (strong, nonatomic) NSString *seatsNumber;

@end
