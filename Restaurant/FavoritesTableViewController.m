//
//  FavoritesTableViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "ProductDetailViewController.h"
#import "GettingCoreContent.h"
#import "ProductCell.h"

@interface FavoritesTableViewController ()

@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) NSNumber *selectedRow;
@property (strong, nonatomic) NSMutableArray *arrayOfObjects;

@end

@implementation FavoritesTableViewController

@synthesize db = _db;
@synthesize selectedRow = _selectedRow;
@synthesize arrayOfObjects = _arrayOfObjects;


-(NSMutableArray *)arrayOfObjects
{
    if (!_arrayOfObjects)
    {
        NSArray *array = [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Favorites"];
        NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Products_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
        _arrayOfObjects = [[NSMutableArray alloc] init];
        for (int i = 0; i <array.count; i++)
        {
            ProductDataStruct *productStruct = [[ProductDataStruct alloc] init];
            //[productStruct setProductId:[[arrayOfElements objectAtIndex:i] valueForKey:@"idProduct"]];
            [productStruct setProductId:[[array objectAtIndex:i] valueForKey:@"underbarid"]];
            [productStruct setDescriptionText:[[arrayOfElements objectAtIndex:i] valueForKey:@"descriptionText"]];
            [productStruct setTitle:[[arrayOfElements objectAtIndex:i] valueForKey:@"nameText"]];
            [productStruct setPrice:[[array objectAtIndex:i] valueForKey:@"cost"]];
            [productStruct setImage:[UIImage imageWithData:[[array objectAtIndex:i] valueForKey:@"picture"]]];
            [productStruct setDiscountValue:[[array objectAtIndex:i] valueForKey:@"discountValue"]];
            
            [_arrayOfObjects addObject:productStruct];     
        }
        
        //сортуємо по id продукта
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productId" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray;
        sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
        _arrayOfObjects = [[NSMutableArray alloc] initWithArray:sortedArray];
        return _arrayOfObjects;
    }
    return _arrayOfObjects;
}

- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayOfObjects.count;
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
    
    ProductDataStruct *productStruct = [self.arrayOfObjects objectAtIndex:indexPath.row];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:(productStruct.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]];
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", price, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    
    cell.productPrice.text = priceString;
    cell.productDescription.text = [NSString stringWithFormat:@"%@", productStruct.descriptionText];
    cell.productTitle.text = [NSString stringWithFormat:@"%@", productStruct.title];
    cell.productImage.image = productStruct.image;
    
//    NSArray *array = [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Favorites"];
//    NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Descriptions_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
//    
//    self.product = [[ProductDataStruct alloc] init];
//    
//    [self.product setProductId:[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"idProduct"]];
//    
//    cell.productDescription.text = [[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"descriptionText"];
//    [self.product setDescriptionText:cell.productDescription.text];
//    
//    cell.productTitle.text = [NSString stringWithFormat:@"%@",[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"nameText"]];
//    [self.product setTitle:[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"nameText"]];
//    
//    cell.productPrice.text = [NSString stringWithFormat:@"%@ грн.", [[array objectAtIndex:indexPath.row] valueForKey:@"cost"]];
//    [self.product setPrice:[[array objectAtIndex:indexPath.row] valueForKey:@"cost"]];
//    
//    cell.productImage.image = [UIImage imageWithData:[[array objectAtIndex:indexPath.row] valueForKey:@"picture"]];
//    [self.product setImage:cell.productImage.image];
//    
//    
//    [self.arrayOfObjects addObject:self.product];
    
    return cell;
}

#pragma mark - Table view delegate

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
        [self.db deleteObjectFromEntity:@"Favorites" withProductId:[[self.arrayOfObjects objectAtIndex:indexPath.row] productId]];
        [self.arrayOfObjects removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }  
}

//змінюємо висоту cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98.0;
}


@end
