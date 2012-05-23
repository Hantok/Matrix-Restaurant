//
//  CityCell.m
//  Restaurant
//
//  Created by Matrix Soft on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell

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
    //[super setSelected:selected animated:animated];
    
    GettingCoreContent *content = [[GettingCoreContent alloc] init];
    NSArray *cities =  [content fetchAllCitiesByLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
    NSString *userCityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"];
    for (int i = 0; i < cities.count; i++)
    {
        if ([[[cities objectAtIndex:i] valueForKey:@"underbarid"] isEqual:userCityId])
            self.detailTextLabel.text = [[cities objectAtIndex:i] valueForKey:@"name"];
    }
     
}

@end
