//
//  DeliveryViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GettingCoreContent.h"
#import "AddressListTableViewController.h"

@interface DeliveryViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate, AddressListDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *addressName;
@property (strong, nonatomic) IBOutlet UITextField *customerName;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *CityName;
@property (strong, nonatomic) IBOutlet UITextField *metroName;
@property (strong, nonatomic) IBOutlet UITextField *street;
@property (strong, nonatomic) IBOutlet UITextField *build;
@property (strong, nonatomic) IBOutlet UITextField *appartaments;
@property (strong, nonatomic) IBOutlet UITextField *floor;
@property (strong, nonatomic) IBOutlet UITextField *access;
@property (strong, nonatomic) IBOutlet UITextField *intercom;
@property (strong, nonatomic) IBOutlet UITextField *otherInformation;

- (IBAction)toOrder:(id)sender;
- (IBAction)saveAddress:(id)sender;
- (IBAction)toAddressList:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) GettingCoreContent *content;
@end
