//
//  NewsListController.h
//  XnewsLite
//
//  Created by figo on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NewsBodyController.h"
#include "NewsCell.h"

@interface NewsListController : UITableViewController <NSXMLParserDelegate> {
    NSMutableArray *newsdata;
    UINib *cellNib;
    NewsCell *tmpCell;
    NSURLConnection *connector;
    NSXMLParser *xmlParser;
    NSMutableData *receivedData;
    NSMutableDictionary *oneNews;
    NSMutableString *currentElementvalue;
    BOOL httpfinished;
}

@property (nonatomic, retain) NSMutableArray *newsdata;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet NewsCell *tmpCell;
- (void)downloadNewsFromWebsite;
@end
