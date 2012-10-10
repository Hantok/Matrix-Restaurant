///амвамвамвавам
#import "RestaurantDetailViewController.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSToolkit/SSToolkit.h"
#import "checkConnection.h"

@interface RestaurantDetailViewController ()
{
    BOOL isDownloadingPicture;
}

@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) SSLoadingView *loadingView;

@end

@implementation RestaurantDetailViewController
@synthesize callButton;
@synthesize showOnMapButton;
@synthesize restaurantImage;
@synthesize dataStruct = _dataStruct;
@synthesize db = _db;
@synthesize alert = _alert;
@synthesize loadingView = _loadingView;
@synthesize scroll = _scroll;
@synthesize restDetAdressLabel = _restDetAdressLabel;
@synthesize restDetAdress = _restDetAdress;
@synthesize restDetWorkingTimeLabel = _restDetWorkingTimeLabel;
@synthesize restDetWorkingTime = _restDetWorkingTime;
@synthesize restDetSeatsNumberLabel = _restDetSeatsNumberLabel;
@synthesize restDetSeatsNumber = _restDetSeatsNumber;
@synthesize restDetParkingLabel =_restDetParkingLabel;
@synthesize restDetParking = _restDetParking;
@synthesize textPhonesLabel = _textPhonesLabel;
@synthesize textTerraceLabel = _textTerraceLabel;

- (GettingCoreContent *)db
{
    if(!_db) _db = [[GettingCoreContent alloc] init];
    return _db;
}

- (void)setDataStruct:(RestaurantDataStruct *)dataStruct
{
    _dataStruct = dataStruct;
}

- (IBAction)callToRestaurant:(id)sender
{
    NSString *phoneNumber = self.dataStruct.phones;
    for (int i = 0; i < phoneNumber.length; i++)
    {
        if ([phoneNumber characterAtIndex:i] == ';')
        {
            phoneNumber = [phoneNumber substringToIndex:i];
            break;
        }
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]]; //@"telprompt://067-412-72-05"];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Calling");
}
- (IBAction)showOnMap:(id)sender {
    [self performSegueWithIdentifier:@"toMap" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMap"])
    {
        NSString *aLatitude = self.dataStruct.latitude;
        NSString *aLongitude = self.dataStruct.longitude;
        
        aLatitude = [aLatitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
        aLongitude = [aLongitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
        
        CLLocationCoordinate2D location = {.latitude = aLatitude.doubleValue, .longitude =  aLongitude.doubleValue};
        [segue.destinationViewController setCoordinates:location];
        [segue.destinationViewController setDataStruct:self.dataStruct];
       
       
        
       
    }
    NSString *idstring = self.dataStruct.restaurantId;
    NSString *restaurantName = self.dataStruct.name;
    [segue.destinationViewController setRestaurantId:idstring];
    [segue.destinationViewController setRestaurantName:restaurantName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // --------------------------------------------- SCROLL VIEW -------------------------------------------------------
    _scroll.contentSize = CGSizeMake(142, 200);
    _scroll.scrollEnabled = YES;
    [_scroll setShowsVerticalScrollIndicator:NO];
    
    // add by BI
    self.restDetAdress.text = [NSString stringWithFormat:@"%@, %@", _dataStruct.street, _dataStruct.build];
    self.restDetWorkingTime.text = [NSString stringWithFormat:@"%@", _dataStruct.workingTime];
    self.restDetSeatsNumber.text = [NSString stringWithFormat:@"%@", _dataStruct.seatsNumber];
    
    NSString *testString1 = [NSString stringWithFormat:@"%@", _dataStruct.parking];
    if([testString1 isEqualToString: @"1"]){self.restDetParking.text = @"+";} else {self.restDetParking.text = @"-";}

    // dynamic adding to ScrollView
    _textTerraceLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 142, 17)];
    _textTerraceLabel.textColor = [UIColor orangeColor];
    _textTerraceLabel.font = [UIFont systemFontOfSize:13];
  
    UITextField *textTerrace = [[UITextField alloc] initWithFrame:CGRectMake(87, 100, 142, 17)];
    textTerrace.textColor = [UIColor whiteColor];
    NSString *testString2 = [NSString stringWithFormat:@"%@", _dataStruct.terrace];
    if([testString2 isEqualToString: @"1"]){textTerrace.text = @"+";} else {textTerrace.text = @"-";}
    textTerrace.font = [UIFont systemFontOfSize:13];

    UITextField *textEmailLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, textTerrace.frame.origin.y + 17, 142, 17)];
    textEmailLabel.textColor = [UIColor orangeColor];
    textEmailLabel.text = @"Email: ";
    textEmailLabel.font = [UIFont systemFontOfSize:13];
 
    UITextField *textEmail = [[UITextField alloc] initWithFrame:CGRectMake(10, textEmailLabel.frame.origin.y + 14, 142, 17)];
    textEmail.textColor = [UIColor whiteColor];
    textEmail.text = [NSString stringWithFormat:@"%@",_dataStruct.additionalContactInfo];
    textEmail.font = [UIFont systemFontOfSize:13];

    _textPhonesLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, textEmail.frame.origin.y + 17, 142, 17)];
    _textPhonesLabel.textColor = [UIColor orangeColor];
    _textPhonesLabel.font = [UIFont systemFontOfSize:13];

    UITextField *textPhones = [[UITextField alloc] initWithFrame:CGRectMake(10, _textPhonesLabel.frame.origin.y + 14, 142, 17)];
    textPhones.textColor = [UIColor whiteColor];
    textPhones.text = [NSString stringWithFormat:@"%@",_dataStruct.phones];
    textPhones.font = [UIFont systemFontOfSize:13];
    
    // adding a subViews to Scroll
    [_scroll addSubview: _textTerraceLabel];
    [_scroll addSubview: textTerrace];
    [_scroll addSubview: textEmailLabel];
    [_scroll addSubview: textEmail];
    [_scroll addSubview: _textPhonesLabel];
    [_scroll addSubview: textPhones];
//----------------------------------------------------------------------------------------------------------------------
    
    
    [self setAllTitlesOnThisPage];
    self.navigationItem.title = self.dataStruct.name;
    NSData *dataOfPicture = [self.db fetchPictureDataByPictureId:self.dataStruct.idPicture];
    if(dataOfPicture)
    {
        self.dataStruct.image  = [UIImage imageWithData:dataOfPicture];
        self.restaurantImage.image = self.dataStruct.image;
    }
    else
    {
        if (checkConnection.hasConnectivity)
        {
            self.loadingView = [[SSLoadingView alloc] initWithFrame:self.restaurantImage.frame];
            self.loadingView.backgroundColor = [UIColor clearColor];
            self.loadingView.activityIndicatorView.color = [UIColor whiteColor];
            self.loadingView.textLabel.textColor = [UIColor whiteColor];
            self.loadingView.textLabel.text = @"";
            [self.view addSubview:self.loadingView];
        }

    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor],(id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    self.callButton.titleLabel.minimumFontSize = 10;
    self.showOnMapButton.titleLabel.minimumFontSize = 10;
    
    CALayer *layerCall = self.callButton.layer;
    [layerCall setCornerRadius:8.0f];
    
    CALayer *layerMap = self.showOnMapButton.layer;
    layerMap.cornerRadius = 8.0f;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    if (!self.dataStruct.image && isDownloadingPicture == NO && checkConnection.hasConnectivity)
    {
        isDownloadingPicture = YES;
        [self performSelectorInBackground:@selector(downloadingPic) withObject:nil];
    }
}

- (void)downloadingPic
{
    NSURL *url = [self.db fetchImageURLbyPictureID:self.dataStruct.idPicture];
    NSData *dataOfPicture = [NSData dataWithContentsOfURL:url];
    [self.db SavePictureToCoreData:self.dataStruct.idPicture toData:dataOfPicture];
    self.dataStruct.image  = [UIImage imageWithData:dataOfPicture];
    self.restaurantImage.image = self.dataStruct.image;
    [self.loadingView removeFromSuperview];
    [self.restaurantImage reloadInputViews];
}

- (IBAction)tebleReserve:(id)sender
{
}

- (void) dismiss
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)viewDidUnload
{
    [self setLoadingView:nil];
    [self setCallButton:nil];
    [self setShowOnMapButton:nil];
    [self setRestaurantImage:nil];
    [self setReserveButton:nil];
    [self setRestDetSeatsNumberLabel:nil];
    [self setRestDetSeatsNumber:nil];
    [self setRestDetParkingLabel:nil];
    [self setRestDetParking:nil];
    [super viewDidUnload];
    [self setAlert:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma mark PRIVATE METHODS

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Working time"])
        {
           self.restDetWorkingTimeLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Phones"])
        {
            _textPhonesLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Parking"])
        {
            self.restDetParkingLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Terrace"])
        {
            _textTerraceLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Number of seats"])
        {
            self.restDetSeatsNumberLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Address"])
        {
            self.restDetAdressLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Show on map"])
        {
            [self.showOnMapButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Reserve table"])
        {
            [self.reserveButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Call"])
        {
            [self.callButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Loading..."])
        {
            self.loadingView.textLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
    }
}

@end
