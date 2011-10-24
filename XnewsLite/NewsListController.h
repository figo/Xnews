//
//  NewsListController.h
//  XnewsLite
//
//  Created by figo on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HTTPFetcher.h"
#import "NewsBodyController.h"
#include "NewsCell.h"
#include "XMLFetcher.h"
#include "HTMLParser.h"

@interface NewsListController : UITableViewController{
    NSMutableArray *newsdata, *newsdetail;
    UINib *cellNib;
    NewsCell *tmpCell;
    XMLFetcher *listFetcher;
    HTTPFetcher *newsdetailFetcher;
    HTMLParser *newsdetailParser;
    int int_array_index;
    BOOL bool_newsdetail_finished;
    UIView *progressView;

}

@property (nonatomic, retain) NSMutableArray *newsdata, *newsdetail;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet NewsCell *tmpCell;
- (void)get_news_detail:(NSMutableArray *)data; 
@end
