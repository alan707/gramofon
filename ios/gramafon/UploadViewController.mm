//
//  UploadViewController.m
//  gramafon
//
//  Created by Christopher Nowak on 2/2/13.
//  Copyright (c) 2013 Elexicon, Inc. All rights reserved.
//

#import "UploadViewController.h"
#import "ASIFormDataRequest.h"
#import "CurrentData.h"

@implementation UploadViewController

@synthesize playButton, titleField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Share";
    [titleField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self playAudio:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    titleField.text = @"";
}

-(IBAction)playAudio:(id)sender
{
    [playButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:[CurrentData sharedInstance].fileName];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    if (audioPlayer)
     audioPlayer = nil;
     NSError *error;
     
     audioPlayer = [[AVAudioPlayer alloc]
     initWithContentsOfURL:soundFileURL
     error:&error];
     
     audioPlayer.delegate = self;
     
     if (error)
     NSLog(@"Error: %@",
     [error localizedDescription]);
     else
     [audioPlayer play];
    
    
}

-(IBAction)playRobot:(id)sender
{
    [playButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:[CurrentData sharedInstance].fileName];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
        
    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    
    // init fileReader which we will later fetch audio from
    NSURL *inputFileURL = soundFileURL;
    
    fileReader = [[AudioFileReader alloc]
                                    initWithAudioFileURL:inputFileURL
                                    samplingRate:audioManager.samplingRate
                                    numChannels:audioManager.numOutputChannels];
    
        
    __block float frequency = 100.0;
    __block float phase = 0.0;
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         //ringBuffer->FetchInterleavedData(data, numFrames, numChannels);
         
         for (int i=0; i < numFrames; ++i)
         {
             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
             {
                 float theta = phase * M_PI * 2;
                 data[i*numChannels + iChannel] *= sin(theta);
             }
             phase += 1.0 / (samplingRate / frequency);
             if (phase > 1.0) phase = -1;
         }
     }];
    
    [fileReader play];
}

-(IBAction)toggleAudio:(id)sender
{
    if([audioPlayer isPlaying])
    {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        [audioPlayer stop];
    }else{
        [self playAudio:nil];
    }
}


-(IBAction)upload:(id)sender
{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://gramofon.herokuapp.com/audio_clips"]];
    [request setPostValue:[CurrentData sharedInstance].username forKey:@"audio_clip[username]"];
    
    NSString *latString = [NSString stringWithFormat:@"%f",[CurrentData sharedInstance].currentLocation.coordinate.latitude];
    NSString *longString = [NSString stringWithFormat:@"%f",[CurrentData sharedInstance].currentLocation.coordinate.longitude];

    [request setPostValue:latString forKey:@"audio_clip[latitude]"];
    [request setPostValue:longString forKey:@"audio_clip[longitude]"];
    [request setPostValue:titleField.text forKey:@"audio_clip[title]"];
    [request setPostValue:@"true" forKey:@"audio_clip[public]"];
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:[CurrentData sharedInstance].fileName];
    
    [request setFile:soundFilePath forKey:@"audio_clip[sound_file]"];
    [request startSynchronous];
    NSString *response = [request responseString];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

@end
