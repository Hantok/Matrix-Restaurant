//
//  XMLParseResponseFromTheServer.h
//  Restaurant
//
//  Created by Matrix Soft on 18.09.12.
//
//

#import <Foundation/Foundation.h>

@interface XMLParseResponseFromTheServer : NSXMLParser <NSXMLParserDelegate>

@property BOOL done;
@property BOOL error;
@property (strong, nonatomic) NSString *success;
@property (strong, nonatomic) NSString *orderNumber;
@property (strong, nonatomic) NSString *cause;

@end
