//
//  XnewsAppDelegate.h
//  Xnews
//
//  Created by figo on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XnewsViewController;

@interface XnewsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    XnewsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet XnewsViewController *viewController;

@end

