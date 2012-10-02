//
//  RestaurantViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 31.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController
@synthesize arrayData = _arrayData;
@synthesize db = _db;
@synthesize selectedRow = _selectedRow;







- (NSMutableArray *)arrayData
{
    if(!_arrayData)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        RestaurantDataStruct *dataStruct;
        NSArray *data = [self.db fetchAllRestaurantsWithDefaultLanguageAndCity];
        id restaurant;
        for(int i=0;i<data.count;i++)
        {
            if(i%2==0) 
            {
                restaurant = [data objectAtIndex:i];
                dataStruct = [[RestaurantDataStruct alloc] init];
                dataStruct.restaurantId = [restaurant valueForKey:@"underbarid"];
                dataStruct.phones = [restaurant valueForKey:@"phones"];
                dataStruct.idPicture = [restaurant valueForKey:@"idPicture"];
                NSArray *coordinates = [[restaurant valueForKey:@"coordinates"] componentsSeparatedByString:@";"];
                dataStruct.latitude = [coordinates objectAtIndex:0];
                dataStruct.longitude = [coordinates objectAtIndex:1];
                
//                NSData *dataOfPicture = [[pictures objectForKey:dataStruct.idPicture] valueForKey:@"data"];
//                NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test4/root/%@",[[pictures objectForKey:dataStruct.idPicture] valueForKey:@"link"]];
//                urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSURL *url = [[NSURL alloc] initWithString:urlForImage];
//                dataStruct.link = url.description;
//                if(dataOfPicture)
//                {
//                    dataStruct.image  = [UIImage imageWithData:dataOfPicture]; 
//                }
            }
            else
            {
                restaurant = [data objectAtIndex:i];
                dataStruct.name = [restaurant valueForKey:@"name"];
                dataStruct.subwayStation = [restaurant valueForKey:@"Metro"];
                dataStruct.street = [restaurant valueForKey:@"Street"];
                dataStruct.workingTime = [restaurant valueForKey:@"workingTime"];
                dataStruct.additionalContactInfo = [restaurant valueForKey:@"AdditionalContactInfo"];
                dataStruct.build = [restaurant valueForKey:@"House"];
                dataStruct.additionalAddressInfo = [restaurant valueForKey:@"AdditionalAddressInfo"];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"RestaurantCell";
    RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    RestaurantDataStruct *dataStruct = [self.arrayData objectAtIndex:indexPath.row];
    if(!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RestaurantCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[RestaurantCell class]])
            {
                cell = (RestaurantCell *)currentObject;
                break;
            }
        }
    }
    cell.restaurantName.text = dataStruct.name;
    cell.restaurantSubway.text = dataStruct.subwayStation;
    cell.restaurantPhones.text = dataStruct.phones;
    cell.restaurantPlace.text = [NSString stringWithFormat:@"%@, %@", dataStruct.street, dataStruct.build];
    NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:dataStruct.idPicture];
    cell.restaurantImage.image = [UIImage imageWithData:dataOfPicture];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.bounds;
    gradient.cornerRadius = 8.0f;
    [gradient setBorderWidth:0.5f];
    [gradient setBorderColor:[[UIColor darkGrayColor] CGColor]];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [cell.layer insertSublayer:gradient atIndex:0];
    
//    if (!dataStruct.image)
//    {
//        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
//        {
//            [self startIconDownload:dataStruct forIndexPath:indexPath];
//        }
//        // if a download is deferred or in progress, return a placeholder image  
//        cell.productImage.image = [UIImage imageNamed:@"Placeholder.png"];
//        
//    }
//    else
//    {
//        cell.productImage.image = dataStruct.image;
//    }
    
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"toRestaurantDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setDataStruct:[self.arrayData objectAtIndex:self.selectedRow]];
}

@end
