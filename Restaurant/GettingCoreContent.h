//
//  GettingCoreContent.h
//  Restaurants
//
//  Created by Matrix Soft on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMLParse.h"

@interface GettingCoreContent : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray *arrayOfCoreData;
- (NSArray *)getArrayFromCoreDatainEntetyName:(NSString *)entityName withSortDescriptor:(NSString *)attributeString;
//- (void) setArrauCoreatEntity:(NSString *)entityName;


- (void) setCoreDataForEntityWithName:(NSString *)entityName 
                dictionaryOfAtributes:(NSDictionary *)attributeDictionary;
- (void) deleteAllObjectsFromEntity: (NSString *) entityDescription;
- (NSArray *)fetchAllRestaurantsFromEntityWithDefaultLanguageandAndCity;

@end
