//
//  ReservHistoryTableViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 10/1/12.
//
//

#import "ReservHistoryTableViewController.h"
#import "AddressCell.h"
#import "HistoryPartCell.h"

@interface ReservHistoryTableViewController ()
@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation ReservHistoryTableViewController
@synthesize reservationHistoryArray = _reservationHistoryArray;
@synthesize content = _content;
@synthesize responseData = _responseData;
@synthesize selectedRow = _selectedRow;
@synthesize db = _db;
@synthesize restaurantName = _restaurantName;
@synthesize titleReservationHistoryBar = _titleReservationHistoryBar;
@synthesize statusOfOrdersDictionary = _statusOfOrdersDictionary;
- (GettingCoreContent *)content
{
    if(!_content)
    {
        _content = [[GettingCoreContent alloc] init];
    }
    return  _content;
}

- (NSMutableArray *) reservationHistoryArray
{
    if (!_reservationHistoryArray)
    {
        _reservationHistoryArray = [self.content getArrayFromCoreDatainEntetyName:@"ReservationHistory" withSortDescriptor:@"reservationID"].mutableCopy;
        return _reservationHistoryArray;
    }
    return _reservationHistoryArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAllTitlesOnThisPage];
	// Do any additional setup after loading the view.
    
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
    
    NSArray *arrayOfIdOrders = [[NSArray alloc] initWithArray:[[self.db.tables valueForKey:@"Response"] valueForKey:@"idReservation"]];
    NSArray *arrayOfIdStatus = [[NSArray alloc] initWithArray:[[self.db.tables valueForKey:@"Response"] valueForKey:@"Status"]];
     NSLog(@"dictionary %@", arrayOfIdOrders);
   
    
    _statusOfOrdersDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < arrayOfIdOrders.count; i++) {
        [_statusOfOrdersDictionary setObject:[arrayOfIdStatus objectAtIndex:i] forKey:[arrayOfIdOrders objectAtIndex:i]];
    }
    
    //    NSArray *arr = [[NSArray alloc] init];
    //    arr = [[self.statusOfOrdersDictionary allKeys] objectAtIndex:j];
    
    //    NSString *str1 = [[NSString alloc] init];
    //    NSString *str2 = [[NSString alloc] init];
    //
    //    if (str1 isEqualToString:<#(NSString *)#>) {
    //        <#statements#>
    //    }
    
    
    for (int i = 0; i < self.reservationHistoryArray.count; i++) {
        for (int j = 0; j <[[self.statusOfOrdersDictionary allKeys] count]; j++) {
            if ([[[self.reservationHistoryArray objectAtIndex:i] valueForKey:@"reservationID"] isEqualToString:[[self.statusOfOrdersDictionary allKeys] objectAtIndex:j]])
            {
                [[self.reservationHistoryArray objectAtIndex:i] setValue:[self.statusOfOrdersDictionary valueForKey:[[self.statusOfOrdersDictionary allKeys] objectAtIndex:j]] forKey:@"statusID"];
                break;
            }
        }
        //        if ([[self.historyArray objectAtIndex:i] valueForKey:@"statusID"] isEqualToString:<#(NSString *)#>) {
        //            <#statements#>
        //        }
     
    }
    
}

- (void)viewDidUnload
{
    [self setTitleReservationHistoryBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.reservationHistoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"HistoryPartCell";
    HistoryPartCell *cell = (HistoryPartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    if(!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HistoryPartCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[HistoryPartCell class]])
            {
                cell = (HistoryPartCell *)currentObject;
                break;
            }
        }
    }
    
    //    cell.dateOfOrder.text = [self.historyArray objectAtIndex:indexPath.row];
    
    cell.dateOfOrder.text = [[self.reservationHistoryArray objectAtIndex:indexPath.row] valueForKey:@"currentDate"];
    //    cell.dateOfOrder.text = [NSString stringWithFormat:@"%@%@", @"from ", [[self.historyArray objectAtIndex:indexPath.row] valueForKey:@"date"]];
    
    //    cell.numberOfOrder.text = [[self.historyArray objectAtIndex:indexPath.row] valueForKey:@"orderID"];
    cell.numberOfOrder.text = [NSString stringWithFormat:@"%@%@", @"№ ", [[self.reservationHistoryArray objectAtIndex:indexPath.row] valueForKey:@"reservationID"]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.bounds;
    gradient.cornerRadius = 8.0f;
    [gradient setBorderWidth:0.5f];
    [gradient setBorderColor:[[UIColor darkGrayColor] CGColor]];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [cell.layer insertSublayer:gradient atIndex:0];
    
    
    
    return cell;
    
    //    UITableViewCell *cell = nil;
    //    cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    //    }
    //    cell.textLabel.text = [NSString stringWithFormat:@"Cell %lu", (unsigned long)indexPath.row + 1];
    //    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(!cell)
//    {
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:nil options:nil];
//        for(id currentObject in topLevelObjects)
//        {
//            if([currentObject isKindOfClass:[AddressCell class]])
//            {
//                cell = (AddressCell *)currentObject;
//                break;
//            }
//        }
//    }
//    
//    cell.addressLabel.textColor = [UIColor yellowColor];
//    cell.addressLabel.text = [[self.reservationHistoryArray objectAtIndex:indexPath.row] valueForKey:@"currentDate"];
//    return cell;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //Delete form DB
        [self.content deleteReservationWithName:[[self.reservationHistoryArray objectAtIndex:indexPath.row] valueForKey:@"time"]];
        
        [self.reservationHistoryArray removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
 [self performSegueWithIdentifier:@"toReservationHistoryDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setReservationHistoryDictionary:[self.reservationHistoryArray objectAtIndex:self.selectedRow]];
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
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Reserv. history"])
        {
            [self.titleReservationHistoryBar setTitle:[[array objectAtIndex:i] valueForKey:@"title"]];
        }
        
        }
    }



@end
