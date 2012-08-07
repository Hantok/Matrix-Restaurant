//
//  MapViewAnnotation.h
//  Restaurant
//
//  Created by Matrix Soft on 07.08.12.
//
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface MapViewAnnotation : NSObject<MKAnnotation> {
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)annotationTitle withSubTitle:(NSString *)annotationSubTitle withCoordinate:(CLLocationCoordinate2D)annotationCoordinates;

@end
