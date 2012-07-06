//
//  LanguageAndCityTableViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LanguageAndCityTableViewController.h"
#import "GettingCoreContent.h"
#import "checkConnection.h"

@interface LanguageAndCityTableViewController ()

@property BOOL isCity;
@property NSUInteger selectedIndex;
@property (strong,nonatomic) NSArray *destinationArray;
@property (strong, nonatomic) NSMutableData *responseData;
@property (nonatomic, strong) XMLParse *db;
@property BOOL isDid;
//@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation LanguageAndCityTableViewController

@synthesize isCity = _isCity;
@synthesize selectedIndex = _selectedIndex;
@synthesize destinationArray = _destinationArray;
@synthesize responseData = _responseData;
@synthesize db = _db;
@synthesize isDid = _isDid;
//@synthesize activityView = _activityView;

- (void)setArrayFromSegue:(BOOL)isCityEnter;
{
    GettingCoreContent *getCon = [[GettingCoreContent alloc] init];
    if (!isCityEnter) 
    {
        _destinationArray = [getCon fetchAllLanguages];
    }
    else 
    {
        _destinationArray = [getCon fetchAllCitiesByLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
        self.isCity = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isCity)
        self.navigationItem.title = @"City";
    else 
        self.navigationItem.title = @"Language";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return [[self destinationArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isCity)
    {
        cell.textLabel.text = [[[self destinationArray] objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        NSString *userCityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"];
        NSString *currCityId = [[[self destinationArray] objectAtIndex:indexPath.row] valueForKey:@"idCity"]; 
        if ([userCityId.description isEqual:currCityId.description])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedIndex = indexPath.row;
        }
    }
    else 
    {
        cell.textLabel.text = [[[self.destinationArray objectAtIndex:indexPath.row] valueForKey:@"language"] description];
        
        NSString *userLangId = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"];
        NSString *currLangId = [[[self destinationArray] objectAtIndex:indexPath.row] valueForKey:@"underbarid"];
        if ([userLangId.description isEqual:currLangId.description])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedIndex = indexPath.row;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (checkConnection.hasConnectivity)
    {
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame = self.view.frame;
        activityView.backgroundColor = [UIColor grayColor];
        activityView.center=self.view.center;
        [activityView startAnimating];
        [self.view addSubview:activityView];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *changeStringForUserDefaults;
        NSString *wasDownloaded;
        id data;
        if (self.isCity)
        {
            changeStringForUserDefaults = @"defaultCityId";
            data = [[self.destinationArray objectAtIndex:indexPath.row] valueForKey:@"idCity"];
            wasDownloaded = [NSString stringWithFormat:@"isCityHere%@", data];
        }
        else 
        {
            changeStringForUserDefaults = @"defaultLanguageId";
            data = [[self.destinationArray objectAtIndex:indexPath.row] valueForKey:@"underbarid"];
            wasDownloaded = [NSString stringWithFormat:@"isLanguageHere%@", data];
        }
        
        if (self.selectedIndex != NSNotFound)
        {
            UITableViewCell *cell = [tableView 
                                     cellForRowAtIndexPath:[NSIndexPath 
                                                            indexPathForRow:self.selectedIndex inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.selectedIndex = indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:changeStringForUserDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[self.navigationController popViewControllerAnimated:YES];
        
        GettingCoreContent *content = [[GettingCoreContent alloc] init];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:wasDownloaded] != nil)
        {
            // http request updatePHP with &tag=update
            GettingCoreContent *content = [[GettingCoreContent alloc] init];
            
            NSNumber *maxRestaurantId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Restaurants"];
            NSNumber *maxRestaurantVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Restaurants"];
            
            NSNumber *maxMenuId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Menus"];
            NSNumber *maxMenuVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Menus"];
            
            NSNumber *maxProductId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Products"];
            NSNumber *maxProductVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Products"];
            
            NSMutableString *myString = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test6/root/Customer_Scripts/update.php?DBid=11&tag=update"];
            
            [myString appendFormat:@"&city_id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"]];
            [myString appendFormat:@"&lang_id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
            
            [myString appendFormat:@"&rest_v=%@", maxRestaurantVersion];
            [myString appendFormat:@"&mrest_id=%@", maxRestaurantId];
            
            [myString appendFormat:@"&menu_v=%@", maxMenuVersion];
            [myString appendFormat:@"&mmenu_id=%@", maxMenuId];
            
            [myString appendFormat:@"&prod_v=%@", maxProductVersion];
            [myString appendFormat:@"&mprod_id=%@", maxProductId];
            
            NSURL *url = [NSURL URLWithString:myString.copy];
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
//            NSArray *arrayOfCartsIds = [content fetchAllIdsFromEntity:@"Cart"];
//            NSArray *arrayOfFavoritesIds = [content fetchAllIdsFromEntity:@"Favorites"];
            
        }
        else 
        {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:wasDownloaded];
            // http request updatePHP with &tag=rmp
            NSMutableString *urlString = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test6/root/Customer_Scripts/update.php?DBid=11&tag=rmp"];
            [urlString appendFormat:@"&idLang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
            [urlString appendFormat:@"&idCity=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"]];
            NSURL *url = [NSURL URLWithString:urlString.copy];
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
            //видалаляємо вміст корзини i favorites, якщо змінюємо city
            if (self.isCity)
            {
                //GettingCoreContent *content = [[GettingCoreContent alloc] init];
                [content deleteAllObjectsFromEntity:@"Cart"];
                [content deleteAllObjectsFromEntity:@"Favorites"];
            }

        }
    }
    else 
    {
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You do not have internet connecntion to update data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma connection with server

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    //NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSASCIIStringEncoding];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Unable to fetch data");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData
                                                   length]);
    NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSASCIIStringEncoding];
    NSLog(@"strinng is - %@",txt);
    
    // создаем парсер
    XMLParse* parser = [[XMLParse alloc] initWithData:self.responseData];
    [parser setDelegate:parser];
    [parser parse];
    self.db = parser;
    [self XMLToCoreData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma finish pragma connention with server

- (void)XMLToCoreData
{
    NSArray *allKeys = [self.db.tables allKeys];
    GettingCoreContent *content = [[GettingCoreContent alloc] init];
    for(int i = 0; i< allKeys.count; i++)
    {
        id key = [allKeys objectAtIndex:i];
        id object = [self.db.tables objectForKey:key];
        if(object)
            [content setCoreDataForEntityWithName:key dictionaryOfAtributes:object];
    }
}
@end
