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
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UIPickerView  *addressPicker;
@property (strong, nonatomic) UITableView *addressTableView;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *arrayOfRestaurants;
@property (strong, nonatomic) NSMutableString *ids;
@property (strong, nonatomic) NSMutableString *counts;
@property (nonatomic) int selectedRow;

//titles
@property (strong, nonatomic) NSString *titleError;
@property (strong, nonatomic) NSString *titleOurOperatorWillCallYou;
@property (strong, nonatomic) NSString *titleCanNotAccessToServer;
@property (strong, nonatomic) NSString *titlePleaseTryAgain;
@property (strong, nonatomic) NSString *titleCancel;
@property (strong, nonatomic) NSString *titleName;
@property (strong, nonatomic) NSString *titlePhone;
@property (strong, nonatomic) NSString *titleTime;
@property (strong, nonatomic) NSString *titleAddress;
@property (strong, nonatomic) NSString *titleOrder;
@property (strong, nonatomic) NSString *titleOnMap;
@property (strong, nonatomic) NSString *titleThankYouForOrder;

@end

@implementation PickupViewController
@synthesize Name = _Name;
@synthesize Address = _Address;
@synthesize Time = _Time;
@synthesize Phone = _phone;

@synthesize historyDictionary = _historyDictionary;
@synthesize selectedRow = _selectedRow;
@synthesize timePickerView = _timePickerView;
@synthesize responseData = _responseData;
@synthesize db = _db;
@synthesize content = _content;
@synthesize textFieldforFails = _textFieldforFails;
@synthesize tapRecognizer = _tapRecognizer;
@synthesize addressPicker = _addressPicker;
@synthesize addressTableView = _addressTableView;
@synthesize btnOnMAp = _btnOnMAp;
@synthesize btnOrder = _btnOrder;
@synthesize hudView = _hudView;

//titles
@synthesize titleThankYouForOrder = _titleThankYouForOrder;
@synthesize titleOurOperatorWillCallYou = _titleOurOperatorWillCallYou;
@synthesize titleError = _titleError;
@synthesize titleCanNotAccessToServer = _titleCanNotAccessToServer;
@synthesize titlePleaseTryAgain = _titlePleaseTryAgain;
@synthesize titleCancel = _titleCancel;
@synthesize titleAddress = _titleAddress;
@synthesize titleName = _titleName;
@synthesize titleOrder = _titleOrder;
@synthesize titlePhone = _titlePhone;
@synthesize titleTime = _titleTime;
@synthesize titleOnMap = _titleOnMap;

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

//------- View methods section --------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    CAGradientLayer *mainGradient = [CAGradientLayer layer];
    mainGradient.frame = self.ScrollView.bounds;
    mainGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.ScrollView.layer insertSublayer:mainGradient atIndex:0];
    
    [self setAllTitlesOnThisPage];
    
    self.Name.placeholder = self.titleName;
    self.Phone.placeholder = self.titlePhone;
    self.Address.placeholder = self.titleAddress;
    self.Time.placeholder = self.titleTime;
    self.btnOnMAp.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.btnOnMAp setTitle:self.titleOnMap forState:UIControlStateNormal];
    self.btnOrder.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.btnOrder setTitle:self.titleOrder forState:UIControlStateNormal];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //set properties of timeViewPicker
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
    self.timePickerView.okButton.title = @"OK";
    [self.timePickerView.okButton setAction:@selector(okButton)];
        
    [self.timePickerView.hideButton setTarget:self];
    self.timePickerView.hideButton.title = self.titleCancel;
    [self.timePickerView.hideButton setAction:@selector(hideButton)];
        
    NSTimeInterval twoHours = 2 * 60 * 60;
    NSDate *date = [[self.timePickerView.datePicker date] dateByAddingTimeInterval:twoHours];
    [self.timePickerView.datePicker setMinimumDate:date];
    self.Time.inputView = self.timePickerView;
    
    //set properties of addressPickerView
    self.addressPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,420,320,220)];
    self.addressPicker.delegate = self;
    self.addressPicker.showsSelectionIndicator = YES;
    self.Address.inputView = self.addressPicker;
    
    //set up addressPickerView buttons
    UIToolbar *addressPickerButtonsView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    addressPickerButtonsView.barStyle = UIBarStyleBlack;
    addressPickerButtonsView.tintColor = nil;
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:self.titleCancel style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancelClicked)];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked)];
    
    [addressPickerButtonsView setItems:[NSArray arrayWithObjects:cancelBtn,flexSpace,doneBtn, nil]];
    
    self.Address.inputAccessoryView = addressPickerButtonsView;
}

-(void) viewWillAppear:(BOOL)animated
{
    
    NSArray *data = [self.content fetchAllRestaurantsWithDefaultLanguageAndCity]; // array of restaurant data
    self.arrayOfRestaurants = [[NSMutableArray alloc]init];
    id restaurant;

    RestaurantDataStruct *dataStruct;
    for(int i=0;i<data.count;i++)
    {
        if(i%2==0)
        {
            restaurant = [data objectAtIndex:i];
            dataStruct = [[RestaurantDataStruct alloc] init];
            dataStruct.restaurantId = [restaurant valueForKey:@"underbarid"];
            dataStruct.phones = [restaurant valueForKey:@"phones"];
            dataStruct.idPicture = [restaurant valueForKey:@"idPicture"];
            NSArray *coordinates = [[restaurant valueForKey:@"coordinates"] componentsSeparatedByString:@";"];
            dataStruct.latitude = [coordinates objectAtIndex:0];
            dataStruct.longitude = [coordinates objectAtIndex:1];
            dataStruct.seatsNumber = [restaurant valueForKey:@"seatsNumber"];
            dataStruct.terrace = [restaurant valueForKey:@"terrace"];
            dataStruct.parking = [restaurant valueForKey:@"parking"];
            dataStruct.workingTime = [restaurant valueForKey:@"workingTime"];
        }
        else
        {
            restaurant = [data objectAtIndex:i];
            dataStruct.name = [restaurant valueForKey:@"name"];
            dataStruct.subwayStation = [restaurant valueForKey:@"Metro"];
            dataStruct.street = [restaurant valueForKey:@"Street"];
            dataStruct.additionalContactInfo = [restaurant valueForKey:@"AdditionalContactInfo"];
            dataStruct.build = [restaurant valueForKey:@"House"];
            dataStruct.additionalAddressInfo = [restaurant valueForKey:@"AdditionalAddressInfo"];
            [self.arrayOfRestaurants addObject:dataStruct];
        }
    }
    
    
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
    [self setBtnOrder:nil];
    [self setBtnOnMAp:nil];
    [super viewDidUnload];
}
// ------- End of View methods section -------

// ------- interaction with textfields and keyboards section -------

//------ picker delegates--------
-(id)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.arrayOfRestaurants objectAtIndex:row] valueForKey:@"name"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayOfRestaurants.count;
}

// ------ end of picker delegates implementation -------

// time picker button's selectors
-(void) okButton
{
    //get the current date
    NSDate *date = [self.timePickerView.datePicker date];
    //format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    self.Time.text = dateString;
    [self.Time resignFirstResponder];
    
}
-(void) hideButton
{
    [self.Time resignFirstResponder];
}

-(void) pickerDoneClicked
{
    self.selectedRow = [self.addressPicker selectedRowInComponent:0];
    RestaurantDataStruct *currentRestaurant = [self.arrayOfRestaurants objectAtIndex:self.selectedRow];
    self.Address.text = [NSString stringWithFormat:@"%@, %@",currentRestaurant.street,currentRestaurant.build];
    [self.Address resignFirstResponder];
}

-(void) pickerCancelClicked
{
    [self.Address resignFirstResponder];
}

//address picker button's selectors


-(void) keyboardWillShow: (NSNotification *)note
{
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.ScrollView.contentSize = CGSizeMake(320,440);
}

-(void) keyboardWillHide: (NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
    self.ScrollView.contentSize = CGSizeMake(320, 415);
}

-(void) didTapAnywhere: (UITapGestureRecognizer *) recognizer
{
    [self.Name resignFirstResponder];
    [self.Phone resignFirstResponder];
    [self.Time resignFirstResponder];
    [self.Address resignFirstResponder];
}
//------- end of interaction section --------

//----------- Working with server -----------

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc]init];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Unable to fetch data");
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:self.titleCanNotAccessToServer
                                                      message:self.titlePleaseTryAgain
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData
                                                   length]);
    NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSASCIIStringEncoding];
    NSLog(@"strinng is - %@",txt);
    
    // создаем парсер
    XMLParseResponseFromTheServer *parser = [[XMLParseResponseFromTheServer alloc] initWithData:self.responseData];
    [parser setDelegate:parser];
    [parser parse];
    self.db = parser;
    
    if ([self.db.success isEqualToString:@"1"])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:self.titleThankYouForOrder
                                                          message:self.titleOurOperatorWillCallYou
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    else
    {

            [self.hudView failAndDismissWithTitle:nil];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:self.titleError
                                                              message:self.titlePleaseTryAgain
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            [self.navigationController popViewControllerAnimated:YES];
            return;

    }
    
    NSLog(@"Success: %@", self.db.success);
    NSLog(@"orderNumber: %@", self.db.orderNumber);
    
    RestaurantDataStruct *currentRest = [self.arrayOfRestaurants objectAtIndex:self.selectedRow];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    self.historyDictionary = [[NSMutableDictionary alloc] init];
    [self.historyDictionary setObject:currentRest.build forKey:@"house"];
    [self.historyDictionary setObject:dateString forKey:@"date"];
    [self.historyDictionary setObject:self.Time.text forKey:@"deliveryTime"];
    [self.historyDictionary setObject:@"3" forKey:@"deliveryID"];
    [self.historyDictionary setObject:self.db.orderNumber forKey:@"orderID"];
    [self.historyDictionary setObject:self.counts forKey:@"productsCounts"];
    [self.historyDictionary setObject:self.ids forKey:@"productsIDs"];
    [self.historyDictionary setObject:@"3" forKey:@"statusID"];
    [self.historyDictionary setObject:currentRest.street forKey:@"street"];
    
    [self.content addObjectToCoreDataEntity:@"CustomerOrders" withDictionaryOfAttributes:self.historyDictionary.copy];
    
    [[[GettingCoreContent alloc] init] deleteAllObjectsFromEntity:@"Cart"];
    
    [self.hudView completeAndDismissWithTitle:nil];
    [self performSelector:@selector(pop:) withObject:nil afterDelay:0.9];
}

- (void)pop:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
//------- End of server interaction ---------

//------- Button actions ---------
-(IBAction)btnMapClicked:(id)sender
{
    if(![self.Address.text isEqual:@""])
        [self performSegueWithIdentifier:@"toMap" sender:self];
}

-(IBAction)btnOrderClicked:(id)sender
{
    if([self checkForLiteracy])
    {
        NSMutableString *order = [NSMutableString stringWithString:@"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/makeOrder.php?tag=order&DBid=12&UUID="];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])
        {
            NSString *uid = [self createUUID];
            [[NSUserDefaults standardUserDefaults] setValue:uid forKey:@"uid"];
            //9E3C884C-6E57-4D16-884F-46132825F21E
            [[NSUserDefaults standardUserDefaults] synchronize];
            [order appendString: uid];
        }
        else
            [order appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
        NSArray *cartArray = [[[GettingCoreContent alloc] init] fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Cart"];
        NSMutableString *ids = [[NSMutableString alloc] init];
        NSMutableString *counts = [[NSMutableString alloc] init];
        for (int i = 0; i < cartArray.count; i++)
        {
            [ids appendString:[NSString stringWithFormat:@"%@;",[[cartArray objectAtIndex:i] valueForKey:@"underbarid"]]];
            [counts appendString:[NSString stringWithFormat:@"%@;",[[cartArray objectAtIndex:i] valueForKey:@"count"]]];
        }
        [ids setString:[ids substringToIndex:(ids.length - 1)]];
        [counts setString:[counts substringToIndex:(counts.length - 1)]];
        
        self.ids = ids;
        self.counts = counts;
        
        NSString *deliveryType = @"3";
        RestaurantDataStruct *currentRest = [self.arrayOfRestaurants objectAtIndex:self.selectedRow];
        
        [order appendFormat:@"&ProdIDs=%@&counts=%@&custName=%@&phone=%@&deliveryType=%@&deliveryTime=%@&idRestaurant=%@",ids,counts,self.Name.text,self.Phone.text, deliveryType,self.Time.text,currentRest.restaurantId];
        
        order = [order stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding].copy;
        NSURL *url = [NSURL URLWithString:order.copy];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"GET"];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        self.ScrollView.frame = self.parentViewController.view.frame;
        self.hudView = [[SSHUDView alloc]init];
        self.hudView.backgroundColor = [UIColor clearColor];
        [self.hudView show];
        
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
//-----------segues --------------
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toMap"])
    {
        RestaurantDataStruct *currentRestaurant = [self.arrayOfRestaurants objectAtIndex:self.selectedRow];
        NSString *latitude = currentRestaurant.latitude;
        NSString *longitude = currentRestaurant.longitude;
        latitude = [latitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
        longitude = [longitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
        CLLocationCoordinate2D location = {.latitude = latitude.doubleValue, .longitude =  longitude.doubleValue};
        [segue.destinationViewController setCoordinates:location];
        [segue.destinationViewController setDataStruct:currentRestaurant];
    }
}
//--------------------------------

-(NSString *)createUUID
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
    if (![self.Name.text isEqual:@""] && ![self.Time.text isEqual:@""] && ![self.Phone.text isEqual:@""] && ![self.Address.text isEqual:@""])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cancel"])
        {
            self.titleCancel = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Can not access to the server"])
        {
            self.titleCanNotAccessToServer = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Please try again."])
        {
            self.titlePleaseTryAgain = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*Your name"])
        {
            self.titleName = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*Time"])
        {
            self.titleTime = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*Phone"])
        {
            self.titlePhone = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"*Address name"])
        {
            self.titleAddress = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Show on map"])
        {
            self.titleOnMap = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Order"])
        {
            self.titleOrder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Error"])
        {
            self.titleError = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Our operator will call you for a while."])
        {
            self.titleOurOperatorWillCallYou = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Thank you for order!"])
        {
            self.titleThankYouForOrder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    }
}
@end