//
//  graySquareView.h
//  gramofon
//
//  Created by Alan Mond on 3/31/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface graySquareView : UIView
- (IBAction)share:(UIButton *)sender;
- (IBAction)favorite:(UIButton *)sender;
- (IBAction)comment:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;
@property (nonatomic) BOOL shouldShow;

@end
