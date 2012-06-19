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
#import "GettingCoreContent.h"
#import "PickerViewCell.h"
#import "IconDownloader.h"

#import <AudioToolbox/AudioToolbox.h>

@interface MainMenuViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, IconDownloaderDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UITableViewController *tableViewController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *restorantsButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) NSNumber *selectedRow;
@property BOOL isCartMode;
@property BOOL isMenuMode;
@property (strong, nonatomic) GettingCoreContent * db;
@property (strong, nonatomic) NSString *restarauntId;
@property (strong, nonatomic) NSString *menuId;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property(nonatomic, assign) id<UIPickerViewDelegate> delegatepV;
@property(nonatomic, assign) id<UIPickerViewDataSource> dataSourcepV;

@property (weak, nonatomic) IBOutlet UIButton *drop;
- (IBAction)OrderButton:(id)sender;

@end
