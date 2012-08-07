//
//  subViewSpam.h
//  Restaurant
//
//  Created by Matrix Soft on 8/3/12.
//
//

#import <UIKit/UIKit.h>

@interface subViewSpam : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)close:(id)sender;
@end
