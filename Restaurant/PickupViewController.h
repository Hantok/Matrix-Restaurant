//
//  PickupViewController.h
//  Restaurant
//
//  Created by Alex on 10/16/12.
//
//

#import <UIKit/UIKit.h>
#import "TimePicker.h"
#import "XMLParseResponseFromTheServer.h"
#import "GettingCoreContent.h"
#import "IconDownloader.h"
#import "PickerViewCell.h"
#import "Singleton.h"
#import "MapViewController.h"
#import "SSToolkit/SSToolkit.h"
#import <QuartzCore/QuartzCore.h>

@interface PickupViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate, UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, weak) TimePicker *timePickerView;
@property (weak, nonatomic) IBOutlet UITextField *Time;
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *Address;
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnOnMAp;
@property (strong, nonatomic) SSHUDView *hudView;
@property (strong, nonatomic) NSMutableDictionary *historyDictionary;

@property (strong, nonatomic) XMLParseResponseFromTheServer *db;
@property (strong, nonatomic) GettingCoreContent *content;

- (IBAction)btnOrderClicked:(id)sender;
- (IBAction)btnMapClicked:(id)sender;



@end
