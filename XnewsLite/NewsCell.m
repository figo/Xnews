//
//  NewsCell.m
//  XnewsLite
//
//  Created by figo on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell
@synthesize icon,body;
/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
*/

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
- (void)seticon:(UIImage *)ic{
    if( ic != nil){
        iconView.image = ic;
    }
}


- (void)setbody:(NSString *)bd{
    if (bd != nil) {
        bodyView.text = bd;
    }
}


- (void) dealloc{
    [body release];
    [icon release];
    [bodyView release];
    [iconView release];
    [super dealloc];
}
@end
