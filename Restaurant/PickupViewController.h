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
#import <QuartzCore/QuartzCore.h>

@interface PickupViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) TimePicker *timePickerView;
@property (weak, nonatomic) IBOutlet UITextField *Time;
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *Address;
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (strong, nonatomic) XMLParseResponseFromTheServer *db;
@property (strong, nonatomic) GettingCoreContent *content;
@property (strong, nonatomic) NSMutableArray *addressDictionary;



@end
