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
#import "checkConnection.h"

@interface LoadAppViewController ()

@end

@implementation LoadAppViewController

@synthesize imageView = _imageView;
@synthesize activityIndicator = _activityIndicator;
@synthesize city = _city;
@synthesize db = _db;



- (void)DropCoreData
{
    //stupid one!!!!! for checking repozetory=)
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
    GettingCoreContent *content = [[GettingCoreContent alloc] init];
    for(int i = 0; i< allKeys.count; i++)
    {
        id key = [allKeys objectAtIndex:i];
        id object = [self.db.tables objectForKey:key];
        if(object)[content setCoreDataForEntityWithName:key dictionaryOfAtributes:object];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    
    
    if(checkConnection.hasConnectivity)
    {
        NSURL* rssURL = [NSURL URLWithString:@"http://matrix-soft.org/addon_domains_folder/test4/root/System_files/XML/matrixso_test4/DBStructure.xml"];//@"http://matrix-soft.org/addon_domains_folder/test3/System_files/XML/matrixso_test3/DBStructure.xml"];
    // создаем парсер при помощи URL, назначаем делегат и запускаем
        NSLog(@"Download is begin");
        XMLParse* parser = [[XMLParse alloc] initWithContentsOfURL:rssURL];
        [parser setDelegate:parser];
        [parser parse];
        self.db = parser;
    }
    
    NSLog(@"I'm in viewDidLoad");
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.activityIndicator stopAnimating];
    [super viewDidAppear:YES];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"])
     {
         [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithInteger:buttonIndex+1] forKey:@"defaultLanguageId"];
         [[NSUserDefaults standardUserDefaults] synchronize];
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
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"toMain" sender:self];
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(checkConnection.hasConnectivity)
    {
        [self DropCoreData];
        [self XMLToCoreData];
    }
    GettingCoreContent *content = [[GettingCoreContent alloc] init];
    NSArray *result = [content fetchAllRestaurantsWithDefaultLanguageAndCity];
    result = [content fetchRootMenuWithDefaultLanguageForRestaurant:@"1"];
    result = [content fetchAllLanguages];
    result = [content fetchAllCitiesByLanguage:@"1"];
    result = [content fetchChildMenuWithDefaultLanguageForParentMenu:@"1"];
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
