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
    
    self.title = @"Share Sounds";
    
    if ( audioPlayer ) {
        audioPlayer = nil;
    }
    
    NSError *error;
        
    // set-up audio player
    NSURL *soundFileURL = [AudioClip sharedInstance].fileName;
//    NSURL *soundFileURL = [NSURL URLWithString:@"https://gramofon.s3.amazonaws.com/uploads/amond/sound_file/D17B7EE9-08B8-4E69-BED8-DD8F6DD1B326.m4a"];
    
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
//    NSURL *url = [NSURL URLWithString:@"https://gramofon.s3.amazonaws.com/uploads/amond/sound_file/D17B7EE9-08B8-4E69-BED8-DD8F6DD1B326.m4a"];
    NSData *soundData = [NSData dataWithContentsOfURL:soundFileURL];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                    NSUserDomainMask, YES) objectAtIndex:0]
                          stringByAppendingPathComponent:@"sound.caf"];
    [soundData writeToFile:filePath atomically:YES];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL
                                                           fileURLWithPath:filePath] error:NULL];
    
    if ( error ) {
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        
        [audioPlayer prepareToPlay];
    }
    
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
    
    if ( audioPlayer.isPlaying ) {
        [playButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];        
    }
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

- (IBAction)dismissKeyboard:(id)sender {
    [titleSound resignFirstResponder];
}

- (IBAction)showKeyboard:(id)sender {
    // focus text field
    [titleSound becomeFirstResponder];
}
@end
