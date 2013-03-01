//
//  RecordViewController.m
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "RecordViewController.h"
#import "AudioClip.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

@synthesize countDownLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    countDownLabel.text = @"12:00";
    
    // when the record view loads, set-up the recorder
    [self resetPlayer];
}

// set-up the recorder
- (void)resetPlayer
{
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *uid;
    NSString *fileName;
    NSString *soundFilePath;
    NSURL *soundFileURL;
    NSDictionary *recordSettings;
    NSError *error = nil;
    AVAudioSession *session;
    
    // build the file name/path;
    uid           = [self GetUUID];
    fileName      = [NSString stringWithFormat:@"%@.m4a",uid];    
    dirPaths      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir       = [dirPaths objectAtIndex:0];
    soundFilePath = [docsDir stringByAppendingPathComponent:fileName];    
    soundFileURL  = [NSURL fileURLWithPath:soundFilePath];
    
    // init the recording settings
    recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
        [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
        [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
        [NSNumber numberWithInt:AVAudioQualityHigh], AVSampleRateConverterAudioQualityKey,
        nil];
    
    // create the recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
    
    // log error, or prepare recorder;
    if ( error ) {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }
    
    // grab the iOS audio session(?)
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    [session setActive:YES error:nil];
    
    audioRecorder.delegate = self;
}

// create the unique ID for use as a filename
- (NSString *)GetUUID
{    
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	NSString *string = (__bridge NSString *)CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return string;
}

- (IBAction)startRecording:(id)sender
{
    if ( audioPlayer.isPlaying ) {
        [audioPlayer stop];
    }
    
    [audioRecorder recordForDuration:12];
    timer = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (IBAction)stopRecording:(id)sender
{
    [audioRecorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{    
    [timer invalidate];
    countDownLabel.text = @"Done!";    

    [AudioClip sharedInstance].fileName = audioRecorder.url;
    
    [self performSegueWithIdentifier: @"SegueToShareSound" sender: self];
}

- (void)previewRecording
{
    if ( audioPlayer.isPlaying == NO ) {
        NSError *error;
        NSURL *soundFile = audioRecorder.url;
        
        if ( audioPlayer ) {
            audioPlayer = nil;
        }
    
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundFile error:&error];
    
        audioPlayer.delegate = self;
    
        [audioPlayer prepareToPlay];
    
        if ( error ) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            [audioPlayer play];
        }
    }
}

-(void)tick
{
    NSTimeInterval timeRemaining = 12 - audioRecorder.currentTime;    
    NSInteger floor = floorf(timeRemaining);
    NSInteger milliseconds = roundf((timeRemaining - floor) * 100);
    
    if(floor < 0){
        countDownLabel.text = @"Done!";
        [timer invalidate];
    }else{
        countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d",floor, milliseconds];
    }
}


@end
