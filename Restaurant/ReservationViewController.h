//
//  NewReservationViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 15.08.12.
//
//

#import <UIKit/UIKit.h>
#import "TimePicker.h"

@interface ReservationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPeople;
@property (weak, nonatomic) IBOutlet UITextField *dateOfReservation;
//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) TimePicker *pickerViewContainer;

- (IBAction)keyboardHide:(id)sender;

@end
