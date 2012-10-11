//
//  MenuIconViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuIconViewController.h"
#import "MainMenuViewController.h"

@interface MenuIconViewController ()
{
    BOOL pageControlBeingUsed;
    int countOfObjectsInCart;
}

@property (strong, nonatomic) UIAlertView *alert;

@property (nonatomic, strong) UIImageView *hitView;
@property (nonatomic, strong) UIImageView *newsItemView;

//Titles

@property (nonatomic, strong) NSString *titleAddToFavotites;
@property (nonatomic, strong) NSString *titleRemoveToFavotites;
@property (nonatomic, strong) NSString *titleYES;
@property (nonatomic, strong) NSString *titleCancel;
@property (nonatomic, strong) NSString *titleAddedFav;
@property (nonatomic, strong) NSString *titleRemovedFav;
@property (nonatomic) bool didLoad;
@end

@implementation MenuIconViewController

@synthesize kindOfMenu = _kindOfMenu;
@synthesize arrayData = _arrayData;
@synthesize db = _db;
@synthesize gmGridView = _gmGridView;
@synthesize viewForOutput = _viewForOutput;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;
@synthesize pageControl;
@synthesize stopEditButton = _stopEditButton;
//@synthesize scrollView = _scrollView;
@synthesize selectedIndex = _selectedIndex;
@synthesize alert;
@synthesize hitView;
@synthesize newsItemView;

//Titles
@synthesize titleAddToFavotites = _titleAddToFavotites;
@synthesize titleRemoveToFavotites = _titleRemoveToFavotites;
@synthesize titleYES = _titleYES;
@synthesize titleCancel = _titleCancel;
@synthesize titleAddedFav = _titleAddedFav;
@synthesize titleRemovedFav = _titleRemovedFav;
@synthesize didLoad = _didLoad;

- (void) imageAnimation: (UIView *) View
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [View setAlpha:1];
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
        NSLog(@"first query end. Second query begin");
//        NSDictionary *pictures = [self.db fetchImageURLAndDatabyMenuID:self.kindOfMenu.menuId];
        NSLog(@"Second query end. For begin");
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
    
    [self.gmGridView reloadData];
    
    //[self activePageWithId:0];
    
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
    NSLog(@"did it loaded? %@", self.titleAddToFavotites);
	self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    self.navigationItem.title = self.kindOfMenu.title;
    
    //self.CartBarItem.image = [UIImage imageNamed:@"Cart.png"];
//    self.navigationItem.leftBarButtonItem.
	pageControlBeingUsed = NO;
    
//	NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
//	for (int i = 0; i < colors.count; i++) 
//    {
//		CGRect frame;
//		frame.origin.x = self.scrollView.frame.size.width * i;
//		frame.origin.y = 0;
//		frame.size = self.scrollView.frame.size;
//		
//		UIView *subview = [[UIView alloc] initWithFrame:frame];
//		subview.backgroundColor = [colors objectAtIndex:i];
//		[self.scrollView addSubview:subview];
//	}
    
    
//    int w = 0;
//    int j = 1;
//    int withSize = 0;
//
//    NSMutableArray *temporaryArray = [[NSMutableArray alloc] init];
//    
//    CGRect frame;
//    CGRect imageFrame;
//    CGRect nameFrame;
//    CGRect priceFrame;
//    CGRect descriptionFrame;
//    NSNumber *temporary = [NSNumber alloc];
//    
//	for (int i = 0; i < self.arrayData.count; i++)
//    {
//        if ((i%3==0) && (i!=0))
//        {
//            w = 0;
//            frame.origin.x = 107 * w + withSize;
//            frame.origin.y = 111 * j;
//            j++;
//            w++;
//            if (i%9 == 0)
//            {
//                w = 0;
//                withSize += 320;
//                frame.origin.x = 107 * w + withSize;
//                frame.origin.y = 0;
//                w++;
//                j = 1;
//            }
//        }
//        else 
//        {
//            frame.origin.x = 107 * w + withSize;
//            w++;
//        }
//    
//        frame.size = CGSizeMake(106,110);
//        //UIView *elementView = [[UIView alloc] initWithFrame:frame];
//        UIButton *element = [[UIButton alloc] initWithFrame:frame];
//        element.backgroundColor = [UIColor blueColor];
//        
//        nameFrame.origin.x = 0;
//        nameFrame.origin.y = 70;
//        nameFrame.size = CGSizeMake(64,21);
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
//        nameLabel.text = [[self.arrayData objectAtIndex:i] title];
//        nameLabel.textAlignment = UITextAlignmentRight;
//        nameLabel.numberOfLines = 1;
//        nameLabel.minimumFontSize = 12;
//        nameLabel.adjustsFontSizeToFitWidth = YES;
//        [element addSubview:nameLabel];
//        
//        priceFrame.origin.x = 64;
//        priceFrame.origin.y = 70;
//        priceFrame.size = CGSizeMake(42,21);
//        UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
//        priceLabel.text = [[self.arrayData objectAtIndex:i]price];//[NSString stringWithFormat:@"%@", [[self.arrayData objectAtIndex:i]productId]];
//        priceLabel.textAlignment = UITextAlignmentRight;
//        [element addSubview:priceLabel];
//        
//        descriptionFrame.origin.x = 0;
//        descriptionFrame.origin.y = 90;
//        descriptionFrame.size = CGSizeMake(106,15);
//        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:descriptionFrame];
//        descriptionLabel.text = [[self.arrayData objectAtIndex:i] descriptionText];
//        descriptionLabel.textAlignment = UITextAlignmentRight;
//        descriptionLabel.numberOfLines = 1;
//        descriptionLabel.minimumFontSize = 8;
//        descriptionLabel.adjustsFontSizeToFitWidth = YES;
//        [element addSubview:descriptionLabel];
//        
//        imageFrame.size = CGSizeMake(106,80);
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
//        if ([[self.arrayData objectAtIndex:i] image] == nil)
//        {
//            [imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
//        }
//        else
//        {
//            [imageView setImage:[[self.arrayData objectAtIndex:i] image]];
//        }
//        
//        [element addSubview:imageView];
//        [self.scrollView addSubview:element];
//        [temporaryArray addObject:[temporary initWithInt:[self.view.subviews indexOfObject:self.view.subviews.lastObject]]];
//    }
//    
//    //CGFloat countOfPages = self.arrayData.count/9;
//	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.arrayData.count/9, 370);
//	
//	self.pageControl.currentPage = 0;
//	self.pageControl.numberOfPages =  (int) self.arrayData.count/9;
    
//    CGRect frame;
//    frame.origin.y = -10;
//    frame.origin.x = -10;
//    frame.size = CGSizeMake(320, 450);
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
    self.gmGridView.sortingDelegate = self;
    self.gmGridView.transformDelegate = self;
    self.gmGridView.dataSource = self;
    self.gmGridView.delegate = self;
    
//    [self.gmGridView layoutSubviewsWithAnimation:GMGridViewItemAnimationFade];
//    self.gmGridView.editing = YES;
    self.gmGridView.enableEditOnLongPress = YES;
    
    self.stopEditButton.hidden = YES;
    
    //задаємо тип скроллінга
    self.gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    self.gmGridView.showsHorizontalScrollIndicator = NO;
    
//    self.gmGridView.style = GMGridViewStylePush;
    
    self.pageControl.currentPage = 0;
    if (self.arrayData.count%9 != 0)
        self.pageControl.numberOfPages = (int) self.arrayData.count/9 + 1;
    else
        self.pageControl.numberOfPages = (int) self.arrayData.count/9;

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.viewForOutput.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.viewForOutput.layer insertSublayer:gradient atIndex:0];
    
    hitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HIT1.png"]];
    newsItemView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New1.png"]];
    
    //даємо слова =)
    self.didLoad = YES;
    [self setAllTitlesOnThisPage];
}

- (void)viewWillAppear:(BOOL)animated
{
    countOfObjectsInCart = [self.db fetchCountOfProductsInEntity:@"Cart"];
    if (countOfObjectsInCart != 0)
    {
        UIButton *cartButton = [[UIButton alloc] init];
        cartButton.frame=CGRectMake(0,0,60,30);
        [cartButton setBackgroundImage:[UIImage imageNamed: @"white-cart_big.png"] forState:UIControlStateNormal];
        cartButton.layer.cornerRadius = 8.0f;
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,15,15)];
        countLabel.text = [NSString stringWithFormat:@"%i", countOfObjectsInCart];
        countLabel.textAlignment = UITextAlignmentCenter;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont boldSystemFontOfSize:10];
        countLabel.backgroundColor = [UIColor orangeColor];
        countLabel.layer.cornerRadius = 8;
        
        [cartButton addSubview:countLabel];
        
        [cartButton addTarget:self action:@selector(toCartMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
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


- (void)viewDidUnload
{
    [self setPageControl:nil];
    [self setGmGridView:nil];
    [self setDb:nil];
    [self setKindOfMenu:nil];
    [self setViewForOutput:nil];
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
        [self loadImagesForOnscreenRows];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
    [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(ProductDataStruct *)appRecord forIndex:(NSNumber *)index
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:index];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexForElement = index;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:index];
        [iconDownloader startDownload]; 
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
//    if ([self.arrayData count] > 0 && self.pageControl.currentPage > 1)
//    {
//        NSMutableArray *visibleIndexes = [[NSMutableArray alloc] init];
//        for (int i = 0; i < 9; i++)
//        {
//            [visibleIndexes addObject:[NSNumber numberWithInteger:(self.pageControl.currentPage*9) + i]];
//        }
//        for (NSNumber *index in visibleIndexes)
//        {
//            ProductDataStruct *appRecord = [self.arrayData objectAtIndex:index.intValue];
//            
//            if (!appRecord.image) // avoid the app icon download if the app already has an icon
//            {
//                [self startIconDownload:appRecord forIndex:index];
//            }
//        }
//    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoadGrid:(NSNumber *)index
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:index];
//    if (iconDownloader != nil)
//    {
//        ProductCell *cell = (ProductCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
//        
//        // Display the newly loaded image
//        cell.productImage.image = iconDownloader.appRecord.image;
    if (iconDownloader != nil)
    {
        [self.db SavePictureToCoreData:iconDownloader.appRecord.idPicture toData:UIImagePNGRepresentation(iconDownloader.appRecord.image)];
        //GMGridViewCell *cell = (GMGridViewCell *)[self.gmGridView cellForItemAtIndex:index.intValue];
        //[cell reloadInputViews];
        [self.gmGridView reloadObjectAtIndex:index.integerValue animated:YES];
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

- (IBAction)changePage {
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

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.arrayData.count;
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
    ProductDataStruct *dataStruct = [self.arrayData objectAtIndex:index];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    if (dataStruct.isFavorites.boolValue != YES)
        cell.deleteButtonIcon = [UIImage imageNamed:@"alphanumeric-plus-sign.png"];
    else
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    налаштування виду елемента
    CGRect imageFrame;
    imageFrame.size = CGSizeMake(90,80);
    imageFrame.origin.x = 0;
    imageFrame.origin.y = 0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    CGRect indocatorFrame;
    indocatorFrame.size = CGSizeMake(20,20);
    UIActivityIndicatorView * loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame: indocatorFrame];
    loadingIndicator.center = imageView.center;
    [imageView addSubview:loadingIndicator];
    
    if (!dataStruct.image)
    {
        if (dataStruct.link)
            [self startIconDownload:dataStruct forIndex:[NSNumber numberWithInteger:index]];
        // if a download is deferred or in progress, return a placeholder image
        //[imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
        [loadingIndicator startAnimating];
    }
    else
    {
        if (self.didLoad)
        {
            imageView.alpha = 0;
        }
        [loadingIndicator stopAnimating];
        [imageView setImage:dataStruct.image];
        [self imageAnimation: imageView];
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
    [segue.destinationViewController setProduct:[self.arrayData objectAtIndex:self.selectedIndex.integerValue] isFromFavorites:NO];
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
    UIAlertView *alertView;
    if (![[[self.arrayData objectAtIndex:index] isFavorites] boolValue])
    {
        alertView= [[UIAlertView alloc] initWithTitle:self.titleAddToFavotites
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:self.titleCancel
                                     otherButtonTitles:self.titleYES, nil];
    }
    else
    {
         alertView= [[UIAlertView alloc] initWithTitle:self.titleRemoveToFavotites
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:self.titleCancel
                                     otherButtonTitles:self.titleYES, nil];
      
    }
    
    [alertView show];
    self.selectedIndex = [NSNumber numberWithInteger:index];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        // add to favorites here
        id currentOne = [self.arrayData objectAtIndex:self.selectedIndex.integerValue];
        //changing is database
        [self.db changeFavoritesBoolValue:![[currentOne isFavorites] boolValue] forId:[currentOne productId]];
        //changing in Array
        [currentOne setIsFavorites:[NSNumber numberWithBool:![[currentOne isFavorites] boolValue]]];
        
        if ([currentOne isFavorites].boolValue)
        {
            self.alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:self.titleAddedFav, [currentOne title]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        }
        else
        {
            self.alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:self.titleRemovedFav, [currentOne title]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        }
        
        [self.alert show];
        self.gmGridView.editing = NO;
        [self.gmGridView reloadData];
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
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{  
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    //NSObject *object = [_currentData objectAtIndex:oldIndex];
    //[_currentData removeObject:object];
    //[_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    //[_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
//    if (INTERFACE_IS_PHONE) 
//    {
//        if (UIInterfaceOrientationIsLandscape(orientation)) 
//        {
//            return CGSizeMake(320, 210);
//        }
//        else
//        {
//            return CGSizeMake(300, 310);
//        }
//    }
//    else
//    {
//        if (UIInterfaceOrientationIsLandscape(orientation)) 
//        {
//            return CGSizeMake(700, 530);
//        }
//        else
//        {
//            return CGSizeMake(600, 500);
//        }
//    }
    
    return CGSizeMake(300, 310);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
//    UIView *fullView = [[UIView alloc] init];
//    fullView.backgroundColor = [UIColor yellowColor];
//    fullView.layer.masksToBounds = NO;
//    fullView.layer.cornerRadius = 8;
//    
//    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
//    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
//    label.textAlignment = UITextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
////    if (INTERFACE_IS_PHONE) 
////    {
////        label.font = [UIFont boldSystemFontOfSize:15];
////    }
////    else
////    {
////        label.font = [UIFont boldSystemFontOfSize:20];
////    }
//    
//    label.font = [UIFont boldSystemFontOfSize:15];
//
//    [fullView addSubview:label];
    UIView *fullView = [[UIView alloc] init];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:fullView.bounds];
    imageView.image = [[self.arrayData objectAtIndex:index] image];
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

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}





//image support old

//-(void) activePageWithId:(NSNumber *)idOfPage
//{
//    int j;
//    int i = idOfPage.intValue*9;
//    if (self.arrayData.count < 9)
//    {
//        j = self.arrayData.count;
//    }
//    else
//    {
//        j = i + 9;
//    }
//    while (i < j)
//    {
//        //[NSThread detachNewThreadSelector:@selector(downloadingAndSaveImagesWithLink:idOfSubview:) toTarget:self withObject:[[self.arrayData objectAtIndex:i] link]:[self.arrayOfSubViews objectAtIndex:i]];
//        if ([[self.arrayData objectAtIndex:i] image] == nil)
//        {
//            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[self.arrayData objectAtIndex:i] idPicture], @"id",
//                                    [[self.arrayData objectAtIndex:i] link], @"link",
//                                     nil];
//            [NSThread detachNewThreadSelector:@selector(downloadingAndSaveImage:) toTarget:self withObject:parameters];
//        }
//        i++;
//    }
//}
//
//- (void) downloadingAndSaveImage:(NSDictionary *)parameters
//{
//    BOOL is;
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[parameters objectForKey:@"link"]]]];
//    if (image != nil)
//    {
//        [self.db SavePictureToCoreData:[parameters objectForKey:@"id"] toData:UIImagePNGRepresentation(image)];
//        is = YES;
//    }
//    
//    if (is)
//    {
//        [super reloadInputViews];
//    }
//}


- (void)toCartMenu:(id)sender 
{
    //обовязково анімація NO !!!
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)stopEditing:(id)sender
{
    self.gmGridView.editing = NO;
}


#pragma mark
#pragma mark PRIVATE METHODS

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Add to favorites?"])
        {
            self.titleAddToFavotites = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Remove from favorites?"])
        {
            self.titleRemoveToFavotites = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"YES"])
        {
            self.titleYES = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cancel"])
        {
            self.titleCancel = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Added %@ to favorites."])
        {
            self.titleAddedFav = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Removed %@ from favorites."])
        {
            self.titleRemovedFav = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    }
}

@end
