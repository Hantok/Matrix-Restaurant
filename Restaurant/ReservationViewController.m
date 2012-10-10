//
//  NewReservationViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 15.08.12.
//
//

#import "ReservationViewController.h"

@interface ReservationViewController ()
{
    int currentReservationIndex;
}

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *titleThankYouForOrder;
@property (strong, nonatomic) NSString *titleOurOperatorWillCallYou;
@property (strong, nonatomic) NSString *titleError;
@property (strong, nonatomic) NSString *titleCanNotAccessToServer;
@property (strong, nonatomic) NSString *titlePleaseTryAgain;
@property (strong, nonatomic) NSString *titleEnterJustNombers;
@property (strong, nonatomic) NSString *titleOutOfTables;
@property (strong, nonatomic) NSString *titleSorry;
@property (strong, nonatomic) NSString *testString;
@end

@implementation ReservationViewController
@synthesize testString = _testString;
@synthesize name;
@synthesize numberOfPeople;
@synthesize dateOfReservation;
//@synthesize datePicker;
@synthesize pickerViewContainer;
@synthesize dictionary = _dictionary;
@synthesize ReservationHistorydDictionary = _ReservationHistorydDictionary;
@synthesize content = _content;
@synthesize phone = _phone;
@synthesize tapRecognizer;
@synthesize restaurantId;
@synthesize restaurantName;
@synthesize db1 = _db1;
@synthesize reservateButton = _reservateButton;
@synthesize titleReservationTableBar = _titleReservationTableBar;
@synthesize scrollView = _scrollView;

@synthesize titleThankYouForOrder = _titleThankYouForOrder;
@synthesize titleOurOperatorWillCallYou = _titleOurOperatorWillCallYou;
@synthesize titleError = _titleError;
@synthesize titleCanNotAccessToServer = _titleCanNotAccessToServer;
@synthesize titlePleaseTryAgain = _titlePleaseTryAgain;
@synthesize titleEnterJustNombers = _titleEnterJustNombers;
@synthesize titleOutOfTables = _titleOutOfTables;
@synthesize titleSorry = _titleSorry;


- (GettingCoreContent *)content
{
    if(!_content)
    {
        _content = [[GettingCoreContent alloc] init];
    }
    return  _content;
}


- (void) setReservationDictionary:(NSDictionary *)dictionary
{
    self.dictionary = [[NSDictionary dictionaryWithDictionary:dictionary] mutableCopy];
    
    self.name.text = [self.dictionary objectForKey:@"name"];
    self.numberOfPeople.text = [self.dictionary objectForKey:@"numberOfPeople"];
    self.phone.text = [self.dictionary objectForKey:@"phone"];
    self.dateOfReservation.text = [self.dictionary objectForKey:@"dateOfReservation"];
    self.dictionary = nil;
}

/*-(void)viewWillAppear:(BOOL)animated
 {
 NSArray *arrayOfReservations = [self.content getArrayFromCoreDatainEntetyName:@"Reservation" withSortDescriptor:@"name"];
 if (arrayOfReservations.count != 0)
 {
 //[self performSelector:@selector(showListOfAddresses:) withObject:nil];
 [self performSegueWithIdentifier:@"toReservationList" sender:self];
 }
 }
 */
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
    
    CAGradientLayer *mainGradient = [CAGradientLayer layer];
    mainGradient.frame = self.scrollView.bounds;
    mainGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.scrollView.layer insertSublayer:mainGradient atIndex:0];
    
    [self setAllTitlesOnThisPage];
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
    NSLog(@"test string is %@", self.testString);
    
}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setNumberOfPeople:nil];
    [self setDateOfReservation:nil];
    [self setPickerViewContainer:nil];
    //    [self setDatePicker:nil];
    [self setPhone:nil];
    [self setReservateButton:nil];
    [self setTitleReservationTableBar:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.dateOfReservation) {
        [self.name resignFirstResponder];
        [self.numberOfPeople resignFirstResponder];
        [self.phone resignFirstResponder];
        
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
    [self.phone resignFirstResponder];
    
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
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
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

- (IBAction)Reserve:(id)sender
{
    if ([self checkForLiteracy])
    {
    self.dictionary = [[NSMutableDictionary alloc] init];
    [self.dictionary setObject:self.name.text forKey:@"name"];
    [self.dictionary setObject:self.numberOfPeople.text forKey:@"numberOfPeople"];
    [self.dictionary setObject:self.dateOfReservation.text forKey:@"dateOfReservation"];
    [self.dictionary setObject:self.phone.text forKey:@"phone"];
    [self.content addObjectToEntity:@"Reservation" withDictionaryOfAttributes:self.dictionary.copy];
    // NSArray *array = [self.content getArrayFromCoreDatainEntetyName:@"Reservation" withSortDescriptor:@"name"].mutableCopy];
    // NSArray *array = [[[GettingCoreContent alloc] init] fetchAllObjects];
    //NSLog(@"objects are - %@", array);
    NSLog(@"currentRest -%@", restaurantName);
    
    NSMutableString *reserve = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/reserv.php?tag=reserv&DBid=12&UUID="];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])
    {
        NSString *uid = [self createUUID];
        [[NSUserDefaults standardUserDefaults] setValue:uid forKey:@"uid"];
        //9E3C884C-6E57-4D16-884F-46132825F21E
        [[NSUserDefaults standardUserDefaults] synchronize];
        [reserve appendString: uid];
    }
    else
        [reserve appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    
    
    [reserve appendFormat:@"&idRestaurant=%@&custName=%@&numberOfPeople=%@&time=%@&phone=%@",restaurantId,self.name.text,self.numberOfPeople.text,self.dateOfReservation.text,self.phone.text];
    reserve = [reserve stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding].copy;
    NSLog(@"reserve url =%@", reserve);
    
    
    
    
    NSURL *url = [NSURL URLWithString:reserve.copy];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!theConnection)
    {
        // Inform the user that the connection failed.
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection"
                                                                     message:@"Not success"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [connectFailMessage show];
    }
    }
        else
        {
            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Fil all rows with '*'."
                                                                         message:nil //@"Not success"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
            [connectFailMessage show];
        }
   
        
    
}

//- (IBAction)saveReservation:(id)sender
//{
//    self.dictionary = [[NSMutableDictionary alloc] init];
//    [self.dictionary setObject:self.name.text forKey:@"name"];
//    [self.dictionary setObject:self.numberOfPeople.text forKey:@"numberOfPeople"];
//    [self.dictionary setObject:self.dateOfReservation.text forKey:@"dateOfReservation"];
//    [self.dictionary setObject:self.phone.text forKey:@"phone"];
//
//    BOOL isSaved = [self.content addObjectToEntity:@"Reservation" withDictionaryOfAttributes:self.dictionary.copy];
//
//    if (isSaved)
//    {
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Saved new reservation %@.", self.name.text]
//                                                          message:nil
//                                                         delegate:self
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        [message show];
//        return;
//    }
//    else
//    {
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You already have reservation with name %@.", self.name.text]
//                                                          message:nil
//                                                         delegate:self
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        [message show];
//        return;
//    }
//
//
//}
//
//
//

- (IBAction)toReservationList:(id)sender {
    
}

/*- (IBAction)getarraybutton:(id)sender {
 
 NSArray *array = [self.content getArrayFromCoreDatainEntetyName:@"Addresses" withSortDescriptor:@"name"].mutableCopy;
 NSLog(@"Objects are - %@", array);
 
 }
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setRestaurantName:restaurantName];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Unable to fetch data");
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Can not access to the server"
                                                      message:@"Please try again."
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData
                                                   length]);
    NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSASCIIStringEncoding];
    NSLog(@"XML is - %@",txt);
    
    // создаем парсер
    XMLParseResponseFromTheServer *parser = [[XMLParseResponseFromTheServer alloc] initWithData:self.responseData];
    [parser setDelegate:parser];
    [parser parse];
    self.db1 = parser;
    
    NSLog(@"Success: %@", self.db1.success);
    NSLog(@"Number: %@", self.db1.orderNumber);
    NSLog(@"Cause: %@", self.db1.cause);
    
    //NSDate *date = [NSDate date];
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"dd.MM.yyyy"];
    //NSString *dateString = [dateFormat stringFromDate:date];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    
    
    if ([self.db1.success isEqualToString:@"1"])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:self.titleThankYouForOrder
                                                          message:self.titleOurOperatorWillCallYou
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [message show];
        
        self.ReservationHistorydDictionary = [[NSMutableDictionary alloc] init];
        [self.ReservationHistorydDictionary setObject:self.name.text forKey:@"name"];
        [self.ReservationHistorydDictionary setObject:self.numberOfPeople.text forKey:@"numberOfPeople"];
        [self.ReservationHistorydDictionary setObject:dateString forKey:@"currentDate"];
        [self.ReservationHistorydDictionary setObject:self.dateOfReservation.text forKey:@"time"];
        [self.ReservationHistorydDictionary setObject:self.phone.text forKey:@"phone"];
        [self.ReservationHistorydDictionary setObject:restaurantName forKey:@"restaurantName"];
        [self.ReservationHistorydDictionary setObject:self.db1.orderNumber forKey:@"reservationID"];
        [self.ReservationHistorydDictionary setObject:@"1" forKey:@"statusID"];
        [self.content addObjectToCoreDataEntity:@"ReservationHistory" withDictionaryOfAttributes:self.ReservationHistorydDictionary.copy];
        
        [[[GettingCoreContent alloc] init] deleteAllObjectsFromEntity:@"Cart"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        if([self.db1.cause isEqualToString:@"0"])
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:self.titleSorry
                                                              message:self.titleOutOfTables
                                                             delegate:self
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil];
            [message show];
            
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:self.titleError
                                                              message:self.titlePleaseTryAgain
                                                             delegate:self
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil];
            [message show];
            
        }
        [[[GettingCoreContent alloc] init] deleteAllObjectsFromEntity:@"Cart"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (NSString *)createUUID
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   ...
    //   UInt8 byte15;
    // } CFUUIDBytes;
    //CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    //CFRelease(uuidObject);
    
    return uuidStr;
}

-(BOOL)checkForLiteracy
{
           if (![self.name.text isEqual:@""] && ![self.numberOfPeople.text isEqual:@""] && ![self.phone.text isEqual:@""] && ![self.dateOfReservation.text isEqual:@""])
        {
            return YES;
        }
        else
            return NO;
}



-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*Your name"])
        {
            self.name.placeholder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*Phone"])
        {
            self.phone.placeholder = [[array objectAtIndex:i] valueForKey:@"title"];
            self.testString = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*People count"])
        {
            self.numberOfPeople.placeholder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*Date"])
        {
            self.dateOfReservation.placeholder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Reservate"])
        {
            [self.reservateButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"]forState:UIControlStateNormal];
        }
        
        
        
        
        
        
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Thank you for order!"])
        {
            self.titleThankYouForOrder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Our operator will call you for a while."])
        {
            self.titleOurOperatorWillCallYou = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Error"])
        {
            self.titleError = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Can not access to the server"])
        {
            self.titleCanNotAccessToServer = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Please try again."])
        {
            self.titlePleaseTryAgain = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Out of available tables!"])
        {
            self.titleOutOfTables = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Sorry"])
        {
            self.titleSorry = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Enter please just numbers!"])
        {
            self.titleEnterJustNombers = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Reserve table"])
        {
            [self.titleReservationTableBar setTitle: [[array objectAtIndex:i] valueForKey:@"title"]];
        }
    }
    
}
@end

