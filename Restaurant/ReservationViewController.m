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
//@synthesize datePicker;
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
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TimePicker" owner:nil options:nil];
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[TimePicker class]])
        {
            self.pickerViewContainer = (TimePicker *)currentObject;
            break;
        }
    }
    self.pickerViewContainer.frame = CGRectMake(0, 460, 320, 261);
    [self.pickerViewContainer.okButton setTarget:self];
    [self.pickerViewContainer.okButton setAction:@selector(okButton)];
    
    [self.pickerViewContainer.hideButton setTarget:self];
    [self.pickerViewContainer.hideButton setAction:@selector(hideButton)];
//    self.pickerViewContainer.hideButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(hideButton)];
//    self.pickerViewContainer.okButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(okButton)];
    
//    [self.view addSubview:self.pickerViewContainer];
    
}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setNumberOfPeople:nil];
    [self setDateOfReservation:nil];
    [self setPickerViewContainer:nil];
//    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.dateOfReservation) {
        [self.name resignFirstResponder];
        [self.numberOfPeople resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        pickerViewContainer.frame = CGRectMake(0, 156, 320, 260);
        [self.view addSubview:self.pickerViewContainer];
        [UIView commitAnimations];
        
        NSTimeInterval twoHours = 2 * 60 * 60;
        NSDate *date = [[self.pickerViewContainer.datePicker date] dateByAddingTimeInterval:twoHours];
        [self.pickerViewContainer.datePicker setMinimumDate:date];

                
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

- (void)hideButton {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    [UIView commitAnimations];

}

- (void)okButton {
        
    //  get the current date
    NSDate *date = [self.pickerViewContainer.datePicker date];
    
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

- (IBAction)keyboardHide:(id)sender {
    [self resignFirstResponder];
}

@end
