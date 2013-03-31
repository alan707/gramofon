//
//  expandedCell.m
//  gramofon
//
//  Created by Alan Mond on 3/28/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "expandedCell.h"

@implementation expandedCell
@synthesize titleLabel, subtitleLabel, theImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//- (UIView *) graySquare {
//    CGRect  viewRect = CGRectMake(10, 10, 100, 100);
//    UIView* myView = [[UIView alloc] initWithFrame:viewRect];
//    [self.contentView addSubview:myView];
//    return myView;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
