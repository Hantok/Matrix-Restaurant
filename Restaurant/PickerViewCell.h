//
//  PickerViewCell.h
//  Restaurant
//
//  Created by Bogdan Geleta on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewCell : UIView
@property (weak, nonatomic) IBOutlet UIImageView *menuImage;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle;

@end
