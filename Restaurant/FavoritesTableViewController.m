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
#import <QuartzCore/QuartzCore.h>

@interface FavoritesTableViewController ()

@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) NSNumber *selectedRow;
@property (strong, nonatomic) NSMutableArray *arrayOfObjects;

@property (nonatomic, strong) UIImageView *hitView;
@property (nonatomic, strong) UIImageView *newsItemView;

@end

@implementation FavoritesTableViewController

@synthesize db = _db;
@synthesize selectedRow = _selectedRow;
@synthesize arrayOfObjects = _arrayOfObjects;
@synthesize hitView;
@synthesize newsItemView;

-(NSMutableArray *)arrayOfObjects
{
    if (!_arrayOfObjects)
    {
        NSArray *array = [self.db fetchFavoritesFromEntityName:@"Products"];
        if (array.count != 0)
        {
            NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Products_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
            _arrayOfObjects = [[NSMutableArray alloc] init];
            for (int i = 0; i < array.count; i++)
            {
                ProductDataStruct *productStruct = [[ProductDataStruct alloc] init];
                //[productStruct setProductId:[[arrayOfElements objectAtIndex:i] valueForKey:@"idProduct"]];
                [productStruct setProductId:[[array objectAtIndex:i] valueForKey:@"underbarid"]];
                [productStruct setDescriptionText:[[arrayOfElements objectAtIndex:i] valueForKey:@"descriptionText"]];
                [productStruct setTitle:[[arrayOfElements objectAtIndex:i] valueForKey:@"nameText"]];
                [productStruct setPrice:[[array objectAtIndex:i] valueForKey:@"price"]];
                [productStruct setDiscountValue:[[array objectAtIndex:i] valueForKey:@"idDiscount"]];
                [productStruct setIsFavorites:[[array objectAtIndex:i] valueForKey:@"isFavorites"]];
                [productStruct setIdPicture:[[array objectAtIndex:i] valueForKey:@"idPicture"]];
                [productStruct setWeight:[[array objectAtIndex:i] valueForKey:@"weight"]];
                [productStruct setProtein:[[array objectAtIndex:i] valueForKey:@"protein"]];
                [productStruct setCarbs:[[array objectAtIndex:i] valueForKey:@"carbs"]];
                [productStruct setFats:[[array objectAtIndex:i] valueForKey:@"fats"]];
                [productStruct setCalories:[[array objectAtIndex:i] valueForKey:@"calories"]];
                [productStruct setHit:[[array objectAtIndex:i] valueForKey:@"hit"]];
                [productStruct setIdMenu:[[array objectAtIndex:i] valueForKey:@"idMenu"]];
                
                [_arrayOfObjects addObject:productStruct];
            }
        }
        else
        {
            return _arrayOfObjects;
        }
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
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    hitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HIT1.png"]];
    newsItemView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New1.png"]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //fetching pictures
    ProductDataStruct *dataStruct;
    for (int i = 0; i < self.arrayOfObjects.count; i++)
    {
        dataStruct = [self.arrayOfObjects objectAtIndex:i];
        NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:[[self.arrayOfObjects objectAtIndex:i] idPicture]];
//        NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test7/root/%@",[[pictures objectForKey:dataStruct.idPicture] valueForKey:@"link"]];
//        urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:urlForImage];
//        dataStruct.link = url.description;
        
        //saving results of secon request
//        [[self.arrayData objectAtIndex:i] setLink:url.description];
        if(dataOfPicture)
        {
            [[self.arrayOfObjects objectAtIndex:i] setImage:[UIImage imageWithData:dataOfPicture]];
        }
        else
        {
            NSString *urlString = [self.db fetchImageStringURLbyPictureID:[[self.arrayOfObjects objectAtIndex:i] idPicture]];
            [[self.arrayOfObjects objectAtIndex:i] setLink:urlString];
        }
    }
    
    [self.tableView reloadData];
    
}

- (void) viewWillDisappear:(BOOL)animated
{    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];

    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setHitView:nil];
    [self setNewsItemView:nil];
    [self setDb:nil];
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
    
    if (!productStruct.image)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO && productStruct.link)
        {
            [self startIconDownload:productStruct forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.productImage.image = [UIImage imageNamed:@"Placeholder.png"];
        
    }
    else
    {
        cell.productImage.image = productStruct.image;
        if (productStruct.hit.integerValue == 1)
        {
            [cell.productImage.layer addSublayer:[hitView layer]];
        }
        else
            if (productStruct.hit.integerValue == 2)
                [cell.productImage.layer addSublayer:[newsItemView layer]];
    }
    
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
//        [self.db deleteObjectFromEntity:@"Favorites" withProductId:[[self.arrayOfObjects objectAtIndex:indexPath.row] productId]];
//        [self.arrayOfObjects removeObjectAtIndex:indexPath.row];
        id currentOne = [self.arrayOfObjects objectAtIndex:indexPath.row];
        //changing is database
        [self.db changeFavoritesBoolValue:NO forId:[currentOne productId]];
        //changing in Array
        [self.arrayOfObjects removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }  
}

//змінюємо висоту cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98.0;
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
    if ([self.arrayOfObjects count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ProductDataStruct *appRecord = [self.arrayOfObjects objectAtIndex:indexPath.row];
            
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
