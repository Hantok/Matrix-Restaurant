//
//  LanguageAndCityTableViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface LanguageAndCityTableViewController : UITableViewController <UIAlertViewDelegate>


- (void)setArrayFromSegue:(BOOL)isCityEnter;
@end
