//
//  NewReservationViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 15.08.12.
//
//

#import "ReservationViewController.h"

@interface ReservationViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation ReservationViewController
@synthesize name;
@synthesize numberOfPeople;
@synthesize dateOfReservation;
@synthesize datePicker;
@synthesize pickerViewContainer;

@synthesize tapRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(didTapAnywhere:)];
    
    pickerViewContainer.frame = CGRectMake(0, 460, 320, 261);

}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setNumberOfPeople:nil];
    [self setDateOfReservation:nil];
    [self setPickerViewContainer:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.dateOfReservation) {
        [self.name resignFirstResponder];
        [self.numberOfPeople resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)keyboardWillShow:(NSNotification *) note
{
    [self.view addGestureRecognizer:self.tapRecognizer];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    [UIView commitAnimations];

}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
    
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.name resignFirstResponder];
    [self.numberOfPeople resignFirstResponder];
    [self.dateOfReservation resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    [UIView commitAnimations];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)hideButton:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    [UIView commitAnimations];

}

- (IBAction)okButton:(id)sender {
    
    //  get the current date
    NSDate *date = [datePicker date];
    
    // format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm zzz"];
    
    // convert it to a string
    NSString *dateString = [dateFormat stringFromDate:date];
    
    self.dateOfReservation.text = dateString;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    [UIView commitAnimations];

}

- (IBAction)showDatePicker:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(0, 156, 320, 260);
    [UIView commitAnimations];

}

- (IBAction)keyboardHide:(id)sender {
    [self resignFirstResponder];
}

@end
