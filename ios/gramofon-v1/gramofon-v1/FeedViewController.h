//
//  FeedViewController.h
//  gramofon
//
//  Created by Dan Trenz on 3/9/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FeedViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>
{
    NSArray *feed;
    AVAudioPlayer *audioPlayer;
}

@end
