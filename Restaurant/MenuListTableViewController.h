//
//  MenuListTableViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuListTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *Products;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (nonatomic, strong) NSString *kindOfMenu;
@property (strong, nonatomic) NSNumber *selectedRow;

@end
