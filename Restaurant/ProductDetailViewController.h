//
//  ProductDetailViewController.h
//  XMLParser
//
//  Created by Bogdan Geleta on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDataStruct.h"

@interface ProductDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) ProductDataStruct *product;
@property (weak, nonatomic) IBOutlet UIPickerView *countPickerView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (strong, nonatomic) NSNumber *count;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@end
