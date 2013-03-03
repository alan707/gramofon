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

@interface ShareSoundViewController ()

@end

@implementation ShareSoundViewController

@synthesize titleSound, playButton;

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
    
    NSURL *soundFileURL = [AudioClip sharedInstance].fileURL;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
    if ( error ) {
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        
        [audioPlayer prepareToPlay];
    }
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
    }
    
    if ( audioPlayer.isPlaying) {
        [playButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];        
    }
}

- (IBAction)shareSoundButton:(id)sender
{
    [AudioClip sharedInstance].title = titleSound.text;
    
    [self uploadAudioClip];
    
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

- (void)uploadAudioClip
{
    NSString *audioClipUserId   = [NSString stringWithFormat:@"%@", [User sharedInstance].user_id];
    NSString *audioClipUserName = [User sharedInstance].username;
    NSString *audioClipTitle    = [AudioClip sharedInstance].title;
    NSString *audioClipLng      = [NSString stringWithFormat:@"%f", [AudioClip sharedInstance].currentLocation.coordinate.longitude];
    NSString *audioClipLat      = [NSString stringWithFormat:@"%f", [AudioClip sharedInstance].currentLocation.coordinate.latitude];
    NSString *audioClipFileName = [AudioClip sharedInstance].fileName;

    NSURL *url = [NSURL URLWithString:@"http://gramofon.herokuapp.com/audio_clips"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];    
    NSMutableData *body = [NSMutableData data];    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];    
    
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
    NSData *soundFileData = [NSData dataWithContentsOfURL:[AudioClip sharedInstance].fileURL];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"audio_clip[sound_file]\"; filename=\"%@\"\r\n", audioClipFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:soundFileData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"audio_clip[user_id]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipUserId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"audio_clip[username]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipUserName dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"audio_clip[title]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipTitle dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"audio_clip[latitude]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipLat dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"audio_clip[longitude]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipLng dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    //return and test
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if ( titleSound == self.titleSound ) {
        [titleSound resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
    [titleSound resignFirstResponder];
}

- (IBAction)showKeyboard:(id)sender {
    // focus text field
    [titleSound becomeFirstResponder];
}

@end
