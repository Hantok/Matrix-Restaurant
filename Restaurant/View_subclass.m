//
//  View_subclass.m
//  Restaurant
//
//  Created by Matrix Soft on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "View_subclass.h"

@implementation View_subclass

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL) enableInputClicksWhenVisible {
    return YES;
}

- (void) playClickForCustomKeyTap {
    [[UIDevice currentDevice] playInputClick];
}

@end
