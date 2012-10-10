//
//  ReservHistoryDetailViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 10/2/12.
//
//

#import <UIKit/UIKit.h>
#import "XMLParseOrdersStatuses.h"
#import <QuartzCore/QuartzCore.h>
#import "GettingCoreContent.h"
#import "ReservHistoryTableViewController.h"
#import "Singleton.h"

@interface ReservHistoryDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *NameOfReservationLable;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfPeopleLable;
@property (weak, nonatomic) IBOutlet UILabel *PhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (strong, nonatomic) NSDictionary *ReservationHistoryDictionary;
@property (strong, nonatomic) XMLParseOrdersStatuses *db;
@property (strong, nonatomic) NSMutableDictionary *statusOfOrdersDictionary;
@property (weak, nonatomic) IBOutlet UILabel *titleNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDateLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleReservationDetailBar;
@property (strong, nonatomic) IBOutlet UIView *mainView;


@end
