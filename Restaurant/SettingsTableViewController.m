//
//  SettingsTableViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "GettingCoreContent.h"
#import "LanguageAndCityTableViewController.h"


@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"to Languages"]) {
        GettingCoreContent *getContent = [[GettingCoreContent alloc] init];
        [[segue destinationViewController] setDestinationArray:[getContent fetchAllLanguages]];
        NSLog(@"LANGUAGES");
    }
    
    if ([[segue identifier] isEqualToString:@"to Cities"]) {
        [[segue destinationViewController] setDestinationArray:nil];
        NSLog(@"CITIES");
    }
}
@end
