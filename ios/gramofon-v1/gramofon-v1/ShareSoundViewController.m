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

@synthesize playButton, titleSound;

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
    
    self.title = @"Share Sounds";
    
    [titleSound becomeFirstResponder];
}
	
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAudio:(id)sender
{
    [playButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    NSURL *soundFileURL = [AudioClip sharedInstance].fileName;
    
    if ( audioPlayer ) {
        audioPlayer = nil;
    }
    
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
    audioPlayer.delegate = self;
    
    if ( error ) {
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {
        [audioPlayer play];
    }   
}

- (IBAction)toggleAudio:(id)sender
{
    if ( audioPlayer.isPlaying )
    {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        [audioPlayer stop];
    } else {
        [self playAudio:nil];
    }
}

- (IBAction)titleSound:(id)sender
{
}

- (IBAction)shareSoundButton:(id)sender
{
    [AudioClip sharedInstance].title = titleSound.text;
    
    NSLog(@"User.username: %@", [User sharedInstance].username);
    NSLog(@"User.facebook_id: %@", [User sharedInstance].facebook_id);
    NSLog(@"User.firstname: %@", [User sharedInstance].firstname);
    NSLog(@"User.lastname: %@", [User sharedInstance].lastname);
    NSLog(@"User.email: %@", [User sharedInstance].email);
    
    NSLog(@"AudioClip.fileName: %@", [[AudioClip sharedInstance].fileName absoluteString]);
    NSLog(@"AudioClip.title: %@", [AudioClip sharedInstance].title);
    NSLog(@"AudioClip.currentLocation: %@", [AudioClip sharedInstance].currentLocation);
//    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://gramofon.herokuapp.com/audio_clips"]];
//    [request setPostValue:[CurrentData sharedInstance].username forKey:@"audio_clip[username]"];
//    
//    NSString *latString = [NSString stringWithFormat:@"%f",[CurrentData sharedInstance].currentLocation.coordinate.latitude];
//    NSString *longString = [NSString stringWithFormat:@"%f",[CurrentData sharedInstance].currentLocation.coordinate.longitude];
//    
//    [request setPostValue:latString forKey:@"audio_clip[latitude]"];
//    [request setPostValue:longString forKey:@"audio_clip[longitude]"];
//    [request setPostValue:titleField.text forKey:@"audio_clip[title]"];
//    [request setPostValue:@"true" forKey:@"audio_clip[public]"];
//    NSArray *dirPaths;
//    NSString *docsDir;
//    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = [dirPaths objectAtIndex:0];
//    NSString *soundFilePath = [docsDir
//                               stringByAppendingPathComponent:[CurrentData sharedInstance].fileName];
//    
//    [request setFile:soundFilePath forKey:@"audio_clip[sound_file]"];
//    [request startSynchronous];
//    NSString *response = [request responseString];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if ( titleSound == self.titleSound ) {
        [titleSound resignFirstResponder];
    }
    return YES;
}

@end
