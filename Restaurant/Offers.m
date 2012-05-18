//
//  Offers.m
//  Restaurant
//
//  Created by Bogdan Geleta on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Offers.h"

@implementation Offers

@synthesize offers = _offers;

- (NSArray *)offers
{
 
    _offers = [[[NSUserDefaults standardUserDefaults] objectForKey:@"offers"] allValues];
    return _offers;
}

- (void)removeOffer:(NSMutableDictionary *)offer
{
    id keyForDeletion = [offer objectForKey:@"id"];
    NSMutableDictionary *offers = [Offers getOffersFromUserDefaults];
    [offers removeObjectForKey:keyForDeletion];
    [Offers setOffersToUserDefaults:offers];
}

+ (NSMutableDictionary *)getOffersFromUserDefaults
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"offers"] mutableCopy];
}

+(void)setOffersToUserDefaults:(NSMutableDictionary *)offers
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"offers"];
    [[NSUserDefaults standardUserDefaults] setObject:offers forKey:@"offers"];
}




@end
