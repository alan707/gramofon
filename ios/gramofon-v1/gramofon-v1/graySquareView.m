//
//  graySquareView.m
//  gramofon
//
//  Created by Alan Mond on 3/31/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "graySquareView.h"

@implementation graySquareView

# define BTN_SCALE_FACTOR_WIDTH  50
# define BTN_SCALE_FACTOR_HEIGHT 10


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *cgRect = [UIBezierPath bezierPathWithRect:self.bounds ];
    [cgRect addClip];
    
    [[UIColor darkGrayColor] setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    
//    UIView *buttonView = [[UIView alloc] initWithFrame:self.bounds];
//    buttonView.center = self.center ;
//    CGRect buttonframe=CGRectMake(0, 0, 44, 44);
//    UIButton *button = [[UIButton alloc] initWithFrame:buttonframe];
    CGRect btnRect =CGRectInset(self.bounds,
                                BTN_SCALE_FACTOR_WIDTH,
                                BTN_SCALE_FACTOR_HEIGHT);
    UIButton *button = [[UIButton alloc] initWithFrame:btnRect];
    UIImage *shareImg = [UIImage imageNamed:@"Share@2x.png" ];
    [button setImage:shareImg forState:UIControlStateNormal ];
    [self addSubview: button];// adds buttons to all expanded cells and just leaves them there.
    
//    [cgRect stroke];

    
}

- (IBAction)share:(UIButton *)sender {
}

- (IBAction)favorite:(UIButton *)sender {
}

- (IBAction)comment:(UIButton *)sender {
}

- (void)setShouldShow:(BOOL)shouldShow  {
    _shouldShow = shouldShow;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

//- (void)addSubview:(UIView *)buttonsRow
//{
//    UIView *buttonView = [[UIView alloc] initWithFrame:self.bounds];
//    buttonView.center = self.center ;
//    CGRect buttonframe=CGRectMake(0, 0, 44, 44);
//    UIButton *button = [[UIButton alloc] initWithFrame:buttonframe];
//    UIImage *shareImg = [UIImage imageNamed:@"Share@2x" ];
//    
////    
////    UIBezierPath *alignedButtons = [UIBezierPath bezierPathWithRect:self.bounds ];
////    [alignedButtons addClip];
//    
//    
//}

- (void) setup
{
    
 
}

-(void)awakeFromNib
{
    [self setup];
}



@end
