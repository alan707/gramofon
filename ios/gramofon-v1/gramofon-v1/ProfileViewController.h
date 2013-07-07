//
//  ProfileViewController.h
//  gramofon
//
//  Created by Dan Trenz on 7/7/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "User.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate>
{
    NSMutableArray *feed;
    AVAudioPlayer *audioPlayer;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileDetail;
@property (weak, nonatomic) IBOutlet UITableView *profileTable;

@end