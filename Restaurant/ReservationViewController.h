//
//  NewReservationViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 15.08.12.
//
//

#import <UIKit/UIKit.h>

@interface ReservationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPeople;
@property (weak, nonatomic) IBOutlet UITextField *dateOfReservation;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;

- (IBAction)hideButton:(id)sender;
- (IBAction)okButton:(id)sender;
- (IBAction)keyboardHide:(id)sender;

@end
