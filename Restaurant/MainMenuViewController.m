//
//  MainMenuViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MenuListTableViewController.h"
#import "CartCell.h"
#import "TotalCartCell.h"
//#import "Offers.h"
#import "GettingCoreContent.h"
#import "MenuDataStruct.h"
#import "LanguageAndCityTableViewController.h"
#import "ProductDataStruct.h"
#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "checkConnection.h"
#import "DeliveryViewController.h"
#import "PromotionStruct.h"
#import "HistoryTableListViewController.h"
#import "RestaurantViewController.h"

//first commit

@interface MainMenuViewController ()
{
    CFURLRef        soundFileURLRef;
    SystemSoundID	soundFileObject;
    BOOL            fromSettings;
    BOOL            fromDeliveriesAndDatailViewController;
    int             currentImage;
    BOOL            deliveryTime;
    BOOL            oneRestaurant;
    HistoryTableListViewController *tempHistory;
}

@property (readwrite)	CFURLRef        soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

@property (strong, nonatomic) ProductDataStruct *product;
@property (strong, nonatomic) NSMutableArray *arrayOfObjects;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic, copy) NSArray *animationImages;
@property (nonatomic,strong) UIAlertView *alert;
@property (nonatomic, strong) NSMutableArray *promotionsArray;

- (void)startIconDownload:(MenuDataStruct *)appRecord forIndexPath:(NSIndexPath *)indexPath;


//titles!!!
@property (nonatomic, weak) NSString *titleRestaurants;
@property (nonatomic, weak) NSString *titleOrder;
@property (nonatomic, weak) NSString *titleMenu;
@property (nonatomic, weak) NSString *titleCart;
@property (nonatomic, weak) NSString *titleBack;
@property (nonatomic, weak) NSString *titleFavorites;
@property (nonatomic, weak) NSString *titleTotal;
@property (nonatomic, weak) NSString *titleCount;
@property (nonatomic, weak) NSString *titleWithDiscounts;
@property (nonatomic, weak) NSString *titleChooseMethodToGetOrder;
@property (nonatomic, weak) NSString *titleDelivery;
@property (nonatomic, weak) NSString *titleDeliveryByTime;
@property (nonatomic, weak) NSString *titleCancel;
@property (nonatomic, weak) NSString *titleMain;
@property (nonatomic, weak) NSString *titleYES;
@property (nonatomic, weak) NSString *titleNO;
@property (nonatomic, weak) NSString *titleDoYouWantDeleteAllItemsFromCart;
@property (nonatomic, weak) NSString *titleNoInternet;
@property (nonatomic, weak) NSString *titleCartIsEmpty;

@end

@implementation MainMenuViewController
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;
@synthesize pickerView = _pickerView;
@synthesize menuButton = _menuButton;
@synthesize cartButton = _cartButton;
@synthesize settingsButton = _settingsButton;
@synthesize restorantsButton = _restorantsButton;
@synthesize imageButton = _imageView;
@synthesize arrayData = _arrayData;
@synthesize selectedRow = _selectedRow;
@synthesize isCartMode = _isCartMode;
@synthesize isMenuMode = _isMenuMode;
@synthesize tableView = _tableView;
@synthesize tableViewController = _tableViewController;
@synthesize delegatepV = _delegatepV;
@synthesize dataSourcepV = _dataSourcepV;
@synthesize drop = _drop;
@synthesize db = _db;
@synthesize restarauntId = _restarauntId;
@synthesize menuId = _menuId;
@synthesize soundFileURLRef;// = _soundFileURLRef;
@synthesize soundFileObject;// = _soundFileObject;
@synthesize product = _product;
@synthesize arrayOfObjects= _arrayOfObjects;
@synthesize selectedPath = _selectedPath;
@synthesize numberOfRows = _numberOfRows;
@synthesize animationImages = _animationImages;
@synthesize shouldBeReloaded = _shouldBeReloaded;
@synthesize singleMenu = _singleMenu;
@synthesize historyButton = _historyButton;
@synthesize mainView = _mainView;
@synthesize alert = _alert;
@synthesize promotionsArray = _promotionsArray;


//Titles!!!!
@synthesize titleMain = _titleMain;
@synthesize titleRestaurants = _titleRestarants;
@synthesize titleOrder = _titleOrder;
@synthesize titleMenu = _titleMenu;
@synthesize titleCart = _titleCart;
@synthesize titleBack = _titleBack;
@synthesize titleFavorites = _titleFavorites;
@synthesize titleCount = _titleCount;
@synthesize titleTotal = _titleTotal;
@synthesize titleWithDiscounts = _titleWithDiscounts;
@synthesize titleChooseMethodToGetOrder = _titleChooseMethodToGetOrder;
@synthesize titleDelivery = _titleDelivery;
@synthesize titleDeliveryByTime = _titleDeliveryByTime;
@synthesize titleCancel = _titleCancel;
@synthesize titleYES = _titleYES;
@synthesize titleNO = _titleNO;
@synthesize titleDoYouWantDeleteAllItemsFromCart = _titleDoYouWantDeleteAllItemsFromCart;
@synthesize titleNoInternet = _titleNoInternet;
@synthesize titleCartIsEmpty = _titleCartIsEmpty;


- (IBAction)drop:(id)sender {
    self.menuId = nil;
    self.restarauntId = nil;
    if (!oneRestaurant)
    {
        if(self.cartButton.isHidden)
        {
            [self.cartButton setHidden:NO];
            [self.menuButton setHidden:NO];
        }
    }
}

-(void)setRestarauntId:(NSString *)restarauntId
{
    _restarauntId = restarauntId;
    self.arrayData = nil;
    [self.pickerView reloadAllComponents];
}

-(void)setMenuId:(NSString *)menuId
{
    _menuId = menuId;
    self.arrayData = nil;
    [self.pickerView reloadAllComponents];
}

//menu
- (NSMutableArray *)arrayData
{
    if(!_arrayData)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        MenuDataStruct *dataStruct;
        NSArray *data = nil;
        if(!self.restarauntId)
        {
            data = [self.db fetchAllRestaurantsWithDefaultLanguageAndCity];
            if(data.count == 2)
            {
                self.restarauntId = [[data objectAtIndex:0] valueForKey:@"underbarid"];
                if (![self.db isRestaurantCanMakeOrderWithRestaurantID:self.restarauntId])
                {
                    [self.cartButton setHidden:YES];
                    [self.menuButton setHidden:YES];
                    oneRestaurant = YES;
                    
                }
                data = [self.db fetchRootMenuWithDefaultLanguageForRestaurant:self.restarauntId];
                data = [self.db fetchChildMenuWithDefaultLanguageForParentMenu:[[data objectAtIndex:0] valueForKey:@"underbarid"]];
            }
        }
        else
        {
            if(self.menuId)
            {
                data = [self.db fetchChildMenuWithDefaultLanguageForParentMenu:self.menuId];
            }
            else
            {
                data = [self.db fetchRootMenuWithDefaultLanguageForRestaurant:self.restarauntId];
                data = [self.db fetchChildMenuWithDefaultLanguageForParentMenu:[[data objectAtIndex:0] valueForKey:@"underbarid"]];
            }
        }
        
        for(int i=0;i<data.count;i++)
        {
            if(i%2==0)
            {
                dataStruct = [[MenuDataStruct alloc] init];
                dataStruct.menuId = [[data objectAtIndex:i] valueForKey:@"underbarid"];
                dataStruct.idPicture = [[data objectAtIndex:i] valueForKey:@"idPicture"];
                NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:dataStruct.idPicture];
                NSURL *url = [self.db fetchImageURLbyPictureID:dataStruct.idPicture];
                dataStruct.link = url.description;
                
                if(dataOfPicture)
                {
                    dataStruct.image  = [UIImage imageWithData:dataOfPicture];
                }
                //                else
                //                {
                //                    dataOfPicture = [NSData dataWithContentsOfURL:url];
                //                    [self.db SavePictureToCoreData:[[data objectAtIndex:i] valueForKey:@"idPicture"] toData:dataOfPicture];
                //                    dataStruct.image  = [UIImage imageWithData:dataOfPicture];
                //                }
                
            }
            else
            {
                if (!self.restarauntId) {
                    dataStruct.title = [[data objectAtIndex:i] valueForKey:@"name"];
                }
                else dataStruct.title = [[data objectAtIndex:i] valueForKey:@"menuText"];
                [array addObject:dataStruct];
            }
        }
        
        //сортуємо по id продукта
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"menuId" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray;
        sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
        _arrayData = [[NSMutableArray alloc] initWithArray:sortedArray];
        return _arrayData;
    }
    return _arrayData;
}

//cart
-(NSMutableArray *)arrayOfObjects
{
    if (!_arrayOfObjects || _arrayOfObjects.count != [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Cart"].count)
    {
        NSArray *array = [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Cart"];
        NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Products_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
        NSNumber *numbers;
        _arrayOfObjects = [[NSMutableArray alloc] init];
        for (int i = 0; i <array.count; i++)
        {
            ProductDataStruct *productStruct = [[ProductDataStruct alloc] init];
            //[productStruct setProductId:[[arrayOfElements objectAtIndex:i] valueForKey:@"idProduct"]];
            [productStruct setProductId:[[array objectAtIndex:i] valueForKey:@"underbarid"]];
            [productStruct setTitle:[[arrayOfElements objectAtIndex:i] valueForKey:@"nameText"]];
            [productStruct setDescriptionText:[[arrayOfElements objectAtIndex:i] valueForKey:@"descriptionText"]];
            numbers = [NSNumber numberWithFloat:([[[array objectAtIndex:i] valueForKey:@"count"] intValue]*[[[array objectAtIndex:i] valueForKey:@"cost"] floatValue])];
            [productStruct setPrice:[NSString stringWithFormat:@"%@",numbers]];
            [productStruct setImage:[UIImage imageWithData:[[array objectAtIndex:i] valueForKey:@"picture"]]];
            [productStruct setCount:[[array objectAtIndex:i] valueForKey:@"count"]];
            [productStruct setDiscountValue:[[array objectAtIndex:i] valueForKey:@"discountValue"]];
            [productStruct setWeight:[[array objectAtIndex:i] valueForKey:@"weight"]];
            [productStruct setProtein:[[array objectAtIndex:i] valueForKey:@"protein"]];
            [productStruct setCarbs:[[array objectAtIndex:i] valueForKey:@"carbs"]];
            [productStruct setFats:[[array objectAtIndex:i] valueForKey:@"fats"]];
            [productStruct setCalories:[[array objectAtIndex:i] valueForKey:@"calories"]];
            [productStruct setIdMenu:[[array objectAtIndex:i] valueForKey:@"idMenu"]];
            [_arrayOfObjects addObject:productStruct];
        }
        
        return _arrayOfObjects;
    }
    return _arrayOfObjects;
}

//promotions
- (NSMutableArray *)promotionsArray
{
    
    if (!_promotionsArray)
    {
        //отримуємо мисив з табл промотіонс
        NSArray *arrayOfPromotions = [self.db getArrayFromCoreDatainEntetyName:@"Promotions" withSortDescriptor:@"underbarid"];
        
        //отримуємо переклад згідно з поточною мовою
        NSArray *array = [self.db fetchObjectsFromCoreDataForEntity:@"Promotions_translation" withArrayObjects:arrayOfPromotions withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
        
        //сортуємо масив щоб картинки з текстом співпадали
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"IdPromotion" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *arrayOfPromotionsWithTranslation;
        arrayOfPromotionsWithTranslation = [array sortedArrayUsingDescriptors:sortDescriptors];
        
        _promotionsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrayOfPromotionsWithTranslation.count; i++)
        {
            PromotionStruct *promotion = [[PromotionStruct alloc] init];
            promotion.promotionId = [[arrayOfPromotions objectAtIndex:i] valueForKey:@"underbarid"];
            promotion.idPicture = [[arrayOfPromotions objectAtIndex:i] valueForKey:@"idPicture"];
            
            promotion.link = [self.db fetchImageStringURLbyPictureID:promotion.idPicture];
            promotion.image = [UIImage imageWithData:[self.db fetchPictureDataByPictureId:promotion.idPicture]];
            promotion.descriptionText = [[arrayOfPromotionsWithTranslation objectAtIndex:i] valueForKey:@"descriptionAbout"];
            promotion.title = [[arrayOfPromotionsWithTranslation objectAtIndex:i] valueForKey:@"title"];
            
            [_promotionsArray addObject:promotion];
        }
        return _promotionsArray;
    }
    return _promotionsArray;
}

- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
}

- (IBAction)menuButton:(id)sender {
    self.isMenuMode = YES;
    self.isCartMode = NO;
    self.menuButton.enabled = NO;
    self.cartButton.enabled = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    //UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)];
    //[self.pickerView addGestureRecognizer:tapgesture];
    
    [self.restorantsButton setTitle:self.titleRestaurants forState:UIControlStateNormal];
    
    [self.settingsButton setHidden:NO];
    [self.drop setHidden:NO];
    [self.historyButton setHidden:YES];
    
    AudioServicesPlayAlertSound(soundFileObject);
}
- (IBAction)cartButton:(id)sender {
    self.isCartMode = YES;
    self.isMenuMode = NO;
    self.menuButton.enabled = YES;
    self.cartButton.enabled = NO;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView removeGestureRecognizer:[self.pickerView.gestureRecognizers lastObject]];
    
    AudioServicesPlaySystemSound (self.soundFileObject);
    
    [self.restorantsButton setTitle:self.titleOrder forState:UIControlStateNormal];
    
    [self.settingsButton setHidden:YES];
    [self.drop setHidden:YES];
    
    int countHistory = [self.db fetchCountOfProductsInEntity:@"CustomerOrders"];
    if (countHistory != 0) {
        [self.historyButton setHidden:NO];
    }
//    [self.historyButton setHidden:NO];

}
- (IBAction)goToSettingsTableViewController:(id)sender
{
    [self performSegueWithIdentifier:@"toSettings" sender:self];
    fromSettings = YES;
}

-(void)awakeFromNib
{
    self.isMenuMode = YES;
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self somethingStupid];
    
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"Button_orange_rev2.png"] forState:UIControlStateNormal];
    
    [self.cartButton setBackgroundImage:[UIImage imageNamed:@"Button_black_light_rev2.png"] forState:UIControlStateNormal];
    
    //[self.restorantsButton setBackgroundImage:[UIImage imageNamed:@"gray button.png"] forState:UIControlStateNormal];
    self.restorantsButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    //[self.settingsButton setBackgroundImage:[UIImage imageNamed:@"blank-gray-button-md.png"] forState:UIControlStateNormal];
    
    CALayer *layerMenu = self.menuButton.layer;
    [layerMenu setCornerRadius:10.0f];
    //layerMenu.masksToBounds = YES;
    //[layerMenu setBorderWidth:0.0f];
    
    
    CALayer *layerCart = self.cartButton.layer;
    layerCart.cornerRadius = 10.0f;
    //layerCart.masksToBounds = YES;
    //layerCart.borderWidth = 0.0f;
    //layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    CALayer *layerRest = self.restorantsButton.layer;
    layerRest.cornerRadius = 8.0f;
    //layerRest.masksToBounds = YES;
    //layerRest.borderWidth = 5.0f;
    //[layerRest setBorderColor:[UIColor grayColor].CGColor];
    
    //    CALayer *layerSett = self.settingsButton.layer;
    //    layerSett.cornerRadius = 9.0f;
    //    //layerSett.masksToBounds = YES;
    //    layerSett.borderWidth = 1.0f;
    //    [layerSett setBorderColor:[UIColor grayColor].CGColor];
    //    [layerSett setBackgroundColor:[UIColor grayColor].CGColor];
    
    [self menuButton:self];
    
    if(!self.isCartMode)
    {
        self.isMenuMode = YES;
    }
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.promotionsArray.count; i++)
    {
        PromotionStruct *promotion = [self.promotionsArray objectAtIndex:i];
        if (![promotion image])
        {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[promotion link]]];
            UIImage *image = [UIImage imageWithData: imageData];
            [promotion setImage:image];
            [self.db SavePictureToCoreData:[promotion idPicture] toData:imageData];
            [imageArray addObject:image];
        }
        else
        {
            [imageArray addObject:[promotion image]];
        }
    }
//    NSArray * imageArray  = [NSArray arrayWithObjects:
//                             [UIImage imageNamed:@"1.jpg"],
//                             [UIImage imageNamed:@"2.jpg"], nil];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.imageButton.frame];
    imageView.animationImages = imageArray;
    imageView.animationDuration = self.promotionsArray.count * 4.0;
    [NSTimer scheduledTimerWithTimeInterval:4.0
                                     target:self
                                   selector:@selector(changingAnimation)
                                   userInfo:nil
                                    repeats:YES];
    currentImage = 0;
    [imageView startAnimating];
    
    [self.imageButton addSubview:imageView];
    
    //    self.imageButton.imageView.animationImages = imageArray;
    //    self.imageButton.imageView.animationDuration = 4.0;
    //    self.imageButton.contentMode = UIViewContentModeRedraw;
    //    [self.imageButton.imageView startAnimating];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)somethingStupid
{
    [self setAllTitlesOnThisPage];
    
    self.navigationItem.title = @"<-"; //@"Main";
    
    [self.menuButton setTitle:self.titleMenu forState:UIControlStateNormal];
    [self.cartButton setTitle:self.titleCart forState:UIControlStateNormal];
    [self.drop setTitle:self.titleBack forState:UIControlStateNormal];
    
    [self.pickerView reloadAllComponents];
}

- (void)changingAnimation
{
    if (currentImage < self.promotionsArray.count - 1)
    {
        currentImage++;
    }
    else
    {
        currentImage = 0;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    if (self.isCartMode == YES && [[self.db getArrayFromCoreDatainEntetyName:@"CustomerOrders" withSortDescriptor:@"name"] count] != 0) {
        [self.historyButton setHidden:NO];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    [self arrayData];
    if (fromSettings)
    {
        //_arrayData = nil;
        self.menuId = nil;
        self.restarauntId = nil;
        fromSettings = NO;
    }
    else if (fromDeliveriesAndDatailViewController)
    {
        [self.pickerView reloadAllComponents];
    }
    
    if (!animated)
    {
        //        self.isMenuMode = NO;
        //        self.isCartMode = YES;
        [self performSelector:@selector(cartButton:)withObject:nil];
    }
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    //    {
    // back button was pressed.  We know this is true because self is no longer
    // in the navigation stack.
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    //    }
    
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (oneRestaurant)
        self.arrayData = nil;
    
    //лол =)
    [self somethingStupid];
    
    if(self.isMenuMode)
    {
        [self.restorantsButton setTitle:self.titleRestaurants forState:UIControlStateNormal];
    }
    else
    {
        self.arrayOfObjects = nil;
        //[self.pickerView reloadAllComponents];
        [self.restorantsButton setTitle:self.titleOrder forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)viewSpam:(id)sender
{
    NSLog(@"current image %i", currentImage);
    
    //    subViewSpam *subView = [[subViewSpam alloc] initWithFrame:self.view.frame];
    //    subView.imageView.image = [UIImage imageNamed:@"11.gif"];
    //    [subView.imageView setImage:[UIImage imageNamed:@"11.gif"]];
    //    subView.label.text = [NSString stringWithFormat:@"current image %i", currentImage];
    //    [self.view addSubview:subView];
    
    subViewSpam *subView;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"subViewSpam" owner:nil options:nil];
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[subViewSpam class]])
        {
            subView = (subViewSpam *)currentObject;
            break;
        }
    }
//    int i = currentImage - 1;
    [subView.imageView setImage:[[self.promotionsArray objectAtIndex:currentImage] image]];
    subView.label.text = [[self.promotionsArray objectAtIndex:currentImage] title];
    subView.textView.text = [[self.promotionsArray objectAtIndex:currentImage] descriptionText];
    [self.view addSubview:subView];
}

- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setMenuButton:nil];
    [self setCartButton:nil];
    [self setSettingsButton:nil];
    [self setRestorantsButton:nil];
    [self setDrop:nil];
    [self setImageButton:nil];
    
    //custom
    [self setDb:nil];
    [self setTableView:nil];
    [self setTableViewController:nil];
    [self setPickerView:nil];
    [self setAlert:nil];
    [self setHistoryButton:nil];
    [self setMainView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark - pickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //self.arrayData = nil;
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.isMenuMode)
    {
        return 1;//self.arrayData.count + 1;
    }
    else
    {
        return 1;
    };
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(self.isCartMode)
    {
        if (self.arrayOfObjects.count == 0)
        {
            PickerViewCell *viewForRow;
            UIImageView *one = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cart1.PNG"]];
            //            one.frame = self.pickerView.frame;
            //            one.frame = CGRectMake(self.pickerView.frame.origin.x + 100, self.pickerView.frame.origin.y + 100, self.pickerView.frame.size.width,self.pickerView.frame.size.height);
            
            //NSArray* ballsArray = [NSArray arrayWithObjects:one, nil];
            viewForRow = (PickerViewCell *)one;
            return viewForRow;
        }
        else
        {
            self.tableView = [[UITableView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 216)];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.backgroundColor = [UIColor clearColor];
            return self.tableView;
            //[[[[NSUserDefaults standardUserDefaults] objectForKey:@"offers"] objectAtIndex:row] objectForKey:@"id"];
        }
    }
    else
    {
        self.tableView = [[UITableView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 216)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        return self.tableView;
        //        if (row == 0)
        //        {
        //            PickerViewCell *viewForRow;
        //            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickerViewCell" owner:nil options:nil];
        //            for(id currentObject in topLevelObjects)
        //            {
        //                if([currentObject isKindOfClass:[PickerViewCell class]])
        //                {
        //                    viewForRow = (PickerViewCell *)currentObject;
        //                    break;
        //                }
        //            }
        //
        //            viewForRow.menuTitle.text = @"Favorites";
        //            viewForRow.menuImage.image = [UIImage imageNamed:@"Heart.png"];
        //
        //            return viewForRow;
        //        }
        //        else
        //        {
        //            MenuDataStruct *dataStruct = [self.arrayData objectAtIndex:row-1];
        //
        //            //UIView *viewForRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pickerView.frame.size.width-30, self.pickerView.frame.size.height/5)];
        //            //NSLog(@"%f", viewForRow.frame.size.width);
        //            //NSLog(@"%f", viewForRow.frame.size.height);
        //            //UIImage *imageForUIImageView  = dataStruct.image;
        //            //UIImageView *imageViewForViewForRow = [[UIImageView alloc] initWithImage:imageForUIImageView];
        //            //UILabel *labelForRow = [[UILabel alloc] initWithFrame:CGRectMake(imageViewForViewForRow.frame.size.width, 5, self.pickerView.frame.size.width-30, pickerView.frame.size.height/5)];
        //            //labelForRow.text = dataStruct.title;
        //            //[viewForRow addSubview:imageViewForViewForRow];
        //            //[viewForRow addSubview:labelForRow];
        //            PickerViewCell *viewForRow;
        //            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickerViewCell" owner:nil options:nil];
        //            for(id currentObject in topLevelObjects)
        //            {
        //                if([currentObject isKindOfClass:[PickerViewCell class]])
        //                {
        //                    viewForRow = (PickerViewCell *)currentObject;
        //                    break;
        //                }
        //            }
        //            viewForRow.menuImage.image = dataStruct.image;
        //            viewForRow.menuTitle.text = dataStruct.title;
        //
        //            return viewForRow;
        //        }
    }
}

-(void)pickerTapped:(UIGestureRecognizer *)gestureRecognizer {
    //определяем координату куда нажали на UIPickerView
    CGPoint myP = [gestureRecognizer locationInView:self.pickerView];
    //Определяем высоту строки в UIPickerView. Я делю на 5 потому что использую стандартную высотку строки
    CGFloat heightOfPickerRow = self.pickerView.frame.size.height/3;
    //объявляем переменную для хранения информации про строку
    NSInteger rowToSelect =[self.pickerView selectedRowInComponent:0];
    //Analyse if any action on the tap is required
    if (myP.y<heightOfPickerRow) {
        //selected area corresponds to current_row-2 row
        //check if we can move to that row (i.e. that
        //it exists and is not blank
        if ([self.pickerView selectedRowInComponent:0] > 0)
            rowToSelect -=1;
        else
            rowToSelect = -1; //no action required code
    }
    else if (myP.y<2*heightOfPickerRow) {
        //selected area corresponds to current_row-1 row
        //check if we can move to that row (i.e. that
        //it exists and is not blank
        rowToSelect = [self.pickerView selectedRowInComponent:0];
    }
    else if (myP.y<3*heightOfPickerRow) {
        //selected area corresponds to current_row+1 row
        //check if we can move to that row (i.e. that
        //it exists and is not blank
        if ([self.pickerView selectedRowInComponent:0] <
            ([self.pickerView numberOfRowsInComponent:0]-1))
            rowToSelect +=1;
        else
            rowToSelect = -1; //no action required code
    }
    else if (myP.y<4*heightOfPickerRow) {
        //selected area corresponds to current_row+1 row
        //check if we can move to that row (i.e. that
        //it exists and is not blank
        if ([self.pickerView selectedRowInComponent:0] <
            ([self.pickerView numberOfRowsInComponent:0]-1))
            rowToSelect +=1;
        else
            rowToSelect = -1; //no action required code
    }
    else {
        //selected area corresponds to current_row+2 row
        //check if we can move to that row (i.e. that
        //it exists and is not blank
        if ([self.pickerView selectedRowInComponent:0] <
            ([self.pickerView numberOfRowsInComponent:0]-2))
            rowToSelect += 2;
        else
            rowToSelect = -1; //no action required code
    }
    //check that we do need to process the tap
    if (rowToSelect!=-1) {
        //tell picker view to scroll to required row
        //ATTENTION - didSelectRow method is not called when you
        //tell the picker to move to select some row
        [self.pickerView selectRow:rowToSelect inComponent:0 animated:YES];
        //hence we need another function
        [self customPickerView:self.pickerView didSelectRow:rowToSelect inComponent:0
                 asResultOfTap:YES];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self customPickerView:pickerView didSelectRow:row inComponent:component asResultOfTap:NO];
}

- (void)customPickerView:(UIPickerView *)pickerView
            didSelectRow:(NSInteger)row
             inComponent:(NSInteger)component
           asResultOfTap:(bool)userTapped
{
    if (userTapped)
    {
        if (row == 0)
        {
            [self performSegueWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"typeOfViewFavorites"] sender:nil];
        }
        else
        {
            NSNumber *selectedRow = [[NSNumber alloc] initWithInt:row - 1];
            //NSLog(@"tapped in %i", row);
            
            if(!self.restarauntId)
            {
                self.restarauntId = [[self.arrayData objectAtIndex:selectedRow.integerValue] menuId];
            }
            else
            {
                id menuId = [[self.arrayData objectAtIndex:selectedRow.integerValue] menuId];
                NSArray *hz = [self.db fetchChildMenuWithDefaultLanguageForParentMenu:menuId];
                if (hz.count)
                {
                    self.menuId = menuId;
                }
                else {
                    if(self.isMenuMode)
                    {
                        self.arrayData = nil;
                        self.selectedRow = selectedRow;
                        [self performSegueWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"typeOfView"] sender:self];
                    }
                }
            }
            NSLog(@"ups");
        }
    }
    else
    {
        //NSLog(@"selected row %i", row);
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    //    if(self.isCartMode)
    //        return self.pickerView.frame.size.height-10;
    //    else
    return self.pickerView.frame.size.height-20;//4;
}

#pragma mark - segue Delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@",[self.arrayData objectAtIndex:self.selectedRow.integerValue]);
    if ([segue.identifier isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"typeOfView"]])
    {
        //MenuDataStruct *dataStruct = [self.arrayData objectAtIndex:self.selectedRow.integerValue];
        [segue.destinationViewController setKindOfMenu:self.singleMenu];
    }
    else if([segue.identifier isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"typeOfViewFavorites"]])
    {
        [[segue.destinationViewController navigationItem] setTitle:self.titleFavorites];
    }
    else
        if([segue.identifier isEqualToString:@"toProductDetail"])
        {
            [[segue destinationViewController] setProduct:[self.arrayOfObjects objectAtIndex:self.selectedRow.integerValue] isFromFavorites:NO];
            [[segue destinationViewController] setLabelOfAddingButtonWithString:@"Change" withIndexPathInDB:self.selectedPath];
            fromDeliveriesAndDatailViewController = YES;
        }
        else
            if([segue.identifier isEqualToString:@"toDelivery"])
            {
                if (deliveryTime == YES)
                {
                    deliveryTime = NO;
                    [[segue destinationViewController] setEnableTime:YES];
                    [[segue.destinationViewController navigationItem] setTitle:self.titleDeliveryByTime];
                }
                else
                {
                    [[segue.destinationViewController navigationItem] setTitle:self.titleDelivery];
                }
            }
            else if ([segue.identifier isEqualToString:@"toRestaurantList"])
            {
                [[segue.destinationViewController navigationItem] setTitle:self.restorantsButton.titleLabel.text];
            }
    
    
    self.shouldBeReloaded = YES;
    self.arrayOfObjects = nil;
    self.promotionsArray = nil;
}


#pragma mark - tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    if(self.isMenuMode)
    return 2;
    //    else return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isMenuMode)
    {
        if(section == 0)
            return 1;
        else
        {
            if (self.arrayData.count == 0)
            {
                return 0;
            }
            else
                return self.arrayData.count;
        }
    }
    else
    {
        if (section == 0)
            return self.arrayOfObjects.count;
        else
            return 1;
    };
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isCartMode)
    {
        if (indexPath.section == 0)
        {
            NSString *CellIdentifier = @"CartCell1";
            CartCell *cell = (CartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:nil options:nil];
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[CartCell class]])
                    {
                        cell = (CartCell *)currentObject;
                        break;
                    }
                }
            }
            ProductDataStruct *productStruct = [self.arrayOfObjects objectAtIndex:indexPath.row];
            cell.productTitle.text  = productStruct.title;
            cell.productCount.text  = [NSString stringWithFormat:@"%@",productStruct.count];
            cell.imageView.image    = productStruct.image;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:(productStruct.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]];
            NSString *priceString;
            if (productStruct.discountValue.floatValue != 0)
            {
                NSString *discountPrice = [formatter stringFromNumber:[NSNumber numberWithFloat:(productStruct.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue] * (1 - productStruct.discountValue.floatValue))]];
                priceString = [NSString stringWithFormat:@"%@(%@)%@", price, discountPrice, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
            }
            else
            {
                priceString = [NSString stringWithFormat:@"%@ %@", price, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
            }
            
            cell.productPrice.text = priceString;
            
            return cell;
        }
        else
        {
            NSString *cellIdentifier = @"Total";
            TotalCartCell *cell = (TotalCartCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TotalCartCell" owner:nil options:nil];
                for (id currentObject in topLevelObjects)
                {
                    if ([currentObject isKindOfClass:[TotalCartCell class]])
                    {
                        cell = (TotalCartCell *)currentObject;
                        break;
                    }
                }
            }
            
            cell.sumLabel.text = self.titleTotal;
            cell.sumWithDiscountsLabel.text = self.titleWithDiscounts; //@"With discounts";
            cell.countLabel.text = self.titleCount; //@"Count";
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingIncrement = [NSNumber numberWithFloat:0.01];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            
            float sum = 0;
            float sumWithDiscounts = 0;
            int totalCount = 0;
            for (int i = 0; i < self.arrayOfObjects.count; i++)
            {
                ProductDataStruct *productDataStruct = [self.arrayOfObjects objectAtIndex:i];
                
                sum                 = sum + ([[formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithFloat:(productDataStruct.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]]] floatValue]);
                if (productDataStruct.discountValue.floatValue != 0)
                {
                    sumWithDiscounts    = sumWithDiscounts + (productDataStruct.price.floatValue * (1 - productDataStruct.discountValue.floatValue) * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue]);
                }
                else
                {
                    sumWithDiscounts = sumWithDiscounts + [[formatter numberFromString:productDataStruct.price] floatValue]* [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue];
                }
                totalCount          = totalCount + productDataStruct.count.intValue;
            }
            
            cell.sumNumberLabel.text = [NSString stringWithFormat:@"%@ %@",[formatter stringFromNumber:[NSNumber numberWithFloat:sum]], [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"]];
            cell.sumWithDiscountsNumberLabel.text = [NSString stringWithFormat:@"%@ %@",[formatter stringFromNumber:[NSNumber numberWithFloat:sumWithDiscounts]], [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"]];
            cell.countNumberLabel.text = [NSString stringWithFormat:@"%i", totalCount];
            
            
            //            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            //            if (cell == nil)
            //            {
            //                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            //
            //                cell.textLabel.text = @"Total";
            //
            //            }
            return cell;
        }
    }
    else
    {
        if(indexPath.section != 0)
        {
            NSString *CellIdentifier = @"PickerViewCell";
            PickerViewCell *cell = (PickerViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickerViewCell" owner:nil options:nil];
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[PickerViewCell class]])
                    {
                        cell = (PickerViewCell *)currentObject;
                        
                        break;
                    }
                }
            }
            MenuDataStruct *dataStruct = [self.arrayData objectAtIndex:indexPath.row];
            cell.menuTitle.text = dataStruct.title;
            if (!dataStruct.image)
            {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    [self startIconDownload:dataStruct forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.menuImage.image = [UIImage imageNamed:@"Placeholder.png"];
                
            }
            else
            {
                cell.menuImage.image = dataStruct.image;
            }
            
            return cell;
        }
        else
        {
            PickerViewCell *viewForRow;
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickerViewCell" owner:nil options:nil];
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[PickerViewCell class]])
                {
                    viewForRow = (PickerViewCell *)currentObject;
                    break;
                }
            }
            viewForRow.menuTitle.text = self.titleFavorites;
            viewForRow.menuImage.image = [UIImage imageNamed:@"Heart.png"];
            return viewForRow;
        }
    }
}

//змінюємо висоту cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isCartMode)
    {
        return 61.0;
    }
    else
    {
        return 50.0;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isCartMode)
    {
        if(section == 1)
        {
            return 1.0;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.imageDownloadsInProgress removeAllObjects];
    if(self.isCartMode)
    {
        if (indexPath.section == 0)
        {
            self.selectedRow = [[NSNumber alloc] initWithInt:indexPath.row];
            [self performSegueWithIdentifier:@"toProductDetail" sender:self];
            self.selectedPath = indexPath;
        }
    }
    else
    {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            [self performSegueWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"typeOfViewFavorites"] sender:nil];
        }
        else
        {
            NSNumber *selectedRow = [[NSNumber alloc] initWithInt:indexPath.row];
            //NSLog(@"tapped in %i", row);
            
            if(!self.restarauntId)
            {
                self.restarauntId = [[self.arrayData objectAtIndex:selectedRow.integerValue] menuId];
                if (![self.db isRestaurantCanMakeOrderWithRestaurantID:self.restarauntId])
                {
                    [self.cartButton setHidden:YES];
                    [self.menuButton setHidden:YES];
                }
                else
                {
                    [self.menuButton setHidden:NO];
                    [self.cartButton setHidden:NO];
                }
                [self.pickerView reloadAllComponents];
            }
            else
            {
                id menuId = [[self.arrayData objectAtIndex:selectedRow.integerValue] menuId];
                NSArray *hz = [self.db fetchChildMenuWithDefaultLanguageForParentMenu:menuId];
                if (hz.count)
                {
                    self.arrayData = nil;
                    self.menuId = menuId;
                    [self.pickerView reloadAllComponents];
                }
                else
                {
                    self.singleMenu = [self.arrayData objectAtIndex:selectedRow.integerValue];
                    self.arrayData = nil;
                    self.selectedRow = selectedRow;
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"typeOfView"])
                    {
                        [self performSegueWithIdentifier:@"menuList" sender:self];
                        [[NSUserDefaults standardUserDefaults] setValue:@"menuList" forKey:@"typeOfView"];
                    }
                    else
                    {
                        [self performSegueWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"typeOfView"] sender:self];
                    }
                }
            }
            NSLog(@"ups");
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //self.arrayOfObjects = nil;
    //[self.pickerView reloadAllComponents];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCartMode)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && self.isCartMode)
    {
        if (indexPath.section != 1)
        {
            [self.db deleteObjectFromEntity:@"Cart" withProductId:[[self.arrayOfObjects objectAtIndex:indexPath.row] productId]];
            self.arrayOfObjects = nil;
            [self arrayOfObjects];
            if (!self.arrayOfObjects)
                [self.arrayOfObjects removeObjectAtIndex:indexPath.row];
            else
            {
                [self.pickerView reloadAllComponents];
            }
            [self.tableView reloadData];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.titleDoYouWantDeleteAllItemsFromCart
                                                           delegate:self
                                                  cancelButtonTitle:self.titleYES
                                                  otherButtonTitles:self.titleNO, nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.db deleteAllObjectsFromEntity:@"Cart"];
        self.arrayOfObjects = nil;
        [self.pickerView reloadAllComponents];
    }
}

- (IBAction)OrderButton:(id)sender
{
    if (self.isCartMode)
    {
        if (!checkConnection.hasConnectivity)
        {
            self.alert = [[UIAlertView alloc] initWithTitle:nil/*@"Internet error"*/ message:self.titleNoInternet delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [self.alert show];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        }
        else
            if(self.arrayOfObjects.count == 0)
            {
                self.alert = [[UIAlertView alloc] initWithTitle:self.titleCartIsEmpty message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [self.alert show];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];

            }
            else
            {
                self.restorantsButton.titleLabel.text = self.titleOrder; //@"Order";
                UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleChooseMethodToGetOrder];  //@"Choose method to get order:"];
                [actionSheet setDelegate:(id)self];
                [actionSheet addButtonWithTitle:self.titleDelivery];  //@"Delivery"];
                [actionSheet addButtonWithTitle:self.titleDeliveryByTime]; //@"Delivery by time"];
//                [actionSheet addButtonWithTitle:@"Pick up"];
                [actionSheet addButtonWithTitle:self.titleCancel]; //@"Cancel"];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                [actionSheet showInView:self.view];
            }
        
    }
    else
    {
        [self performSegueWithIdentifier:@"toRestaurantList" sender:nil];
    }
}

//private
- (void) dismiss
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"toDelivery" sender:nil];
        fromDeliveriesAndDatailViewController = YES;
        return;
    }
    else
        if (buttonIndex == 1)
        {
            deliveryTime = YES;
            [self performSegueWithIdentifier:@"toDelivery" sender:nil];
            fromDeliveriesAndDatailViewController = YES;
            return;
        }
        else
        {
            self.restorantsButton.titleLabel.text = self.titleOrder;
        }
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(ProductDataStruct *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.arrayData count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {   if(indexPath.section != 0)
        {
            MenuDataStruct *appRecord = [self.arrayData objectAtIndex:indexPath.row];
            
            if (!appRecord.image) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        PickerViewCell *cell = (PickerViewCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.menuImage.image = iconDownloader.appRecord.image;
        [self.db SavePictureToCoreData:iconDownloader.appRecord.idPicture toData:UIImagePNGRepresentation(cell.menuImage.image)];
        
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


#pragma mark 
#pragma mark PRIVATE METHODS

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Main"])
        {
            self.titleMain = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Restaurants"])
        {
            self.titleRestaurants = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Order"])
        {
            self.titleOrder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Menu"])
        {
            self.titleMenu = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cart"])
        {
            self.titleCart = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Back"])
        {
            self.titleBack = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Favorites"])
        {
            self.titleFavorites = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Total"])
        {
            self.titleTotal = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Count"])
        {
            self.titleCount = [[array objectAtIndex:i] valueForKey:@"title"];
        }

        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"With discounts"])
        {
            self.titleWithDiscounts = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Choose method to get order:"])
        {
            self.titleChooseMethodToGetOrder = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Delivery"])
        {
            self.titleDelivery = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Delivery by time"])
        {
            self.titleDeliveryByTime = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cancel"])
        {
            self.titleCancel = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"YES"])
        {
            self.titleYES = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"NO"])
        {
            self.titleNO = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Do you want to delete all items from Cart?"])
        {
            self.titleDoYouWantDeleteAllItemsFromCart = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"No internet connection."])
        {
            self.titleNoInternet = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cart is empty."])
        {
            self.titleCartIsEmpty = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    }

}


@end