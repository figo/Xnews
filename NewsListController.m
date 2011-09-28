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
    if(connector == nil){
        connector = [[NSURLConnection alloc] initWithRequest:urlq delegate:self];
    }
    if (connector){
        receivedData = [[NSMutableData data] retain];
    } else{
        NSLog(@"Connection setup failed");
    }

}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    httpfinished = FALSE;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
    //NSString *dataPath =[rootPath stringByAppendingPathComponent:@"Data.plist"];
    //if(![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
    
    
    
    /*  read from plist file
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    self.data = [NSArray arrayWithContentsOfFile:dataPath];
    */
    
    [self downloadNewsFromWebsite];
    //while (!newsdata){};
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

    // Return the number of sections.
    //return newsdata.count;
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
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
        //[cell autorelease];
    }
    
    //while(newsdata == nil){};
    
    NSDictionary *item = (NSDictionary *)[newsdata objectAtIndex:indexPath.section];
    //cell.textLabel.text = [item objectForKey:@"head"];
    //cell.detailTextLabel.text = [item objectForKey:@"sub"];
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"pic"] ofType:@"png"];
    //UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    
    //[cell seticon:theImage];
    [cell setbody:[item objectForKey:@"title"]];
     
    return cell;
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 120;
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
    [connector release];
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
    
    [connector release];
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
        httpfinished = TRUE;
    }    
    
    if([elementName isEqualToString:@"item"]){
        [newsdata addObject:oneNews];
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
    [connector release];
    [xmlParser release];
    [receivedData release];
    [super dealloc];
}


@end
