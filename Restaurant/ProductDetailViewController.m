//
//  ProductDetailViewController.m
//  XMLParser
//
//  Created by Bogdan Geleta on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSToolkit/SSToolkit.h"
#import "checkConnection.h"

#import <FacebookSDK/FacebookSDK.h>

@interface ProductDetailViewController () <FBLoginViewDelegate, UITextViewDelegate>
{
    BOOL isDownloadingPicture;
    BOOL isDeletingFromCart;
    BOOL isPictureViewContanerShow;
}

@property BOOL isInFavorites;
@property (strong, nonatomic) NSString *labelString;
@property (strong, nonatomic) UIAlertView *alert;
@property (nonatomic, strong) SSLoadingView *loadingView;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (strong, nonatomic) UIView *facebookView;
@property (strong, nonatomic) FBProfilePictureView *fbProfilePictureView;
@property (strong, nonatomic) FBLoginView *loginview;
@property (strong, nonatomic) UIButton *postOnWallButton;
@property (strong, nonatomic) UIButton *tellFriendButton;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UITextView *textView;

//titles
@property (strong, nonatomic) NSString *titleWihtDiscounts;
@property (strong, nonatomic) NSString *titleCancel;
@property (strong, nonatomic) NSString *titleAddetItemToTheCart;
@property (weak, nonatomic) NSString *titleYES;
@property (weak, nonatomic) NSString *titleNO;
@property (weak, nonatomic) NSString *titleDoYouWantDeleteItemFromCart;

@end

@implementation ProductDetailViewController
@synthesize db = _db;
@synthesize product = _product;
@synthesize countPickerView = _countPickerView;
@synthesize priceView = _priceView;
//@synthesize priceLabel = _priceLabel;
@synthesize cartButton = _cartButton;
@synthesize count = _count;
//@synthesize productImage = _productImage;
@synthesize shareButton = _addToFavorites;
@synthesize nameLabal = _nameLabal;
@synthesize pictureViewContainer = _pictureViewContainer;
@synthesize pictureButton = _pictureButton;
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize captionLabel = _captionLabel;
@synthesize nilCaption = _nilCaption;
@synthesize proteinLabel = _proteinLabel;
@synthesize fatLabel = _fatLabel;
@synthesize carbohydratesLabel = _carbohydratesLabel;
@synthesize kCalLabel = _kCal;
@synthesize portionLabel = _portionLabel;
@synthesize portionProteinLabel = _portionProteinLabel;
@synthesize portionFatLabel = _portionFatLabel;
@synthesize portionCarbohydratesLabel = _portionCarbohydratesLabel;
@synthesize portionKCalLabel = _portionKCalLabel;
@synthesize in100gLabel = _in100gLabel;
@synthesize in100gProteinLabel = _in100gProteinLabel;
@synthesize in100gFatLabel = _in100gFatLabel;
@synthesize in100gCarbohydratesLabel = _in100gCarbohydratesLabel;
@synthesize in100gKCalLabel = _in100gKCalLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize weightLabel = _weightLabel;
@synthesize isInFavorites = _isInFavorites;
@synthesize labelString = _labelString;
@synthesize alert = _alert;
@synthesize loadingView = _loadingView;
@synthesize loggedInUser = _loggedInUser;
@synthesize facebookView = _facebookView;
@synthesize fbProfilePictureView = _fbProfilePictureView;
@synthesize loginview = _loginview;
@synthesize postOnWallButton = _postOnWallButton;
@synthesize tellFriendButton = _tellFriendButton;
@synthesize indicator = _indicator;
@synthesize textView = _textView;
@synthesize titleAddetItemToTheCart = _titleAddetItemToTheCart;

//titles
@synthesize titleWihtDiscounts = _titleWihtDiscounts;
@synthesize titleCancel = _titleCancel;
@synthesize titleYES = _titleYES;
@synthesize titleNO = _titleNO;
@synthesize titleDoYouWantDeleteItemFromCart = _titleDoYouWantDeleteItemFromCart;

- (void)setProduct:(ProductDataStruct *)product isFromFavorites:(BOOL)boolValue
{
    _product = product;
    self.isInFavorites = boolValue;
}

-(void)setLabelOfAddingButtonWithString:(NSString *)labelString withIndexPathInDB:(NSIndexPath *)indexPath
{
    self.labelString = labelString;
    [_product setCount:[NSNumber numberWithInt:0]];
}

- (IBAction)share:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
    [actionSheet setTitle:self.shareButton.titleLabel.text];
    [actionSheet setDelegate:(id)self];
    [actionSheet addButtonWithTitle:@"Twitter"];
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:self.view];
}

- (IBAction)showOrHidePictureViewContainer:(id)sender {
    if (!isPictureViewContanerShow) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.pictureViewContainer.frame = CGRectMake(35, -180, 250, 240);
        [UIView commitAnimations];
        
        [self.scrollView setHidden:NO];
        
        isPictureViewContanerShow = YES;
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.pictureViewContainer.frame = CGRectMake(35, 0, 250, 240);
        [UIView commitAnimations];

        isPictureViewContanerShow = NO;
    }
}

- (IBAction)dragPictureViewContainer:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.view];
    //    translation.y
    sender.view.center = CGPointMake(sender.view.center.x, sender.view.center.y + translation.y);
    
    if (sender.view.center.y >= 120) {
        sender.view.center = CGPointMake(sender.view.center.x, 120);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        isPictureViewContanerShow = NO;
    } else if (sender.view.center.y <= -60) {
        sender.view.center = CGPointMake(sender.view.center.x, -60);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        //        [self.scrollView setHidden:NO];
        
        isPictureViewContanerShow = YES;
        
    } else {
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        isPictureViewContanerShow = NO;
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Twitter");
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"I like %@ from www.matrix-soft.org =)", self.product.title]];
            
            [self presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }

    }
    if (buttonIndex == 1)
    {
//        self.facebookView = [[UIView alloc] initWithFrame:CGRectMake(0,110, 320, 350)];
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        if (!self.facebookView)
        {
            self.facebookView = [[UIView alloc] initWithFrame:self.view.frame];
            self.facebookView.backgroundColor = [UIColor whiteColor];
        }
//        UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(self.facebookView.bounds.origin.x, self.facebookView.bounds.origin.y, self.facebookView.bounds.size.width/2, self.facebookView.bounds.size.height)];
        


        if (!self.loginview)
        {
//            if ([[FBSession activeSession] isOpen])
//            {
////                [[FBSession activeSession] close];
//                //_loginview = nil;
//                self.loginview = [[FBLoginView alloc] init];
//            }
//            else
//            {
            self.loginview = [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"status_update"]];
//            }
            self.loginview.frame = CGRectOffset(self.loginview.frame, 5, 5);
            self.loginview.delegate = self;
            [self.loginview sizeToFit];
            [self.facebookView addSubview:self.loginview];
        }
        
        
        if (!self.fbProfilePictureView)
        {
            self.fbProfilePictureView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(20, 70, 100, 100)];
            [self.facebookView addSubview:self.fbProfilePictureView];
        }
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(127, 70, 173, 100)];
        [self.facebookView addSubview:self.textView];
        self.textView.text = [NSString stringWithFormat:@"I like %@ from www.matrix-soft.org =)", self.product.title];
        [self.textView setReturnKeyType:UIReturnKeyDone];
        [self.textView setDelegate:self];
        [self.textView.layer setBorderColor:[[UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:182.0f/255.0f alpha:1.0f] CGColor]];
        [self.textView.layer setBorderWidth:2];
        [self.textView.layer setCornerRadius:2];
        
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(280, 0, 35, 35);
        [exitButton setImage:[UIImage imageNamed:@"close_x.png"] forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(removeMySelf) forControlEvents:UIControlEventTouchUpInside];
        [self.facebookView addSubview:exitButton];
        
        self.postOnWallButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.postOnWallButton.frame = CGRectMake(84, 307, 150, 37);
        [self.postOnWallButton setTitle:@"Post on timeline" forState:UIControlStateNormal];
        [self.postOnWallButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self.postOnWallButton addTarget:self action:@selector(postOnWall) forControlEvents:UIControlEventTouchUpInside];
        [self.facebookView addSubview:self.postOnWallButton];
        
//        self.tellFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        self.tellFriendButton.frame = CGRectMake(84, 357, 150, 37);
//        [self.tellFriendButton setTitle:@"Tell a Friend" forState:UIControlStateNormal];
//        [self.tellFriendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//        self.tellFriendButton.titleLabel.textColor = [UIColor blueColor];
//        self.tellFriendButton.titleLabel.textAlignment = UITextAlignmentCenter;
//        [self.tellFriendButton addTarget:self action:@selector(tellFriend) forControlEvents:UIControlEventTouchUpInside];
//        [self.facebookView addSubview:self.tellFriendButton];

        NSLog(@"Facebook");

        [self.view addSubview:self.facebookView];
    }
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


//////////////////////
#pragma mark FACEBOOK
//////////////////////


- (void)removeMySelf
{
    [self.facebookView removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.indicator)
        [self.indicator stopAnimating];
}

- (void) postOnWall
{
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.frame = self.facebookView.frame;
    [self.facebookView addSubview:self.indicator];
    [self.indicator startAnimating];
    
    NSString *message = self.textView.text;
    //[NSString stringWithFormat:@"I like %@ from www.matrix-soft.org =)", self.product.title];
    
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    
                                    [self showAlert:message result:result error:error];
                                }];
}

- (void) tellFriend
{
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed) {
         if (!donePressed) {
             [self performSelector:@selector(removeMySelf)];
             return;
         }
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }
         
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];

}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    self.alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [self.alert show];
    [self performSelector:@selector(removeMySelf)];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"In");
    self.tellFriendButton.enabled = YES;
    self.postOnWallButton.enabled = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"Out");
    self.tellFriendButton.enabled = NO;
    self.postOnWallButton.enabled = NO;
    self.fbProfilePictureView.profileID = nil;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
//    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    
    
    self.fbProfilePictureView.profileID = user.id;
    self.loggedInUser = user;
}

- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setAllTitlesOnThisPage];
    
//    self.captionLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.captionLabel.layer.borderWidth = 2.0;
//    
//    self.nilCaption.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.nilCaption.layer.borderWidth = 2.0;
//    
//    self.proteinLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.proteinLabel.layer.borderWidth = 2.0;
//    
//    self.fatLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.fatLabel.layer.borderWidth = 2.0;
//    
//    self.carbohydratesLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.carbohydratesLabel.layer.borderWidth = 2.0;
//    
//    self.kCalLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.kCalLabel.layer.borderWidth = 2.0;
//    
//    self.portionLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.portionLabel.layer.borderWidth = 2.0;
//    
//    self.portionProteinLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.portionProteinLabel.layer.borderWidth = 2.0;
//    
//    self.portionFatLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.portionFatLabel.layer.borderWidth = 2.0;
//    
//    self.portionCarbohydratesLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.portionCarbohydratesLabel.layer.borderWidth = 2.0;
//    
//    self.portionKCalLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.portionKCalLabel.layer.borderWidth = 2.0;
//    
//    self.in100gLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.in100gLabel.layer.borderWidth = 2.0;
//    
//    self.in100gProteinLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.in100gProteinLabel.layer.borderWidth = 2.0;
//    
//    self.in100gFatLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.in100gFatLabel.layer.borderWidth = 2.0;
//    
//    self.in100gCarbohydratesLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.in100gCarbohydratesLabel.layer.borderWidth = 2.0;
//    
//    self.in100gKCalLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.in100gKCalLabel.layer.borderWidth = 2.0;

    if (![self.db isRestaurantCanMakeOrderWithRestaurantID:[self.db fetchIdRestaurantFromIdMenu:self.product.idMenu]])
    {
        self.cartButton.hidden = YES;
        self.countPickerView.hidden = YES;
    }
    
    self.pictureViewContainer.frame = CGRectMake(35, -240, 250, 240);
    
    self.cartButton.titleLabel.textAlignment = UITextAlignmentCenter;
//    if (self.labelString)
//    {
//        [self.cartButton setTitle:self.labelString forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.cartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
//    }

    //self.navigationItem.title = self.product.title;
    self.nameLabal.text = self.product.title;
        
    self.portionProteinLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.protein.floatValue) / 100)];
    self.portionFatLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.fats.floatValue) / 100)];
    self.portionCarbohydratesLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.carbs.floatValue) / 100)];
    self.portionKCalLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.calories.floatValue) / 100)];



    
    self.in100gProteinLabel.text = [NSString stringWithFormat:@"%@",self.product.protein];
    self.in100gFatLabel.text = [NSString stringWithFormat:@"%@",self.product.fats];
    self.in100gCarbohydratesLabel.text = [NSString stringWithFormat:@"%@",self.product.carbs];
    self.in100gKCalLabel.text = [NSString stringWithFormat:@"%@",self.product.calories];
    
    self.weightLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.weightLabel.text, @" ", self.product.weight, @" g"];

    
    if ([self.product.descriptionText isEqualToString:@""]) {
        self.descriptionLabel.text = self.product.descriptionText;
    } else {
        
//        NSString *str = self.product.descriptionText;

        if (self.product.descriptionText.length < 50) {
            
            [self.scrollView setScrollEnabled:NO];

        } else {
            
            NSString *str = self.product.descriptionText;
            
            int countStr = str.length / 25;
            
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setContentSize:CGSizeMake(250, 220 + (countStr - 2) * 15)];
            [self.scrollView setShowsVerticalScrollIndicator:NO];

        }
        self.descriptionLabel.text = self.product.descriptionText;
        [self.descriptionLabel sizeToFit];
    }
    
    NSString *str = self.product.descriptionText;
    NSLog(@"Довжина стрічки = %i",[str length]);
        
	// Do any additional setup after loading the view.
    //self.countPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 63.0, 90.0)];
    self.countPickerView.frame = CGRectMake(237, 248, 63, 108);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:(self.product.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]];
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", price, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    
    NSArray *discountsArray = [self.db getArrayFromCoreDatainEntetyName:@"Discounts" withSortDescriptor:@"underbarid"];
    if (self.product.discountValue.floatValue >= 1)
    {
        for (int i = 0; i < discountsArray.count; i++)
        {
            if ([[[[discountsArray objectAtIndex:i] valueForKey:@"underbarid"] description] isEqual:self.product.discountValue])
            {
                self.product.discountValue = [[discountsArray objectAtIndex:i] valueForKey:@"value"];
                if ([[[[discountsArray objectAtIndex:i] valueForKey:@"value"] description] isEqual:@"0"])
                {
                    break;
                }
                else
                {
                    priceString = [NSString stringWithFormat:@"(<strike style=\"color:White;\">%@</strike>) %@ %@", price, [formatter stringFromNumber:[NSNumber numberWithFloat:(self.product.price.floatValue * (1 - self.product.discountValue.floatValue) * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]], [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
                }
                break;
            }
        }
    }
    else
    {
        if (self.product.discountValue.floatValue != 0)
        priceString = [NSString stringWithFormat:@"(<strike style=\"color:White;\">%@</strike>) %@ %@", price, [formatter stringFromNumber:[NSNumber numberWithFloat:(self.product.price.floatValue * (1 - self.product.discountValue.floatValue) * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]], [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    }
    
    //self.priceLabel.text = priceString;
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<html>"
                                   "<body style=\"font-family:Helvetica; font-size:14px;color:#FF7F00;text-align:left;\">"
                                   "<p>%@</p>"
                                   "</body></html>", priceString];
    
    self.priceView.opaque = NO;
    self.priceView.backgroundColor = [UIColor clearColor];
    [self.priceView loadHTMLString:htmlContentString baseURL:nil];
    
    self.imageView.frame = self.pictureButton.frame;
    
    if (self.product.image) {
        
        self.imageView.image = self.product.image;
        [self.pictureButton addSubview:self.imageView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.pictureViewContainer.frame = CGRectMake(35, 0, 250, 240);
        [UIView commitAnimations];
        
        [self.scrollView setHidden:NO];

        
    } else {
        if (checkConnection.hasConnectivity) {
            
            self.loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0, 230, 250, 240)];
            self.loadingView.textLabel.text = @"";
            self.loadingView.backgroundColor = [UIColor clearColor];
            self.loadingView.activityIndicatorView.color = [UIColor whiteColor];
            self.loadingView.textLabel.textColor = [UIColor whiteColor];
            [self.pictureButton addSubview:self.loadingView];
        }
    }
    
    if (self.product.hit.integerValue == 1)
    {
        [self.imageView.layer addSublayer:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HIT1.png"]].layer];
    }
    else
        if (self.product.hit.integerValue == 2)
        {
            [self.imageView.layer addSublayer:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New1.png"]].layer];
        }
        
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    if(self.product.isFavorites.boolValue)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    if (!self.product.image && isDownloadingPicture == NO && checkConnection.hasConnectivity)
    {
        isDownloadingPicture = YES;
        [self performSelectorInBackground:@selector(downloadingPic) withObject:nil];
    }
}

- (void)downloadingPic
{
    NSURL *url = [self.db fetchImageURLbyPictureID:self.product.idPicture];
    NSData *dataOfPicture = [NSData dataWithContentsOfURL:url];
    [self.db SavePictureToCoreData:self.product.idPicture toData:dataOfPicture];
    self.product.image  = [UIImage imageWithData:dataOfPicture];
    self.imageView.image = self.product.image;
    [self.loadingView removeFromSuperview];
    [self.imageView reloadInputViews];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.pictureViewContainer.frame = CGRectMake(35, 0, 250, 240);
    [UIView commitAnimations];
    
    [self.scrollView setHidden:NO];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addToCart:(id)sender {
    //    ProductDataStruct *offer;
    //    NSMutableDictionary *offers;
    //    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"offers"])
    //    {
    //        offers = [[NSMutableDictionary alloc] init];
    //    }
    //    else {
    //        offers = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"offers"]];
    //    }
    //    if(![offers objectForKey:self.product.productId])
    //    {
    //        //[offer setObject:[self.product objectForKey:@"id"] forKey:@"id"];
    //        //[offer setObject:[self.product objectForKey:@"cost"] forKey:@"cost"];
    //        //[offer setObject:[self.product objectForKey:@"name"] forKey:@"name"];
    //        offer = self.product;
    //    }
    //    else
    //    {
    //        offer = [[ProductDataStruct alloc] initWithDictionary:[offers objectForKey:self.product.productId]];
    //        int sum = offer.count.integerValue + self.product.count.integerValue;
    //        offer.count = [NSNumber numberWithInt:sum];
    //    }
    //    [offers setObject:offer.getDictionaryDependOnDataStruct forKey:self.product.productId];
    //    [[NSUserDefaults standardUserDefaults] setObject:offers forKey:@"offers"];
    //    if([[NSUserDefaults standardUserDefaults] synchronize])
    //    {
    //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Количества товара \"%@\" в корзине %@ шт.", offer.title, offer.count] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //        [alert show];
    //        [[self navigationController] popViewControllerAnimated:YES];
    //    }
    
    if (self.product.count.intValue == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:self.titleDoYouWantDeleteItemFromCart, self.product.title]
                                                       delegate:self
                                              cancelButtonTitle:self.titleYES
                                              otherButtonTitles:self.titleNO, nil];
        [alert show];
        isDeletingFromCart = YES;
        
    }
    else
    {
        [self.db SaveProductToEntityName:@"Cart" WithId:self.product.productId
                               withCount:self.product.count.integerValue
                               withPrice:self.product.price.floatValue
                             withPicture:UIImagePNGRepresentation(self.product.image)
                       withDiscountValue:self.product.discountValue.floatValue
                              withWeight:self.product.weight
                             withProtein:self.product.protein withCarbs:self.product.carbs
                                withFats:self.product.fats
                            withCalories:self.product.calories
                             isFavorites:self.product.isFavorites.boolValue
                                   isHit:NO
                              withIdMenu:self.product.idMenu];
        
        self.alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:self.titleAddetItemToTheCart,self.product.count.integerValue, self.product.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [self. alert show];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && isDeletingFromCart == YES)
    {
        [self.db deleteObjectFromEntity:@"Cart" withProductId:self.product.productId];
        NSLog(@"deleted");
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (IBAction)AddToFavorites:(id)sender
{
    // add to favorites here
    id currentOne = self.product;
    //changing is database
    [self.db changeFavoritesBoolValue:![[currentOne isFavorites] boolValue] forId:[currentOne productId]];
    //changing in Array
    [currentOne setIsFavorites:[NSNumber numberWithBool:![[currentOne isFavorites] boolValue]]];
    
    if ([currentOne isFavorites].boolValue)
    {
        self.alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:[NSString stringWithFormat:@"Added \"%@\" to favorites.", [currentOne title]]
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    }
    else
    {
        self.alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:[NSString stringWithFormat:@"Removed \"%@\" from favorites.", [currentOne title]]
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    }
    
    [self.alert show];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];

}

- (void) dismiss
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    [self setAlert:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([[FBSession activeSession] isOpen])
    {
        [[FBSession activeSession] close];
        
        //An instance 0x1001e130 of class FBSession was deallocated while key value observers were still registered with it. Observation info was leaked, and may even become mistakenly attached to some other object. Set a breakpoint on NSKVODeallocateBreak to stop here in the debugger. Here's the current observation info:
    }
}

- (void)viewDidUnload
{
    [self setCountPickerView:nil];
    //[self setPriceLabel:nil];
    [self setPriceView:nil];
    [self setCartButton:nil];
//    [self setProductImage:nil];
    [self setShareButton:nil];
    [self setNameLabal:nil];
    [self setAlert:nil];
    
    [self setLoadingView:nil];
    [self setDb:nil];
    [self setProduct:nil];
    
    [self setLoggedInUser:nil];
    [self setFacebookView:nil];
    [self setFbProfilePictureView:nil];
    [self setLoginview:nil];
    [self setPostOnWallButton:nil];
    [self setTellFriendButton:nil];

    [self setPictureViewContainer:nil];
    [self setPictureButton:nil];
    [self setImageView:nil];
    [self setScrollView:nil];
    [self setCaptionLabel:nil];
    [self setNilCaption:nil];
    [self setProteinLabel:nil];
    [self setFatLabel:nil];
    [self setCarbohydratesLabel:nil];
    [self setKCalLabel:nil];
    [self setPortionLabel:nil];
    [self setPortionProteinLabel:nil];
    [self setPortionFatLabel:nil];
    [self setPortionCarbohydratesLabel:nil];
    [self setPortionKCalLabel:nil];
    [self setIn100gLabel:nil];
    [self setIn100gProteinLabel:nil];
    [self setIn100gFatLabel:nil];
    [self setIn100gCarbohydratesLabel:nil];
    [self setIn100gKCalLabel:nil];
    [self setDescriptionLabel:nil];
    [self setWeightLabel:nil];
    [self setFavoritesButton:nil];
    [self setPriceView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.labelString)
        return 21;
    else
        return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowNumber;
    if (self.labelString)
    {
        rowNumber = [[NSString alloc] initWithFormat:@"%i", row];
    }
    else
    {
        rowNumber = [[NSString alloc] initWithFormat:@"%i", row+1];
    }
    return rowNumber;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.labelString)
        self.product.count = [NSNumber numberWithInt:row];
    else 
        self.product.count = [NSNumber numberWithInt:row+1];
}


#pragma mark
#pragma mark PRIVATE METHODS

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"the nutritional values"])
        {
            self.captionLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"portion"])
        {
            self.portionLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"protein"])
        {
            self.proteinLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"in 100g"])
        {
            self.in100gLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"fat"])
        {
            self.fatLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"carbohydrate"])
        {
            self.carbohydratesLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Weight"])
        {
            self.weightLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Add favorites"])
        {
            self.favoritesButton.title = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if (!self.labelString && [[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Add to Cart"])
        {
            [self.cartButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if (self.labelString && [[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Change"])
        {
            [self.cartButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Share"])
        {
            [self.shareButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"with discount"])
        {
            self.titleWihtDiscounts = [[array objectAtIndex:i] valueForKey:@"title"];
        }

        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cancel"])
        {
            self.titleCancel = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Added %i item(s) %@ to the Cart."])
        {
            self.titleAddetItemToTheCart = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Do you want to delete item %@"])
        {
            self.titleDoYouWantDeleteItemFromCart = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"YES"])
        {
            self.titleYES = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"NO"])
        {
            self.titleNO = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Loading..."])
        {
            self.loadingView.textLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    }
}


@end
