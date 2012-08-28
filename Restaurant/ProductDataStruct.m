//
//  ProductDataStruct.m
//  Restaurant
//
//  Created by Bogdan Geleta on 24.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDataStruct.h"

@implementation ProductDataStruct

@synthesize productId = _productId;
@synthesize price = _price;
@synthesize image = _image;
@synthesize descriptionText = _descriptionText;
@synthesize title = _title;
@synthesize count = _count;
@synthesize idPicture = _idPicture;
@synthesize link = _link;
@synthesize isFavorites = _isFavorites;
@synthesize discountValue = _discountValue;

- (NSNumber *)count
{
    if(!_count)
    {
        _count = [[NSNumber alloc] initWithInteger:1];
        return _count;
    }
    else return _count;
    
}

- (id)initWithDictionary:(NSMutableDictionary *)aDictionary
{
    self.productId = [aDictionary objectForKey:@"productId"];
    self.price = [aDictionary objectForKey:@"price"];
    //self.image = [aDictionary objectForKey:@"image"];
    self.descriptionText = [aDictionary objectForKey:@"descriptionText"];
    self.title = [aDictionary objectForKey:@"title"];
    self.count = [aDictionary objectForKey:@"count"];
    self.discountValue = [aDictionary objectForKey:@"idDiscount"];
    self.isFavorites = [aDictionary objectForKey:@"isFavorites"];
    return self;
    
}

- (NSDictionary *)getDictionaryDependOnDataStruct
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:self.price forKey:@"price"];
    [result setObject:self.productId forKey:@"productId"];
    [result setObject:self.descriptionText forKey:@"descriptionText"];
    [result setObject:self.title forKey:@"title"];
    [result setObject:self.count forKey:@"count"];
    [result setObject:self.discountValue forKey:@"idDiscount"];
    [result setObject:self.isFavorites forKey:@"isFavorites"];
    return result.copy;
}

@end
