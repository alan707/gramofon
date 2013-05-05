//
//  FollowingFeedTableViewController.h
//  gramofon
//
//  Created by Alan Mond on 5/5/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "User.h"
#import "expandedCell.h"

@interface FollowingFeedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,
AVAudioPlayerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate >
{
    NSMutableArray *feed;
    AVAudioPlayer *audioPlayer;
}
//@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)shareButton:(id)sender;


@end
