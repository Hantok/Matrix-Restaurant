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

@property (strong, nonatomic) NSMutableData *responseData;
@property BOOL isHappyEnd;
@property BOOL isFirstTime;

@end

@implementation LoadAppViewController

@synthesize imageView = _imageView;
@synthesize activityIndicator = _activityIndicator;
@synthesize city = _city;
@synthesize db = _db;
@synthesize isHappyEnd = _isHappyEnd;
@synthesize isFirstTime = _isFirstTime;

@synthesize responseData = _responseData;

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
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    [self.activityIndicator startAnimating];
//    
//    
//    if(checkConnection.hasConnectivity)
//    {
//        NSURL* rssURL = [NSURL URLWithString:@"http://matrix-soft.org/addon_domains_folder/test5/root/System_files/XML/matrixso_test5/DBStructure.xml"];
//    // создаем парсер при помощи URL, назначаем делегат и запускаем
//        NSLog(@"Download is begin");
//        XMLParse* parser = [[XMLParse alloc] initWithContentsOfURL:rssURL];
//        [parser setDelegate:parser];
//        [parser parse];
//        self.db = parser;
//    }
//    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"] && checkConnection.hasConnectivity)
    {
        self.isFirstTime = YES;
        NSString *order = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test5/root/Customer_Scripts/update.php?DBid=10&tag=init"];
        NSURL *url = [NSURL URLWithString:order];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"GET"];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (!theConnection)
        {
            // Inform the user that the connection failed.
            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection" 
                                                                         message:@"Not success"  
                                                                        delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
            [connectFailMessage show];
        }

    }
    
    NSLog(@"I'm in viewDidLoad");
}

#pragma connection with server

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Unable to fetch data");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData
                                                   length]);
    NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSASCIIStringEncoding];
    NSLog(@"strinng is - %@",txt);
    
    // создаем парсер
    XMLParse* parser = [[XMLParse alloc] initWithData:self.responseData];
    [parser setDelegate:parser];
    [parser parse];
    self.db = parser;
    
    [self XMLToCoreData];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"])
    {
        NSArray *languages = [self.db GetAllLanguages];
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Select language:"];
        [actionSheet setDelegate:(id)self];
        
        for( int i=0; i<languages.count; i++ )
            [actionSheet addButtonWithTitle:[languages objectAtIndex:i]];
        
        [actionSheet showInView:self.view];
    }
    
    if (self.isHappyEnd)
        [self performSegueWithIdentifier:@"toMain" sender:self];
}

#pragma finish pragma connention with server

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
        
        
        //створюємо http зарпос
        if (checkConnection.hasConnectivity)
        {
            NSMutableString *order = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test5/root/Customer_Scripts/update.php?DBid=10&tag=rmp"];
            [order appendFormat:@"&idLang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
            [order appendFormat:@"&idCity=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"]];
            NSURL *url = [NSURL URLWithString:order.copy];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [request setHTTPMethod:@"GET"];
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (!theConnection)
            {
                // Inform the user that the connection failed.
                UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection" 
                                                                             message:@"Not success"  
                                                                            delegate:self
                                                                   cancelButtonTitle:@"Ok"
                                                                   otherButtonTitles:nil];
                [connectFailMessage show];
            }
            self.isHappyEnd = YES;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (!self.isFirstTime)
        [self performSegueWithIdentifier:@"toMain" sender:self];
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
