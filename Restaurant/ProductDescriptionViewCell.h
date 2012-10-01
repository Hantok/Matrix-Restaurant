//
//  ProductDescriptionViewCell.h
//  Restaurant
//
//  Created by Matrix Soft on 24.09.12.
//
//

#import <UIKit/UIKit.h>

@interface ProductDescriptionViewCell : UIView

@property (strong, nonatomic) UILabel *productName;
@property (strong, nonatomic) UILabel *productCount;
@property (strong, nonatomic) UILabel *productPriceSum;
@property (strong, nonatomic) UIImageView *lineSeparator;

@end
