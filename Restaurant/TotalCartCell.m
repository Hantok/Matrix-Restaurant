//
//  TotalCartCell.m
//  Restaurant
//
//  Created by Matrix Soft on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TotalCartCell.h"

@implementation TotalCartCell
@synthesize sumLabel;
@synthesize sumNumberLabel;
@synthesize sumWithDiscountsLabel;
@synthesize sumWithDiscountsNumberLabel;
@synthesize countLabel;
@synthesize countNumberLabel;

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
}

@end
