//
//  DeliveryViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeliveryViewController.h"

@interface DeliveryViewController ()
{
    int currentAddressIndex;
}

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UITextField *textFieldForFeils;
@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation DeliveryViewController
@synthesize scrollView;
@synthesize addressName;
@synthesize customerName;
@synthesize phone;
@synthesize CityName;
@synthesize metroName;
@synthesize street;
@synthesize build;
@synthesize appartaments;
@synthesize otherInformation;
@synthesize access;
@synthesize intercom;
@synthesize floor;
@synthesize dictionary = _dictionary;

@synthesize tapRecognizer = _tapRecognizer;
@synthesize textFieldForFeils = _textFieldForFeils;
@synthesize responseData = _responseData;
@synthesize content = _content;


- (GettingCoreContent *)content
{
    if(!_content)
    {
        _content = [[GettingCoreContent alloc] init];
    }
    return  _content;
}

///////////////////////////////////////////////
#pragma mark
#pragma mark AddressListDelegate methods
///////////////////////////////////////////////

- (void) setAddressDictionary:(NSDictionary *)dictionary
{
    self.dictionary = [[NSDictionary dictionaryWithDictionary:dictionary] mutableCopy];
    
    self.addressName.text = [self.dictionary objectForKey:@"name"];
    self.customerName.text = [self.dictionary objectForKey:@"username"];
    self.phone.text = [self.dictionary objectForKey:@"phone"];
    self.CityName.text = [self.dictionary objectForKey:@"city"];
    self.street.text = [self.dictionary objectForKey:@"street"];
    self.build.text =  [self.dictionary objectForKey:@"house"];
    self.appartaments.text = [self.dictionary objectForKey:@"room_office"];
    self.metroName.text = [self.dictionary objectForKey:@"metro"];
    self.floor.text = [self.dictionary objectForKey:@"floor"];
    self.intercom.text = [self.dictionary objectForKey:@"intercom"];
    self.access.text = [self.dictionary objectForKey:@"access"];
    self.otherInformation.text = [self.dictionary objectForKey:@"additional_info"];
    
    self.dictionary = nil;
}

///////////////////////////////////////////////
#pragma mark
#pragma mark LOADS methods
///////////////////////////////////////////////

-(void)viewWillAppear:(BOOL)animated
{
    NSArray *arrayOfAddresses = [self.content getArrayFromCoreDatainEntetyName:@"Addresses" withSortDescriptor:@"name"];
    if (arrayOfAddresses.count != 0)
    {
        //[self performSelector:@selector(showListOfAddresses:) withObject:nil];
        [self performSegueWithIdentifier:@"toAddressList" sender:self];
    }
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
	// Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(320, 550);

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
}

- (void)viewDidUnload
{
    [self setAddressName:nil];
    [self setCustomerName:nil];
    [self setPhone:nil];
    [self setCityName:nil];
    [self setMetroName:nil];
    [self setStreet:nil];
    [self setBuild:nil];
    [self setAppartaments:nil];
    [self setOtherInformation:nil];
    [self setScrollView:nil];
    [self setFloor:nil];
    [self setAccess:nil];
    [self setIntercom:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

///////////////////////////////////////////////
#pragma mark
#pragma mark TextFields and keyboards features
///////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{    
    [theTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.textFieldForFeils)
    {
        [self.textFieldForFeils becomeFirstResponder];
        self.textFieldForFeils = nil;
    }
    
    if (textField == self.appartaments || textField == self.build || textField == self.street 
        || textField == self.otherInformation)
    {
        CGFloat tempy = self.scrollView.contentSize.height;//imageView.frame.size.height;
        CGFloat tempx = self.scrollView.contentSize.width;;
        CGRect zoomRect = CGRectMake((tempx/2), (tempy/2), tempy, tempx);
        [self.scrollView scrollRectToVisible:zoomRect animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phone || textField == self.build || textField == self.appartaments)
    {
        if (![textField.text isEqual:@""])
            if (![[NSScanner scannerWithString:textField.text] scanInteger:nil])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter please just numbers!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                textField.text = nil;
                //[textField becomeFirstResponder];
                self.textFieldForFeils = textField;
            }
    }
}

-(void) keyboardWillShow:(NSNotification *) note 
{
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {    
    [self.addressName resignFirstResponder];
    [self.customerName resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.CityName resignFirstResponder];
    [self.metroName resignFirstResponder];
    [self.street resignFirstResponder];
    [self.build resignFirstResponder];
    [self.appartaments resignFirstResponder];
    [self.otherInformation resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/////////////////////////////////////////////////////
#pragma mark
#pragma mark IBActions
/////////////////////////////////////////////////////

//send info to the server
- (IBAction)toOrder:(id)sender 
{
    if ([self checkForLiteracy])
    {
        //save address
        self.dictionary = [[NSMutableDictionary alloc] init];
        [self.dictionary setObject:self.addressName.text forKey:@"name"];
        [self.dictionary setObject:self.customerName.text forKey:@"username"];
        [self.dictionary setObject:self.phone.text forKey:@"phone"];
        [self.dictionary setObject:self.CityName.text forKey:@"city"];
        [self.dictionary setObject:self.street.text forKey:@"street"];
        [self.dictionary setObject:self.build.text forKey:@"house"];
        [self.dictionary setObject:self.appartaments.text forKey:@"room_office"];
        [self.dictionary setObject:self.metroName.text forKey:@"metro"];
        [self.dictionary setObject:self.floor.text forKey:@"floor"];
        [self.dictionary setObject:self.intercom.text forKey:@"intercom"];
        [self.dictionary setObject:self.access.text forKey:@"access"];
        [self.dictionary setObject:self.otherInformation.text forKey:@"additional_info"];
        [self.content addObjectToEntity:@"Addresses" withDictionaryOfAttributes:self.dictionary.copy];
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.backgroundColor = [UIColor darkTextColor];
        activityView.frame = self.parentViewController.view.frame;
        activityView.center=self.view.center;
        [activityView startAnimating];
        [self.view addSubview:activityView];
        
        //    NSString *orderStringUrl = [@"http://matrix-soft.org/addon_domains_folder/test5/root/Customer_Scripts/makeOrder.php?tag=" stringByAppendingString: @"order"];
        //    orderStringUrl = [orderStringUrl stringByAppendingString: @"&DBid=10&UUID=fdsampled-roma-roma-roma-69416d19df4e&ProdIDs=9;11&counts=30;5&city=Kyiv&street=qweqw&house=1&room_office=232&custName=eqweqwewqewe&phone=+380(099)9999999&idDelivery=1"];
        
        NSMutableString *order = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test6/root/Customer_Scripts/makeOrder.php?tag=order&DBid=11&UUID="];
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
        
        [order appendFormat:@"&ProdIDs=%@&counts=%@&city=%@&street=%@&house=%@&room_office=%@&custName=%@&phone=%@&additional_info=%@&access=%@&intercom=%@&floor=%@&idDelivery=1",ids,counts,self.CityName.text,self.street.text,self.build.text,self.appartaments.text,self.customerName.text,self.phone.text,self.otherInformation.text, self.access.text,self.intercom.text, self.floor.text];
        
        order = [[order stringByReplacingOccurrencesOfString:@" " withString:@"_"] mutableCopy];
        
        NSURL *url = [NSURL URLWithString:order.copy];
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

- (IBAction)saveAddress:(id)sender 
{
    if ([self checkForLiteracy])
    {
        self.dictionary = [[NSMutableDictionary alloc] init];
        [self.dictionary setObject:self.addressName.text forKey:@"name"];
        [self.dictionary setObject:self.customerName.text forKey:@"username"];
        [self.dictionary setObject:self.phone.text forKey:@"phone"];
        [self.dictionary setObject:self.CityName.text forKey:@"city"];
        [self.dictionary setObject:self.street.text forKey:@"street"];
        [self.dictionary setObject:self.build.text forKey:@"house"];
        [self.dictionary setObject:self.appartaments.text forKey:@"room_office"];
        [self.dictionary setObject:self.metroName.text forKey:@"metro"];
        [self.dictionary setObject:self.floor.text forKey:@"floor"];
        [self.dictionary setObject:self.intercom.text forKey:@"intercom"];
        [self.dictionary setObject:self.access.text forKey:@"access"];
        [self.dictionary setObject:self.otherInformation.text forKey:@"additional_info"];
        
        [self.content addObjectToEntity:@"Addresses" withDictionaryOfAttributes:self.dictionary.copy];
    }
    else 
    {
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Fill all rows with '*'." 
                                                                     message:nil //@"Not success"  
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [connectFailMessage show];
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Saved new address %@.", self.addressName.text]
                                                      message:nil  
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (IBAction)toAddressList:(id)sender 
{
//    [[[AddressListTableViewController alloc] initWithNibName:@"AddressListTableViewController" bundle:[NSBundle mainBundle]] setDelegate:self];
//    AddressListTableViewController *controller =  [[AddressListTableViewController alloc] init];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toAddressList"])
    {
        AddressListTableViewController *controller =  [segue destinationViewController];
        controller.delegate = self;
    }
}

/////////////////////////////////////////////////////
#pragma mark 
#pragma mark working with server
/////////////////////////////////////////////////////

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
    NSLog(@"strinng is - %@",txt);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thank you for order!" 
                                                                 message:@"Our operator will call you for a while."  
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
    [message show];
    [[[GettingCoreContent alloc] init] deleteAllObjectsFromEntity:@"Cart"]; 
    [self.navigationController popViewControllerAnimated:YES];
}

/////////////////////////////////////////////////////
#pragma mark 
#pragma mark private methods
/////////////////////////////////////////////////////

-(BOOL)checkForLiteracy
{
    if (![self.addressName.text isEqual:@""] && ![self.customerName.text isEqual:@""] && ![self.phone.text isEqual:@""] && ![self.CityName.text isEqual:@""] && ![self.street.text isEqual:@""] && ![self.build.text isEqual:@""] && ![self.appartaments.text isEqual:@""]) 
    {
        return YES;
    }
    else
        return NO;
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
@end
