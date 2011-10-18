//
//  NewsCell.h
//  XnewsLite
//
//  Created by figo on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NewsCell : UITableViewCell
{
    UIImage *icon;
    NSString *body;
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *bodyView;
}

@property (retain) UIImage *icon;
@property (retain) NSString *body;

- (void)seticon:(UIImage *)ic;
- (void)setbody:(NSString *)bd;

@end
