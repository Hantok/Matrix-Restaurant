//
//  HistoryTableListViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 30.08.12.
//
//

#import "HistoryTableListViewController.h"
#import "HistoryPartCell.h"
#import "RestaurantCell.h"
#import "SSToolkit/SSToolkit.h"

@interface HistoryTableListViewController ()

@property (strong, nonatomic) NSMutableData *responseData;
@property (nonatomic, strong) SSHUDView *hudView;

// titles
@property (nonatomic, weak) NSString *titleLoading;
@property (nonatomic, weak) NSString *titleFinished;
@property (nonatomic, weak) NSString *titleUnableFetchData;
@property (nonatomic, weak) NSString *titleSuccesLanguage;

@end

@implementation HistoryTableListViewController
@synthesize tableView = _tableView;
@synthesize historyArray = _historyArray;
@synthesize selectedRow = _selectedRow;
@synthesize content = _content;
@synthesize responseData = _responseData;
@synthesize db = _db;
@synthesize statusOfOrdersDictionary = _statusOfOrdersDictionary;
@synthesize hudView = _hudView;

// titles
@synthesize titleLoading = _titleLoading;
@synthesize titleFinished = _titleFinished;
@synthesize titleUnableFetchData = _titleUnableFetchData;
@synthesize titleSuccesLanguage = _titleSuccesLanguage;

- (GettingCoreContent *)content
{
    if(!_content)
    {
        _content = [[GettingCoreContent alloc] init];
    }
    return  _content;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
        tempArray = [[self.content getArrayFromCoreDatainEntetyName:@"CustomerOrders" withSortDescriptor:@"name"] mutableCopy];
        
        for (int i = tempArray.count; i > 0; i--) {
            [_historyArray addObject:[tempArray objectAtIndex:i - 1]];
            [tempArray2 addObject:[tempArray objectAtIndex:i - 1]];
            NSLog(@"%u %u", [_historyArray count], [tempArray2 count]);
        }
        
        _historyArray = [tempArray2 mutableCopy];
        
        return _historyArray;
    }
    return _historyArray;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSMutableString *statusRequesString = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/getStatuses.php?DBid=12&UUID="];
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
    } else {
        self.hudView = [[SSHUDView alloc] initWithTitle:@"Loading..."];
        [self.hudView show];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
//    self.hudView = [[SSHUDView alloc] initWithTitle:self.titleLoading];
//    self.hudView = [[SSHUDView alloc] initWithTitle:@"Loading..."];
//    [self.hudView show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
//    [self.hudView failAndDismissWithTitle:self.titleUnableFetchData];
    [self.hudView failAndDismissWithTitle:@"Error"];

    
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
    
    
    for (int i = 0; i < self.historyArray.count; i++) {
        for (int j = 0; j <[[self.statusOfOrdersDictionary allKeys] count]; j++) {
            if ([[[self.historyArray objectAtIndex:i] valueForKey:@"orderID"] isEqualToString:[[self.statusOfOrdersDictionary allKeys] objectAtIndex:j]]) {
                [[self.historyArray objectAtIndex:i] setValue:[self.statusOfOrdersDictionary valueForKey:[[self.statusOfOrdersDictionary allKeys] objectAtIndex:j]] forKey:@"statusID"];
                break;
            }
        }
    }
    
//    [self.hudView completeWithTitle:self.titleFinished];
    [self.hudView completeWithTitle:@"Finished"];
    [self.hudView dismiss];
    
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

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyArray count];
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
    
    
    cell.dateOfOrder.text = [[self.historyArray objectAtIndex:indexPath.row] valueForKey:@"date"];
    
    cell.numberOfOrder.text = [NSString stringWithFormat:@"%@%@", @"№ ", [[self.historyArray objectAtIndex:indexPath.row] valueForKey:@"orderID"]];
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
//        //Delete form DB
//        [self.content deleteAddressWithName:[[self.arrayOfAddresses objectAtIndex:indexPath.row] valueForKey:@"name"]];
//
//        [self.arrayOfAddresses removeObjectAtIndex:indexPath.row];
                
        [self.content deleteOrderWithId:[[self.historyArray objectAtIndex:indexPath.row] valueForKey:@"orderID"]];
        [self.historyArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"toHistoryPartDetail" sender:self];
    
    [self.content fetchStatusForOrder:@"3"];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    [segue.destinationViewController setHistoryDictionary:[self.historyArray objectAtIndex:self.selectedRow]];
    [segue.destinationViewController setProductsArray:[self.content fetchProductWithId:[[self.historyArray objectAtIndex:self.selectedRow] valueForKey:@"productsIDs"] withCounts:[[self.historyArray objectAtIndex:self.selectedRow] valueForKey:@"productsCounts"]]];
}

@end
