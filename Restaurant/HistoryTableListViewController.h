//
//  HistoryTableListViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 30.08.12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PartOfHistoryViewController.h"
#import "GettingCoreContent.h"

@interface HistoryTableListViewController : UITableViewController <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *historyArray;
@property NSInteger selectedRow;
@property (strong, nonatomic) GettingCoreContent *content;

@end
