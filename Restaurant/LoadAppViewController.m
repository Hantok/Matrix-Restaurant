//
//  LoadAppViewController.m
//  Restaurant
//
//  Created by Bogdan Geleta on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadAppViewController.h"
#import "GettingCoreContent.h"
#import "XMLParse.h"

@interface LoadAppViewController ()

@end

@implementation LoadAppViewController

@synthesize imageView = _imageView;
@synthesize activityIndicator = _activityIndicator;
@synthesize city = _city;
@synthesize db = _db;



- (void)DropCoreData
{
    NSArray *allKeys = [self.db.tables allKeys];
    GettingCoreContent *content = [[GettingCoreContent alloc] init];
    for(int i = 0; i < self.db.tables.count;i++)
    {
        [content deleteAllObjectsFromEntity:[allKeys objectAtIndex:i]];
    }
}

- (void)XMLToCoreData
{
    NSArray *allKeys = [self.db.tables allKeys];
    for(int i = 0; i< [self.db.tables count]; i++)
    {
        GettingCoreContent *content = [[GettingCoreContent alloc] init];
        [content setCoreDataForEntityWithName:[allKeys objectAtIndex:i] dictionaryOfAtributes:[self.db.tables objectForKey:[allKeys objectAtIndex:i]]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    
    
    NSURL* rssURL = [NSURL URLWithString:@"http://matrix-soft.org/addon_domains_folder/test3/System_files/XML/matrixso_test3/DBStructure.xml"];
    // создаем парсер при помощи URL, назначаем делегат и запускаем
    NSLog(@"Download is begun");
    XMLParse* parser
    = [[XMLParse alloc] initWithContentsOfURL:rssURL];
    [parser setDelegate:parser];
    [parser parse];
    
    self.db = parser;
    
    if(/*интерент есть то делаем этo*/true)
    {
        [self DropCoreData];
        [self XMLToCoreData];
    }
    
    NSLog(@"I'm in viewDidLoad");
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.activityIndicator stopAnimating];
    [super viewDidAppear:YES];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"defaultLanguageId"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"defaultCityId"];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"])
    {
        NSArray *languages = [self.db GetAllLanguages];
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Select language:"];
        [actionSheet setDelegate:(id)self];
        
        for( int i=0; i<languages.count; i++ )
            [actionSheet addButtonWithTitle:[languages objectAtIndex:i]];
        
        [actionSheet showInView:self.view];
    } else 
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"])
    {
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"])
     {
         [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithInteger:buttonIndex+1] forKey:@"defaultLanguageId"];
         UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
         [actionSheet setTitle:@"Select city:"];
         [actionSheet setDelegate:(id)self];
         
         NSArray *cities = [self.db GetAllCitiesOnLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
         for( int i=0; i<cities.count; i++ )
             [actionSheet addButtonWithTitle:[cities objectAtIndex:i]];
         
         [actionSheet showInView:self.view];
         return;
     }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"])
    {
         [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithInteger:buttonIndex+1] forKey:@"defaultCityId"];
        [self performSegueWithIdentifier:@"toMain" sender:self];
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[segue.destinationViewController setDb:self.db];
}
     
- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    NSLog(@"I'm in viewDidUnload");
}



@end
