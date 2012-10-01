//
//  ProductDescriptionViewCell.m
//  Restaurant
//
//  Created by Matrix Soft on 24.09.12.
//
//

#import "ProductDescriptionViewCell.h"

@implementation ProductDescriptionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.productName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 142, 20)];
        self.productName.text = @"Product name!";
        [self.productName setFrame:CGRectMake(10, 0, 151, 20)];
        [self.productName setFont:[UIFont systemFontOfSize:13]];
        [self.productName setNumberOfLines:0];
//        [self.productName sizeToFit];
        [self.productName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.productName];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.productName.frame.size.height)];
        
        self.productCount = [[UILabel alloc] initWithFrame:CGRectMake(180, -2, 15, 20)];
        [self.productCount setText:@"25"];
        [self.productCount setFont:[UIFont systemFontOfSize:11]];
        [self.productCount setNumberOfLines:0];
//        [self.productCount sizeToFit];
        [self.productCount setTextColor:[UIColor darkGrayColor]];
        [self.productCount setTextAlignment:UITextAlignmentRight];
        [self.productCount setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.productCount];

        
        self.productPriceSum = [[UILabel alloc] initWithFrame:CGRectMake(205, -2, 75, 20)];
        [self.productPriceSum setText:@"214.20"];
        [self.productPriceSum setFont:[UIFont systemFontOfSize:11]];
        [self.productPriceSum setNumberOfLines:0];
//        [self.productPriceSum sizeToFit];
        [self.productPriceSum setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.productPriceSum];
        
        self.lineSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 1, self.frame.size.height)];
        UIImage *lineSeparatorImage = [UIImage imageNamed:@"Line1pVerticalGray.jpg"];
        [self.lineSeparator setImage:lineSeparatorImage];
        
        [self addSubview:self.lineSeparator];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


@end
