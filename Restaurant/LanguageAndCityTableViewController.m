//
//  LanguageAndCityTableViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LanguageAndCityTableViewController.h"
#import "GettingCoreContent.h"

@interface LanguageAndCityTableViewController ()

@property BOOL isCity;
@property NSUInteger selectedIndex;
@property (strong,nonatomic) NSArray *destinationArray;
//@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation LanguageAndCityTableViewController

@synthesize isCity = _isCity;
@synthesize selectedIndex = _selectedIndex;
@synthesize destinationArray = _destinationArray;

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
        NSString *currCityId = [[[self destinationArray] objectAtIndex:indexPath.row] valueForKey:@"underbarid"]; 
        if ([userCityId isEqual:currCityId])
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
        if ([userLangId isEqual:currLangId])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedIndex = indexPath.row;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *changeStringForUserDefaults;
    if (self.isCity)
    {
        changeStringForUserDefaults = @"defaultCityId";
    }
    else 
    {
        changeStringForUserDefaults = @"defaultLanguageId";
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
    id data = [[self.destinationArray objectAtIndex:indexPath.row] valueForKey:@"underbarid"];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:changeStringForUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
