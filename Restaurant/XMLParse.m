//
//  XMLParse.m
//  XMLParser
//
//  Created by Bogdan Geleta on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParse.h"

@interface XMLParse()
{
    BOOL needToChangeLogoPicture;
}

@property (strong, nonatomic) NSMutableArray *fields;
@property (strong, nonatomic) NSMutableDictionary *rows;
@property (strong, nonatomic) NSString *currentTableName;

@end

@implementation XMLParse


@synthesize done=_done;
@synthesize error=_error;
@synthesize tables = _tables;
@synthesize currentTableName = _currentTableName;
@synthesize fields = _fields;
@synthesize rows = _rows;

// документ начал парситься
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.done = NO;
    self.tables = [[NSMutableDictionary alloc] init];
    NSLog(@"PARSE IS BEGUN");
}
// парсинг окончен
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.done = YES;
    [self GetAllRestaurantsNamesOnLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"] forCity:[[NSNumber alloc] initWithInt:3]];
    NSLog(@"PARSE IS END");
}
// если произошла ошибка парсинга
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    self.done = YES;
}
// если произошла ошибка валидации
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    self.done = YES;
}
// встретили новый элемент
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"TABLE"])
    {
        if([attributeDict objectForKey:@"TableName"])
        {
            self.currentTableName = [attributeDict objectForKey:@"TableName"];
        }
    }
    else{
        if([elementName isEqualToString:@"FIELDS"])
        {
            self.fields = [[NSMutableArray alloc] init];
        }
        else {
            if([elementName isEqualToString:@"FIELD"])
            {
                [self.fields addObject:[attributeDict objectForKey:@"FieldName"]];
            }
            else {
                if([elementName isEqualToString:@"ROWDATA"])
                {
                    self.rows = [[NSMutableDictionary alloc] init];
                }
                else {
                    if([elementName isEqualToString:@"ROW"])
                    {
                        NSArray *keys = [attributeDict allKeys];
                        id key = nil;
                        for(int i=0;i<keys.count;i++)
                        {
                            key = [keys objectAtIndex:i];
                            if([self.rows objectForKey:key])
                            {
                                [[self.rows objectForKey:key] addObject:[attributeDict objectForKey:key]];
                            }
                            else {
                                NSMutableArray *valuesForRow = [[NSMutableArray alloc] init];
                                [valuesForRow addObject:[attributeDict objectForKey:key]];
                                [self.rows setObject:valuesForRow forKey:key];
                            }
                        }
                    }
                }
            }
        }
    }
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"TABLE"])
    {
        self.currentTableName = nil;
    }
    else {
        if([elementName isEqualToString:@"ROWDATA"])
        {
            [self.tables setObject:[self.rows copy] forKey:self.currentTableName];
            self.rows = nil;
        }
        else {
            
        }
    }

}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // трішки бидлокоду
    if (string.integerValue)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"logoVersion"] integerValue] != string.integerValue)
        {
            NSLog(@"Logo Version = %@", string);
            [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"logoVersion"];
            needToChangeLogoPicture = YES;
            return;
        }
    }
    if (needToChangeLogoPicture == YES && string.length > 6)
    {
        NSLog(@"Link is %@", string);
        NSString *utf8String = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *fullURLString = [NSString stringWithFormat:@"http://matrix-soft.org/addon_domains_folder/test7/root/%@",utf8String];
        
        //add logoURL
        //[[NSUserDefaults standardUserDefaults] setValue:fullURLString forKey:@"LogoURL"];
        
        NSData *dataImage =  [NSData dataWithContentsOfURL:[NSURL URLWithString:fullURLString]];
        if (dataImage)
        {
            [[NSUserDefaults standardUserDefaults] setValue:dataImage forKey:@"logo"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logoVersion"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
}


#pragma mark - Bogdan Geleta

-(NSArray *)GetAllLanguages
{
    NSMutableDictionary *languages = [self.tables objectForKey:@"Languages"];
    languages = [languages objectForKey:@"language"];
    return (NSArray *)languages;
}

-(NSArray *)GetAllCitiesOnLanguage:(NSNumber *)languageId
{
    NSMutableArray *cities = cities = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *allCitiesByAllLanguages = [self.tables objectForKey:@"Cities_translation"];
    NSArray *allIdLanguagesForCities = [allCitiesByAllLanguages objectForKey:@"idLanguage"];
    NSArray *allCitiesNames = [allCitiesByAllLanguages objectForKey:@"name"];
   // NSArray *allCitiesIDs = [allCitiesByAllLanguages objectForKey:@"idCity"];
    //int countOfCities = 0;
    for(int i=0; i<allIdLanguagesForCities.count;i++)
    {
        if([[[allIdLanguagesForCities objectAtIndex:i] description] isEqualToString:languageId.description])
        {
            
            [cities addObject:[allCitiesNames objectAtIndex:i]];
        }
    }
    return [cities copy];
    
}

-(NSArray *)GetAllRestaurantsNamesOnLanguage:(NSNumber *)languageId forCity:(NSNumber *)cityId
{
    NSMutableArray *restaurantsNames = [[NSMutableArray alloc] init];
    
    
    
    NSMutableDictionary *allRestaurantsByAllLanguages = [self.tables objectForKey:@"Restaurants_translation"];
    NSArray *allIdLanguagesForRestaurants = [allRestaurantsByAllLanguages objectForKey:@"idLanguage"];
    NSArray *allIdCitiesForRestaurants = [allRestaurantsByAllLanguages objectForKey:@"idCity"];
    NSArray *allRestaurantsNames = [allRestaurantsByAllLanguages objectForKey:@"name"];
    
    for(int i=0;i<allIdLanguagesForRestaurants.count;i++)
    {
        if([[[allIdLanguagesForRestaurants objectAtIndex:i] description] isEqualToString:languageId.description] && [[[allIdCitiesForRestaurants objectAtIndex:i] description] isEqualToString:cityId.description])
        {
            
            [restaurantsNames addObject:[allRestaurantsNames objectAtIndex:i]];
        }
    }
    
    
    return [restaurantsNames copy];
}

-(NSArray *)GetAllIDsOfRestorantsForCity:(NSNumber *)cityId
{
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *allRestaurants = [self.tables objectForKey:@"Restaurants"];
    NSArray *idOfRestoraunts = [allRestaurants objectForKey:@"_id"];
    NSArray *idCity = [allRestaurants objectForKey:@"idCity"];
    
    for(int i=0;i<idCity.count;i++)
    {
        if([[[idCity objectAtIndex:i] description] isEqualToString:cityId.description])
        {
            [ids addObject:[idOfRestoraunts objectAtIndex:i]];
        }
    }
    
    
    return ids;
}

-(void)manual
{
    NSArray *allKeysForEntity= [self.tables allKeys]; //Names of all entities
    NSArray *allKeysForAttributes = [[NSArray alloc] init];
    NSArray *allValuesOfSomeAttributes = [[NSArray alloc] init];
    NSDictionary *someEntity =[[NSDictionary alloc] init];
    for(int i=0;i<allKeysForEntity.count;i++) //цикл получающий каждое энтети поочередно
    {
        someEntity = [self.tables objectForKey:[allKeysForEntity objectAtIndex:i]];
        allKeysForAttributes = [someEntity allKeys];
        for(int j=0;j<allKeysForAttributes.count;j++)
        {
            allValuesOfSomeAttributes = [someEntity objectForKey:[allKeysForAttributes objectAtIndex:j]];
            for(int k=0;k<allValuesOfSomeAttributes.count;k++)
                NSLog(@"%@",[[allValuesOfSomeAttributes objectAtIndex:k] description]);
        }
        
        
    }
}

#pragma mark - Private methods

//Get Image From URL
-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfFile:fileURL];//initWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

@end
