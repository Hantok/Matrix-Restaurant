//
//  AddressListTableViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressListTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AddressCell.h"

@interface AddressListTableViewController ()

@end

@implementation AddressListTableViewController

@synthesize delegate = _delegate;
@synthesize arrayOfAddresses = _arrayOfAddresses;
@synthesize content = _content;


- (GettingCoreContent *)content
{
    if(!_content)
    {
        _content = [[GettingCoreContent alloc] init];
    }
    return  _content;
}

- (IBAction)cancelButton:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSMutableArray *)arrayOfAddresses
{
    if (!_arrayOfAddresses)
    {
        _arrayOfAddresses = [self.content getArrayFromCoreDatainEntetyName:@"Addresses" withSortDescriptor:@"name"].mutableCopy;
        return _arrayOfAddresses;
    }
    
    return _arrayOfAddresses;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayOfAddresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[AddressCell class]])
            {
                cell = (AddressCell *)currentObject;
                break;
            }
        }
    }
    
    cell.addressLabel.textColor = [UIColor yellowColor];
    cell.addressLabel.text = [[self.arrayOfAddresses objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        //Delete form DB
        [self.content deleteAddressWithName:[[self.arrayOfAddresses objectAtIndex:indexPath.row] valueForKey:@"name"]];
        
        [self.arrayOfAddresses removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
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
    [self.delegate setAddressDictionary:[self.arrayOfAddresses objectAtIndex:indexPath.row]];
    [self dismissModalViewControllerAnimated:YES];   
}

@end
