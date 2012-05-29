//
//  MenuListTableViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GettingCoreContent.h"
#import "MenuDataStruct.h"
#import "IconDownloader.h"
#import "ProductCell.h"

@interface MenuListTableViewController : UITableViewController <IconDownloaderDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (nonatomic, strong) MenuDataStruct *kindOfMenu;
@property (strong, nonatomic) NSNumber *selectedRow;
@property (strong, nonatomic) GettingCoreContent *db;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;


@end
