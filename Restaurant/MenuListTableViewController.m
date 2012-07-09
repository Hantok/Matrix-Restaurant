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
#import <QuartzCore/QuartzCore.h>

@interface MenuListTableViewController ()
{
    int countOfObjects;
}

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
    //for you baby! 
    
    if(!_arrayData)
    {
//        NSLog(@"<----------initiation");
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        ProductDataStruct *dataStruct;
//        NSArray *data = [self.db fetchAllProductsFromMenu:self.kindOfMenu.menuId];
//        for(int i=0;i<data.count;i++)
//        {
//            if(i%2==0) 
//            {
//                dataStruct = [[ProductDataStruct alloc] init];
//                dataStruct.productId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
//                dataStruct.price = [[data objectAtIndex:i] valueForKey:@"price"];
//                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
//                NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:dataStruct.idPicture];
//                NSURL *url = [self.db fetchImageURLbyPictureID:dataStruct.idPicture];
//                dataStruct.link = url.description;
//                if(dataOfPicture)
//                {
//                    dataStruct.image  = [UIImage imageWithData:dataOfPicture]; 
//                }
//            }
//            else
//            {
//                dataStruct.title = [[data objectAtIndex:i] valueForKey:@"nameText"];
//                dataStruct.descriptionText = [[data objectAtIndex:i] valueForKey:@"descriptionText"];
//                [array addObject:dataStruct];
//            }
//        }
//        _arrayData = array;
//        NSLog(@"<----------initiation is deactivated");
        
        NSLog(@"request is began");
        NSMutableArray *array = [[NSMutableArray alloc] init];
        ProductDataStruct *dataStruct;
        NSArray *data = [self.db fetchAllProductsFromMenu:self.kindOfMenu.menuId];
        NSLog(@"first query");
        NSDictionary *pictures = [self.db fetchImageURLAndDatabyMenuID:self.kindOfMenu.menuId];
        NSLog(@"first query end");
        for(int i=0;i<data.count;i++)
        {
            if(i%2==0) 
            {
                dataStruct = [[ProductDataStruct alloc] init];
                dataStruct.productId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
                dataStruct.price = [[data objectAtIndex:i] valueForKey:@"price"];
                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
                NSData *dataOfPicture = [[pictures objectForKey:dataStruct.idPicture] valueForKey:@"data"];
                NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test6/root/%@",[[pictures objectForKey:dataStruct.idPicture] valueForKey:@"link"]];
                urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [[NSURL alloc] initWithString:urlForImage];
                dataStruct.link = url.description;
                if(dataOfPicture)
                {
                    dataStruct.image  = [UIImage imageWithData:dataOfPicture]; 
                }
            }
            else
            {
                dataStruct.title = [[data objectAtIndex:i] valueForKey:@"nameText"];
                dataStruct.descriptionText = [[data objectAtIndex:i] valueForKey:@"descriptionText"];
                [array addObject:dataStruct];
            }
            
        }
        _arrayData = array;
        
        NSLog(@"end;;;;;");
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
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    self.navigationItem.title = self.kindOfMenu.title;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    countOfObjects = [self.db fetchCountOfProductsInEntity:@"Cart"];
    if (countOfObjects != 0)
    {
        UIButton *cartButton = [[UIButton alloc] init];
        cartButton.frame=CGRectMake(0,0,60,30);
        [cartButton setBackgroundImage:[UIImage imageNamed: @"white-cart_big.png"] forState:UIControlStateNormal];
        cartButton.layer.cornerRadius = 8.0f;
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,15,15)];
        countLabel.text = [NSString stringWithFormat:@"%i", countOfObjects];
        countLabel.textAlignment = UITextAlignmentCenter;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont boldSystemFontOfSize:10];
        countLabel.backgroundColor = [UIColor orangeColor];
        countLabel.layer.cornerRadius = 8;
        
        [cartButton addSubview:countLabel];
        
        [cartButton addTarget:self action:@selector(toCartMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cartButton];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) 
    {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        [segue.destinationViewController setProduct:[self.arrayData objectAtIndex:self.selectedRow.integerValue] isFromFavorites:NO];
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

- (void)toCartMenu:(id)sender 
{
    //обовязково анімація NO !!!
    [self.navigationController popViewControllerAnimated:NO];
}

@end
