//
//  subViewSpam.m
//  Restaurant
//
//  Created by Matrix Soft on 8/3/12.
//
//

#import "subViewSpam.h"

@implementation subViewSpam
@synthesize imageView;
@synthesize label;
@synthesize textView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

//- (id)init
//{
//    
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)close:(id)sender
{
    [self removeFromSuperview];
}
@end
