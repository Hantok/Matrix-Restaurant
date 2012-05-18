//
//  MenuListTableViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuListTableViewController.h"
#import "XMLParse.h"
#import "ProductDetailViewController.h"
#import "ProductCell.h"

@interface MenuListTableViewController ()



@end

@implementation MenuListTableViewController
@synthesize tableView = _tableView;
@synthesize Products = _Products;
@synthesize navigationBar = _navigationBar;
@synthesize kindOfMenu = _kindOfMenu;
@synthesize selectedRow = _selectedRow;



- (void)setKindOfMenu:(NSString *)kindOfMenu
{
    _kindOfMenu = kindOfMenu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.kindOfMenu;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Hello from User Defaults! %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"city"]);
    return self.Products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellWithViewForProduct";
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"productCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[ProductCell class]])
            {
                cell = (ProductCell *)currentObject;
                break;
            }
        }
    }
    
    cell.productPrice.text = [NSString stringWithFormat:@"%@ uah", [[self.Products objectAtIndex:indexPath.row] objectForKey:@"cost"]];
    cell.productDescription.text = [NSString stringWithFormat:@"%@", [[self.Products objectAtIndex:indexPath.row] objectForKey:@"description"]];
    cell.productTitle.text = [NSString stringWithFormat:@"%@", [[self.Products objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = [[NSNumber alloc] initWithInt:indexPath.row];
    [self performSegueWithIdentifier:@"toProductDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@",[self.Products objectAtIndex:self.selectedRow.integerValue]);
    [segue.destinationViewController setProduct:[self.Products objectAtIndex:self.selectedRow.integerValue]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
