//
//  expandedCell.h
//  gramofon
//
//  Created by Alan Mond on 3/28/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface expandedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *theImage;
@property (strong, nonatomic) IBOutlet UIView *graySquare;


@end
