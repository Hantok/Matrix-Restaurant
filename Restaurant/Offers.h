//
//  Offers.h
//  Restaurant
//
//  Created by Bogdan Geleta on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Offers : NSArray

@property (strong, nonatomic) NSArray* offers;

- (void)removeOffer:(NSMutableDictionary *)offer;
+ (NSMutableDictionary *)getOffersFromUserDefaults;
+ (void)setOffersToUserDefaults:(NSMutableDictionary *)offers;

@end
