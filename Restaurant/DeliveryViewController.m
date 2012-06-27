//
//  DeliveryViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeliveryViewController.h"
#import "GettingCoreContent.h"

@interface DeliveryViewController ()

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

@synthesize tapRecognizer = _tapRecognizer;
@synthesize textFieldForFeils = _textFieldForFeils;
@synthesize responseData = _responseData;

- (void)viewDidLoad
{
    //[super viewDidLoad];
	// Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(320, 500);

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
}

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//send info to the server
- (IBAction)toOrder:(id)sender 
{
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.backgroundColor = [UIColor darkTextColor];
    activityView.frame = self.parentViewController.view.frame;
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
//    NSString *orderStringUrl = [@"http://matrix-soft.org/addon_domains_folder/test5/root/Customer_Scripts/makeOrder.php?tag=" stringByAppendingString: @"order"];
//    orderStringUrl = [orderStringUrl stringByAppendingString: @"&DBid=10&UUID=fdsampled-roma-roma-roma-69416d19df4e&ProdIDs=9;11&counts=30;5&city=Kyiv&street=qweqw&house=1&room_office=232&custName=eqweqwewqewe&phone=+380(099)9999999&idDelivery=1"];
    
    NSMutableString *order = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test5/root/Customer_Scripts/makeOrder.php?tag=order&DBid=10&UUID="];
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
    
    [order appendFormat:@"&ProdIDs=%@&counts=%@&city=%@&street=%@&house=%@&room_office=%@&custName=%@&phone=%@&additional_info=%@&idDelivery=1",ids,counts,self.CityName.text,self.street.text,self.build.text,self.appartaments.text,self.customerName.text,self.phone.text,self.otherInformation.text];
    
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
    [self.navigationController popViewControllerAnimated:NO];
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)saveAddress:(id)sender 
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sorry!" 
                                                      message:@"Not working now."  
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
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
