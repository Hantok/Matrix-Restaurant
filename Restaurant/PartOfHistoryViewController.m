//
//  PartOfHistoryViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 30.08.12.
//
//

#import "PartOfHistoryViewController.h"

@interface PartOfHistoryViewController ()

@property BOOL isInfoOfOrderShow;
@property BOOL isInfoOfProductInOrder;

@property float firstContainerX;
@property float firstContainerY;
@property float firstContainerWidth;
@property float firstContainerHeight;

@property float secondContainerX;
@property float secondContainerY;
@property float secondContainerWidth;
@property float secondContainerHeight;

@property float tempFirstContainerY;

@end

@implementation PartOfHistoryViewController
@synthesize messageLabel = _messageLabel;
@synthesize rowNumber = _rowNumber;
@synthesize tempStr = _tempStr;
@synthesize scrollView = _scrollView;
@synthesize infoOfOrderContainer = _infoOfOrderContainer;
@synthesize mainView = _mainView;
@synthesize infoOfOrderContainerInnerView = _infoOfOrderContainerInnerView;
@synthesize showOrHideButtonFirst = _showOrHideButtonFirst;
@synthesize infoOfOrderDetailView = _infoOfOrderDetailView;
@synthesize tempLabel = _tempLabel;
@synthesize infoOfProductInOrderContainer = _infoOfProductInOrderContainer;
@synthesize infoOfProductInOrderInnerView = _infoOfProductInOrderInnerView;
@synthesize showOrHideButtonSecond = _showOrHideButtonSecond;
@synthesize infoOfProductInOrderDetailView = _infoOfProductInOrderDetailView;
@synthesize tempLabel2 = _tempLabel2;
@synthesize isInfoOfOrderShow = _isInfoOfOrderShow;
@synthesize firstContainerX = _firstContainerX;
@synthesize firstContainerY = _firstContainerY;
@synthesize firstContainerWidth = _firstContainerWidth;
@synthesize firstContainerHeight = _firstContainerHeight;
@synthesize secondContainerX = _secondContainerX;
@synthesize secondContainerY = _secondContainerY;
@synthesize secondContainerWidth = _secondContainerWidth;
@synthesize secondContainerHeight = _secondContainerHeight;
@synthesize tempFirstContainerY = _tempFirstContainerY;

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
    self.messageLabel.text = self.tempStr;
    
    [super viewDidLoad];
        
    CAGradientLayer *mainGradient = [CAGradientLayer layer];
    mainGradient.frame = self.mainView.bounds;
    mainGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.mainView.layer insertSublayer:mainGradient atIndex:0];
    
    self.firstContainerX = self.infoOfOrderContainer.frame.origin.x;
    self.firstContainerY = self.infoOfOrderContainer.frame.origin.y;
    self.firstContainerWidth = self.infoOfOrderContainer.frame.size.width;
    self.firstContainerHeight = self.infoOfOrderContainer.frame.size.height;
        
    self.secondContainerX = self.infoOfProductInOrderContainer.frame.origin.x;
    self.secondContainerY = self.infoOfProductInOrderContainer.frame.origin.y;
    self.secondContainerWidth = self.infoOfProductInOrderContainer.frame.size.width;
    self.secondContainerHeight = self.infoOfProductInOrderContainer.frame.size.height;
    
    self.infoOfOrderContainerInnerView.frame = CGRectMake(0, 1, self.firstContainerWidth, self.firstContainerHeight - 2);
    [self.tempLabel sizeToFit];
    self.infoOfOrderDetailView.frame = CGRectMake(20, 30, 272, self.tempLabel.frame.size.height + 10);
    
    self.infoOfProductInOrderInnerView.frame = CGRectMake(0, 1, self.secondContainerWidth, self.secondContainerHeight - 2);
    [self.tempLabel2 sizeToFit];
    self.infoOfProductInOrderDetailView.frame = CGRectMake(20, 30, 272, self.tempLabel2.frame.size.height + 10);
            
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320 , 420)];
    
}

- (void)viewDidUnload
{
    [self setMessageLabel:nil];
    [self setScrollView:nil];
    [self setInfoOfOrderContainer:nil];
    [self setMainView:nil];
    [self setInfoOfOrderContainerInnerView:nil];
    [self setShowOrHideButtonFirst:nil];
    [self setInfoOfOrderDetailView:nil];
    [self setTempLabel:nil];
    [self setInfoOfProductInOrderContainer:nil];
    [self setInfoOfProductInOrderInnerView:nil];
    [self setShowOrHideButtonSecond:nil];
    [self setInfoOfProductInOrderDetailView:nil];
    [self setTempLabel2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showOrHideInfoOfOrder:(id)sender
{
    
    if (!self.isInfoOfOrderShow) {
        UIImage *img = [UIImage imageNamed:@"buttonPlayDown.png"];
        [self.showOrHideButtonFirst setImage:img forState:UIControlStateNormal];
                
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.infoOfOrderContainer.frame = CGRectMake(self.firstContainerX, self.firstContainerY, self.firstContainerWidth, self.infoOfOrderDetailView.frame.size.height + 60);
        
        self.tempFirstContainerY = self.infoOfProductInOrderContainer.frame.origin.y;
        
        if (!self.isInfoOfProductInOrder) {
            self.infoOfProductInOrderContainer.frame = CGRectMake(self.secondContainerX, self.firstContainerY + self.infoOfOrderContainer.frame.size.height - 1, self.secondContainerWidth, self.secondContainerHeight);
            [UIView commitAnimations];
        } else {
            self.infoOfProductInOrderContainer.frame = CGRectMake(self.secondContainerX, self.firstContainerY + self.infoOfOrderContainer.frame.size.height - 1, self.secondContainerWidth, self.infoOfProductInOrderDetailView.frame.size.height + 60);
            [UIView commitAnimations];
        }
                        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.7];
        [self.infoOfOrderDetailView setAlpha:1];
        [UIView commitAnimations];

        self.isInfoOfOrderShow = YES;
    } else {
        UIImage *img = [UIImage imageNamed:@"buttonPlayRight.png"];
        [self.showOrHideButtonFirst setImage:img forState:UIControlStateNormal];
        
        if (!self.isInfoOfProductInOrder) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            self.infoOfOrderContainer.frame = CGRectMake(self.firstContainerX, self.firstContainerY, self.firstContainerWidth, self.firstContainerHeight);
            self.infoOfProductInOrderContainer.frame = CGRectMake(self.secondContainerX, self.tempFirstContainerY, self.secondContainerWidth, self.secondContainerHeight);
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            self.infoOfOrderContainer.frame = CGRectMake(self.firstContainerX, self.firstContainerY, self.firstContainerWidth, self.firstContainerHeight);
            self.infoOfProductInOrderContainer.frame = CGRectMake(self.secondContainerX, self.tempFirstContainerY, self.secondContainerWidth, self.infoOfProductInOrderDetailView.frame.size.height + 60);
            [UIView commitAnimations];
        }
                
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [self.infoOfOrderDetailView setAlpha:0];
        [UIView commitAnimations];

        self.isInfoOfOrderShow = NO;
    }

}

- (IBAction)infoOfProductInOrder:(id)sender
{
    if (!self.isInfoOfProductInOrder) {
        UIImage *img = [UIImage imageNamed:@"buttonPlayDown.png"];
        [self.showOrHideButtonSecond setImage:img forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.infoOfProductInOrderContainer.frame = CGRectMake(self.secondContainerX, self.firstContainerY + self.infoOfOrderContainer.frame.size.height - 1, self.secondContainerWidth, self.infoOfProductInOrderDetailView.frame.size.height + 60);
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.7];
        [self.infoOfProductInOrderDetailView setAlpha:1];
        [UIView commitAnimations];
        
        self.isInfoOfProductInOrder = YES;
    } else {
        UIImage *img = [UIImage imageNamed:@"buttonPlayRight.png"];
        [self.showOrHideButtonSecond setImage:img forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8];
        self.infoOfProductInOrderContainer.frame = CGRectMake(self.secondContainerX, self.firstContainerY + self.infoOfOrderContainer.frame.size.height - 1, self.secondContainerWidth, self.secondContainerHeight);
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [self.infoOfProductInOrderDetailView setAlpha:0];
        [UIView commitAnimations];

        self.isInfoOfProductInOrder = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
