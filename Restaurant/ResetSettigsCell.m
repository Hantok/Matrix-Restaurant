//
//  ResetSettigsCell.m
//  Restaurant
//
//  Created by Matrix Soft on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetSettigsCell.h"

@implementation ResetSettigsCell

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
    
    //[[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"defaultLanguageId"];
    //[[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"defaultCityId"];
}

@end
