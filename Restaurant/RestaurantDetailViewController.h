#import <UIKit/UIKit.h>
#import "RestaurantDataStruct.h"
#import "GettingCoreContent.h"
#import "Singleton.h"

@interface RestaurantDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *showOnMapButton;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) RestaurantDataStruct *dataStruct;
@property (strong, nonatomic) GettingCoreContent *db;
- (IBAction)tebleReserve:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *restDetAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDetAdress;
@property (weak, nonatomic) IBOutlet UILabel * restDetWorkingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDetWorkingTime;
@property (strong, nonatomic) IBOutlet UILabel *restDetSeatsNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *restDetSeatsNumber;
@property (strong, nonatomic) IBOutlet UILabel *restDetParkingLabel;
@property (strong, nonatomic) IBOutlet UILabel *restDetParking;
@property (strong, nonatomic) IBOutlet UITextField *textPhonesLabel;
@property (strong, nonatomic) IBOutlet UITextField *textTerraceLabel;
@end
