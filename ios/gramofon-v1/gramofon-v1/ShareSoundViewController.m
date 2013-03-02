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
}

- (void)viewWillAppear:(BOOL)animated
{
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
    
    NSURL *soundFileURL = [AudioClip sharedInstance].fileName;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
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
    
//    NSString *longitude = [NSString stringWithFormat:@"%f", [AudioClip sharedInstance].currentLocation.coordinate.longitude];
//    NSString *latitude = [NSString stringWithFormat:@"%f", [AudioClip sharedInstance].currentLocation.coordinate.latitude];
    
    
    // try this upload code instead
    // from: http://stackoverflow.com/questions/11033448/send-json-data-with-nsurlconnection-in-xcode
    // and: http://stackoverflow.com/questions/9460817/form-data-request-using-nsurlconnection-in-ios
//    NSString *key = [NSString stringWithFormat:@"audio_clip[user_id]=%@&audio_clip[title]=%@&audio_clip[latitude]=%@&audio_clip[longitude]=%@&audio_clip[sound_file]",
//                     [User sharedInstance].user_id,
//                     [AudioClip sharedInstance].title,
//                     longitude,
//                     latitude];
//    
//    NSURL *url = [NSURL URLWithString:@"http://gramofon.herokuapp.com/audio_clips"];
//    
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[key dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    // this is for you to be able to get your server answer.
//    // you will need to make your class a delegate of NSURLConnectionDelegate and NSURLConnectionDataDelegate
//    myClassPointerData = [[NSMutableData data] retain];
//    
//    //later in your class you need to implement
//    
//    -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//        [myClassPointerData appendData:data]
//    }
//    
//    -(void)connection:(NSURLConnection *)connection DidFinishLoading {
//        // do what you want with myClassPointerData the data that your server did send you back here
//        // for info on your server php script you just need to do: echo json_encode(array('var1'=> $var1, 'var2'=>$var2...));
//        // to get your server sending an answer
//    }
    
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
