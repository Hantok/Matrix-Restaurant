//
//  MapViewAnnotation.m
//  Restaurant
//
//  Created by Matrix Soft on 07.08.12.
//
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

- (id)initWithTitle:(NSString *)annotationTitle withSubTitle:(NSString *)annotationSubTitle withCoordinate:(CLLocationCoordinate2D)annotationCoordinates
{
    self = [super init];
    self.title = annotationTitle;
    self.subtitle = annotationSubTitle;
    self.coordinate = annotationCoordinates;
    return self;
}

@end
