//
//  LanguageCell.m
//  Restaurant
//
//  Created by Matrix Soft on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LanguageCell.h"

@implementation LanguageCell

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
    //передадаємо значення із юзердефолт для мови у self.detailTextLabel.text
    GettingCoreContent *content = [[GettingCoreContent alloc] init];
    NSArray *languages =  content.fetchAllLanguages;
    NSString *userLangId = [[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguageId"];

    for (int i = 0; i < languages.count; i++)
    {
        if ([[[[languages objectAtIndex:i] valueForKey:@"underbarid"] description] isEqualToString:userLangId.description])
            self.detailTextLabel.text = [[languages objectAtIndex:i] valueForKey:@"language"];
    }
}

@end
