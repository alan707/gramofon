//
//  RecordViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController : UIViewController <AVAudioRecorderDelegate>
{
    AVAudioRecorder *audioRecorder;
    NSTimer * timer;
}

@property (strong, nonatomic) IBOutlet UILabel *countDownLabel;
@property (strong, nonatomic) IBOutlet UILabel *tapLabel;

- (IBAction)toggleRecording:(id)sender;

@end
