//
//  ReservHistoryTableViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 10/1/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GettingCoreContent.h"
#import "ReservHistoryDetailViewController.h"
#import "XMLParseOrdersStatuses.h"
#import "Singleton.h"



@interface ReservHistoryTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray * reservationHistoryArray;
@property (strong, nonatomic) GettingCoreContent *content;
@property (nonatomic, strong) NSString *restaurantName;
@property (strong, nonatomic) NSDictionary *ReservationHistoryDictionary;
@property (strong, nonatomic) XMLParseOrdersStatuses *db;
@property (strong, nonatomic) NSMutableDictionary *statusOfOrdersDictionary;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleReservationHistoryBar;
@property NSInteger selectedRow;
@end
