//
//  NewsListDownloader.h
//  XnewsLite
//
//  Created by figo on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListDownloader : NSObject <NSXMLParserDelegate>{
  NSMutableArray *local_newsdata;
  NSXMLParser *xmlParser;
  NSMutableData *receivedData;
  NSMutableDictionary *oneNews;
  NSMutableString *currentElementvalue;
  bool finished,failed; 
}


@property bool finished,failed;
@property (nonatomic, retain) NSMutableArray *local_newsdata;

@end
