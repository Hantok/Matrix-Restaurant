//
//  HistoryPartCell.m
//  Restaurant
//
//  Created by Matrix Soft on 31.08.12.
//
//

#import "HistoryPartCell.h"

@implementation HistoryPartCell
@synthesize dateOfOrder;
@synthesize numberOfOrder;

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
