//
//  ReservationViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 8/2/12.
//
//

#import "ReservationViewController.h"

@interface ReservationViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation ReservationViewController

@synthesize name;
@synthesize  numberPeople;
@synthesize date;
@synthesize datePicker;

@synthesize tapRecognizer;


-(void) keyboardWillShow:(NSNotification *) note
{
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self navigationController] popViewControllerAnimated:YES];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
