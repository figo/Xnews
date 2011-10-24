//
//  NewsListController.m
//  XnewsLite
//
//  Created by figo on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsListController.h"


@implementation NewsListController

@synthesize newsdata,tmpCell,cellNib,newsdetail;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}




//parse the xml file get the USA today top news list
//data structure will be Array of node, each node has such a format below:
//           title       ->   *****
//           link        ->   *****
//           description ->   *****
//           guiid       ->   *****
-(void)downloadlistFinished{
    
    if(!listFetcher.results )
    {
        NSLog(@"no data return");
    }else
    {
        XPathResultNode *first_level_node, *second_level_node;
        NSMutableDictionary *oneitem;
        NSArray *listchildnodeAarray;
        newsdata = [[NSMutableArray alloc] initWithCapacity:[listFetcher.results count]];
        for (first_level_node in listFetcher.results){
            listchildnodeAarray = [first_level_node childNodes];
            oneitem = [[[NSMutableDictionary alloc] initWithCapacity:[listchildnodeAarray count]] autorelease];
            
            for(second_level_node in listchildnodeAarray){
                [oneitem setObject:[second_level_node contentString] forKey:[second_level_node name]];
            }
            [newsdata addObject:oneitem];
        }
        
        [self get_news_detail:newsdata]; 
        [progressView removeFromSuperview];
        //[progressView release];
        [self.tableView reloadData];
        
    }
}





//pasrse the html file for each news, get the image link, and words content of each news
//result would be dictionary with key: link and content
-(void)downloaddetailFinished{
    if(newsdetailFetcher.data == nil)
    {
        NSLog(@"no data return");
    }else
    {
        
        NSError *error = nil;
        newsdetailParser = [[HTMLParser alloc] initWithData:newsdetailFetcher.data error:&error];
        if(error){
            NSLog(@"failed to init the parser:%@",error);
        }
        
        HTMLNode *bodyNode = [newsdetailParser body];
        
        
        
        //get the image
        HTMLNode *imgNode = [bodyNode findChildOfClass:@"ppy-imglist"];
        imgNode = [imgNode findChildTag:@"img"];
        NSString *imageURL = [imgNode getAttributeNamed:@"src"];
        
        if (imageURL == nil){
            imageURL = @"NONE";
        }
        imageURL = [imageURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        //get the news body words
        NSMutableString *newsBodyContent = [[NSMutableString alloc] initWithCapacity:2000];
        HTMLNode *firstpara = [bodyNode findChildOfClass:@"firstParagraph"];
        if(firstpara.contents){
            [newsBodyContent appendString:@"<p>"];
            [newsBodyContent appendString:[firstpara contents]];
            [newsBodyContent appendString:@"</p>"];
        }
        
        if ( imageURL != @"NONE"){
            [newsBodyContent appendString:@"<img src='"];
            [newsBodyContent appendString:imageURL];
            [newsBodyContent appendString:@"' width='250' height='200' border='0' />"];
        }
        
        NSArray *contentNodes = [bodyNode findChildrenOfClass:@"inside-copy"];
        for (HTMLNode *contentNode in contentNodes) {
            if ([contentNode contents]) {
                [newsBodyContent appendString:@"<p>"];
                [newsBodyContent appendString:[contentNode contents]];
                [newsBodyContent appendString:@"</p>"];
            }
        }
        
        
        
        NSMutableDictionary *oneitem = [[NSMutableDictionary alloc] initWithCapacity:2];
        [oneitem setObject:imageURL forKey:@"img_url"];
        [oneitem setObject:newsBodyContent forKey:@"body"];
        //NSLog(@"image url:%@ \n new body: %@\n", imageURL,newsBodyContent);
        [newsdetail addObject:oneitem];
    }
    newsdetailParser = nil;
    bool_newsdetail_finished = TRUE;
}


//data is an array of dictionary, dictionary has keyword "link"
- (void)get_news_detail:(NSMutableArray *)data
{
    
    NSMutableDictionary *oneitem;
    NSRunLoop *theRL;
    NSMutableString *url;
    
    
    newsdetail = [[NSMutableArray alloc] initWithCapacity:[newsdata count]];
    
    if( data != nil ){
        int_array_index = 0;
        for (oneitem in data) {
            bool_newsdetail_finished = FALSE;
            url = (NSMutableString *)[[oneitem objectForKey:@"link"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(@"newsdetail url:%@", url);
            newsdetailFetcher = [[HTTPFetcher alloc] initWithURLString:url receiver:self action:@selector(downloaddetailFinished)];
            [newsdetailFetcher start];
            theRL = [NSRunLoop currentRunLoop];
            while (!bool_newsdetail_finished && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
            int_array_index++;
            newsdetailFetcher = nil;
        }
    }
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //display the progress view here.
    progressView = [[UIView alloc] initWithFrame:self.tableView.frame];
    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ac.center = [progressView center];
    [progressView addSubview:ac];
    [ac startAnimating];
    [ac release];
    [self.tableView addSubview:progressView];
    [progressView release];
    
    NSString *usatoday_url = @"http://api.usatoday.com/open/articles/topnews?api_key=w883u462b4v9k8d3vvhdxtqp";
    NSString *listXPath = @"/rss/channel/item"; 
    listFetcher = [[XMLFetcher alloc] initWithURLString:usatoday_url xPathQuery:listXPath receiver:self action:@selector(downloadlistFinished)];
    [listFetcher start];
    
    /*  read from plist file
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    self.data = [NSArray arrayWithContentsOfFile:dataPath];

    //multi thread, create a download block and download queue
    receivedData = [[NSMutableData data] retain];
    dispatch_queue_t downloadQueue = dispatch_queue_create("download_queue", NULL);
    dispatch_async(downloadQueue,^{
    NSString * ggurl = @"http://api.usatoday.com/open/articles/topnews?api_key=w883u462b4v9k8d3vvhdxtqp";
    NSURLRequest *urlq =[NSURLRequest requestWithURL:[NSURL URLWithString:ggurl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    if([[NSURLConnection alloc] initWithRequest:urlq delegate:self] == nil){
        [receivedData release];
        NSLog(@"Connection setup failed");
    }
    });
    //dispatch_release(downloadQueue);
    */

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tmpCell = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"USA Today";
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(newsdata.count > 0 )
        return newsdata.count;
    else
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        self.cellNib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
        [self.cellNib instantiateWithOwner:self options:nil];
        cell = tmpCell;
        self.tmpCell = nil;
    }
    
    
    NSDictionary *item = (NSDictionary *)[newsdata objectAtIndex:indexPath.section];
    if(item){
        [cell setbody:[[item valueForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    NSDictionary *detailitem = (NSDictionary *)[newsdetail objectAtIndex:indexPath.section];
    NSString *path = [detailitem valueForKey:@"img_url"];
    
    if(path && path != @"NONE"){
        UIImage *theImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
        [cell seticon:theImage];
    }
    
    return cell;
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 100;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NewsBodyController *cellController = [[NewsBodyController alloc] init];
    NSDictionary *item = (NSDictionary *)[newsdata objectAtIndex:indexPath.section];
    cellController.cellurl = [item objectForKey:@"link"];  
    item = (NSDictionary *)[newsdetail objectAtIndex:indexPath.section];
    cellController.cellnewsbody = [item objectForKey:@"body"];
    [self.navigationController pushViewController:cellController animated:YES];
    [cellController release];
    //[self.tabBarController hidesBottomBarWhenPushed];
}


-(void) dealloc{
    
    [newsdata release];
    [newsdetail release];
    [HTTPFetcher release];
    [XMLFetcher release];
    [HTMLParser release];
    [cellNib release];
    [tmpCell release];
    [progressView release];
    [super dealloc];
}


@end
