//
//  DetailViewController.m
//  gramafon
//
//  Created by Christopher Nowak on 2/1/13.
//  Copyright (c) 2013 Elexicon, Inc. All rights reserved.
//

#import "RecordViewController.h"
#import "CurrentData.h"

@interface RecordViewController ()
@end


@implementation RecordViewController

@synthesize countdownLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(NSString *)GetUUID
{
    
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	NSString *string = (__bridge NSString *)CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return string;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    countdownLabel.text = @"12:00";
    [self resetPlayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)recordAudio:(id)sender
{
        
    [audioRecorder recordForDuration:12];
    timer = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(tick) userInfo:nil repeats:YES];
     
}
                         
-(void)resetPlayer 
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    NSString * uid = [self GetUUID];
    [CurrentData sharedInstance].fileName = [NSString stringWithFormat:@"%@.m4a",uid];

    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:[CurrentData sharedInstance].fileName];
    
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:AVAudioQualityHigh], AVSampleRateConverterAudioQualityKey,
                                    //[NSNumber numberWithInt:128000], AVEncoderBitRateKey,
                                    //[NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    //[NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    //[NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                    nil];
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }
    
     
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    [session setActive:YES error:nil];
    audioRecorder.delegate = self;
}

-(void)tick
{
    NSTimeInterval timeRemaining = 12-audioRecorder.currentTime; 
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeRemaining sinceDate:date1];
    NSInteger seconds = ceilf(timeRemaining);
    NSInteger floor = floorf(timeRemaining);
    NSInteger milliseconds = roundf((timeRemaining - floor) * 100);
    
    if(floor < 0){
        countdownLabel.text = @"Done!";
        [timer invalidate];
    }else{
        countdownLabel.text = [NSString stringWithFormat:@"%02d:%02d",floor, milliseconds];
    }
}

-(IBAction)stopRecording:(id)sender
{
    [audioRecorder stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    int flags = AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation;
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:NO withFlags:flags error:nil];
    //[session setPreferredHardwareSampleRate:22 error:<#(NSError *__autoreleasing *)#>
    
    [timer invalidate];
    countdownLabel.text = @"Done!";
}

-(IBAction)signOut:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if(uploadController == nil){
        uploadController = [UploadViewController alloc];
    }
    [self.navigationController pushViewController:uploadController animated:true];
    
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}
@end
