//
//  ProductCell.m
//  Restaurant
//
//  Created by Bogdan Geleta on 26.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProductCell
@synthesize productImage = _productImage;
@synthesize productTitle = _productTitle;
@synthesize productDescription = _productDescription;
@synthesize productPrice = _productPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
}

@end
