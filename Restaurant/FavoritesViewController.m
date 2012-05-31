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

@end

@implementation FavoritesViewController
@synthesize tableView;
@synthesize toolbar;
@synthesize db = _db;
@synthesize selectedRow = _selectedRow;

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//	// Do any additional setup after loading the view.
//}

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
    [self setToolbar:nil];
    [self setTableView:nil];
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
                break;
            }
        }
    }
    
    NSArray *array = [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Favorites"];
    NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Descriptions_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
    
    //треба дописати загрузку картинок=)
    
    cell.productDescription.text = [[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"descriptionText"];
    cell.productTitle.text = [NSString stringWithFormat:@"%@",[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"nameText"]];
    cell.productPrice.text = [NSString stringWithFormat:@"%@ грн.", [[array objectAtIndex:indexPath.row] valueForKey:@"cost"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //треба дописати перехід на ProductDetailViewController або зробити на нього копію, бо дані відрізняються при пересиланні
    
    //self.selectedRow = [[NSNumber alloc] initWithInt:indexPath.row];
    //[self performSegueWithIdentifier:@"toProductDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@",[self.Products objectAtIndex:self.selectedRow.integerValue]);
    //[segue.destinationViewController setProduct:[self.arrayData objectAtIndex:self.selectedRow.integerValue]];
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
