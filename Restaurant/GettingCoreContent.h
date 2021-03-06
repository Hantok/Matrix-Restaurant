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

//coommememmed
- (void) setCoreDataForEntityWithName:(NSString *)entityName 
                dictionaryOfAtributes:(NSDictionary *)attributeDictionary;
- (void) deleteAllObjectsFromEntity:(NSString *)entityDescription;
- (NSArray *)fetchAllRestaurantsWithDefaultLanguageAndCity;
- (NSArray *)fetchAvalibleTypesOfDeliveries;
- (NSArray *)fetchRootMenuWithDefaultLanguageForRestaurant:(NSString *)restaurnatId;
- (NSArray *)fetchChildMenuWithDefaultLanguageForParentMenu:(NSString *)parentMenuId;
- (NSArray *)fetchAllLanguages;
- (NSArray *)fetchAllCitiesByLanguage:(NSString *)languageId;
- (NSURL *)fetchImageURLbyPictureID:(NSString *)pictureId;
- (NSString *)fetchImageStringURLbyPictureID:(NSString *)pictureId;
- (void) deleteReservationWithName:(NSString *)name;
- (NSArray *)fetchAllProductsFromMenu:(NSString *)menuId;
- (void)SavePictureToCoreData:(NSString *)idPicture toData:(NSData *)data;
- (NSData *)fetchPictureDataByPictureId:(NSString *)pictureId;
- (NSDictionary *)fetchImageURLAndDatabyMenuID:(NSString *)menuId;
- (NSArray *)fetchProductWithId:(NSString *)productsIds
                     withCounts:(NSString *)productsCounts;
- (NSString *)fetchDiscountByIdDiscount:(NSString *)idDiscount;
- (NSArray *)fetchStatusForOrder:(NSString *)idStatus;


- (void)SaveProductToEntityName:(NSString *)entityName
                         WithId:(NSNumber *)underbarid
                      withCount:(int)countOfProducts
                      withPrice:(float)cost
                    withPicture:(NSData *)picture
              withDiscountValue:(float)discountValue
                     withWeight:(NSNumber *)weight
                    withProtein:(NSNumber *)protein
                      withCarbs:(NSNumber *)carbs
                       withFats:(NSNumber *)fats
                   withCalories:(NSNumber *)calories
                    isFavorites:(BOOL)isFavorites
                          isHit:(BOOL)hit
                     withIdMenu:(NSString *)idMenu;

- (NSArray *)fetchAllProductsIdAndTheirCountWithPriceForEntity:(NSString *)entityName;

//- (void) deleteObjectFromEntity:(NSString *)entityName atIndexPath:(NSIndexPath *)indexPath;
- (void) deleteObjectFromEntity:(NSString *)entityName
                  withProductId:(NSNumber *)underbarid;

- (NSArray *) fetchObjectsFromCoreDataForEntity:(NSString *)entityName
                               withArrayObjects:(NSArray *)underbaridsArray
                          withDefaultLanguageId:(NSString *)languageId;

//для updatePHP, а саме параметра tag=param
- (NSNumber *) fetchMaximumNumberOfAttribute:(NSString *)fieldName
                                  fromEntity:(NSString *)entityName;


- (NSArray *) fetchAllIdsFromEntity:(NSString *)entityName;

- (int) fetchCountOfProductsInEntity:(NSString *)entityName;

-  (BOOL) addObjectToEntity:(NSString *)entityName
 withDictionaryOfAttributes:(NSDictionary *)dictionary;

- (void) addObjectToCoreDataEntity:(NSString *)entityName
        withDictionaryOfAttributes:(NSDictionary *)dictionary;

- (void) deleteAddressWithName:(NSString *)name;
- (void) deleteOrderWithId:(NSString *)idOrder;
- (void) deleteReservationWithID:(NSString *) idReservation;

- (NSArray *)fetchFavoritesFromEntityName:(NSString *)entityName;
- (void) changeFavoritesBoolValue:(BOOL)isFavorites forId:(NSNumber *)underbarid;

- (BOOL)isRestaurantCanMakeOrderWithRestaurantID:(NSString *)idRestaurant;

-(NSString *)fetchIdRestaurantFromIdMenu:(NSString *)idMenu;
- (NSArray *)fetchAllObjectsFromEntity:(NSString *)entityName;
@end
