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
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize pickerView = _pickerView;
@synthesize menuButton = _menuButton;
@synthesize cartButton = _cartButton;
@synthesize settingsButton = _settingsButton;
@synthesize restorantsButton = _restorantsButton;
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

- (void)setIsCartModeMy:(BOOL)isCartMode
{
    _isCartMode = isCartMode;
}


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
            data = [self.db fetchAllRestaurantsWithDefaultLanguageAndCity];
        else 
        {
            if(self.menuId)
            {
                data = [self.db fetchChildMenuWithDefaultLanguageForParentMenu:self.menuId];
            }
            else
            {
                data = [self.db fetchRootMenuWithDefaultLanguageForRestaurant:self.restarauntId];
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
                if(dataOfPicture)
                {
                   dataStruct.image  = [UIImage imageWithData:dataOfPicture]; 
                }
                else 
                {
                    dataOfPicture = [NSData dataWithContentsOfURL:url];
                    [self.db SavePictureToCoreData:[[data objectAtIndex:i] valueForKey:@"idPicture"] toData:dataOfPicture];
                    dataStruct.image  = [UIImage imageWithData:dataOfPicture];
                }
                
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
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)];
    [self.pickerView addGestureRecognizer:tapgesture];
}
- (IBAction)cartButton:(id)sender {
    self.isCartMode = YES;
    self.isMenuMode = NO;
    self.menuButton.enabled = YES;
    self.cartButton.enabled = NO;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView removeGestureRecognizer:[self.pickerView.gestureRecognizers lastObject]];
}
- (IBAction)goToSettingsTableViewController:(id)sender {
    [self performSegueWithIdentifier:@"toSettings" sender:self];
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

    [self menuButton:self];

    if(!self.isCartMode)
    {
        self.isMenuMode = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //if(self.restarauntId) 
        [self.pickerView reloadAllComponents];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma pickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.isMenuMode)
    {
        return self.arrayData.count;
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
        self.tableView = [[UITableView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 216)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        return self.tableView;
        //[[[[NSUserDefaults standardUserDefaults] objectForKey:@"offers"] objectAtIndex:row] objectForKey:@"id"];
        
    }
    else {
        MenuDataStruct *dataStruct = [self.arrayData objectAtIndex:row];
        
        //UIView *viewForRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pickerView.frame.size.width-30, self.pickerView.frame.size.height/5)];
        //NSLog(@"%f", viewForRow.frame.size.width);
        //NSLog(@"%f", viewForRow.frame.size.height);
        //UIImage *imageForUIImageView  = dataStruct.image;
        //UIImageView *imageViewForViewForRow = [[UIImageView alloc] initWithImage:imageForUIImageView];
        //UILabel *labelForRow = [[UILabel alloc] initWithFrame:CGRectMake(imageViewForViewForRow.frame.size.width, 5, self.pickerView.frame.size.width-30, pickerView.frame.size.height/5)];
       //labelForRow.text = dataStruct.title;
        //[viewForRow addSubview:imageViewForViewForRow];
        //[viewForRow addSubview:labelForRow];
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
        
        viewForRow.menuImage.image = dataStruct.image;
        viewForRow.menuTitle.text = dataStruct.title;
        
        return viewForRow;
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
        NSNumber *selectedRow = [[NSNumber alloc] initWithInt:row];
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
                    self.selectedRow = selectedRow;
                    [self performSegueWithIdentifier:@"menuList" sender:self];
                }
            }
        }
            NSLog(@"ups");
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
    else return self.pickerView.frame.size.height/4;
}

#pragma segue Delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@",[self.arrayData objectAtIndex:self.selectedRow.integerValue]);
    if ([segue.identifier isEqualToString:@"menuList"])
    {
        MenuDataStruct *dataStruct = [self.arrayData objectAtIndex:self.selectedRow.integerValue];
        [segue.destinationViewController setKindOfMenu:dataStruct];
        
    }
    self.arrayData = nil;
    self.restarauntId = nil;
    self.menuId = nil;
    
}


#pragma tableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Offers* offers = [[Offers alloc] init];
    //return offers.offers.count;
    return [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Cart"].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *CellIdentifier = @"CartCell";
//    CartCell *cell = (CartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if(!cell)
//    {
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:nil options:nil];
//        for(id currentObject in topLevelObjects)
//        {
//            if([currentObject isKindOfClass:[CartCell class]])
//            {
//                cell = (CartCell *)currentObject;
//                break;
//            }
//        }
//    }
//    
//    Offers* offers = [[Offers alloc] init];
//    ProductDataStruct *dataStruct = [[ProductDataStruct alloc] initWithDictionary:[offers.offers objectAtIndex:indexPath.row]];
//    
//    
//    cell.productTitle.text = dataStruct.title;
//    NSNumber *count = dataStruct.count;
//
//    cell.productCount.text = [NSString stringWithFormat:@"%i шт.", [count intValue]];
//    NSNumber *cost = [NSNumber numberWithDouble:dataStruct.price.doubleValue];
//    cell.productPrice.text = [NSString stringWithFormat:@"%i грн.", [cost intValue]*[count intValue]];
    
    NSString *CellIdentifier = @"CartCell";
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
    NSArray *array = [self.db fetchAllProductsIdAndTheirCountWithPriceForEntity:@"Cart"];
    NSArray *arrayOfElements = [self.db fetchObjectsFromCoreDataForEntity:@"Descriptions_translation" withArrayObjects:array withDefaultLanguageId:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
    cell.productTitle.text = [NSString stringWithFormat:@"%@",[[arrayOfElements objectAtIndex:indexPath.row] valueForKey:@"nameText"]];
    cell.productCount.text = [NSString stringWithFormat:@"%@", [[array objectAtIndex:indexPath.row] valueForKey:@"count"]];

    NSNumber *numbers = [NSNumber numberWithFloat:([[[array objectAtIndex:indexPath.row] valueForKey:@"count"] intValue]*[[[array objectAtIndex:indexPath.row] valueForKey:@"cost"] floatValue])];

    cell.productPrice.text = [NSString stringWithFormat:@"%@ грн.", numbers];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%i", indexPath.row);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [self.db deleteObjectFromEntity:@"Cart" atIndexPath:indexPath];
        //Offers* offers = [[Offers alloc] init];
        //[offers removeOffer:[offers.offers objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
    }  
}

@end