//
//  FavoritesIconViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesIconViewController.h"

@interface FavoritesIconViewController ()
{
    BOOL pageControlBeingUsed;
}

@property (strong, nonatomic) UIAlertView *alert;
@property (nonatomic, strong) UIImageView *hitView;
@property (nonatomic, strong) UIImageView *newsItemView;

@end

@implementation FavoritesIconViewController
@synthesize viewForOutput;
@synthesize pageControl;

@synthesize gmGridView = _gmGridView;
@synthesize arrayOfObjects = _arrayOfObjects;
@synthesize db = _db;
@synthesize selectedIndex = _selectedIndex;
@synthesize stopEditButton = _stopEditButton;
@synthesize alert;
@synthesize hitView;
@synthesize newsItemView;



- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
}

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
        
//        NSArray *array = [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Favorites"];
//        NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Products_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
//        _arrayOfObjects = [[NSMutableArray alloc] init];
//        for (int i = 0; i <array.count; i++)
//        {
//            ProductDataStruct *productStruct = [[ProductDataStruct alloc] init];
//            //[productStruct setProductId:[[arrayOfElements objectAtIndex:i] valueForKey:@"idProduct"]];
//            [productStruct setProductId:[[array objectAtIndex:i] valueForKey:@"underbarid"]];
//            [productStruct setDescriptionText:[[arrayOfElements objectAtIndex:i] valueForKey:@"descriptionText"]];
//            [productStruct setTitle:[[arrayOfElements objectAtIndex:i] valueForKey:@"nameText"]];
//            [productStruct setPrice:[[array objectAtIndex:i] valueForKey:@"cost"]];
//            [productStruct setImage:[UIImage imageWithData:[[array objectAtIndex:i] valueForKey:@"picture"]]];
//            [productStruct setDiscountValue:[[array objectAtIndex:i] valueForKey:@"discountValue"]];
//            
//            [_arrayOfObjects addObject:productStruct];     
//        }
//
//        //сортуємо по id продукта
//        NSSortDescriptor *sortDescriptor;
//        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productId" ascending:YES];
//        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//        NSArray *sortedArray;
//        sortedArray = [_arrayOfObjects sortedArrayUsingDescriptors:sortDescriptors];
//        _arrayOfObjects = [[NSMutableArray alloc] initWithArray:sortedArray];
//        return _arrayOfObjects;
//    }
//    return _arrayOfObjects;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.viewForOutput.bounds];
    //gmGridView.frame.origin.x = -30;
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.viewForOutput addSubview:gmGridView];
    self.gmGridView = gmGridView;
    
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.arrayData.count/9, 370);
    self.gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gmGridView.backgroundColor = [UIColor clearColor];
    
    self.gmGridView.style = GMGridViewStyleSwap;
    
    int spacing = 10;
    self.gmGridView.itemSpacing = spacing;
    self.gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    //self.gmGridView.centerGrid = YES;
    self.gmGridView.actionDelegate = self;
//    self.gmGridView.sortingDelegate = self;
    self.gmGridView.transformDelegate = self;
    self.gmGridView.dataSource = self;
    self.gmGridView.delegate = self;
    //задаємо тип скроллінга
    self.gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    self.gmGridView.showsHorizontalScrollIndicator = NO;
    
    self.gmGridView.enableEditOnLongPress = YES;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = (int) self.arrayOfObjects.count/9;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.viewForOutput.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.viewForOutput.layer insertSublayer:gradient atIndex:0];
    
    self.stopEditButton.hidden = YES;
    
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
    }
    
    [self.gmGridView reloadData];
    
}

- (void)viewDidUnload
{
    [self setViewForOutput:nil];
    [self setPageControl:nil];
    
    [self setDb:nil];
    [self setGmGridView:nil];
    
    [self setStopEditButton:nil];
    [self setAlert:nil];
    
    [self setHitView:nil];
    [self setNewsItemView:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//////////////////////////////////////////////////////////////
#pragma mark UIScrollViewDeledate
//////////////////////////////////////////////////////////////

- (void)scrollViewDidScroll:(GMGridView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.gmGridView.frame.size.width;
		int page = floor((self.gmGridView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
        //[self activePageWithId:[NSNumber numberWithInt:page]];
        //[self loadImagesForOnscreenRows];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
    //[self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
    //[self loadImagesForOnscreenRows];
}



- (IBAction)changePage:(id)sender {
    // Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.gmGridView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.gmGridView.frame.size;
	[self.gmGridView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

- (IBAction)stopEditing:(id)sender
{
    self.gmGridView.editing = NO;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.arrayOfObjects.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(90, 110);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    ProductDataStruct *dataStruct = [self.arrayOfObjects objectAtIndex:index];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //    налаштування виду елемента
    CGRect imageFrame;
    imageFrame.size = CGSizeMake(90,80);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    if (dataStruct.image)
    {
        [imageView setImage:dataStruct.image];
    }
    
    if (dataStruct.hit.integerValue == 1)
    {
        //            [cell.productImage addSubview:hitView];
        [imageView.layer addSublayer:[hitView layer]];
    }
    else
        if (dataStruct.hit.integerValue == 2)
            [imageView.layer addSublayer:[newsItemView layer]];
    
    [cell.contentView addSubview:imageView];
    
    CGRect nameFrame;
    nameFrame.origin.x = 0;
    nameFrame.origin.y = 90;
    nameFrame.size = CGSizeMake(90,20);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.text = dataStruct.title;
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.numberOfLines = 1;
    nameLabel.minimumFontSize = 9;
    nameLabel.font = [UIFont boldSystemFontOfSize:12];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:nameLabel];
    
    CGRect priceFrame;
    priceFrame.origin.x = 0;
    priceFrame.origin.y = 75;
    priceFrame.size = CGSizeMake(90,20);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
    //priceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:(dataStruct.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]];
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", price, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    priceLabel.text = priceString;
    
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.textAlignment = UITextAlignmentLeft;
    priceLabel.backgroundColor = [UIColor clearColor];
    //priceLabel.highlightedTextColor = [UIColor yellowColor];
    priceLabel.numberOfLines = 1;
    priceLabel.minimumFontSize = 9;
    priceLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:priceLabel];
    
    //    CGRect descriptionFrame;
    //    descriptionFrame.origin.x = 0;
    //    descriptionFrame.origin.y = 90;
    //    descriptionFrame.size = CGSizeMake(90,15);
    //    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:descriptionFrame];
    //    descriptionLabel.backgroundColor = [UIColor clearColor];
    //    descriptionLabel.text = dataStruct.descriptionText;
    //    descriptionLabel.textColor = [UIColor lightGrayColor];
    //    descriptionLabel.textAlignment = UITextAlignmentRight;
    //    descriptionLabel.numberOfLines = 1;
    //    descriptionLabel.minimumFontSize = 8;
    //    descriptionLabel.adjustsFontSizeToFitWidth = YES;
    //    [cell.contentView addSubview:descriptionLabel];
    
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    
    self.selectedIndex = [NSNumber numberWithInteger:position];
    [self performSegueWithIdentifier:@"toProductDetail" sender:self];
}


//segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@",[self.Products objectAtIndex:self.selectedRow.integerValue]);
    [segue.destinationViewController setProduct:[self.arrayOfObjects objectAtIndex:self.selectedIndex.integerValue] isFromFavorites:YES];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView changedEdit:(BOOL)edit
{
    if (edit == YES)
    {
        self.stopEditButton.hidden = NO;
    }
    else
        self.stopEditButton.hidden = YES;
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Remove to favorites?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
    
    [alertView show];
    self.selectedIndex = [NSNumber numberWithInteger:index];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        id currentOne = [self.arrayOfObjects objectAtIndex:self.selectedIndex.integerValue];
        //changing is database
        [self.db changeFavoritesBoolValue:NO forId:[currentOne productId]];
        //changing in Array
        [self.arrayOfObjects removeObjectAtIndex:self.selectedIndex.integerValue];
        self.alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:[NSString stringWithFormat:@"Removed \"%@\" from favorites.", [currentOne title]]
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [self.alert show];
        self.gmGridView.editing = NO;
        [self.gmGridView removeObjectAtIndex:self.selectedIndex.intValue withAnimation:GMGridViewItemAnimationFade];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];

    }
}

/////////////////////////////
#pragma mark myPrivateMethod
/////////////////////////////
- (void) dismiss
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    [self setAlert:nil];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:nil
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:nil
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [self.arrayOfObjects objectAtIndex:oldIndex];
    [_arrayOfObjects removeObject:object];
    [_arrayOfObjects insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_arrayOfObjects exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(300, 310);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
//    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
//    label.text = [NSString stringWithFormat:@"%@", [[self.arrayOfObjects objectAtIndex:index] title]];
//    label.textAlignment = UITextAlignmentCenter;
//    label.backgroundColor = [UIColor greenColor];
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //    if (INTERFACE_IS_PHONE) 
    //    {
    //        label.font = [UIFont boldSystemFontOfSize:15];
    //    }
    //    else
    //    {
    //        label.font = [UIFont boldSystemFontOfSize:20];
    //    }
    
//    label.font = [UIFont boldSystemFontOfSize:15];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:fullView.bounds];
    imageView.image = [[self.arrayOfObjects objectAtIndex:index] image];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [fullView addSubview:imageView];
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:nil
                     completion:nil];
    
    self.gmGridView.actionDelegate = nil;
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:nil                     
                     completion:nil];
        
    self.gmGridView.actionDelegate = self;
}

@end
