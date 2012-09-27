//
//  SettingsViewController.m
//  Restaurant
//
//  Created by Roman Slysh on 9/27/12.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    BOOL isStyle;
    BOOL isCurrency;
    BOOL isFriend;
}

@property (nonatomic, strong) NSArray *currencyArray;

//Titles
@property (nonatomic, strong) NSString *titleSettings;
@property (nonatomic, strong) NSString *titleLanguage;
@property (nonatomic, strong) NSString *titleCity;
@property (nonatomic, strong) NSString *titleMenuStyle;
@property (nonatomic, strong) NSString *titleCurrency;
@property (nonatomic, strong) NSString *titleShare;
@property (nonatomic, strong) NSString *titleTellFriend;
@property (nonatomic, strong) NSString *titleAbout;

@property (nonatomic, strong) NSString *titleStyle;//для двох наступних
@property (nonatomic, strong) NSString *titleIcons;
@property (nonatomic, strong) NSString *titleList;

@property (nonatomic, strong) NSString *titleChooseStyle;
@property (nonatomic, strong) NSString *titleSetCurrency;
@property (nonatomic, strong) NSString *titleSosialNetworks;
@property (nonatomic, strong) NSString *titleCancel;

@end

@implementation SettingsViewController

@synthesize currencyArray = _currencyArray;

//Titles
@synthesize titleSettings = _titleSettings;
@synthesize titleLanguage = _titleLanguage;
@synthesize titleCity = _titleCity;
@synthesize titleMenuStyle = _titleMenuStyle;
@synthesize titleCurrency = _titleCurrency;
@synthesize titleShare = _titleShare;
@synthesize titleTellFriend = _titleTellFriend;
@synthesize titleAbout = _titleAbout;
@synthesize titleStyle = _titleStyle;

@synthesize titleChooseStyle = _titleChooseStyle;
@synthesize titleSetCurrency = _titleSetCurrency;
@synthesize titleSosialNetworks = _titleSosialNetworks;
@synthesize titleCancel = _titleCancel;

#pragma mark - Life circle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setAllTitlesOnThisPage];
    
    self.navigationItem.title = self.titleSettings;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"typeOfView"] isEqualToString:@"menuIcon"])
        self.titleStyle = self.titleIcons;
    else
        self.titleStyle = self.titleList;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 4;
        }
        case 1:
        {
            return 2;
        }
            
        default:
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
//    cell.textLabel.text = @"Test";
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = self.titleLanguage;
                GettingCoreContent *content = [[GettingCoreContent alloc] init];
                NSArray *languages =  content.fetchAllLanguages;
                NSString *userLangId = [[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguageId"];
                
                for (int i = 0; i < languages.count; i++)
                {
                    if ([[[[languages objectAtIndex:i] valueForKey:@"underbarid"] description] isEqualToString:userLangId.description])
                    {
                        cell.detailTextLabel.text = [[languages objectAtIndex:i] valueForKey:@"language"];
                    }
                }
                break;
            }
            case 1:
            {
                cell.textLabel.text = self.titleCity;
                GettingCoreContent *content = [[GettingCoreContent alloc] init];
                NSArray *cities =  [content fetchAllCitiesByLanguage:[[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguageId"] description]];
                NSString *userCityId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultCityId"] description];
                for (int i = 0; i < cities.count; i++)
                {
                    if ([[[NSString stringWithFormat:@"%@",[[cities objectAtIndex:i] valueForKey:@"idCity"]] description] isEqual:userCityId.description])
                        cell.detailTextLabel.text = [[cities objectAtIndex:i] valueForKey:@"name"];
                }
                break;
            }
            case 2:
                cell.textLabel.text = self.titleMenuStyle;
                cell.detailTextLabel.text = self.titleStyle;
                break;
            case 3:
                cell.textLabel.text = self.titleCurrency;
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"];
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = self.titleShare;
                break;
                
            case 1:
                cell.textLabel.text = self.titleTellFriend;
                break;
        }
    }
    else
    {
        cell.textLabel.text = self.titleAbout;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                [self performSegueWithIdentifier:@"to Languages" sender:self];
                break;
            }
            case 1:
            {
                [self performSegueWithIdentifier:@"to Cities" sender:self];
                break;
            }
            case 2:
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleChooseStyle];
                [actionSheet setDelegate:(id)self];
                isStyle = YES;
                [actionSheet addButtonWithTitle:self.titleIcons];
                [actionSheet addButtonWithTitle:self.titleList];
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                [actionSheet showInView:self.view];
                break;
            }
            case 3:
            {
                GettingCoreContent *db = [[GettingCoreContent alloc] init];
                self.currencyArray = [NSArray arrayWithArray:[db getArrayFromCoreDatainEntetyName:@"Currencies" withSortDescriptor:@"underbarid"]];
                
                UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleSetCurrency];
                [actionSheet setDelegate:(id)self];
                isCurrency = YES;
                
                for (int i = 0; i < self.currencyArray.count; i++)
                {
                    [actionSheet addButtonWithTitle:[[self.currencyArray objectAtIndex:i] valueForKey:@"currency"]];
                }
                
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                [actionSheet showInView:self.view];
                
                break;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleSosialNetworks];
                [actionSheet setDelegate:(id)self];
                [actionSheet addButtonWithTitle:@"Twitter"];
                [actionSheet addButtonWithTitle:@"Facebook"];
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                [actionSheet showInView:self.view];
                
                break;
            }
                
            case 1:
            {
                UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleTellFriend];
                [actionSheet setDelegate:(id)self];
                isFriend = YES;
                [actionSheet addButtonWithTitle:@"SMS"];
                [actionSheet addButtonWithTitle:@"E-mail"];
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                [actionSheet showInView:self.view];
                
                break;
            }
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"About" sender:self];
    }

}

#pragma mark - Action view delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex)
    {
        isFriend = 0;
        isStyle = 0;
        isCurrency = 0;
        return;
    }
    else if (isFriend)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"SMS");
            isFriend = 0;
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"AppStore link and something else :)";
                controller.recipients = [NSArray arrayWithObjects:/*phone numbers*/nil];
                controller.messageComposeDelegate = (id)self;
                [self presentModalViewController:controller animated:YES];
            }
        }
        if (buttonIndex == 1)
        {
            NSLog(@"Email");
            isFriend = 0;
            
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
    
    else if (!isStyle && !isFriend && !isCurrency)
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
    
    else if (isStyle)
    {
        if (buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"toFavoritesIcon" forKey:@"typeOfViewFavorites"];
            [[NSUserDefaults standardUserDefaults] setValue:@"menuIcon" forKey:@"typeOfView"];
            self.titleStyle = self.titleIcons;
            
        }
        if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"toFavoritesList" forKey:@"typeOfViewFavorites"];
            [[NSUserDefaults standardUserDefaults] setValue:@"menuList" forKey:@"typeOfView"];
            self.titleStyle = self.titleList;
        }
        isStyle = 0;
    }
    
    else if (isCurrency)
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
//        self.currencyCell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"];
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"to Languages"])
    {
        [[segue destinationViewController] setArrayFromSegue:NO];
        [[[segue destinationViewController] navigationItem] setTitle:self.titleLanguage];
        NSLog(@"LANGUAGES");
    }
    
    if ([[segue identifier] isEqualToString:@"to Cities"])
    {
        [[segue destinationViewController] setArrayFromSegue:YES];
        [[[segue destinationViewController] navigationItem] setTitle:self.titleCity];
        NSLog(@"CITIES");
    }
}

#pragma mark
#pragma mark PRIVATE METHODS

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton sharedManager];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Settings"])
        {
            self.titleSettings = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Language"])
        {
            self.titleLanguage = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"City"])
        {
            self.titleCity = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Menu style"])
        {
            self.titleMenuStyle = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Currency"])
        {
            self.titleCurrency = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Share"])
        {
            self.titleShare = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Tell a friend"])
        {
            self.titleTellFriend = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"About"])
        {
            self.titleAbout = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Choose style"])
        {
            self.titleChooseStyle = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Icons"])
        {
            self.titleIcons = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"List"])
        {
            self.titleList = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Set currency"])
        {
            self.titleSetCurrency = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Social networks"])
        {
            self.titleSosialNetworks = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Cancel"])
        {
            self.titleCancel = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
        }
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
	picker.mailComposeDelegate = (id)self;
	
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
