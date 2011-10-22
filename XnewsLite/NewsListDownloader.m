//
//  NewsListDownloader.m
//  XnewsLite
//
//  Created by figo on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsListDownloader.h"

@implementation NewsListDownloader

@synthesize finished, local_newsdata,failed;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    receivedData = [[NSMutableData alloc] init];
    finished = FALSE;
    failed = FALSE;
    return self;
}



//URL connection deletegation

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    [receivedData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [receivedData release];
    failed = TRUE;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"succeeded %d",[receivedData length]);
    local_newsdata = [[NSMutableArray alloc] init];
    xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    [xmlParser setDelegate:self];
    
    if(![xmlParser parse]){
        local_newsdata = nil;
    }
    [receivedData release];
}

//xml parser delegation
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //lock = [[NSLock alloc] init];
    if([elementName isEqualToString:@"item"]){
        oneNews = [[NSMutableDictionary alloc] init];
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!currentElementvalue){
        currentElementvalue = [[NSMutableString alloc] initWithString:string];
    }else{
        [currentElementvalue appendString:string];
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    if([elementName isEqualToString:@"rss"]){
        finished = TRUE;
        //[self.tableView reloadData];
    }    
    
    if([elementName isEqualToString:@"item"]){
        //[lock lock];
        [local_newsdata addObject:oneNews];
        //[lock unlock];
    }else{
        [oneNews setValue:currentElementvalue forKey:elementName];
    }
    
    [currentElementvalue release];
    currentElementvalue = nil;
}



-(void) dealloc{
    [super dealloc];
    [xmlParser release];
    [receivedData release];
    [oneNews release];
}

@end
