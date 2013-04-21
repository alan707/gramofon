//
//  FeedTableViewController.h
//  gramofon
//
//  Created by Alan Mond on 3/21/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "User.h"
#import "expandedCell.h"

@interface FeedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>
{
    NSMutableArray *feed;
    AVAudioPlayer *audioPlayer;
}
@property (nonatomic, strong) IBOutlet UIProgressView *progressBar;


@end


