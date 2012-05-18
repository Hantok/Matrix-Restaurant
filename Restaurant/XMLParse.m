//
//  XMLParse.m
//  XMLParser
//
//  Created by Bogdan Geleta on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParse.h"

@interface XMLParse()

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
    [self GetAllRestaurantsNamesOnLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
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
                        for(int i=0;i<keys.count;i++)
                        {
                            id key = [keys objectAtIndex:i];
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
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
}


#pragma Bogdan Geleta

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

-(NSArray *)GetAllRestaurantsNamesOnLanguage:(NSNumber *)languageId
{
    NSMutableArray *restaurantsNames = [[NSMutableArray alloc] init];
    NSMutableDictionary *allRestaurantsByAllLanguages = [self.tables objectForKey:@"Restaurants_translation"];
    NSArray *allIdLanguagesForRestaurants = [allRestaurantsByAllLanguages objectForKey:@"idLanguage"];
    NSArray *allRestaurantsNames = [allRestaurantsByAllLanguages objectForKey:@"name"];
    
    for(int i=0; i<allIdLanguagesForRestaurants.count;i++)
    {
        if([[[allIdLanguagesForRestaurants objectAtIndex:i] description] isEqualToString:languageId.description])
        {
            
            [restaurantsNames addObject:[allRestaurantsNames objectAtIndex:i]];
        }
    }
    
    
    return [restaurantsNames copy];
}

#pragma Roman Slysh



@end
