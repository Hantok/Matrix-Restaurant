//
//  MenuIconViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GettingCoreContent.h"
#import "MenuDataStruct.h"
#import "IconDownloader.h"
#import "ProductCell.h"
#import "ProductDataStruct.h"

@interface MenuIconViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayData;
@property (nonatomic, strong) MenuDataStruct *kindOfMenu;
@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage;

@end
