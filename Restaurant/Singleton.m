//
//  Singleton.m
//  Restaurant
//
//  Created by Roman Slysh on 9/21/12.
//
//

#import "Singleton.h"

@interface Singleton()

@property (nonatomic, strong) NSArray *someProperty;

@end

@implementation Singleton

@synthesize someProperty = _someProperty;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init //повертає массив перекладу на поточній мові
{
    if (self = [super init])
    {
        GettingCoreContent *db = [[GettingCoreContent alloc] init];
        NSArray *array = [db fetchAllObjectsFromEntity:@"Titles"];
        NSString *defaultLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"];
        if (defaultLanguage)
        {
            _someProperty = [db fetchObjectsFromCoreDataForEntity:@"Titles_translation" withArrayObjects:array withDefaultLanguageId:defaultLanguage];
        }
        else
        {
            _someProperty = [db fetchObjectsFromCoreDataForEntity:@"Titles_translation" withArrayObjects:array withDefaultLanguageId:@"1"];
            
        }
        
    }
    return (id)_someProperty;
}

@end