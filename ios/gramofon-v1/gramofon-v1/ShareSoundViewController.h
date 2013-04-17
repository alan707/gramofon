//
//  ShareSoundViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ShareSoundViewController : UIViewController <AVAudioPlayerDelegate, UITextFieldDelegate>
{
    AVAudioPlayer *audioPlayer;
    AVAudioSession *audioSession;
}

@property (weak, nonatomic) IBOutlet UITextField *titleSound;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)shareSoundButton:(id)sender;
- (IBAction)shareLocation:(id)sender;
- (IBAction)toggleAudio:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)showKeyboard:(id)sender;

@end
