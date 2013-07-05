//
//  RecordViewController.m
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "RecordViewController.h"
#import "AudioClip.h"
#import "GAI.h"

@interface RecordViewController ()
@property (weak, nonatomic) NSString *GetUUID;
@end

@implementation RecordViewController


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

}

- (void)viewWillAppear:(BOOL)animated
{
    self.tapLabel.text = @"TAP To Record";
    self.recordingProgress.progress = 0;
    // when the record view loads, set-up the recorder
    [self resetPlayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    // track screen view in Google Analytics
    [[[GAI sharedInstance] defaultTracker] sendView:@"Record Screen"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // release the iOS audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:NO error:nil];
    self.GetUUID=nil;

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

    // grab the iOS audio session for recording
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



- (IBAction)toggleRecording:(id)sender
{
    if ( audioRecorder.isRecording ) {
        [audioRecorder stop];
    } else {
        [audioRecorder recordForDuration:12];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [self performSelectorInBackground:@selector(progressBar) withObject:nil];
//
        self.tapLabel.text = @"TAP To Finish";
    }
}

- (void)progressBar {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSTimer  scheduledTimerWithTimeInterval:0 target:self selector:@selector(progressBar) userInfo:nil repeats:NO];
        float actual = [self.recordingProgress progress];
        if (actual < 1) {
            self.recordingProgress.progress =
            ((float)audioRecorder.currentTime/(float)12);
            
        }
        else{
        }
    });
    }


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [timer invalidate];
    
    // blank out title, in case of a previous title
    [AudioClip sharedInstance].title    = @"";
    
    // track record event in GoogleAnalytics
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"User Interaction"
                                                      withAction:@"User Recorded a Clip"
                                                       withLabel:@"NA"
                                                       withValue:[NSNumber numberWithInt:0]];
    
    // store audio clip data
    [AudioClip sharedInstance].fileURL  = recorder.url;
    [AudioClip sharedInstance].fileData = [NSData dataWithContentsOfURL:recorder.url];
    
    NSString *url  = [recorder.url absoluteString];
    NSArray *parts = [url componentsSeparatedByString:@"/"];
    
    [AudioClip sharedInstance].fileName = [parts objectAtIndex:[parts count] - 1];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
}

-(void)tick
{
//    NSTimeInterval timeRemaining = 12 - audioRecorder.currentTime;    
//    NSInteger floor = floorf(timeRemaining);
//    NSInteger milliseconds = roundf((timeRemaining - floor) * 100);
    
    if ( floor < 0 ){
        [timer invalidate];
    } else {
//        self.countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d",floor, milliseconds];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    NSNumber *latitude  = [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude];
    NSNumber *longitude = [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude];
    
    [AudioClip sharedInstance].location  = newLocation;
    [AudioClip sharedInstance].latitude  = [NSString stringWithFormat:@"%@", latitude];
    [AudioClip sharedInstance].longitude = [NSString stringWithFormat:@"%@", longitude];
    
    [self performSegueWithIdentifier:@"SegueToShareSound" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ( error.code == kCLErrorDenied ) {
        [self.locationManager stopUpdatingLocation];
        [self performSegueWithIdentifier:@"SegueToShareSound" sender:self];
    } else if( error.code == kCLErrorLocationUnknown ) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
