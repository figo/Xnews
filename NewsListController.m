//
//  NewsListController.m
//  XnewsLite
//
//  Created by figo on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsListController.h"


@implementation NewsListController

@synthesize newsdata,tmpCell,cellNib;


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


- (void)downloadNewsFromWebsite
{
    NSString * ggurl = @"http://api.usatoday.com/open/articles/topnews?api_key=w883u462b4v9k8d3vvhdxtqp";
    NSURLRequest *urlq =[NSURLRequest requestWithURL:[NSURL URLWithString:ggurl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    receivedData = [[NSMutableData data] retain];
    if([[NSURLConnection alloc] initWithRequest:urlq delegate:self] == nil){
        [receivedData release];
        NSLog(@"Connection setup failed");
    }

}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*
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
    
    lock = [[NSLock alloc] init];
    [self downloadNewsFromWebsite];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    /*  read from plist file
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    self.data = [NSArray arrayWithContentsOfFile:dataPath];
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
    self.navigationItem.title = @"Back";
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
    return newsdata.count;
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
    //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        self.cellNib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
        [self.cellNib instantiateWithOwner:self options:nil];
        cell = tmpCell;
        self.tmpCell = nil;
    }
    
    
    NSDictionary *item = (NSDictionary *)[newsdata objectAtIndex:indexPath.section];
    //cell.textLabel.text = [item objectForKey:@"head"];
    //cell.detailTextLabel.text = [item objectForKey:@"sub"];
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"pic"] ofType:@"png"];
    //UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    
    //[cell seticon:theImage];
    [cell setbody:[[item objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
     
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */

    NewsBodyController *cellController = [[NewsBodyController alloc] init];
    NSDictionary *item = (NSDictionary *)[newsdata objectAtIndex:indexPath.section];
    cellController.cellurl = [item objectForKey:@"link"];  
    [self.navigationController pushViewController:cellController animated:YES];
    [cellController release];
    //[self.tabBarController hidesBottomBarWhenPushed];
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
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"succeeded %d",[receivedData length]);
    newsdata = [[NSMutableArray alloc] init];
    xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    [xmlParser setDelegate:self];
 
    if(![xmlParser parse]){
        newsdata = nil;
    }
    [receivedData release];
}

//xml parser delegation
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
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
        [self.tableView reloadData];
    }    
    
    if([elementName isEqualToString:@"item"]){
        [lock lock];
        [newsdata addObject:oneNews];
        [lock unlock];
    }else{
        [oneNews setValue:currentElementvalue forKey:elementName];
    }
    
    [currentElementvalue release];
    currentElementvalue = nil;
}

-(void) dealloc{
    
    [newsdata release];
    [cellNib release];
    [tmpCell release];
    [xmlParser release];
    [receivedData release];
    [lock release];
    [super dealloc];
}


@end
