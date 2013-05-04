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
#import "expandedCell.h"

@interface UserFeedTableViewController: UITableViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>
{
    NSMutableArray *feed;
    AVAudioPlayer *audioPlayer;
}
//@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)shareButton:(id)sender;


@end