//
//  ProductDetailViewController.m
//  XMLParser
//
//  Created by Bogdan Geleta on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "GettingCoreContent.h"
#import <QuartzCore/QuartzCore.h>

@interface ProductDetailViewController ()

@property BOOL isInFavorites;
@property (strong, nonatomic) NSString *labelString;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property BOOL countForDeleting;

@end

@implementation ProductDetailViewController

@synthesize product = _product;
@synthesize countPickerView = _countPickerView;
@synthesize priceLabel = _priceLabel;
@synthesize cartButton = _cartButton;
@synthesize count = _count;
@synthesize productImage = _productImage;
@synthesize addToFavorites = _addToFavorites;
@synthesize nameLabal = _nameLabal;
@synthesize isInFavorites = _isInFavorites;
@synthesize labelString = _labelString;
@synthesize selectedPath = _selectedPath;
@synthesize countForDeleting = _countForDeleting;

- (void)setProduct:(ProductDataStruct *)product isFromFavorites:(BOOL)boolValue
{
    _product = product;
    self.isInFavorites = boolValue;
}

-(void)setLabelOfAddingButtonWithString:(NSString *)labelString withIndexPathInDB:(NSIndexPath *)indexPath
{
    self.labelString = labelString;
    self.selectedPath = indexPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    //self.navigationItem.title = self.product.title;
    self.nameLabal.text = self.product.title;
    
	// Do any additional setup after loading the view.
    //self.countPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 63.0, 90.0)];
    self.countPickerView.frame = CGRectMake(237, 236, 63, 108);
    NSString *cost = self.product.price;
    
    self.priceLabel.text = [NSString stringWithFormat:@"Цена: %@ %@", cost, @"грн."];
    self.productImage.image = self.product.image;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
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
    
    GettingCoreContent *db = [[GettingCoreContent alloc] init];
    
    if (self.countForDeleting || self.product.count.intValue == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Do you want to delete item %@", self.product.title] delegate:self cancelButtonTitle:@"YES" otherButtonTitles: @"NO", nil];
        [alert show];
    }
    else 
    {
        [db SaveProductToEntityName:@"Cart" WithId:self.product.productId 
                          withCount:self.product.count.integerValue
                          withPrice:self.product.price.floatValue
                        withPicture:UIImagePNGRepresentation(self.product.image)];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Добавлено %i ед. товара \"%@\" в корзину.",self.product.count.integerValue, self.product.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        GettingCoreContent *db = [[GettingCoreContent alloc] init];
        [db deleteObjectFromEntity:@"Cart" withProductId:self.product.productId];
        NSLog(@"deleted");
        [self.navigationController popViewControllerAnimated:NO];
    }
    self.cartButton.titleLabel.text = self.labelString;
}
- (IBAction)AddToFavorites:(id)sender 
{
    GettingCoreContent *db = [[GettingCoreContent alloc] init];
    [db SaveProductToEntityName:@"Favorites" WithId:self.product.productId 
                      withCount:0
                      withPrice:self.product.price.floatValue
                    withPicture:UIImagePNGRepresentation(self.product.image)];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Добавлено товар \"%@\" в favorites.", self.product.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidUnload
{
    [self setCountPickerView:nil];
    [self setPriceLabel:nil];
    [self setCartButton:nil];
    [self setProductImage:nil];
    [self setAddToFavorites:nil];
    [self setNameLabal:nil];
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
    self.countForDeleting = NO;
    
    if (self.labelString)
        self.product.count = [NSNumber numberWithInt:row];
    else 
        self.product.count = [NSNumber numberWithInt:row+1];
}
@end
