//
//  RestaurantCell.m
//  Restaurant
//
//  Created by Bogdan Geleta on 31.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantCell.h"

@implementation RestaurantCell
@synthesize restaurantAdress = _restaurantAdress;
@synthesize restaurantImage = _restaurantImage;
@synthesize restaurantSubway = _restaurantSubway;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
