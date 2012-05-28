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

- (void)startIconDownload:(ProductDataStruct *)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MenuListTableViewController
@synthesize tableView = _tableView;
@synthesize navigationBar = _navigationBar;
@synthesize kindOfMenu = _kindOfMenu;
@synthesize selectedRow = _selectedRow;
@synthesize arrayData = _arrayData;
@synthesize db = _db;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;



- (NSMutableArray *)arrayData
{
    NSLog(@"getter arrayData is activated");
    if(!_arrayData)
    {
        NSLog(@"initiation");
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
                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
                NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:dataStruct.idPicture];
                NSURL *url = [self.db fetchImageURLbyPictureID:dataStruct.idPicture];
                dataStruct.link = url.description;
                if(dataOfPicture)
                {
                    dataStruct.image  = [UIImage imageWithData:dataOfPicture]; 
                }
               // else 
                //{
                  //  NSLog(@"%@ download begin", url.description);
                    //dataOfPicture = [NSData dataWithContentsOfURL:url];
                    //[self.db SavePictureToCoreData:[[data objectAtIndex:i] valueForKey:@"idPicture"] toData:dataOfPicture];
                    //dataStruct.image  = [UIImage imageWithData:dataOfPicture];
                    //NSLog(@"end");
                //}
            }
            else
            {
                dataStruct.title = [[data objectAtIndex:i] valueForKey:@"nameText"];
                dataStruct.descriptionText = [[data objectAtIndex:i] valueForKey:@"descriptionText"];
                [array addObject:dataStruct];
            }
        }
        _arrayData = array;
        NSLog(@"getter arrayData is deactivated");
        return _arrayData;
    }
    NSLog(@"getter arrayData is deactivated");
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
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
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
    return NO;
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
    
    if (!dataStruct.image)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:dataStruct forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image  
        cell.productImage.image = [UIImage imageNamed:@"Placeholder.png"];
        
    }
    else
    {
        cell.productImage.image = dataStruct.image;
    }
    
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



#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(ProductDataStruct *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload]; 
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.arrayData count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ProductDataStruct *appRecord = [self.arrayData objectAtIndex:indexPath.row];
            
            if (!appRecord.image) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        ProductCell *cell = (ProductCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.productImage.image = iconDownloader.appRecord.image;
        [self.db SavePictureToCoreData:iconDownloader.appRecord.idPicture toData:UIImagePNGRepresentation(cell.productImage.image)];
        
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
