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

@property (nonatomic, strong) UIImageView *hitView;
@property (nonatomic, strong) UIImageView *newsItemView;
@property (nonatomic) bool didLoad;

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
@synthesize hitView;
@synthesize newsItemView;
@synthesize didLoad = _didLoad;


- (void) imageAnimation: (ProductCell *) cell
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [cell.productImage setAlpha:1];
    [UIView commitAnimations];
}
- (NSMutableArray *)arrayData
{
    
    if(!_arrayData)
    {
        
        NSLog(@"request is began");
        NSMutableArray *array = [[NSMutableArray alloc] init];
        ProductDataStruct *dataStruct;
        NSLog(@"first query begin");
        NSArray *data = [self.db fetchAllProductsFromMenu:self.kindOfMenu.menuId];
//        NSLog(@"first query end. Second query begin");
//        NSDictionary *pictures = [self.db fetchImageURLAndDatabyMenuID:self.kindOfMenu.menuId];
//        sNSLog(@"Second query end. For begin");
        for(int i=0;i<data.count;i++)
        {
            if(i%2==0)
            {
                dataStruct = [[ProductDataStruct alloc] init];
                dataStruct.productId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
                dataStruct.price = [[data objectAtIndex:i] valueForKey:@"price"];
                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
                dataStruct.discountValue = [[data objectAtIndex:i] valueForKey:@"idDiscount"]; //here is not value, underbarid of table discounts;
                dataStruct.isFavorites = [[data objectAtIndex:i] valueForKey:@"isFavorites"];
                [dataStruct setWeight:[[data objectAtIndex:i] valueForKey:@"weight"]];
                [dataStruct setProtein:[[data objectAtIndex:i] valueForKey:@"protein"]];
                [dataStruct setCarbs:[[data objectAtIndex:i] valueForKey:@"carbs"]];
                [dataStruct setFats:[[data objectAtIndex:i] valueForKey:@"fats"]];
                [dataStruct setCalories:[[data objectAtIndex:i] valueForKey:@"calories"]];
                [dataStruct setHit:[[data objectAtIndex:i] valueForKey:@"hit"]];
                [dataStruct setIdMenu:[[data objectAtIndex:i] valueForKey:@"idMenu"]];
                //                NSData *dataOfPicture = [[pictures objectForKey:dataStruct.idPicture] valueForKey:@"data"];
                //                NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test7/root/%@",[[pictures objectForKey:dataStruct.idPicture] valueForKey:@"link"]];
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
                dataStruct.title = [[data objectAtIndex:i] valueForKey:@"nameText"];
                dataStruct.descriptionText = [[data objectAtIndex:i] valueForKey:@"descriptionText"];
                [array addObject:dataStruct];
            }
            
        }
        //сортуємо по id продукта
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productId" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray;
        sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
        _arrayData = [[NSMutableArray alloc] initWithArray:sortedArray];
        
        NSLog(@"end;;;;;");
        return _arrayData;
    }
    return _arrayData;
//    //old one
//        NSLog(@"request is began");
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        ProductDataStruct *dataStruct;
//        NSArray *data = [self.db fetchAllProductsFromMenu:self.kindOfMenu.menuId];
//        NSLog(@"first query");
//        NSDictionary *pictures = [self.db fetchImageURLAndDatabyMenuID:self.kindOfMenu.menuId];
//        NSLog(@"first query end");
//        for(int i=0;i<data.count;i++)
//        {
//            if(i%2==0) 
//            {
//                dataStruct = [[ProductDataStruct alloc] init];
//                dataStruct.productId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
//                dataStruct.price = [[data objectAtIndex:i] valueForKey:@"price"];
//                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
//                dataStruct.discountValue = [[data objectAtIndex:i] valueForKey:@"idDiscount"]; //here is not value, underbarid of table discounts
//                NSData *dataOfPicture = [[pictures objectForKey:dataStruct.idPicture] valueForKey:@"data"];
//                NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test7/root/%@",[[pictures objectForKey:dataStruct.idPicture] valueForKey:@"link"]];
//                urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSURL *url = [[NSURL alloc] initWithString:urlForImage];
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
//            
//        }
//        
//        //сортуємо по id продукта
//        NSSortDescriptor *sortDescriptor;
//        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productId" ascending:YES];
//        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//        NSArray *sortedArray;
//        sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
//        _arrayData = [[NSMutableArray alloc] initWithArray:sortedArray];
//        
//        NSLog(@"end;;;;;");
//        return _arrayData;
//    }
//    return _arrayData;
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
    
    hitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HIT1.png"]];
    newsItemView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New1.png"]];
    self.didLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //fetching pictures
    NSDictionary *pictures = [self.db fetchImageURLAndDatabyMenuID:self.kindOfMenu.menuId];
    ProductDataStruct *dataStruct;
    for (int i = 0; i < self.arrayData.count; i++)
    {
        dataStruct = [self.arrayData objectAtIndex:i];
        NSData *dataOfPicture = [[pictures objectForKey:dataStruct.idPicture] valueForKey:@"data"];
        NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test7/root/%@",[[pictures objectForKey:dataStruct.idPicture] valueForKey:@"link"]];
        urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlForImage];
        //        dataStruct.link = url.description;
        
        //saving results of secon request
        [[self.arrayData objectAtIndex:i] setLink:url.description];
        if(dataOfPicture)
        {
            [[self.arrayData objectAtIndex:i] setImage:[UIImage imageWithData:dataOfPicture]];
        }
    }
    
    [self.tableView reloadData];
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
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) 
//    {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    self.didLoad = NO;
//    }
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

    [self setKindOfMenu:nil];
    [self setDb:nil];
    [self setHitView:nil];
    [self setNewsItemView:nil];
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
//    if(!cell)
//    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"productCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[ProductCell class]])
            {
                cell = (ProductCell *)currentObject;
                break;
            }
        }
//    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:(dataStruct.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]];
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", price, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    
    cell.productPrice.text = priceString;
    cell.productDescription.text = [NSString stringWithFormat:@"%@", dataStruct.descriptionText];
    cell.productTitle.text = [NSString stringWithFormat:@"%@", dataStruct.title];
    
    if (dataStruct.hit.integerValue == 1)
    {
        //            [cell.productImage addSubview:hitView];
        [cell.productImage.layer addSublayer:[hitView layer]];
    }
    else
        if (dataStruct.hit.integerValue == 2)
            [cell.productImage.layer addSublayer:[newsItemView layer]];
    
    if (!dataStruct.image)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO && dataStruct.link)
        {
            [self startIconDownload:dataStruct forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image  
        //cell.productImage.image = [UIImage imageNamed:@"Placeholder.png"];
        
        // if a download is deferred or in progress, return a loading screen
        cell.productImage.alpha = 0;
        [cell.productImageLoadingIndocator startAnimating];
        
    }
    else
    {
        if (self.didLoad)
        {
            cell.productImage.alpha = 0;
        }
        [cell.productImageLoadingIndocator stopAnimating];
        cell.productImage.image = dataStruct.image;
        [self imageAnimation: cell];
//        else
//        {
//            [hitView removeFromSuperview];
//        }
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
        [cell.productImageLoadingIndocator stopAnimating];
        cell.productImage.image = iconDownloader.appRecord.image;
        [self imageAnimation: cell];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.didLoad = NO;
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
