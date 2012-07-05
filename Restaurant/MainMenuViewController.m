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
#import "Offers.h"
#import "GettingCoreContent.h"
#import "MenuDataStruct.h"
#import "LanguageAndCityTableViewController.h"
#import "ProductDataStruct.h"
#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainMenuViewController ()
{
    CFURLRef        soundFileURLRef;
    SystemSoundID	soundFileObject;
}

@property (readwrite)	CFURLRef        soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

@property (strong, nonatomic) ProductDataStruct *product;
@property (strong, nonatomic) NSMutableArray *arrayOfObjects;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property (nonatomic) NSInteger numberOfRows;
@property(nonatomic, copy) NSArray *animationImages;

- (void)startIconDownload:(MenuDataStruct *)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MainMenuViewController
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;
@synthesize pickerView = _pickerView;
@synthesize menuButton = _menuButton;
@synthesize cartButton = _cartButton;
@synthesize settingsButton = _settingsButton;
@synthesize restorantsButton = _restorantsButton;
@synthesize imageView = _imageView;
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


- (IBAction)drop:(id)sender {
    self.menuId = nil;
    self.restarauntId = nil;
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
        _arrayData = array;
        return _arrayData;
    }
    return _arrayData;
}

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
            
            
            [_arrayOfObjects addObject:productStruct];     
        }
        
        return _arrayOfObjects;
    }
    return _arrayOfObjects;
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
    self.restorantsButton.titleLabel.text = @"Restaurants";
    
    [self.settingsButton setHidden:NO];
    [self.drop setHidden:NO];
    
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
    
    self.restorantsButton.titleLabel.text = @"Order";    
    
    [self.settingsButton setHidden:YES];
    [self.drop setHidden:YES];
}
- (IBAction)goToSettingsTableViewController:(id)sender 
{
    [self performSegueWithIdentifier:@"toSettings" sender:self];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    
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
    
    self.navigationItem.title = @"Main";
    [self menuButton:self];
    
    if(!self.isCartMode)
    {
        self.isMenuMode = YES;
    }
    
    //не працює з ARC!!!!!
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap"
                                                withExtension: @"aif"];
    
    soundFileURLRef = (__bridge CFURLRef) tapSound;
    
    AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
    
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"1.jpg"],
                             [UIImage imageNamed:@"11.gif"], nil];
    self.imageView.animationImages = imageArray;
    self.imageView.animationDuration = 4.0;
    self.imageView.contentMode = UIViewContentModeBottomLeft;
    [self.imageView startAnimating];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if(self.isMenuMode)
    {
        // [self.pickerView reloadAllComponents];
        self.restorantsButton.titleLabel.text = @"Restaurants";
    }
    else 
    {
        self.arrayOfObjects = nil;
        //[self.pickerView reloadAllComponents];
        self.restorantsButton.titleLabel.text = @"Order";
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setMenuButton:nil];
    [self setCartButton:nil];
    [self setSettingsButton:nil];
    [self setRestorantsButton:nil];
    [self setDrop:nil];
    [self setImageView:nil];
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
            UIImageView *one = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cart.png"]];
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
            [self performSegueWithIdentifier:@"toFavorites" sender:nil];
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
    if(self.isCartMode)
        return self.pickerView.frame.size.height;
    else 
        return self.pickerView.frame.size.height;//4;
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
    //self.arrayData = nil;
    //self.restarauntId = nil;
    //self.menuId = nil;
    self.shouldBeReloaded = YES;
    if([segue.identifier isEqualToString:@"toProductDetail"])
    {
        [[segue destinationViewController] setProduct:[self.arrayOfObjects objectAtIndex:self.selectedRow.integerValue] isFromFavorites:NO];
        [[segue destinationViewController] setLabelOfAddingButtonWithString:@"Изменить" withIndexPathInDB:self.selectedPath];
    }
    self.arrayOfObjects = nil;
    
}


#pragma mark - tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isMenuMode)
        return 2;
    else return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isMenuMode)
    {
        if(section == 0) return 1;
        else return self.arrayData.count;
    }
    else 
    {
        return self.arrayOfObjects.count;
    };
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    if(self.isCartMode)
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
        cell.productPrice.text  = productStruct.price;
        
        return cell;
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
            viewForRow.menuTitle.text = @"Favorites";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.imageDownloadsInProgress removeAllObjects];
    if(self.isCartMode)
    {
        self.selectedRow = [[NSNumber alloc] initWithInt:indexPath.row];
        [self performSegueWithIdentifier:@"toProductDetail" sender:self];
        self.selectedPath = indexPath;
    }
    else
    {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"toFavorites" sender:nil];
        }
        else 
        {
            NSNumber *selectedRow = [[NSNumber alloc] initWithInt:indexPath.row];
            //NSLog(@"tapped in %i", row);
            
            if(!self.restarauntId)
            {
                self.restarauntId = [[self.arrayData objectAtIndex:selectedRow.integerValue] menuId];
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
                else {
                    if(self.isMenuMode)
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
            }
            NSLog(@"ups");
        }
        
    }
    
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
        [self.db deleteObjectFromEntity:@"Cart" withProductId:[[self.arrayOfObjects objectAtIndex:indexPath.row] productId]];
        self.arrayOfObjects = nil;
        [self arrayOfObjects];
        if (!self.arrayOfObjects)
            [self.arrayOfObjects removeObjectAtIndex:indexPath.row];
        else {
            [self.pickerView reloadAllComponents];
        }
        [self.tableView reloadData];
    }  
}

- (IBAction)OrderButton:(id)sender 
{
    if (self.isCartMode)
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Choose method to get order:"];
        [actionSheet setDelegate:(id)self];
        [actionSheet addButtonWithTitle:@"Delivery"];
        [actionSheet addButtonWithTitle:@"Pick up"];
        [actionSheet showInView:self.view];
        
    }
    else 
    {
        [self performSegueWithIdentifier:@"toRestaurantList" sender:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"toDelivery" sender:nil];
    }
    
    else 
    {
        
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


@end