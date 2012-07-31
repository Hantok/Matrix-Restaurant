//
//  ProductDataStruct.h
//  Restaurant
//
//  Created by Bogdan Geleta on 24.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDataStruct : NSObject

@property (nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *idPicture;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSNumber *discountValue;

- (NSDictionary *)getDictionaryDependOnDataStruct;
- (id)initWithDictionary:(NSMutableDictionary *)aDictionary;


@end
