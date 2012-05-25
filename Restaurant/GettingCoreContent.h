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
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
- (NSArray *)getArrayFromCoreDatainEntetyName:(NSString *)entityName withSortDescriptor:(NSString *)attributeString;
//- (void) setArrauCoreatEntity:(NSString *)entityName;


- (void) setCoreDataForEntityWithName:(NSString *)entityName 
                dictionaryOfAtributes:(NSDictionary *)attributeDictionary;
- (void) deleteAllObjectsFromEntity: (NSString *) entityDescription;
- (NSArray *)fetchAllRestaurantsWithDefaultLanguageAndCity;
- (NSArray *)fetchRootMenuWithDefaultLanguageForRestaurant:(NSString *)restaurnatId;
- (NSArray *)fetchChildMenuWithDefaultLanguageForParentMenu:(NSString *)parentMenuId;
- (NSArray *)fetchAllLanguages;
- (NSArray *)fetchAllCitiesByLanguage:(NSString *)languageId;
- (NSURL *)fetchImageURLbyPictureID:(NSString *)pictureId;
- (NSArray *)fetchAllProductsFromMenu:(NSString *)menuId;
- (void)SavePictureToCoreData:(NSString *)idPicture toData:(NSData *)data;




@end
