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

@property BOOL isFriend;
@property BOOL isStyle;
@property BOOL isCurrency;
@property (nonatomic, strong) NSArray *currencyArray;
@property (nonatomic, strong) NSString *typeOfView;

@end

@implementation SettingsTableViewController
@synthesize styleCell = _styleCell;
@synthesize currencyCell = _currencyCell;

@synthesize isFriend = _isFriend;
@synthesize isStyle = _isStyle;
@synthesize typeOfView = _typeOfView;
@synthesize isCurrency = _isCurrency;
@synthesize currencyArray = _currencyArray;

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"typeOfView"] isEqualToString:@"menuIcon"]) 
        self.typeOfView = @"Icons";
    else 
        self.typeOfView = @"List";
    
    self.styleCell.detailTextLabel.text = self.typeOfView;
    
    
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"])
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"USD" forKey:@"Currency"];
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"CurrencyCoefficient"];
//        self.currencyCell.detailTextLabel.text = @"USD";
//    }
    
    self.currencyCell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidUnload
{
    [self setStyleCell:nil];
    [self setCurrencyCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    if (self.isFriend)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"SMS");
            self.isFriend = 0;
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"AppStore link and something else :)";
                controller.recipients = [NSArray arrayWithObjects:/*phone numbers*/nil];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }
        }
        if (buttonIndex == 1)
        {
            NSLog(@"Email");
            self.isFriend = 0;
            
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    [self displayComposerSheet];
                }
                else
                {
                    [self launchMailAppOnDevice];
                }
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
    }
    
    if (!self.isStyle && !self.isFriend && !self.isCurrency)
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
    
    if (self.isStyle)
    {
        if (buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"toFavoritesIcon" forKey:@"typeOfViewFavorites"];
            [[NSUserDefaults standardUserDefaults] setValue:@"menuIcon" forKey:@"typeOfView"];
            self.styleCell.detailTextLabel.text = @"Icons";
            
        }
        if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"toFavoritesList" forKey:@"typeOfViewFavorites"];
            [[NSUserDefaults standardUserDefaults] setValue:@"menuList" forKey:@"typeOfView"];
            self.styleCell.detailTextLabel.text = @"List";
        }
    }
    
    if (self.isCurrency)
    {
        for (int i = 0; i <self.currencyArray.count; i++)
        {
            if (buttonIndex == i)
            {
                [[NSUserDefaults standardUserDefaults] setValue:[[self.currencyArray objectAtIndex:i] valueForKey:@"currency"] forKey:@"Currency"];
                [[NSUserDefaults standardUserDefaults] setValue:[[self.currencyArray objectAtIndex:i] valueForKey:@"coef"] forKey:@"CurrencyCoefficient"];
                [[NSUserDefaults standardUserDefaults] synchronize];    
                break;
            }
        }
        self.currencyCell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"];
    }
    
    if (actionSheet.cancelButtonIndex == buttonIndex)
    {
        self.isFriend = 0;
        self.isStyle = 0;
        self.isCurrency = 0;
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
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
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
        [actionSheet setTitle:@"Tell a friend:"];
        [actionSheet setDelegate:(id)self];
        self.isFriend = YES;
        [actionSheet addButtonWithTitle:@"via SMS"];
        [actionSheet addButtonWithTitle:@"via e-mail"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:self.view];
    }
    
    if ([cell.reuseIdentifier isEqualToString:@"typeOfView"])
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Choose style:"];
        [actionSheet setDelegate:(id)self];
        self.isStyle = YES;
        [actionSheet addButtonWithTitle:@"Icons"];
        [actionSheet addButtonWithTitle:@"List"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        [actionSheet showInView:self.view];
    }
    
    if ([cell.reuseIdentifier isEqualToString:@"currency"])
    {
        GettingCoreContent *db = [[GettingCoreContent alloc] init];
        self.currencyArray = [NSArray arrayWithArray:[db getArrayFromCoreDatainEntetyName:@"Currencies" withSortDescriptor:@"underbarid"]];
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Set currency:"];
        [actionSheet setDelegate:(id)self];
        self.isCurrency = YES;
        
        for (int i = 0; i < self.currencyArray.count; i++)
        {
            [actionSheet addButtonWithTitle:[[self.currencyArray objectAtIndex:i] valueForKey:@"currency"]];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
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







#pragma mark -
#pragma mark SMS Mail

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) 
    {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Unknown Error"
														   delegate:self
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
			[alert show];
			break;
        }
		case MessageComposeResultSent:
            NSLog(@"Sent");
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Restaurant"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
	NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil]; 
	NSArray *bccRecipients = [NSArray arrayWithObject:@""]; 
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];	
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
	//[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"Here is Appstore link to download application or something else =)";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	//message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


@end
