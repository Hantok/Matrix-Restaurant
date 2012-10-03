//
//  PartOfHistoryViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 30.08.12.
//
//

#import "PartOfHistoryViewController.h"
#import "ProductDescriptionViewCell.h"

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
@synthesize historyDictionary = _historyDictionary;
@synthesize addressLabel = _addressLabel;
@synthesize cityLabel = _cityLabel;
@synthesize metroLabel = _metroLabel;
@synthesize additionalLabel = _additionalLabel;
@synthesize addressDescriptionLabel = _addressDescriptionLabel;
@synthesize cityDescriptionLabel = _cityDescriptionLabel;
@synthesize metroDescriptionLabel = _metroDescriptionLabel;
@synthesize additionalDescriptionLabel = _additionalDescriptionLabel;
@synthesize db = _db;
@synthesize productName = _productName;
@synthesize productsArray = _productsArray;
@synthesize orderNumberLabel = _orderNumberLabel;

- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
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
                    
    CAGradientLayer *mainGradient = [CAGradientLayer layer];
    mainGradient.frame = self.mainView.bounds;
    mainGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.mainView.layer insertSublayer:mainGradient atIndex:0];
    
    [self.orderNumberLabel setText:[NSString stringWithFormat:@"%@ %@", [self.orderNumberLabel text], [self.historyDictionary valueForKey:@"orderID"]]];
    
    self.firstContainerX = self.infoOfOrderContainer.frame.origin.x;
    self.firstContainerY = self.infoOfOrderContainer.frame.origin.y;
    self.firstContainerWidth = self.infoOfOrderContainer.frame.size.width;
    self.firstContainerHeight = self.infoOfOrderContainer.frame.size.height;
        
    self.secondContainerX = self.infoOfProductInOrderContainer.frame.origin.x;
    self.secondContainerY = self.infoOfProductInOrderContainer.frame.origin.y;
    self.secondContainerWidth = self.infoOfProductInOrderContainer.frame.size.width;
    self.secondContainerHeight = self.infoOfProductInOrderContainer.frame.size.height;
    
    self.infoOfOrderContainerInnerView.frame = CGRectMake(0, 1, self.firstContainerWidth, self.firstContainerHeight - 2);
//    self.infoOfOrderDetailView.frame = CGRectMake(20, 30, 272, self.tempLabel.frame.size.height + 10);
    self.infoOfOrderDetailView.frame = CGRectMake(15, 40, 290, self.additionalDescriptionLabel.frame.origin.y + self.additionalDescriptionLabel.frame.size.height + 10);
    
    self.infoOfProductInOrderInnerView.frame = CGRectMake(0, 1, self.secondContainerWidth, self.secondContainerHeight - 2);
//    [self.tempLabel2 sizeToFit];
//    self.infoOfProductInOrderDetailView.frame = CGRectMake(20, 30, 272, self.tempLabel2.frame.size.height + 10);
    
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320 , 420)];
    
//    self.addressDescriptionLabel.text = [self.historyDictionary valueForKey:@"street"];
        
    self.addressDescriptionLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", [self.historyDictionary valueForKey:@"street"], @", ", [self.historyDictionary valueForKey:@"house"], @"/", [self.historyDictionary valueForKey:@"room_office"]];
    self.cityDescriptionLabel.text = [self.historyDictionary valueForKey:@"city"];
    self.metroDescriptionLabel.text = [self.historyDictionary valueForKey:@"metro"];
    self.additionalDescriptionLabel.text = [self.historyDictionary valueForKey:@"additional_info"];
    
//    self.productName.text = [[[[self.productsArray objectAtIndex:0] valueForKey:@"resultArray"] objectAtIndex:1] valueForKey:@"nameText"];
//    self.productsCount.text = [[self.productsArray objectAtIndex:0] valueForKey:@"count"];
//    int productCount = [[self.historyDictionary valueForKey:@"productsCounts"] intValue];
//    float productPrice = [[[[[self.productsArray objectAtIndex:0] valueForKey:@"resultArray"] objectAtIndex:0] valueForKey:@"price"] floatValue];
//    self.productPriceSumm.text = [NSString stringWithFormat:@"%6.2f", productCount * productPrice];
    
    NSMutableArray *viewCellArray = [[NSMutableArray alloc] init];
    ProductDescriptionViewCell *viewCell;
    float viewCellSumHeight = 0;
    float totalProductPrice = 0;
    float totalProductPriceWithDiscount = 0;
    
    for (int i = 0; i < self.productsArray.count; i++) {
        if (i == 0) {
            viewCell = [[ProductDescriptionViewCell alloc] init];
            viewCell.productName.text = [[[[self.productsArray objectAtIndex:i] valueForKey:@"resultArray"] objectAtIndex:1] valueForKey:@"nameText"];
            viewCell.productCount.text = [[self.productsArray objectAtIndex:i] valueForKey:@"count"];
            int productCount = [viewCell.productCount.text intValue];
            float productPrice = [[[[[self.productsArray objectAtIndex:i] valueForKey:@"resultArray"] objectAtIndex:0] valueForKey:@"price"] floatValue] * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue];
            viewCell.productPriceSum.text = [NSString stringWithFormat:@"%6.2f %@", productCount * productPrice, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
            totalProductPrice = totalProductPrice + viewCell.productPriceSum.text.floatValue;
            float discountCoeficient = [self.db fetchDiscountByIdDiscount:[[[[self.productsArray objectAtIndex:i] valueForKey:@"resultArray"] objectAtIndex:0] valueForKey:@"idDiscount"]].floatValue;
            totalProductPriceWithDiscount = totalProductPriceWithDiscount + viewCell.productPriceSum.text.floatValue - (viewCell.productPriceSum.text.floatValue * discountCoeficient);
            [viewCell.productName sizeToFit];
            [viewCell setFrame:CGRectMake(0, 40, 272, viewCell.productName.frame.size.height)];
            [viewCell.lineSeparator setFrame:CGRectMake(199, 0, 1, viewCell.productName.frame.size.height)];
            
            viewCellSumHeight = viewCellSumHeight + viewCell.frame.size.height;
            
            [self.infoOfProductInOrderDetailView addSubview:viewCell];
            [viewCellArray addObject:viewCell];
        }
        else {
            viewCell = [[ProductDescriptionViewCell alloc] init];
            viewCell.productName.text = [[[[self.productsArray objectAtIndex:i] valueForKey:@"resultArray"] objectAtIndex:1] valueForKey:@"nameText"];
            viewCell.productCount.text = [[self.productsArray objectAtIndex:i] valueForKey:@"count"];
            int productCount = [viewCell.productCount.text intValue];
            float productPrice = [[[[[self.productsArray objectAtIndex:i] valueForKey:@"resultArray"] objectAtIndex:0] valueForKey:@"price"] floatValue] * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue];
            viewCell.productPriceSum.text = [NSString stringWithFormat:@"%6.2f %@", productCount * productPrice, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
            totalProductPrice = totalProductPrice + viewCell.productPriceSum.text.floatValue;
            float discountCoeficient = [self.db fetchDiscountByIdDiscount:[[[[self.productsArray objectAtIndex:i] valueForKey:@"resultArray"] objectAtIndex:0] valueForKey:@"idDiscount"]].floatValue;
            totalProductPriceWithDiscount = totalProductPriceWithDiscount + viewCell.productPriceSum.text.floatValue - (viewCell.productPriceSum.text.floatValue * discountCoeficient);
            [viewCell.productName sizeToFit];
            float previousY = [[viewCellArray objectAtIndex:i - 1] frame].origin.y;
            float previousH = [[viewCellArray objectAtIndex:i - 1] frame].size.height;
            [viewCell setFrame:CGRectMake(0, previousY + previousH, 272, viewCell.productName.frame.size.height)];
            [viewCell.lineSeparator setFrame:CGRectMake(199, 0, 1, viewCell.productName.frame.size.height)];
            
            viewCellSumHeight = viewCellSumHeight + viewCell.frame.size.height;

            [self.infoOfProductInOrderDetailView addSubview:viewCell];
            [viewCellArray addObject:viewCell];
        }
    }
    
    UILabel *totalPriceSumCaption = [[UILabel alloc] initWithFrame:CGRectMake(155, 40 + viewCellSumHeight + 10, 37, 15)];
    [totalPriceSumCaption setFont:[UIFont systemFontOfSize:13]];
    [totalPriceSumCaption setTextColor:[UIColor darkGrayColor]];
    [totalPriceSumCaption setBackgroundColor:[UIColor clearColor]];
    [totalPriceSumCaption setText:@"Total: "];
    [self.infoOfProductInOrderDetailView addSubview:totalPriceSumCaption];
    
    UILabel *totalPriceSumValue = [[UILabel alloc] initWithFrame:CGRectMake(totalPriceSumCaption.frame.origin.x + totalPriceSumCaption.frame.size.width, totalPriceSumCaption.frame.origin.y, 90, totalPriceSumCaption.frame.size.height)];
    totalPriceSumValue.text = [NSString stringWithFormat:@"%7.2f %@", totalProductPrice, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    [totalPriceSumValue setFont:[UIFont boldSystemFontOfSize:13]];
    [totalPriceSumValue setBackgroundColor:[UIColor clearColor]];
    [self.infoOfProductInOrderDetailView addSubview:totalPriceSumValue];
    
    UILabel *totalPriceSumWithDiscountCaption = [[UILabel alloc] initWithFrame:CGRectMake(100, totalPriceSumCaption.frame.origin.y + totalPriceSumCaption.frame.size.height, 92, totalPriceSumCaption.frame.size.height)];
    totalPriceSumWithDiscountCaption.text = @"With discounts: ";
    [totalPriceSumWithDiscountCaption setFont:[UIFont systemFontOfSize:13]];
    [totalPriceSumWithDiscountCaption setTextColor:[UIColor orangeColor]];
    [totalPriceSumWithDiscountCaption setBackgroundColor:[UIColor clearColor]];
    [self.infoOfProductInOrderDetailView addSubview:totalPriceSumWithDiscountCaption];
    
    UILabel *totalPriceSumWithDiscountValue = [[UILabel alloc] initWithFrame:CGRectMake(totalPriceSumWithDiscountCaption.frame.origin.x + totalPriceSumWithDiscountCaption.frame.size.width, totalPriceSumWithDiscountCaption.frame.origin.y, 92, totalPriceSumWithDiscountCaption.frame.size.height)];
    totalPriceSumWithDiscountValue.text = [NSString stringWithFormat:@"%7.2f %@", totalProductPriceWithDiscount, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    [totalPriceSumWithDiscountValue setFont:[UIFont boldSystemFontOfSize:13]];
    [totalPriceSumWithDiscountValue setBackgroundColor:[UIColor clearColor]];
    [self.infoOfProductInOrderDetailView addSubview:totalPriceSumWithDiscountValue];
    
    self.infoOfProductInOrderDetailView.frame = CGRectMake(15, 40, 290, totalPriceSumWithDiscountCaption.frame.origin.y + totalPriceSumWithDiscountCaption.frame.size.height + 10);
    
    int curentNumberOfStatus;
    
    for (int i = 0; [[self.db fetchAllObjectsFromEntity:@"Statuses"] count]; i++) {
        
        NSString *str1 = [[[[self.db fetchAllObjectsFromEntity:@"Statuses"] objectAtIndex:i] valueForKey:@"underbarid"] stringValue];
        NSString *str2 = [NSString stringWithFormat:@"%@", [self.historyDictionary valueForKey:@"statusID"]];
        
        if ([str1 isEqualToString:str2]) {
            curentNumberOfStatus = [[[[self.db fetchAllObjectsFromEntity:@"Statuses"] objectAtIndex:i] valueForKey:@"value"] intValue];
            break;
        }
        
    }
    
    int countOfStatus = [[self.db fetchAllObjectsFromEntity:@"Statuses"] count] - 1;
    
    NSMutableArray *arrowArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < countOfStatus; i++) {
        
        if (i == 0) {
            UIImageView *firstArrow = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 315 / countOfStatus + ((countOfStatus - 1) * 10)/countOfStatus, 15)];
            if (curentNumberOfStatus == 1) {
                [firstArrow setImage:[UIImage imageNamed:@"arrow1_green.png"]];
            } else {
                [firstArrow setImage:[UIImage imageNamed:@"arrow1_red.png"]];
            }
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstArrow.frame.origin.x, firstArrow.frame.origin.y + firstArrow.frame.size.height, firstArrow.frame.size.width, 21)];
            [statusLabel setText:@"asdfdgh"];
            [statusLabel setTextColor:[UIColor whiteColor]];
            [statusLabel setFont:[UIFont systemFontOfSize:12]];
            [statusLabel setTextAlignment:NSTextAlignmentCenter];
            [statusLabel setBackgroundColor:[UIColor clearColor]];
            [self.scrollView addSubview:statusLabel];
            [self.scrollView addSubview:firstArrow];
            [arrowArray addObject:firstArrow];
        } else {
            if (i == countOfStatus - 1) {
                UIImageView *lastArrow = [[UIImageView alloc] initWithFrame:CGRectMake([[arrowArray objectAtIndex:i - 1] frame].origin.x + [[arrowArray objectAtIndex:i - 1] frame].size.width - 10, 40, 315 / countOfStatus + ((countOfStatus - 1) * 10)/countOfStatus, 15)];
                if (curentNumberOfStatus == 0) {
                    [lastArrow setImage:[UIImage imageNamed:@"arrow3_green.png"]];
                } else {
                    [lastArrow setImage:[UIImage imageNamed:@"arrow3_red.png"]];
                }
                [self.scrollView addSubview:lastArrow];
                [arrowArray addObject:lastArrow];
            }
            else {
                UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake([[arrowArray objectAtIndex:i - 1] frame].origin.x + [[arrowArray objectAtIndex:i - 1] frame].size.width - 10, 40, 315 / countOfStatus + ((countOfStatus - 1) * 10)/countOfStatus, 15)];
                if (curentNumberOfStatus == i + 1 || curentNumberOfStatus == i + 2) {
                    [arrow setImage:[UIImage imageNamed:@"arrow2_green.png"]];
                } else {
                    [arrow setImage:[UIImage imageNamed:@"arrow2_red.png"]];
                }
                [self.scrollView addSubview:arrow];
                [arrowArray addObject:arrow];
            }
        }
                
//        if (i == 0) {
//            UIImageView *firstArrow = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 315 / countOfStatus, 10)];
//            if (i == curentNumberOfStatus - 1) {
//                [firstArrow setImage:[UIImage imageNamed:@"arrow1_green.png"]];
//            } else {
//                [firstArrow setImage:[UIImage imageNamed:@"arrow1_red.png"]];
//            }
//            [self.scrollView addSubview:firstArrow];
//            [arrowArray addObject:firstArrow];
//        } else {
//            if (i == countOfStatus - 1) {
//                UIImageView *lastArrow = [[UIImageView alloc] initWithFrame:CGRectMake([[arrowArray objectAtIndex:i - 1] frame].origin.x + [[arrowArray objectAtIndex:i - 1] frame].size.width - 10, 30, 315 / countOfStatus + 10, 10)];
//                if (i == curentNumberOfStatus - 1) {
//                    [lastArrow setImage:[UIImage imageNamed:@"arrow3_green.png"]];
//                } else {
//                    [lastArrow setImage:[UIImage imageNamed:@"arrow3_red.png"]];
//                }
//                [self.scrollView addSubview:lastArrow];
//                [arrowArray addObject:lastArrow];
//            }
//            else {
//                UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake([[arrowArray objectAtIndex:i - 1] frame].origin.x + [[arrowArray objectAtIndex:i - 1] frame].size.width - 10, 30, 315 / countOfStatus + 10, 10)];
//                if (i == curentNumberOfStatus - 1) {
//                    [arrow setImage:[UIImage imageNamed:@"arrow2_green.png"]];
//                } else {
//                    [arrow setImage:[UIImage imageNamed:@"arrow2_red.png"]];
//                }
//                [self.scrollView addSubview:arrow];
//                [arrowArray addObject:arrow];
//            }
//        }        
    }
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
    [self setInfoOfProductInOrderContainer:nil];
    [self setInfoOfProductInOrderInnerView:nil];
    [self setShowOrHideButtonSecond:nil];
    [self setInfoOfProductInOrderDetailView:nil];
    [self setTempLabel2:nil];
    [self setCityLabel:nil];
    [self setMetroLabel:nil];
    [self setAdditionalLabel:nil];
    [self setCityDescriptionLabel:nil];
    [self setMetroDescriptionLabel:nil];
    [self setAdditionalDescriptionLabel:nil];
    [self setAddressLabel:nil];
    [self setAddressDescriptionLabel:nil];
    [self setProductName:nil];
    [self setProductsCount:nil];
    [self setProductPriceSumm:nil];
    [self setOrderNumberLabel:nil];
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
