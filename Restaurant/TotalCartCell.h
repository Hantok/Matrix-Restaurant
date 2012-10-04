//
//  TotalCartCell.h
//  Restaurant
//
//  Created by Matrix Soft on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalCartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *sumLabel;
@property (strong, nonatomic) IBOutlet UILabel *sumNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *sumWithDiscountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *sumWithDiscountsNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *countNumberLabel;
@property (strong, nonatomic) IBOutlet UIWebView *sumNumberView;

@end
