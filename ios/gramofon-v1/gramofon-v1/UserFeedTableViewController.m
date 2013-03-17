//
//  UserFeedTableViewController.m
//  gramofon
//
//  Created by Alan Mond on 3/17/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "UserFeedTableViewController.h"

@interface UserFeedTableViewController ()

@end

@implementation UserFeedTableViewController
@synthesize feed = _feed;
@synthesize audioPlayer;

- (void) setAudioClips:(NSArray *)audioClips
{
    _audioClips = audioClips;
    [self.tableView reloadData]; // reloads data from model
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _feed = [NSMutableArray array];

    
    [self getFeedData:0 itemCount:20];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_feed count]; // count # of rows
    NSLog(@"Feed Count USER Profile: %u", [_feed count]);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Audio Clip";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *clip  = [_feed objectAtIndex:indexPath.row];
    NSString *clipTitle = [clip objectForKey:@"title"];
    NSString *clipVenue = [clip objectForKey:@"fsvenue"];
    
    
    if ( clipTitle.length == 0 ) {
        clipTitle = @"Untitled";
    }
    
    // image
    NSString *path = [[NSBundle mainBundle] pathForResource:@"speaker" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    
    // primary label
    cell.textLabel.text = clipTitle;
    
    // detail label
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"near %@", clipVenue];
    return cell;
}
- (void)getFeedData:(int)offset itemCount:(int)limit
{
    

    NSError *error;
//    [User sharedInstance].username = @"dtrenz";
    
    NSString *url         = [NSString stringWithFormat:@"http://gramofon.herokuapp.com/users/%@/audio_clips.json?offset=%i&limit=20", [User sharedInstance].username, offset];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response      = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if ( ! error ) {
        NSArray *data = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
        
        if ( ! error ) {
            for (NSDictionary *clip in data) {
                [_feed addObject:clip];
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"feed count:%u", [_feed count]);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ( audioPlayer.isPlaying ) {
        [audioPlayer stop];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"speaker" ofType:@"png"];
        UIImage *theImage = [UIImage imageWithContentsOfFile:path];
        cell.imageView.image = theImage;
    } else {
        // set-up audio player
        NSError *error;
        
        // grab the iOS audio session for playback
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:&error];
        
        if ( error ) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        // Get the clip
        NSDictionary *clip = [_feed objectAtIndex:indexPath.row];
        NSString *clipURL = [clip objectForKey:@"sound_file_url"];
        NSURL *soundFileURL = [NSURL URLWithString:clipURL];
        
        NSData *soundFileData=[[NSData alloc]initWithContentsOfURL:soundFileURL];
        
        if ( audioPlayer ) {
            audioPlayer = nil;
        }
        
        audioPlayer = [[AVAudioPlayer alloc] initWithData:soundFileData error:&error];
        
        if ( ! error ) {
            audioPlayer.delegate = self;
            
            [audioPlayer prepareToPlay];
            
            [audioPlayer play];
            
            if ( audioPlayer.isPlaying ) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"];
                UIImage *theImage = [UIImage imageWithContentsOfFile:path];
                cell.imageView.image = theImage;
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }

    
    
    
    
    //      [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
