//
//  FavoritesViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ProductDetailViewController.h"
#import "GettingCoreContent.h"
#import "ProductCell.h"

@interface FavoritesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) NSNumber *selectedRow;
@property (strong, nonatomic) NSMutableArray *arrayOfObjects;
@property (strong, nonatomic) ProductDataStruct *product;

@end

@implementation FavoritesViewController
@synthesize tableView;
@synthesize navigationbar;
@synthesize db = _db;
@synthesize selectedRow = _selectedRow;
@synthesize arrayOfObjects = _arrayOfObjects;
@synthesize product = _product;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfObjects = [[NSMutableArray alloc] init];
}

- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setNavigationbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma customize tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Favorites"].count;
    //return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellWithViewForProduct";
    ProductCell *cell = (ProductCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"productCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[ProductCell class]])
            {
                cell = (ProductCell *)currentObject;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
            }
        }
    }
    
    NSArray *array = [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Favorites"];
    NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Descriptions_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
    
    self.product = [[ProductDataStruct alloc] init];
    
    [self.product setProductId:[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"idProduct"]];
    
    cell.productDescription.text = [[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"descriptionText"];
    [self.product setDescriptionText:cell.productDescription.text];
    
    cell.productTitle.text = [NSString stringWithFormat:@"%@",[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"nameText"]];
    [self.product setTitle:[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"nameText"]];
    
    cell.productPrice.text = [NSString stringWithFormat:@"%@ грн.", [[array objectAtIndex:indexPath.row] valueForKey:@"cost"]];
    [self.product setPrice:[[array objectAtIndex:indexPath.row] valueForKey:@"cost"]];
    
    cell.productImage.image = [UIImage imageWithData:[[array objectAtIndex:indexPath.row] valueForKey:@"picture"]];
    [self.product setImage:cell.productImage.image];
    
    
    [self.arrayOfObjects addObject:self.product];
    
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
    [[segue destinationViewController] setProduct:[self.arrayOfObjects objectAtIndex:self.selectedRow.integerValue] isFromFavorites:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [self.db deleteObjectFromEntity:@"Favorites" atIndexPath:indexPath];
        [self.tableView reloadData];
    }  
}

- (IBAction)bachButton:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
