//
//  ReservationViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 8/2/12.
//
//

#import <UIKit/UIKit.h>

@interface ReservationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *numberPeople;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
