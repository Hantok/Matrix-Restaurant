//
//  FavoritesIconViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GettingCoreContent.h"
#import "MenuDataStruct.h"
#import "IconDownloader.h"
#import "ProductDataStruct.h"
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "ProductDetailViewController.h"
#import "GMGridViewLayoutStrategies.h"
#import "Singleton.h"


@interface FavoritesIconViewController : UIViewController <UIScrollViewDelegate, GMGridViewDataSource,GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewForOutput;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) GMGridView *gmGridView;
@property (strong, nonatomic) NSMutableArray *arrayOfObjects;
@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) NSNumber *selectedIndex;
@property (weak, nonatomic) IBOutlet UIButton *stopEditButton;

- (IBAction)changePage:(id)sender;
- (IBAction)stopEditing:(id)sender;


@end
