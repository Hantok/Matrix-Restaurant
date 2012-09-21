//
//  Singleton.h
//  Restaurant
//
//  Created by Roman Slysh on 9/21/12.
//
//

#import <Foundation/Foundation.h>
#import "GettingCoreContent.h"

@interface Singleton : NSObject

@property (nonatomic, strong) NSArray *someProperty;

+ (id)sharedManager;

@end
