//
//  DetailViewController.h
//  gramafon
//
//  Created by Christopher Nowak on 2/1/13.
//  Copyright (c) 2013 Elexicon, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadViewController.h"

@interface RecordViewController : UIViewController<AVAudioRecorderDelegate>
{
    AVAudioRecorder *audioRecorder;
    NSTimer * timer;
    UploadViewController *uploadController;
} 


@property (nonatomic, strong) IBOutlet UILabel * countdownLabel;
-(IBAction)recordAudio:(id)sender;
-(IBAction)stopRecording:(id)sender;
-(IBAction)signOut:(id)sender;
-(NSString *)GetUUID;
-(void)resetPlayer;


@end
