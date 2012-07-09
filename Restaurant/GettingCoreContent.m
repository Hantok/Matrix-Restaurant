//
//  GettingCoreContent.m
//  Restaurants
//
//  Created by Matrix Soft on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GettingCoreContent.h"
#import "RestaurantAppDelegate.h"
#import "ProductDataStruct.h"

@interface GettingCoreContent()

@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation GettingCoreContent

@synthesize arrayOfCoreData = _arrayOfCoreData;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

-(NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext)
    {
        _managedObjectContext = [(RestaurantAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return _managedObjectContext;
}

- (NSArray *)getArrayFromCoreDatainEntetyName:(NSString *)entityName withSortDescriptor:(NSString *)attributeString
{
    
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeString ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    //self.fetchedResultsController = aFetchedResultsController;
    
    
	NSError *error = nil;
	if (![	aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    abort();
	}
    
    self.arrayOfCoreData = [context executeFetchRequest:fetchRequest error:&error];
    
    return self.arrayOfCoreData;
}


- (void) setCoreDataForEntityWithName:(NSString *)entityName 
                dictionaryOfAtributes:(NSDictionary *)attributeDictionary;
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSArray *items= [self fetchAllIdsFromEntity:entityName];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSArray *keys = [attributeDictionary allKeys];
    int counter = 0;
    NSString *editAttrinbuteWithUnderBar = [[NSString alloc] init];
    if(attributeDictionary.count)
    {
        NSArray *ArrayOfEnteringIDs = [attributeDictionary objectForKey:@"_id"]; 
        for (int i = 0; i < items.count; i++)
        {
            for (int j = 0; j < ArrayOfEnteringIDs.count; j++)
                if ([[items objectAtIndex:i] intValue] == [[[attributeDictionary objectForKey:@"_id"] objectAtIndex:j] intValue])
                {
                    [self deleteObjectFromEntity:entityName withProductId:[items objectAtIndex:i]];
                    break;
                }
        }
        
        if ([entityName isEqualToString:@"Products"])
        {
            NSArray *arrayOfCartsIds = [self fetchAllIdsFromEntity:@"Cart"];
            NSArray *arrayOfFavoritesIds = [self fetchAllIdsFromEntity:@"Favorites"];
            
            for (int i = 0; i < arrayOfCartsIds.count; i++)
                for (int j = 0; j < ArrayOfEnteringIDs.count; j++)
                    if ([[arrayOfCartsIds objectAtIndex:i] intValue] == [[[attributeDictionary objectForKey:@"_id"] objectAtIndex:j] intValue])
                    {
                        [self deleteObjectFromEntity:@"Cart" withProductId:[arrayOfCartsIds objectAtIndex:i]];
                    }
            
            for (int j = 0; j < arrayOfFavoritesIds.count; j++)
                for (int i = 0; i < ArrayOfEnteringIDs.count; i++)
                    if ([[arrayOfFavoritesIds objectAtIndex:i] intValue] == [[[attributeDictionary objectForKey:@"_id"] objectAtIndex:j] intValue])
                    {
                        [self deleteObjectFromEntity:@"Favorites" withProductId:[arrayOfFavoritesIds objectAtIndex:i]];
                    }
            
        }
        
        NSArray *values = [attributeDictionary objectForKey:[keys objectAtIndex:0]];
        while(counter <  values.count)
        {
            NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
            for(int i=0;i<keys.count;i++)
            {
                id objectAtIndexI = [keys objectAtIndex:i];
                values = [attributeDictionary objectForKey:objectAtIndexI];
                editAttrinbuteWithUnderBar = objectAtIndexI;
                
                NSString *subString = [editAttrinbuteWithUnderBar substringToIndex:1];
                //[editAttrinbuteWithUnderBar characterAtIndex:0];
                if([editAttrinbuteWithUnderBar characterAtIndex:0] == '_')
                {
                    editAttrinbuteWithUnderBar = [NSString stringWithFormat:@"%@%@", @"underbar", [editAttrinbuteWithUnderBar substringFromIndex:1]];
                }
                
                else if ([subString uppercaseString])
                {
                    editAttrinbuteWithUnderBar = [NSString stringWithFormat:@"%@%@", [subString lowercaseString], [editAttrinbuteWithUnderBar substringFromIndex:1]];
                    if ([editAttrinbuteWithUnderBar isEqualToString:@"description"])
                    {
                        editAttrinbuteWithUnderBar = @"descriptionAbout";
                    }
                }
                if ([editAttrinbuteWithUnderBar isEqualToString:@"idPicture"] || [editAttrinbuteWithUnderBar isEqualToString:@"underbarid"] || [editAttrinbuteWithUnderBar isEqualToString:@"idProduct"] || [editAttrinbuteWithUnderBar isEqualToString:@"version"] || [editAttrinbuteWithUnderBar isEqualToString:@"isOrder"] || [editAttrinbuteWithUnderBar isEqualToString:@"terrace"] || [editAttrinbuteWithUnderBar isEqualToString:@"parking"] || [editAttrinbuteWithUnderBar isEqualToString:@"seatsNumber"] || [editAttrinbuteWithUnderBar isEqualToString:@"hit"] ||
                    [editAttrinbuteWithUnderBar isEqualToString:@"carbs"] || [editAttrinbuteWithUnderBar isEqualToString:@"calories"] || [editAttrinbuteWithUnderBar isEqualToString:@"weight"] ||[editAttrinbuteWithUnderBar isEqualToString:@"protein"] || [editAttrinbuteWithUnderBar isEqualToString:@"fats"]) 
                {
                    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                    [f setNumberStyle:NSNumberFormatterDecimalStyle];
                    NSNumber * idPicture = [f numberFromString:[values objectAtIndex:counter]];
                    [newManagedObject setValue:idPicture forKey:editAttrinbuteWithUnderBar];
                }
                else 
                    if ([editAttrinbuteWithUnderBar isEqualToString:@"action"])
                    {
                        if([[[attributeDictionary objectForKey:@"action"] objectAtIndex:counter] isEqual:@"2"])
                        {
                            [self deleteObjectFromEntity:entityName withProductId:[ArrayOfEnteringIDs objectAtIndex:counter]];
                            break;
                        }
                        else 
                        {
                            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                            [f setNumberStyle:NSNumberFormatterDecimalStyle];
                            NSNumber *numberValue = [f numberFromString:[values objectAtIndex:counter]];
                            [newManagedObject setValue:numberValue forKey:editAttrinbuteWithUnderBar];
                        }
                    }
                    else 
                    {
                        [newManagedObject setValue:[[values objectAtIndex:counter] description] forKey:editAttrinbuteWithUnderBar];
                    }
            }
            counter++;
        }
        // Save the context.
        //NSError *error = nil;
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
}


- (void) deleteAllObjectsFromEntity:(NSString *)entityDescription{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    if (entityDescription == nil)
        NSLog(@"NSLOG");
    else 
    {
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
        for (NSManagedObject *managedObject in items) {
            [context deleteObject:managedObject];
            //NSLog(@"%@ object deleted",entityDescription);
        }
        if (![context save:&error]) {
            NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
        }
    }
    
}

- (NSArray *)fetchAllRestaurantsWithDefaultLanguageAndCity
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Restaurants" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"idCity == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"]];
    NSManagedObjectContext *moc = context;
    NSError *error;
    NSMutableArray *citiesIDs = [[moc executeFetchRequest:request error:&error] mutableCopy];
    NSMutableArray *resultOfARequest = [[NSMutableArray alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurants_translation"];
    for(int i=0;i<citiesIDs.count;i++)
    {
        id currentCity = [citiesIDs objectAtIndex:i];
        request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@ && idRestaurant == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"], [currentCity valueForKey:@"underbarid"]];
        [resultOfARequest addObject:currentCity];
        [resultOfARequest addObjectsFromArray:[moc executeFetchRequest:request error:&error]];
    }
    return [resultOfARequest copy];
}

-(NSArray *)fetchRootMenuWithDefaultLanguageForRestaurant:(NSString *)restaurnatId
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Menus" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"idParentMenu == 0 && idRestaurant == %@",restaurnatId];
    NSManagedObjectContext *moc = context;
    NSError *error;
    NSMutableArray *menuIDs = [[moc executeFetchRequest:request error:&error] mutableCopy];
    NSMutableArray *resultOfARequest;
    if(menuIDs.count)
    {
        resultOfARequest = [[NSMutableArray alloc] init];
        request = [NSFetchRequest fetchRequestWithEntityName:@"Menus_translation"];
        request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@ && idMenu == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"], [[menuIDs objectAtIndex:0] valueForKey:@"underbarid"]];
        [resultOfARequest addObjectsFromArray:menuIDs];
        [resultOfARequest addObjectsFromArray:[moc executeFetchRequest:request error:&error]];
    }
    return [resultOfARequest copy]; 
}

-(NSArray *)fetchChildMenuWithDefaultLanguageForParentMenu:(NSString *)parentMenuId
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Menus" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"idParentMenu == %@",parentMenuId];
    NSManagedObjectContext *moc = context;
    NSError *error;
    NSMutableArray *menuIDs = [[moc executeFetchRequest:request error:&error] mutableCopy];
    NSMutableArray *resultOfARequest = [[NSMutableArray alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"Menus_translation"];
    for(int i = 0;i<menuIDs.count;i++)
    {
        id currentMenu = [menuIDs objectAtIndex:i];
        request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@ && idMenu == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"], [currentMenu valueForKey:@"underbarid"]];
        [resultOfARequest addObject:currentMenu];
        [resultOfARequest addObjectsFromArray:[moc executeFetchRequest:request error:&error]];
    }
    return [resultOfARequest copy]; 
}

-(NSArray *)fetchAllLanguages
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Languages" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"underbarid > 0"];
    NSManagedObjectContext *moc = context;
    NSError *error;
    NSMutableArray *resultOfARequest = [[moc executeFetchRequest:request error:&error] mutableCopy];
    return [resultOfARequest copy]; 
}

-(NSArray *)fetchAllCitiesByLanguage:(NSString *)languageId
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cities_translation" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@", languageId];
    NSManagedObjectContext *moc = context;
    NSError *error;
    NSMutableArray *resultOfARequest = [[moc executeFetchRequest:request error:&error] mutableCopy];
    return [resultOfARequest copy];
}

-(NSArray *)fetchAllProductsFromMenu:(NSString *)menuId
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Products" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"idMenu == %@",menuId];
    NSError *error;
    NSLog(@"Dasdasd");
    NSMutableArray *menuIDs = [[context executeFetchRequest:request error:&error] mutableCopy];
    NSLog(@"DasdasdEND!!111");
    NSMutableArray *resultOfARequest = [[NSMutableArray alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"Products_translation"];
    request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"idProduct" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *resultOfSecondRequest = [context executeFetchRequest:request error:&error];
    NSLog(@"for begin");
    NSInteger index;
    NSInteger count = resultOfSecondRequest.count;
    for(int i = 0;i<menuIDs.count;i++)
    {
        id currentMenu = [menuIDs objectAtIndex:i];
        [currentMenu valueForKey:@"underbarid"];
        index = [self binarySearchIn:resultOfSecondRequest byKey:[currentMenu valueForKey:@"underbarid"] between:0 and:count forAttribute:@"idProduct"];
        [resultOfARequest addObject:currentMenu];
        [resultOfARequest addObject:[resultOfSecondRequest objectAtIndex:index]];
    }
    NSLog(@"for end!!111");
    return [resultOfARequest copy]; 
}

- (void)SavePictureToCoreData:(NSString *)idPicture toData:(NSData *)data
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Pictures" inManagedObjectContext:self.managedObjectContext]];
    
    if (idPicture.intValue != 0)
        [request setPredicate:[NSPredicate predicateWithFormat:@"underbarid==%@", idPicture]];
    else
        return;
    
    NSError *error;
    NSArray *debug= [self.managedObjectContext executeFetchRequest:request error:&error];
    NSManagedObject *objectToUpdate = [debug objectAtIndex:0];
    if (objectToUpdate != nil)
        [objectToUpdate setValue:data forKey:@"data"];
    if (![self.managedObjectContext save:&error]) {
        //Handle any error with the saving of the context
    }
}

- (NSData *)fetchPictureDataByPictureId:(NSString *)pictureId
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Pictures" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"underbarid==%@", pictureId]];
    
    NSError *error;
    NSArray *debug= [self.managedObjectContext executeFetchRequest:request error:&error];
    if (debug.count != 0)
    {
        NSManagedObject *objectToGet = [debug objectAtIndex:0];
        return [objectToGet valueForKey:@"data"];
    }
    else
    {
        return nil;
    }
}

- (NSURL *)fetchImageURLbyPictureID:(NSString *)pictureId
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pictures" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"underbarid == %@", pictureId];
    NSManagedObjectContext *moc = context;
    NSError *error;
    
    NSArray *resultOfARequest = [moc executeFetchRequest:request error:&error];
//    if (resultOfARequest.count != 0)
    {
        NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test6/root/%@",[[resultOfARequest objectAtIndex:0] valueForKey:@"link"]];
        urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:urlForImage];
        return url;
    }
//    else {
//        return nil;
//    }
}

- (NSDictionary *)fetchImageURLAndDatabyMenuID:(NSString *)menuId
{
    
    NSMutableDictionary *dontTouchThisOne = [[NSMutableDictionary alloc] init];
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Products" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idPicture" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"idMenu == %@", menuId];
    NSManagedObjectContext *moc = context;
    NSError *error;
    
    NSArray *resultOfARequest = [moc executeFetchRequest:request error:&error];
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"Pictures"];
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"underbarid" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    request.predicate = [NSPredicate predicateWithFormat:@"underbarid > %@", [NSString stringWithFormat:@"%i",0]];
    NSArray *resultOfSecondRequest = [moc executeFetchRequest:request error:&error];
    int count = resultOfARequest.count;
    id product;
    id picture;
    int secondCount = resultOfSecondRequest.count;
    int index;
    for(int i = 0; i < count; i++)
    {
        product = [resultOfARequest objectAtIndex:i];
        index = [self binarySearchIn:resultOfSecondRequest byKey:[product valueForKey:@"idPicture"] between:0 and:secondCount forAttribute:@"underbarid"];
        if(index != -1)
        {
            picture = [resultOfSecondRequest objectAtIndex:index];
            [dontTouchThisOne setObject:picture forKey:[picture valueForKey:@"underbarid"]];
        }
        
        
    }
    //NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test4/root/%@",[[resultOfARequest objectAtIndex:0] valueForKey:@"link"]];
    //urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //NSURL *url = [[NSURL alloc] initWithString:urlForImage];
    
    
    return dontTouchThisOne.copy;
}

-(NSInteger)binarySearchIn:(NSArray *)anArray byKey:(NSNumber *)aKey between:(NSInteger)imin and:(NSInteger)imax forAttribute:(NSString *)anAttribute
{
    // test if array is empty
    if (imax < imin)
        // set is empty, so return value showing not found
        return 0;
    else
    {
        // calculate midpoint to cut set in half
        int imid = (imin + imax) / 2;
        
        // three-way comparison
        if ([[[anArray objectAtIndex:imid] valueForKey:anAttribute] integerValue] > [aKey integerValue])
            // key is in lower subset
            return [self binarySearchIn:anArray byKey:aKey between:imin and:imid-1 forAttribute:anAttribute];
        else if ([[[anArray objectAtIndex:imid] valueForKey:anAttribute] integerValue] < [aKey integerValue])
            // key is in upper subset
            return [self binarySearchIn:anArray byKey:aKey between:imid+1 and:imax forAttribute:anAttribute];
        else return imid;
    }
}


- (void)SaveProductToEntityName:(NSString *)entityName WithId:(NSNumber *)underbarid withCount:(int)countOfProducts withPrice:(float)cost withPicture:(NSData *)picture
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error;
    NSArray *debug= [self.managedObjectContext executeFetchRequest:request error:&error];
    BOOL allreadyInEntity = NO;
    for (int i = 0; i < debug.count; i++)
    {
        if ([[[debug objectAtIndex:i] valueForKey:@"underbarid"] isEqual:underbarid])
        {
            NSManagedObject *objectToUpdate = [debug objectAtIndex:i];
            if(countOfProducts != 0)
            {
                int curInt = [[objectToUpdate valueForKey:@"count"] intValue] + countOfProducts;
                [objectToUpdate setValue:[NSNumber numberWithInt:curInt] forKey:@"count"];
            }
            allreadyInEntity = YES;
            break;
        }
    }
    if (!allreadyInEntity)
    {
        NSManagedObject *objectToInsert = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
        [objectToInsert setValue:underbarid forKey:@"underbarid"];
        [objectToInsert setValue:[NSNumber numberWithFloat:cost] forKey:@"cost"];
        [objectToInsert setValue:picture forKey:@"picture"];
        if(countOfProducts != 0)
        {
            [objectToInsert setValue:[NSNumber numberWithInt:countOfProducts] forKey:@"count"];
        }
    }
    
    // Save the context.
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSArray *)fetchAllProductsIdAndTheirCountWithPriceForEntity:(NSString *)entityName
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error;
    NSArray *arrayOfDictionaries= [self.managedObjectContext executeFetchRequest:request error:&error];
    
    // Save the context.
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return  arrayOfDictionaries;
}


//working
- (NSArray *) fetchObjectsFromCoreDataForEntity:(NSString *)entityName withArrayObjects:(NSArray *)underbaridsArray withDefaultLanguageId:(NSString *)languageId
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    
    NSError *error;
    NSArray *items= [context executeFetchRequest:request error:&error];
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <items.count; i++)
    {
        for (int j = 0; j < underbaridsArray.count; j++)
        {
            if ([[[[items objectAtIndex:i] valueForKey:@"idProduct"] description] isEqual:[[[underbaridsArray objectAtIndex:j] valueForKey:@"underbarid"] description]])
            {
                if ([[[[items objectAtIndex:i] valueForKey:@"idLanguage"] description] isEqualToString:[languageId description]])
                {
                    [outputArray addObject:[items objectAtIndex:i]]; 
                }
            }
        }
    }
    
    // Save the context.
    if (![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return  outputArray.copy;
}


- (void) deleteObjectFromEntity:(NSString *)entityName withProductId:(NSNumber *)underbarid
{    
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (int i = 0; i < items.count; i++)
    {
        //if ([[items objectAtIndex:i] isEqual:[items objectAtIndex:indexPath.row]])
        //    [context deleteObject:[items objectAtIndex:i]];
        if ([[[items objectAtIndex:i] valueForKey:@"underbarid"] intValue] == underbarid.intValue || [[[items objectAtIndex:i] valueForKey:@"underbarid"] intValue] == 0)
        {
            [context deleteObject:[items objectAtIndex:i]];
            break;
        }
    }
    
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@", entityName, error);
    }
}

- (NSNumber *) fetchMaximumNumberOfAttribute:(NSString *)fieldName fromEntity:(NSString *)entityName
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    
    NSError *error;
    NSArray *items= [context executeFetchRequest:request error:&error];
    NSNumber *maxVersion;
    if (items.count != 0)
    {
        maxVersion = [[items objectAtIndex:0] valueForKey:fieldName];
        for (int i = 0; i<items.count; i++)
        {
            if ([[[items objectAtIndex:i] valueForKey:fieldName] intValue] > maxVersion.intValue)
                maxVersion = [[items objectAtIndex:i] valueForKey:fieldName];
        }
        return maxVersion;
    }
    else {
        maxVersion = [NSNumber numberWithInt:0];
        return maxVersion;
    }
}

- (NSArray *) fetchAllIdsFromEntity:(NSString *)entityName
{   
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    
    NSError *error;
    NSArray *items= [context executeFetchRequest:request error:&error];
    NSMutableArray *arrayOfIds = [[NSMutableArray alloc] init];
    if (items.count != 0)
    {
        for (int i = 0; i<items.count; i++)
        {
            [arrayOfIds addObject:[[items objectAtIndex:i] valueForKey:@"underbarid"]];
        }    
        return arrayOfIds.copy;
    }
    else 
    {
        return nil;
    }
}
@end
