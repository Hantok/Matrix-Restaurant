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

@interface HistoryTableListViewController : UITableViewController <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *historyArray;
@property NSInteger selectedRow;
//@property (strong, nonatomic)

@end
