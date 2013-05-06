//
//  ShareSoundViewController.m
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "ShareSoundViewController.h"
#import "User.h"
#import "AudioClip.h"
#import "AudioClipModel.h"
#import "GAI.h"

@interface ShareSoundViewController ()

@end

@implementation ShareSoundViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // grab the iOS audio session fo playback
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    // when the share view loads, set-up the player
    if ( audioPlayer ) {
        audioPlayer = nil;
    }
    
    // set-up audio player
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[AudioClip sharedInstance].fileData error:&error];

    if ( error ) {
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        
        [audioPlayer prepareToPlay];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // if the clip has a title, reload it into the title text input
    if ( [AudioClip sharedInstance].title ) {
        self.titleSound.text = [AudioClip sharedInstance].title;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    // track screen view in Google Analytics
    [[[GAI sharedInstance] defaultTracker] sendView:@"Share Screen"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // release the iOS audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleAudio:(id)sender
{
    if ( audioPlayer.isPlaying ) {
        [audioPlayer stop];
    } else {
        [audioPlayer play];        
        
        // track clip preview event in GoogleAnalytics
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"User Interaction"
                                                          withAction:@"Previewed Clip from Share Screen"
                                                           withLabel:@"NA"
                                                           withValue:[NSNumber numberWithInt:0]];
    }
    
    if ( audioPlayer.isPlaying) {
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (IBAction)shareLocation:(id)sender
{
    // if the user has entered a title, store it for later
    if ( self.titleSound.text ) {
        [AudioClip sharedInstance].title = self.titleSound.text;
    }
    
    [self performSegueWithIdentifier:@"SegueToVenueList" sender:self];    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

- (IBAction)shareSoundButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:TRUE];
    
    [AudioClipModel uploadAudioClip];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if ( self.titleSound == self.titleSound ) {
        [self.titleSound resignFirstResponder];
    }
    
    // update the title of the audio clip
    [AudioClip sharedInstance].title = self.titleSound.text;
    
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.titleSound resignFirstResponder];
}

- (IBAction)showKeyboard:(id)sender
{
    // focus text field
    [self.titleSound becomeFirstResponder];
}

@end
