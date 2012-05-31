//
//  RestaurantViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 31.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantCell.h"

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController
@synthesize arrayData = _arrayData;
@synthesize db = _db;







- (NSMutableArray *)arrayData
{
    if(!_arrayData)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        RestaurantDataStruct *dataStruct;
        NSArray *data = [self.db fetchAllRestaurantsWithDefaultLanguageAndCity];
        for(int i=0;i<data.count;i++)
        {
            if(i%2==0) 
            {
                dataStruct = [[RestaurantDataStruct alloc] init];
                dataStruct.restaurantId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
                dataStruct.phones = [[data objectAtIndex:i] valueForKey:@"phones"];
//                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
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
                dataStruct.name = [[data objectAtIndex:i] valueForKey:@"name"];
                dataStruct.subwayStation = [[data objectAtIndex:i] valueForKey:@"Metro"];
                dataStruct.street = [[data objectAtIndex:i] valueForKey:@"Street"];
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
    
    cell.restaurantAdress.text = dataStruct.street;
    cell.restaurantSubway.text = dataStruct.subwayStation;
    
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
}

@end
