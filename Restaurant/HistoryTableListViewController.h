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
#import "XMLParseOrdersStatuses.h"


@interface HistoryTableListViewController : UITableViewController <UITableViewDataSource, NSURLConnectionDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *historyArray;
@property NSInteger selectedRow;
@property (strong, nonatomic) GettingCoreContent *content;
@property (strong, nonatomic) XMLParseOrdersStatuses *db;
@property (strong, nonatomic) NSMutableDictionary *statusOfOrdersDictionary;

@end
