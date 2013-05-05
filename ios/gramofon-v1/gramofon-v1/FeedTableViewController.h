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


- (IBAction)shareButton:(id)sender;
- (IBAction)followButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *theImage;


@end


