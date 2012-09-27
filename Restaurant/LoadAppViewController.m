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
#import "SSToolkit/SSLoadingView.h"

@interface LoadAppViewController ()

@property (strong, nonatomic) NSMutableData *responseData;
@property BOOL isHappyEnd;
@property BOOL isFirstTime;
@property BOOL isParamTagDone;
@property (nonatomic, strong) GettingCoreContent *content;

//Titles
//@property (nonatomic, weak) NSString *titleLoading;

@end

@implementation LoadAppViewController

@synthesize imageView = _imageView;
//@synthesize activityIndicator = _activityIndicator;
@synthesize city = _city;
@synthesize db = _db;
@synthesize isHappyEnd = _isHappyEnd;
@synthesize isFirstTime = _isFirstTime;

@synthesize responseData = _responseData;
@synthesize isParamTagDone = _isParamTagDone;
@synthesize content = _content;

//titles
//@synthesize titleLoading = _titleLoading;

- (GettingCoreContent *)content
{
    if(!_content)
    {
        _content = [[GettingCoreContent alloc] init];
    }
    return  _content;
}

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
        if(object)
            [content setCoreDataForEntityWithName:key dictionaryOfAtributes:object];
    }
}

- (void)awakeFromNib
{
    if (checkConnection.hasConnectivity)
    {
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"])
        {
            //tag=init http request
            NSLog(@"<<<<<<<<<Generating init request>>>>>>>>>>");
            self.isFirstTime = YES;
            NSString *order = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/update.php?DBid=12&tag=init&idPhone=1&"];
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
        else
        {
            //http request updatePHP with &tag=params
            NSLog(@"<<<<<<<<<Generating params request>>>>>>>>>>");
            self.isParamTagDone = YES;
            GettingCoreContent *content = [[GettingCoreContent alloc] init];
            NSNumber *maxCityId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Cities"];
            NSNumber *maxCityVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Cities"];
            
            NSNumber *maxLanguageId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Languages"];
            NSNumber *maxLanguageVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Languages"];
            
            NSNumber *maxCurresnciesId =  [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Currencies"];
            NSNumber *maxCurrencyVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Currencies"];
            
            NSNumber *maxStatusId =  [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Statuses"];
            NSNumber *maxStatusVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Statuses"];
            
            NSNumber *maxDeliveriesId =  [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Deliveries"];
            NSNumber *maxDeliveryVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Deliveries"];
            
            NSNumber *maxPromotionsId =  [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Promotions"];
            NSNumber *maxPromotionsVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Promotions"];
            
            NSMutableString *myString = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/update.php?DBid=12&tag=params&idPhone=1&"];
            [myString appendFormat:@"&city_v=%@",maxCityVersion];
            [myString appendFormat:@"&mcity_id=%@",maxCityId];
            
            [myString appendFormat:@"&lang_v=%@",maxLanguageVersion];
            [myString appendFormat:@"&mlang_id=%@",maxLanguageId];
            
            [myString appendFormat:@"&curr_v=%@",maxCurrencyVersion];
            [myString appendFormat:@"&mcurr_id=%@",maxCurresnciesId];
            
            [myString appendFormat:@"&stat_v=%@", maxStatusVersion];
            [myString appendFormat:@"&mstat_id=%@", maxStatusId];
            
            [myString appendFormat:@"&del_v=%@", maxDeliveryVersion];
            [myString appendFormat:@"&mdel_id=%@",maxDeliveriesId];
            
            [myString appendFormat:@"&prom_v=%@", maxPromotionsVersion];
            [myString appendFormat:@"&mprom_id=%@",maxPromotionsId];
            
            NSURL *url = [NSURL URLWithString:myString.copy];
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
    }
    NSLog(@"IN awakeFromNib");
}

- (void)viewDidLoad
{
    SSLoadingView *loadingView = [[SSLoadingView alloc] initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor clearColor];
    loadingView.activityIndicatorView.color = [UIColor whiteColor];
    loadingView.textLabel.textColor = [UIColor whiteColor];
    
//    if (self.isFirstTime)
//        loadingView.textLabel.text = @"Loading...";
//    else
//    {
//        [self setAllTitlesOnThisPage];
//        loadingView.textLabel.text = self.titleLoading;
//    }
    
    [self.view addSubview:loadingView];
    
//    NSArray *arrayOfPromotions = [self.content getArrayFromCoreDatainEntetyName:@"Promotions" withSortDescriptor:@"underbarid"];
//    if (arrayOfPromotions.count == 0)
//    {
//        self.imageView.image = [UIImage imageNamed:@"picture.png"];
//        return;
//    }
//    NSString *idPicture = [[arrayOfPromotions objectAtIndex:0] valueForKey:@"idPicture"];
//    self.imageView.image = [UIImage imageWithData:[self.content fetchPictureDataByPictureId:idPicture]];
//    if (!self.imageView.image)
//    {
//        if(checkConnection.hasConnectivity)
//        {
//            NSString *stringURL = [self.content fetchImageStringURLbyPictureID:idPicture];
//            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:stringURL]];
//            UIImage *image = [UIImage imageWithData: imageData];
//            [self.content SavePictureToCoreData:idPicture toData:imageData];
//            self.imageView.image = image;
//        }
//        else
//        {
//            self.imageView.image = [UIImage imageNamed:@"picture.png"];
//        }
//    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"logo"])
    {
        self.imageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"logo"]];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"picture.png"];
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
    [self performSegueWithIdentifier:@"toMain" sender:self];
    [self DropCoreData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData
                                                   length]);
    NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSUTF8StringEncoding];
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
    
    if (self.isParamTagDone && checkConnection.hasConnectivity)
    {
        NSLog(@"<<<<<<<<<< UPDATE request >>>>>>>>>>");
        // http request updatePHP with &tag=update
        GettingCoreContent *content = [[GettingCoreContent alloc] init];
        
        NSNumber *maxRestaurantId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Restaurants"];
        NSNumber *maxRestaurantVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Restaurants"];
        
        NSNumber *maxMenuId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Menus"];
        NSNumber *maxMenuVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Menus"];
        
        NSNumber *maxProductId = [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Products"];
        NSNumber *maxProductVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Products"];
        
        NSNumber *maxPromotionsId =  [content fetchMaximumNumberOfAttribute:@"underbarid" fromEntity:@"Promotions"];
        NSNumber *maxPromotionsVersion = [content fetchMaximumNumberOfAttribute:@"version" fromEntity:@"Promotions"];
        
        NSMutableString *myString = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/update.php?DBid=12&tag=update"];
        
        [myString appendFormat:@"&city_id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"]];
        [myString appendFormat:@"&lang_id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
        
        [myString appendFormat:@"&rest_v=%@", maxRestaurantVersion];
        [myString appendFormat:@"&mrest_id=%@", maxRestaurantId];
        
        [myString appendFormat:@"&menu_v=%@", maxMenuVersion];
        [myString appendFormat:@"&mmenu_id=%@", maxMenuId];
        
        [myString appendFormat:@"&prod_v=%@", maxProductVersion];
        [myString appendFormat:@"&mprod_id=%@", maxProductId];
        
        [myString appendFormat:@"&prom_v=%@", maxPromotionsVersion];
        [myString appendFormat:@"&mprom_id=%@",maxPromotionsId];
        
        NSURL *url = [NSURL URLWithString:myString.copy];
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
        self.isParamTagDone = NO;
    }
    
    if (self.isHappyEnd)
    {
        //якщо нема лого - качаєм і зберігаємо картинку
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"logo"])
        {
            NSString *logoURLstring = [[NSUserDefaults standardUserDefaults] valueForKey:@"logoURL"];
            NSData *dataImage =  [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURLstring]];
            if (dataImage)
            {
                [[NSUserDefaults standardUserDefaults] setValue:dataImage forKey:@"logo"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logoVersion"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

#pragma finish pragma connention with server

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"])
    {
        NSNumber *idLanguage = [[NSNumber alloc] initWithInteger:buttonIndex+1];
        [[NSUserDefaults standardUserDefaults] setObject:idLanguage forKey:@"defaultLanguageId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTitle:@"Select city:"];
        [actionSheet setDelegate:(id)self];
        
        NSArray *cities = [self.db GetAllCitiesOnLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLanguageId"]];
        for( int i=0; i<cities.count; i++ )
            [actionSheet addButtonWithTitle:[cities objectAtIndex:i]];
        
        [actionSheet showInView:self.view];
        
        //зберігаємо стан загрузки мови
        [[NSUserDefaults standardUserDefaults] setObject:idLanguage forKey:[NSString stringWithFormat:@"isLanguageHere%@", idLanguage]];
        return;
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCityId"])
    {
        NSNumber *idCity = [[NSNumber alloc] initWithInteger:buttonIndex+1];
        [[NSUserDefaults standardUserDefaults] setObject:idCity forKey:@"defaultCityId"];
        
        //зберігаємо стан загрузки міста
        [[NSUserDefaults standardUserDefaults] setObject:idCity forKey:[NSString stringWithFormat:@"isCityHere%@", idCity]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        //створюємо http зарпос
        if (checkConnection.hasConnectivity)
        {
            NSMutableString *order = [NSMutableString stringWithString: @"http://matrix-soft.org/addon_domains_folder/test7/root/Customer_Scripts/update.php?DBid=12&tag=rmp"];
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
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"typeOfView"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"menuList" forKey:@"typeOfView"];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"typeOfViewFavorites"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"toFavoritesList" forKey:@"typeOfViewFavorites"];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"USD" forKey:@"Currency"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"CurrencyCoefficient"];
    }
    
    if (!checkConnection.hasConnectivity)
    {
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    //[self setActivityIndicator:nil];
    
    //custom
    [self setDb:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    NSLog(@"I'm in viewDidUnload");
}


#pragma mark
#pragma mark PRIVATE METHODS

//-(void)setAllTitlesOnThisPage
//{
//    NSArray *array = [Singleton sharedManager];
//    for (int i = 0; i <array.count; i++)
//    {
//        if ([[[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"code"] isEqualToString:@"Loading..."])
//        {
//            self.titleLoading = [[[Singleton sharedManager] objectAtIndex:i] valueForKey:@"title"];
//        }
//    }
//}


@end
