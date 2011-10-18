//
//  XnewsLiteAppDelegate.h
//  XnewsLite
//
//  Created by figo on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingController.h"
#import "NewsListController.h"


@interface XnewsLiteAppDelegate : NSObject <UIApplicationDelegate>{
@public
    UITabBarController *tab;
    UINavigationController *nav;
    SettingController *setting;
    NewsListController *newslist;
    NSArray * controllers;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
