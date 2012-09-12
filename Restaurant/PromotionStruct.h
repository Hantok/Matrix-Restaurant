//
//  PromotionStruct.h
//  Restaurant
//
//  Created by Roman Slysh on 9/12/12.
//
//

#import <Foundation/Foundation.h>

@interface PromotionStruct : NSObject

@property (nonatomic) NSNumber *promotionId;
@property (strong, nonatomic) NSString *idPicture;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *descriptionText;

@end
