//
//  NewsCellController.m
//  XnewsLite
//
//  Created by figo on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsBodyController.h"

@implementation NewsBodyController

@synthesize wview, tview,cellurl,cellnewsbody;


-(void) hideTabBar
{
    
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    wview = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [wview scalesPageToFit];
    [wview loadHTMLString:cellnewsbody baseURL:nil];
    //[wview loadData:[cellnewsbody dataUsingEncoding:NSUTF8StringEncoding] MIMEType:@"text" textEncodingName:@"utf-8" baseURL:nil];
    self.view = wview;
    //NSLog(@"print out the url:%@ \n body: %@",cellurl,cellnewsbody);
    //Do any additional setup after loading the view from its nib.

    
    /*  UITextView to display content
    tview = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    tview.text = cellnewsbody;
    [tview setFont:[UIFont fontWithName:@"Arial" size:17]];
    self.view = tview;*/
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Back";
    //cellurl = (NSMutableString *)[cellurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //[wview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cellurl]]];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
