//
//  LoadAppViewController.h
//  Restaurant
//
//  Created by Bogdan Geleta on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParse.h"
#import "GettingCoreContent.h"
#import "Singleton.h"

@interface LoadAppViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) NSString *city;
@property (nonatomic, strong) XMLParse *db;

@end
