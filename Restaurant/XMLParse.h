//
//  XMLParse.h
//  XMLParser
//
//  Created by Bogdan Geleta on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParse : NSXMLParser <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableDictionary *tables; // Ключи - название таблиц базы данных, по этим ключам лежат NSMutableDictionary, где ключи - название полей, по ключам лежат массивы с значениями для этих полей.
@property BOOL done;
@property BOOL error;

#pragma Bogdan Geleta
-(NSArray *)GetAllLanguages;
-(NSArray *)GetAllCitiesOnLanguage:(NSNumber *)languageId;
-(NSArray *)GetALLRestaurantsNamesOnLanguage:(NSNumber *)languageId;

#pragma Roman Slysh


@end
