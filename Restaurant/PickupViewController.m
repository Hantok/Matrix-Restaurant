//
//  PickupViewController.m
//  Restaurant
//
//  Created by Alex on 10/16/12.
//
//

#import "PickupViewController.h"

@interface PickupViewController ()

@property (weak, nonatomic) UITextField *textFieldforFails;
@property (weak, nonatomic) UITapGestureRecognizer *tapRecognizer;
//titles

@end

@implementation PickupViewController
@synthesize Name = _Name;
@synthesize Address = _Address;
@synthesize Time = _Time;
@synthesize Phone = _phone;

@synthesize timePickerView = _timePickerView;
@synthesize db = _db;
@synthesize content = _content;
@synthesize addressDictionary = _addressDictionary;
@synthesize textFieldforFails = _textFieldforFails;
@synthesize tapRecognizer = _tapRecognizer;

//titles

-(GettingCoreContent *)content
{
    if (!_content)
    {
        _content = [[GettingCoreContent alloc] init];
    }
    return _content;
}



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
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    CAGradientLayer *mainGradient = [CAGradientLayer layer];
    mainGradient.frame = self.ScrollView.bounds;
    mainGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.ScrollView.layer insertSublayer:mainGradient atIndex:0];
    
    [self setAllTitlesOnThisPage];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.Time)
    {
        [self.Name resignFirstResponder];
        [self.Phone resignFirstResponder];
        [self.Address resignFirstResponder];
        [self.Time resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        if (self.timePickerView == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TimePicker" owner:nil options:nil];
            for (id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[TimePicker class]])
                {
                    self.timePickerView = (TimePicker *)currentObject;
                    break;
                }
            }
            self.timePickerView.frame = CGRectMake(0,415,320,260);
            [self.timePickerView.okButton setTarget:self];
            [self.timePickerView.okButton setAction:@selector(okButton)];
            
            [self.timePickerView.hideButton setTarget:self];
            [self.timePickerView.hideButton setAction:@selector(hide)];
            
            NSTimeInterval twoHours = 2 * 60 * 60;
            NSDate *date = [[self.timePickerView.datePicker date] dateByAddingTimeInterval:twoHours];
            [self.timePickerView.datePicker setMaximumDate:date];
        }
        self.timePickerView.frame = CGRectMake(0, 160, 320, 260);
        [self.view addSubview:self.timePickerView];
        [UIView commitAnimations];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.textFieldforFails)
    {
        [self.textFieldforFails becomeFirstResponder];
        self.textFieldforFails = nil;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

-(void) okButton
{
    //get the current date
    NSDate *date = [self.timePickerView.datePicker date];
    //format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm zzz"];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    self.Time.text = dateString;
    [self hide];
    
}

-(void) keyboardWillShow: (NSNotification *)note
{
    //[self.view addGestureRecognizer:self.tapRecognizer];
    [self hide];
}

-(void) keyboardWillHide: (NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
}

-(void) didTapAnywhere: (UITapGestureRecognizer *) recognizer
{
    [self.Name resignFirstResponder];
    [self.Phone resignFirstResponder];
    [self.Time resignFirstResponder];
    [self.Address resignFirstResponder];
}

-(void) hide //used by hidebutton in time picker
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.timePickerView.frame = CGRectMake(0,415,320,260);
    [UIView commitAnimations];
    [self performSelector:@selector(removingTimePicker) withObject:nil afterDelay:0.5];
}

-(void) removingTimePicker
{
    [self.timePickerView removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setTime:nil];
    [self setPhone:nil];
    [self setAddress:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
-(void)setAllTitlesOnThisPage
{
    //some titles
}
@end
