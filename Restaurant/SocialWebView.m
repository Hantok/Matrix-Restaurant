//
//  SocialWebView.m
//  Restaurant
//
//  Created by Matrix Soft on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialWebView.h"

@implementation SocialWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.scalesPageToFit = YES;
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
}


@end
