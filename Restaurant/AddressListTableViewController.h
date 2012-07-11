//
//  AddressListTableViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GettingCoreContent.h"

@protocol AddressListDelegate <NSObject>

-(void) setAddressDictionary:(NSDictionary *)dictionary;

@end

@interface AddressListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <AddressListDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *arrayOfAddresses;
@property (strong, nonatomic) GettingCoreContent *content;
- (IBAction)cancelButton:(id)sender;

@end
