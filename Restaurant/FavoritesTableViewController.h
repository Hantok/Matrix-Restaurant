//
//  FavoritesTableViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface FavoritesTableViewController : UITableViewController <IconDownloaderDelegate>

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end
