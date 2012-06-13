//
//  DeliveryViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeliveryViewController.h"

@interface DeliveryViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation DeliveryViewController
@synthesize scrollView;
@synthesize addressName;
@synthesize customerName;
@synthesize phone;
@synthesize CityName;
@synthesize metroName;
@synthesize street;
@synthesize build;
@synthesize appartaments;
@synthesize otherInformation;

@synthesize tapRecognizer = _tapRecognizer;

- (void)viewDidLoad
{
    //[super viewDidLoad];
	// Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(320, 500);

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{    
    [theTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.appartaments || textField == self.build || textField == self.street 
        || textField == self.otherInformation)
    {
        CGFloat tempy = self.scrollView.contentSize.height;//imageView.frame.size.height;
        CGFloat tempx = self.scrollView.contentSize.width;;
        CGRect zoomRect = CGRectMake((tempx/2), (tempy/2), tempy, tempx);
        [self.scrollView scrollRectToVisible:zoomRect animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phone || textField == self.build || textField == self.appartaments)
    {
        if (![[NSScanner scannerWithString:textField.text] scanInteger:nil])
        {
            [textField becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter please just numbers" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            textField.text = nil;
        }
    }
}

-(void) keyboardWillShow:(NSNotification *) note 
{
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {    
    [self.addressName resignFirstResponder];
    [self.customerName resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.CityName resignFirstResponder];
    [self.metroName resignFirstResponder];
    [self.street resignFirstResponder];
    [self.build resignFirstResponder];
    [self.appartaments resignFirstResponder];
    [self.otherInformation resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setAddressName:nil];
    [self setCustomerName:nil];
    [self setPhone:nil];
    [self setCityName:nil];
    [self setMetroName:nil];
    [self setStreet:nil];
    [self setBuild:nil];
    [self setAppartaments:nil];
    [self setOtherInformation:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)toOrder:(id)sender {
}

- (IBAction)saveAddress:(id)sender {
}
@end
