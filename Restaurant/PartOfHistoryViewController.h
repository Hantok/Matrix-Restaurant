//
//  PartOfHistoryViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 30.08.12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HistoryTableListViewController.h"

@interface PartOfHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (readwrite) int rowNumber;
@property (strong, nonatomic) NSString *tempStr;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *infoOfOrderContainer;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *infoOfOrderContainerInnerView;
@property (strong, nonatomic) IBOutlet UIButton *showOrHideButtonFirst;
@property (strong, nonatomic) IBOutlet UIView *infoOfOrderDetailView;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;

@property (strong, nonatomic) IBOutlet UIView *infoOfProductInOrderContainer;
@property (strong, nonatomic) IBOutlet UIView *infoOfProductInOrderInnerView;
@property (strong, nonatomic) IBOutlet UIButton *showOrHideButtonSecond;
@property (strong, nonatomic) IBOutlet UIView *infoOfProductInOrderDetailView;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel2;
@property (strong, nonatomic) NSDictionary *historyDictionary;


- (IBAction)showOrHideInfoOfOrder:(id)sender;
- (IBAction)infoOfProductInOrder:(id)sender;

@end
