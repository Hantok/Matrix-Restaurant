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
#import "ProductDataStruct.h"

@interface MenuListTableViewController ()



@end

@implementation MenuListTableViewController
@synthesize tableView = _tableView;
@synthesize navigationBar = _navigationBar;
@synthesize kindOfMenu = _kindOfMenu;
@synthesize selectedRow = _selectedRow;
@synthesize arrayData = _arrayData;
@synthesize db = _db;



- (NSMutableArray *)arrayData
{
    if(!_arrayData)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        ProductDataStruct *dataStruct;
        NSArray *data = [self.db fetchAllProductsFromMenu:self.kindOfMenu.menuId];
        for(int i=0;i<data.count;i++)
        {
            if(i%2==0) 
            {
                dataStruct = [[ProductDataStruct alloc] init];
                dataStruct.productId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
                dataStruct.price = [[data objectAtIndex:i] valueForKey:@"price"];
                NSURL *url = [self.db fetchImageURLbyPictureID:[[data objectAtIndex:i] valueForKey:@"idPicture"]];
                dataStruct.image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            }
            else
            {
                dataStruct.title = [[data objectAtIndex:i] valueForKey:@"nameText"];
                dataStruct.descriptionText = [[data objectAtIndex:i] valueForKey:@"descriptionText"];
                [array addObject:dataStruct];
            }
        }
        _arrayData = array;
        return _arrayData;
    }
    return _arrayData;
}

- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
}

- (void)setKindOfMenu:(MenuDataStruct *)kindOfMenu
{
    _kindOfMenu = kindOfMenu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.kindOfMenu.title;
    
    
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
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellWithViewForProduct";
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ProductDataStruct *dataStruct = [self.arrayData objectAtIndex:indexPath.row];
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
    
    cell.productPrice.text = [NSString stringWithFormat:@"%@ uah", dataStruct.price];
    cell.productDescription.text = [NSString stringWithFormat:@"%@", dataStruct.descriptionText];
    cell.productTitle.text = [NSString stringWithFormat:@"%@", dataStruct.title];
    cell.productImage.image = dataStruct.image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = [[NSNumber alloc] initWithInt:indexPath.row];
    [self performSegueWithIdentifier:@"toProductDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@",[self.Products objectAtIndex:self.selectedRow.integerValue]);
    [segue.destinationViewController setProduct:[self.arrayData objectAtIndex:self.selectedRow.integerValue]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
