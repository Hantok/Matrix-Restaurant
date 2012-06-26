//
//  MenuIconViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuIconViewController.h"

@interface MenuIconViewController ()
{
    BOOL pageControlBeingUsed;
}

@end

@implementation MenuIconViewController

@synthesize kindOfMenu = _kindOfMenu;
@synthesize arrayData = _arrayData;
@synthesize db = _db;
@synthesize scrollView = _scrollView;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;
@synthesize pageControl;

- (NSMutableArray *)arrayData
{
    if(!_arrayData)
    {
        
        NSLog(@"request is began");
        NSMutableArray *array = [[NSMutableArray alloc] init];
        ProductDataStruct *dataStruct;
        NSArray *data = [self.db fetchAllProductsFromMenu:self.kindOfMenu.menuId];
        NSLog(@"first query");
        NSDictionary *pictures = [self.db fetchImageURLAndDatabyMenuID:self.kindOfMenu.menuId];
        for(int i=0;i<data.count;i++)
        {
            if(i%2==0) 
            {
                dataStruct = [[ProductDataStruct alloc] init];
                dataStruct.productId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
                dataStruct.price = [[data objectAtIndex:i] valueForKey:@"price"];
                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
                NSData *dataOfPicture = [[pictures objectForKey:dataStruct.idPicture] valueForKey:@"data"];
                NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test5/root/%@",[[pictures objectForKey:dataStruct.idPicture] valueForKey:@"link"]];
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
    int w = 0;
    int j = 1;
    int withSize = 0;
    CGRect frame;
    CGRect imageFrame;
    CGRect nameFrame;
    CGRect priceFrame;
    CGRect descriptionFrame;
	for (int i = 0; i < self.arrayData.count; i++)
    {
        if ((i%3==0) && (i!=0))
        {
            w = 0;
            frame.origin.x = 107 * w + withSize;
            frame.origin.y = 111 * j;
            j++;
            w++;
            if (i%9 == 0)
            {
                w = 0;
                withSize += 320;
                frame.origin.x = 107 * w + withSize;
                frame.origin.y = 0;
                w++;
                j = 1;
            }
        }
        else 
        {
            frame.origin.x = 107 * w + withSize;
            w++;
        }
    
        frame.size = CGSizeMake(106,110);
        //UIView *elementView = [[UIView alloc] initWithFrame:frame];
        UIButton *element = [[UIButton alloc] initWithFrame:frame];
        element.backgroundColor = [UIColor blueColor];
        
        imageFrame.size = CGSizeMake(106,80);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        if ([[self.arrayData objectAtIndex:i] image] == nil)
        {
            [imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
        }
        else
            
            [imageView setImage:[[self.arrayData objectAtIndex:i] image]];
        [element addSubview:imageView];
        
        nameFrame.origin.x = 0;
        nameFrame.origin.y = 70;
        nameFrame.size = CGSizeMake(64,21);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
        nameLabel.text = [[self.arrayData objectAtIndex:i] title];
        nameLabel.textAlignment = UITextAlignmentRight;
        nameLabel.numberOfLines = 1;
        nameLabel.minimumFontSize = 12;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        [element addSubview:nameLabel];
        
        priceFrame.origin.x = 64;
        priceFrame.origin.y = 70;
        priceFrame.size = CGSizeMake(42,21);
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
        priceLabel.text = [[self.arrayData objectAtIndex:i]price];//[NSString stringWithFormat:@"%@", [[self.arrayData objectAtIndex:i]productId]];
        priceLabel.textAlignment = UITextAlignmentRight;
        [element addSubview:priceLabel];
        
        descriptionFrame.origin.x = 0;
        descriptionFrame.origin.y = 90;
        descriptionFrame.size = CGSizeMake(106,15);
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:descriptionFrame];
        descriptionLabel.text = [[self.arrayData objectAtIndex:i] descriptionText];
        descriptionLabel.textAlignment = UITextAlignmentRight;
        descriptionLabel.numberOfLines = 1;
        descriptionLabel.minimumFontSize = 8;
        descriptionLabel.adjustsFontSizeToFitWidth = YES;
        [element addSubview:descriptionLabel];
        
        [self.scrollView addSubview:element];
    }
    
    //CGFloat countOfPages = self.arrayData.count/9;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.arrayData.count/9, 370);
	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages =  (int) self.arrayData.count/9;

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


- (void)viewDidUnload
{
    [self setPageControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark <UIScrollViewDelegate> methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

#pragma mark -
#pragma mark image downloading support

//- (void)startIconDownload:(ProductDataStruct *)appRecord forIndexPath:(NSIndexPath *)indexPath
//{
//    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
//    if (iconDownloader == nil) 
//    {
//        iconDownloader = [[IconDownloader alloc] init];
//        iconDownloader.appRecord = appRecord;
//        iconDownloader.indexPathInTableView = indexPath;
//        iconDownloader.delegate = self;
//        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
//        [iconDownloader startDownload]; 
//    }
//}
//
//// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
//- (void)loadImagesForOnscreenRows
//{
//    if ([self.arrayData count] > 0)
//    {
//        NSIndexPath *path = [[NSIndexPath alloc] initWithIndex:0];
//        [path indexPathByAddingIndex:1];
//        //NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
//        //for (NSIndexPath *indexPath in visiblePaths)
//        for (NSIndexPath *indexPath in 9)
//        {
//            ProductDataStruct *appRecord = [self.arrayData objectAtIndex:indexPath.row];
//            
//            if (!appRecord.image) // avoid the app icon download if the app already has an icon
//            {
//                [self startIconDownload:appRecord forIndexPath:indexPath];
//            }
//        }
//    }
//}
//
//// called by our ImageDownloader when an icon is ready to be displayed
//- (void)appImageDidLoad:(NSIndexPath *)indexPath
//{
//    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
//    if (iconDownloader != nil)
//    {
//        ProductCell *cell = (ProductCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
//        
//        // Display the newly loaded image
//        cell.productImage.image = iconDownloader.appRecord.image;
//        [self.db SavePictureToCoreData:iconDownloader.appRecord.idPicture toData:UIImagePNGRepresentation(cell.productImage.image)];
//        
//    }
//}
//
//#pragma mark -
//#pragma mark Deferred image loading (UIScrollViewDelegate)
//
//// Load images for all onscreen rows when scrolling is finished
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate)
//	{
//        [self loadImagesForOnscreenRows];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self loadImagesForOnscreenRows];
//}


@end
