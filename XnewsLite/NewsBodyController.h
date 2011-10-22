//
//  NewsCellController.h
//  XnewsLite
//
//  Created by figo on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsBodyController : UIViewController
{
  UIWebView *wview;
  UITextView *tview;
  NSMutableString *cellurl;  
  NSMutableString *cellnewsbody;
}

@property(retain) UIWebView *wview;
@property(retain) UITextView *tview;
@property(retain) NSMutableString *cellurl, *cellnewsbody;
@end
