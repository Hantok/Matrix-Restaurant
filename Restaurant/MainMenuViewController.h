//
//  MainMenuViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "XMLParse.h"
#include "GettingCoreContent.h"

@interface MainMenuViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UITableViewController *tableViewController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *restorantsButton;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) NSNumber *selectedRow;
@property BOOL isCartMode;
@property BOOL isMenuMode;
@property (strong, nonatomic) GettingCoreContent * db;

@property(nonatomic, assign) id<UIPickerViewDelegate> delegatepV;
@property(nonatomic, assign) id<UIPickerViewDataSource> dataSourcepV;


@end
