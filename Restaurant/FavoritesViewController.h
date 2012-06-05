//
//  FavoritesViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationbar;

- (IBAction)bachButton:(id)sender;

@end
