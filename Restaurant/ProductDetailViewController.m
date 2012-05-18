//
//  ProductDetailViewController.m
//  XMLParser
//
//  Created by Bogdan Geleta on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

@synthesize product = _product;
@synthesize countPickerView = _countPickerView;
@synthesize priceLabel = _priceLabel;
@synthesize cartButton = _cartButton;
@synthesize count = _count;


- (NSNumber *)count
{
    if(!_count)
    {
        _count = [[NSNumber alloc] initWithInteger:1];
        return _count;
    }
    else return _count;
    
}

- (void)setProduct:(NSMutableDictionary *)product
{
    _product = product;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = [self.product objectForKey:@"name"];
    NSLog(@"%@", [self.product objectForKey:@"cost"]);
    //self.countPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 63.0, 90.0)];
    self.countPickerView.frame = CGRectMake(237, 236, 63, 108);
    NSString *cost = [self.product objectForKey:@"cost"];
    
    self.priceLabel.text = [NSString stringWithFormat:@"Цена: %@ %@", cost, @"грн."];
    
    
    
}
- (IBAction)addToCart:(id)sender {
    NSMutableDictionary *offer = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *offers;
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"offers"])
    {
        offers = [[NSMutableDictionary alloc] init];
    }
    else {
        offers = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"offers"]];
    }
    if(![offers objectForKey:[self.product objectForKey:@"id"]])
    {
        [offer setObject:[self.product objectForKey:@"id"] forKey:@"id"];
        [offer setObject:[self.product objectForKey:@"cost"] forKey:@"cost"];
        [offer setObject:[self.product objectForKey:@"name"] forKey:@"name"];
        [offer setObject:self.count forKey:@"count"];
    }
    else
    {
        offer = [offers objectForKey:[self.product objectForKey:@"id"]];
        offer = offer.mutableCopy;
        int sum = [[offer objectForKey:@"count"] integerValue] + self.count.integerValue;
        NSNumber *count = [[NSNumber alloc] initWithInt:sum];
        [offer removeObjectForKey:@"count"];
        [offer setObject:count forKey:@"count"];
    }
    [offers setObject:offer forKey:[self.product objectForKey:@"id"]];
    [[NSUserDefaults standardUserDefaults] setObject:offers forKey:@"offers"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Количества товара \"%@\" в корзине %@ шт.", [offer objectForKey:@"name"], [offer objectForKey:@"count"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (void)viewDidUnload
{
    [self setCountPickerView:nil];
    [self setPriceLabel:nil];
    [self setCartButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowNumber = [[NSString alloc] initWithFormat:@"%i", row+1];
    return rowNumber;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.count = [[NSNumber alloc] initWithInteger:row+1];
}
@end
