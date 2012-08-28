//
//  TimePicker.h
//  Restaurant
//
//  Created by Matrix Soft on 8/27/12.
//
//

#import <UIKit/UIKit.h>

@interface TimePicker : UIView
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *hideButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *okButton;

@end
