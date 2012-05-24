
//
//  GettingCoreContent.m
//  Restaurants
//
//  Created by Matrix Soft on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GettingCoreContent.h"
#import "RestaurantAppDelegate.h"
//хуй2

@implementation GettingCoreContent

@synthesize arrayOfCoreData = _arrayOfCoreData;
@synthesize managedObjectContext = _managedObjectContext;

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
    
    
	NSError *error = nil;
	if (![	aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    self.arrayOfCoreData = [context executeFetchRequest:fetchRequest error:&error];
    
    return self.arrayOfCoreData;
}


- (void) setCoreDataForEntityWithName:(NSString *)entityName 
    dictionaryOfAtributes:(NSDictionary *)attributeDictionary;
{
    
    NSManagedObjectContext * context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSArray *keys = [attributeDictionary allKeys];
    int counter = 0;
    NSString *editAttrinbuteWithUnderBar = [[NSString alloc] init];
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
            
            [newManagedObject setValue:[values objectAtIndex:counter] forKey:editAttrinbuteWithUnderBar];
        }
        counter++;
    }
    // Save the context.
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}


- (void) deleteAllObjectsFromEntity:(NSString *)entityDescription{
    NSManagedObjectContext * context = [(RestaurantAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
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
        request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@ && underbarid == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"], [[citiesIDs objectAtIndex:i] valueForKey:@"underbarid"]];
        [resultOfARequest addObjectsFromArray:[moc executeFetchRequest:request error:&error]];
    }
    NSLog(@"smth")	;
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
    NSMutableArray *resultOfARequest = [[NSMutableArray alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"Menus_translation"];
    request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@ && idMenu == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"], [[menuIDs objectAtIndex:0] valueForKey:@"underbarid"]];
        [resultOfARequest addObjectsFromArray:[moc executeFetchRequest:request error:&error]];
    [resultOfARequest addObjectsFromArray:menuIDs];
    NSLog(@"smth")	;
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
    NSLog(@"smth")	;
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
    NSString *urlForImage = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test3/%@",[[resultOfARequest objectAtIndex:0] valueForKey:@"link"]];
    urlForImage = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:urlForImage];
    return url;
}

-(NSArray *)fetchAllProductsFromMenu:(NSString *)menuId
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Products" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"idMenu == %@",menuId];
    NSManagedObjectContext *moc = context;
    NSError *error;
    NSMutableArray *menuIDs = [[moc executeFetchRequest:request error:&error] mutableCopy];
    NSMutableArray *resultOfARequest = [[NSMutableArray alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"Descriptions_translation"];
    for(int i = 0;i<menuIDs.count;i++)
    {
        id currentMenu = [menuIDs objectAtIndex:i];
        request.predicate = [NSPredicate predicateWithFormat:@"idLanguage == %@ && idProduct == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"], [currentMenu valueForKey:@"underbarid"]];
        [resultOfARequest addObject:currentMenu];
        [resultOfARequest addObjectsFromArray:[moc executeFetchRequest:request error:&error]];
    }
    NSLog(@"smth")	;
    return [resultOfARequest copy]; 
}

@end
