//
//  RestaurantCell.h
//  Restaurant
//
//  Created by Bogdan Geleta on 31.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (strong, nonatomic) IBOutlet UILabel *restaurantSubway;
@property (strong, nonatomic) IBOutlet UILabel *restaurantPhones;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantPlace;
@end
