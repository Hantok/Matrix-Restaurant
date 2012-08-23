//
//  ProductDetailViewController.h
//  XMLParser
//
//  Created by Bogdan Geleta on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDataStruct.h"
#import "GettingCoreContent.h"
#import <Twitter/Twitter.h>

@interface ProductDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) ProductDataStruct *product;
@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) NSNumber *count;
@property (weak, nonatomic) IBOutlet UIPickerView *countPickerView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabal;
@property (weak, nonatomic) IBOutlet UIView *pictureViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)setProduct:(ProductDataStruct *)product isFromFavorites:(BOOL)boolValue;

-(void)setLabelOfAddingButtonWithString:(NSString *)labelString withIndexPathInDB:(NSIndexPath *)indexPath;
- (IBAction)share:(id)sender;
- (IBAction)showOrHidePictureViewContainer:(id)sender;

@end
