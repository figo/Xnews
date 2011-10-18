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
  NSMutableString *cellurl;  
}

@property(retain) UIWebView *wview;
@property(retain) NSMutableString *cellurl;
@end
