//
//  RestaurantViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 31.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantDataStruct.h"
#import "GettingCoreContent.h"
#import "RestaurantDetailViewController.h"

@interface RestaurantViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) GettingCoreContent *db;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property NSInteger selectedRow;

@end    
