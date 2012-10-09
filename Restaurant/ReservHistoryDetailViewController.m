//
//  ReservHistoryDetailViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 10/2/12.
//
//

#import "ReservHistoryDetailViewController.h"

@interface ReservHistoryDetailViewController ()
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *acceptedString;
@property (strong, nonatomic) NSString *rejectedString;
@property (strong, nonatomic) NSString *waitingString;
@end

@implementation ReservHistoryDetailViewController

@synthesize ReservationHistoryDictionary = _ReservationHistoryDictionary;
@synthesize db = _db;
@synthesize statusOfOrdersDictionary = _statusOfOrdersDictionary;
@synthesize acceptedString = _acceptedString;
@synthesize rejectedString = _rejectedString;
@synthesize waitingString = _waitingString;

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
    [self setAllTitlesOnThisPage];

    NSMutableString *statusRequesString = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/getStatusesReservations.php?DBid=12&UUID="];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])
        {
            NSString *uid = [self createUUID];
            [[NSUserDefaults standardUserDefaults] setValue:uid forKey:@"uid"];
            //9E3C884C-6E57-4D16-884F-46132825F21E
            [[NSUserDefaults standardUserDefaults] synchronize];
            [statusRequesString appendString: uid];
        }
    else
        [statusRequesString appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    
    statusRequesString = [statusRequesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding].copy;
    
    NSURL *urlStatusRequest = [NSURL URLWithString:statusRequesString.copy];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlStatusRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
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
    
    
    
    
    
    
    
    
   
    
    NSLog(@"status request is -%@", request);
	// Do any additional setup after loading the view.
    self.NameOfReservationLable.text = [self.ReservationHistoryDictionary valueForKey:@"name"];
    self.NumberOfPeopleLable.text = [self.ReservationHistoryDictionary valueForKey:@"numberOfPeople"];
    self.TimeLabel.text = [self.ReservationHistoryDictionary valueForKey:@"time"];
    self.PhoneLabel.text = [self.ReservationHistoryDictionary valueForKey:@"phone"];
    if([[self.ReservationHistoryDictionary valueForKey:@"statusID"] isEqualToString:@"0"]){
        self.StatusLabel.text = self.waitingString;
    }
    if([[self.ReservationHistoryDictionary valueForKey:@"statusID"] isEqualToString:@"1"]){
        self.StatusLabel.text = self.acceptedString;
    }
    if([[self.ReservationHistoryDictionary valueForKey:@"statusID" ] isEqualToString:@"2"]){
        self.StatusLabel.text = self.rejectedString;
    }
  //  self.StatusLabel.text = [self.ReservationHistoryDictionary valueForKey:@"statusID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameOfReservationLable:nil];
    [self setNumberOfPeopleLable:nil];
    [self setPhoneLabel:nil];
    [self setTimeLabel:nil];
    [self setStatusLabel:nil];
    [self setTitlePhoneLabel:nil];
    [self setTitleNumberLabel:nil];
    [self setTitlePhoneLabel:nil];
    [self setTitleStatusLabel:nil];
    [self setTitleStatusLabel:nil];
    [self setTitleDateLabel:nil];
    [self setTitleReservationDetailBar:nil];
    [super viewDidUnload];
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
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSASCIIStringEncoding];
    NSLog(@"strinng is - %@",txt);

    // создаем парсер
    XMLParseOrdersStatuses *parser = [[XMLParseOrdersStatuses alloc] initWithData:self.responseData];
    [parser setDelegate:parser];
    [parser parse];
    self.db = parser;
    
    NSArray *arrayOfIdOrders = [[NSArray alloc] initWithArray:[[self.db.tables valueForKey:@"Response"] valueForKey:@"idOrder"]];
    NSArray *arrayOfIdStatus = [[NSArray alloc] initWithArray:[[self.db.tables valueForKey:@"Response"] valueForKey:@"idStatus"]];

    _statusOfOrdersDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < arrayOfIdOrders.count; i++) {
        [_statusOfOrdersDictionary setObject:[arrayOfIdStatus objectAtIndex:i] forKey:[arrayOfIdOrders objectAtIndex:i]];
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
-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"People count"])
        {
            self.titleNumberLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"phone"])
        {
            self.titlePhoneLabel.text =[[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Date"])
        {
            self.titleDateLabel.text =[[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Accepted"])
        {
            self.acceptedString =[[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Rejected"])
        {
            self.rejectedString =[[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Waiting"])
        {
            self.waitingString =[[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Status"])
        {
            self.titleStatusLabel.text =[[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Reservation detail"])
        {
            [self.titleReservationDetailBar setTitle:[[array objectAtIndex:i] valueForKey:@"title"]];
        }


       //        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Accepted"])
//        {
//            self.StatusLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
//        }
    
        
    }
}
@end
