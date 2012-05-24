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
#import "SocialViewController.h"


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
    if ([[segue identifier] isEqualToString:@"to Languages"]) 
    {
        [[segue destinationViewController] setArrayFromSegue:NO];
        NSLog(@"LANGUAGES");
    }
    
    if ([[segue identifier] isEqualToString:@"to Cities"]) 
    {
        [[segue destinationViewController] setArrayFromSegue:YES];
        NSLog(@"CITIES");
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0)
    {
        NSLog(@"Twitter");
        [[NSUserDefaults standardUserDefaults] setValue:@"http://twitter.com" forKey:@"social"];
        [self performSegueWithIdentifier:@"Social" sender:nil];
        
    }
    if (buttonIndex == 1)
    {
        NSLog(@"Facebook");
        [[NSUserDefaults standardUserDefaults] setValue:@"http://facebook.com" forKey:@"social"];
        [self performSegueWithIdentifier:@"Social" sender:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.reuseIdentifier isEqualToString:@"Social"])
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Social networks:"];
        [actionSheet setDelegate:(id)self];
        [actionSheet addButtonWithTitle:@"Twitter"];
        [actionSheet addButtonWithTitle:@"Facebook"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet showInView:self.view];
    }
    if ([cell.reuseIdentifier isEqualToString:@"Reset"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:@"Are you sure?" 
                                                       delegate:self 
                                              cancelButtonTitle:@"YES" 
                                              otherButtonTitles:@"NO", nil]; 
        [alert show]; 
    }
    
    if([cell.reuseIdentifier isEqualToString:@"Friend"])
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Telt a friend:"];
        [actionSheet setDelegate:nil];
        [actionSheet addButtonWithTitle:@"via SMS"];
        [actionSheet addButtonWithTitle:@"via e-mail"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet showInView:self.view];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"defaultLanguageId"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"defaultCityId"];
        [self.tableView reloadData];
    }
    
}

@end
