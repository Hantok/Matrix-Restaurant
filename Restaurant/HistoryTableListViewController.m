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

@interface HistoryTableListViewController ()

@end

@implementation HistoryTableListViewController
@synthesize tableView = _tableView;
@synthesize historyArray = _historyArray;
@synthesize selectedRow = _selectedRow;

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
//    [self.tableView setBackgroundColor:[UIColor darkGrayColor]];
    
    self.historyArray = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//    return 0;
    return [self.historyArray count];
//    return 2;
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
    
    cell.dateOfOrder.text = [self.historyArray objectAtIndex:indexPath.row];
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    [segue.destinationViewController setTempStr:[self.historyArray objectAtIndex:self.selectedRow]];
}

@end
