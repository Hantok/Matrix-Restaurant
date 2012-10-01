//
//  Singleton.m
//  Restaurant
//
//  Created by Roman Slysh on 9/21/12.
//
//

#import "Singleton.h"

@interface Singleton()

@end

@implementation Singleton

#pragma mark Singleton Methods

+ (NSArray *)titlesTranslation_withISfromSettings:(BOOL)boolValue
{
    static NSArray *titles;
    static NSArray *titles_translation;
    static GettingCoreContent *db;
    
    if (titles_translation == nil)
    {
        db = [[GettingCoreContent alloc] init];
        titles = [db fetchAllObjectsFromEntity:@"Titles"];
        NSString *defaultLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"];
        if (defaultLanguage)
        {
            titles_translation = [db fetchObjectsFromCoreDataForEntity:@"Titles_translation" withArrayObjects:titles withDefaultLanguageId:defaultLanguage];
        }
        else
        {
            titles_translation = [db fetchObjectsFromCoreDataForEntity:@"Titles_translation" withArrayObjects:titles withDefaultLanguageId:@"1"];
            
        }

    }
    else if (boolValue == YES)
    {
        NSString *defaultLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"];
        if (defaultLanguage)
        {
            titles_translation = [db fetchObjectsFromCoreDataForEntity:@"Titles_translation" withArrayObjects:titles withDefaultLanguageId:defaultLanguage];
        }
        else
        {
            titles_translation = [db fetchObjectsFromCoreDataForEntity:@"Titles_translation" withArrayObjects:titles withDefaultLanguageId:@"1"];
            
        }
    }

    return titles_translation;
}

@end