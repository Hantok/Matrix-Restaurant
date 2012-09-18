//
//  XMLParseResponseFromTheServer.m
//  Restaurant
//
//  Created by Matrix Soft on 18.09.12.
//
//

#import "XMLParseResponseFromTheServer.h"

@interface XMLParseResponseFromTheServer()
@property (strong, nonatomic) NSString *elementName;
@property (strong, nonatomic) NSString *tempString;
@end

@implementation XMLParseResponseFromTheServer

@synthesize done = _done;
@synthesize error = _error;
@synthesize success = _success;
@synthesize orderNumber = _orderNumber;
@synthesize elementName = _elementName;
@synthesize tempString = _tempString;

// документ начал парситься
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.done = NO;
    NSLog(@"PARSE IS BEGUN");
}

// парсинг окончен
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.done = YES;
    NSLog(@"PARSE IS END");
}

// если произошла ошибка парсинга
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.done = YES;
}

// если произошла ошибка валидации
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    self.done = YES;
}

// встретили новый элемент
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"success"]) {
        self.elementName = elementName;
    } else {
        if ([elementName isEqualToString:@"number"]) {
            self.elementName = elementName;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"success"]) {
        self.success = self.tempString;
    } else {
        if ([elementName isEqualToString:@"number"]) {
            self.orderNumber = self.tempString;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.tempString = string;    
}

@end
