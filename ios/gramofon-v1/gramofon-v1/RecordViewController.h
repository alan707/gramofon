//
//  RecordViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    NSTimer * timer;
}

@property (strong, nonatomic) IBOutlet UILabel *countDownLabel;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (void)previewRecording;

@end
