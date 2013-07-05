//
//  RecordViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RecordViewController : UIViewController <AVAudioRecorderDelegate, CLLocationManagerDelegate>
{
    AVAudioRecorder *audioRecorder;
    NSTimer * timer;
}
@property (weak, nonatomic) IBOutlet UIProgressView *recordingProgress;

@property (strong, nonatomic) IBOutlet UILabel *tapLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)toggleRecording:(id)sender;


@end
