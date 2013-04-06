//
//  UserFeedTableViewController.h
//  gramofon
//
//  Created by Alan Mond on 3/17/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "User.h"


@interface UserFeedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>
@property (nonatomic, strong) NSArray *audioClips; //of NSDictionary
@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
