//
//  UploadViewController.h
//  gramafon
//
//  Created by Christopher Nowak on 2/2/13.
//  Copyright (c) 2013 Elexicon, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "NVDSP.h"
#import "Filters/NVHighpassFilter.h"

@interface UploadViewController : UIViewController<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    Novocaine * audioManager;
    AudioFileReader * fileReader;
}

-(IBAction)playAudio:(id)sender;
-(IBAction)upload:(id)sender;
-(IBAction)playRobot:(id)sender;

@property (nonatomic,strong) IBOutlet UIButton * playButton;
@property (nonatomic,strong) IBOutlet UITextField * titleField;

@end
