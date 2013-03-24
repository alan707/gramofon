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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [playButton setTitle:@"Play" forState:UIControlStateNormal];    
}

- (IBAction)shareSoundButton:(id)sender
{
    [AudioClip sharedInstance].title = titleSound.text;
    
    [self.navigationController popToRootViewControllerAnimated:TRUE];
    dispatch_queue_t uploadQ  = dispatch_queue_create("upload sound loading queue", NULL);
    dispatch_async(uploadQ, ^{

        [self uploadAudioClip];
    
    });
}

- (void)uploadAudioClip
{
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    NSString *audioClipUserId   = [NSString stringWithFormat:@"%@", [User sharedInstance].user_id];
    NSString *audioClipTitle    = [AudioClip sharedInstance].title;
    NSString *audioClipLng      = [NSString stringWithFormat:@"%@", [AudioClip sharedInstance].longitude];
    NSString *audioClipLat      = [NSString stringWithFormat:@"%@", [AudioClip sharedInstance].latitude];
    NSString *audioClipFileName = [AudioClip sharedInstance].fileName;
    NSString *audioClipVenue    = [AudioClip sharedInstance].venue;

    NSURL *url = [NSURL URLWithString:@"http://api.gramofon.co/clips"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];    
    NSMutableData *body = [NSMutableData data];    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];    
    
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
    NSData *soundFileData = [NSData dataWithContentsOfURL:[AudioClip sharedInstance].fileURL];
    
    NSLog(@"Uploading...");
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"audio\"; filename=\"%@\"\r\n", audioClipFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:soundFileData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"clip[user_id]: %@", audioClipUserId);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"clip[user_id]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipUserId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSLog(@"clip[username]: %@", audioClipUserName);
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"audio_clip[username]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[audioClipUserName dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"clip[title]: %@", audioClipTitle);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"clip[title]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipTitle dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"clip[latitude]: %@", audioClipLat);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"clip[latitude]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipLat dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"clip[longitude]: %@", audioClipLng);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"clip[longitude]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipLng dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"clip[venue]: %@", audioClipVenue);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"clip[venue]\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[audioClipVenue dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    //return and test
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
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
