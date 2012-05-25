//
//  Pictures.h
//  Restaurant
//
//  Created by Bogdan Geleta on 25.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Pictures : NSManagedObject

@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *underbarid;

@end
