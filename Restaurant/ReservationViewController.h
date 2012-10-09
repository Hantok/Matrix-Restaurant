//
//  NewReservationViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 15.08.12.
//

#import <UIKit/UIKit.h>
#import "GettingCoreContent.h"
#import "TimePicker.h"
#import "XMLParseResponseFromTheServer.h"
#import "RestaurantDataStruct.h"
#import "Singleton.h"
#import "SSToolkit/SSToolkit.h"


@interface ReservationViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *reservateButton;
@property (strong, nonatomic) IBOutlet UITextField *numberOfPeople;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *dateOfReservation;
//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleReservationTableBar;
@property (strong, nonatomic) TimePicker *pickerViewContainer;
@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) NSMutableDictionary *ReservationHistorydDictionary;
@property (strong, nonatomic) GettingCoreContent  *content;
@property (weak, nonatomic) XMLParseResponseFromTheServer *db1;

@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSString *restaurantName;
- (IBAction)keyboardHide:(id)sender;
- (IBAction)Reserve:(id)sender;
- (IBAction)toReservationList:(id)sender;

@end
