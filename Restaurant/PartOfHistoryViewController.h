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
#import "GettingCoreContent.h"

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

@property (strong, nonatomic) IBOutlet UIView *infoOfProductInOrderContainer;
@property (strong, nonatomic) IBOutlet UIView *infoOfProductInOrderInnerView;
@property (strong, nonatomic) IBOutlet UIButton *showOrHideButtonSecond;
@property (strong, nonatomic) IBOutlet UIView *infoOfProductInOrderDetailView;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel2;
@property (strong, nonatomic) NSDictionary *historyDictionary;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *metroLabel;
@property (strong, nonatomic) IBOutlet UILabel *additionalLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *metroDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *additionalDescriptionLabel;
@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productsCount;
@property (strong, nonatomic) IBOutlet UILabel *productPriceSumm;
@property (strong, nonatomic) NSArray *productsArray;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *reorderButton;

- (IBAction)showOrHideInfoOfOrder:(id)sender;
- (IBAction)infoOfProductInOrder:(id)sender;
- (IBAction)reorderClick:(id)sender;

@end
