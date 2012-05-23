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
    //передадаємо значення із юзердефолт для міста у self.detailTextLabel.text
    GettingCoreContent *content = [[GettingCoreContent alloc] init];
    NSArray *cities =  [content fetchAllCitiesByLanguage:[[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguageId"] description]];
    NSString *userCityId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultCityId"] description];
    
    //NSLog(@"langID %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguageId"]);
    //NSLog(@"userCityId %@", userCityId);
    
    for (int i = 0; i < cities.count; i++)
    {
        if ([[[cities objectAtIndex:i] valueForKey:@"underbarid"] isEqualToString:[userCityId description]])
            self.detailTextLabel.text = [[cities objectAtIndex:i] valueForKey:@"name"];
    }
     
}

@end
