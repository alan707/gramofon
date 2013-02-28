//
//  ShareSoundViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSoundViewController : UIViewController
- (IBAction)titleSound:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)shareSoundButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *facebookShareSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twitterShareSwitch;

@end
