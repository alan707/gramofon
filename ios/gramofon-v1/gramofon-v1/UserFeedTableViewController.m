//
//  UserFeedTableViewController.m
//  gramofon
//
//  Created by Alan Mond on 3/17/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "UserFeedTableViewController.h"
#import "Utilities.h"
#import "HTTPRequest.h"
#import "AudioClipModel.h"

@interface UserFeedTableViewController ()

@end

@implementation UserFeedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    feed = [NSMutableArray array];
    
    [self getFeedData:0 itemCount:20];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list.
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        NSInteger row      = [indexPath row];
        NSDictionary *clip = feed[row];
        NSNumber *clipId   = clip[@"id"];
        
        [AudioClipModel deleteAudioClip:clipId complete:^{
            [feed removeObjectAtIndex:row];
            [tableView reloadData];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // # of rows = # of clips in feed response
    return [feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Audio Clip";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *clip   = feed[indexPath.row];
    NSString *clipTitle  = clip[@"title"];
    NSString *clipVenue  = clip[@"venue"];
    NSString *momentsAgo = [Utilities getRelativeTime:clip[@"created"]];
    
    NSLog(@"Title: %@", clipTitle);
    
    if ( clipTitle.length == 0 ) {
        clipTitle = @"Untitled";
    }
    
    // image
    NSString *path    = [[NSBundle mainBundle] pathForResource:@"speaker" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    
    cell.imageView.image = theImage;
    
    // primary label
    cell.textLabel.text = clipTitle;
    
    // detail label
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"near %@ - %@", clipVenue, momentsAgo];
    
    return cell;
}

- (void)getFeedData:(int)offset itemCount:(int)limit
{
    [AudioClipModel getAudioClipsByUser:[User sharedInstance].user_id
                             itemOffset:offset
                              itemCount:limit
                               complete:^(NSArray *clips) {
                                   for ( NSDictionary *clip in clips ) {
                                       [feed addObject:clip];
                                   }
                                   
                                   [self.tableView reloadData];
                               }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( audioPlayer.isPlaying ) {
        [audioPlayer stop];
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
        NSDictionary *clip = [feed objectAtIndex:indexPath.row];
        NSString *url      = [clip objectForKey:@"url"];
        
        // asynchrous loading of clips w/ complete callback handler
        [[HTTPRequest sharedInstance] doAsynchRequest:@"GET"
                                           requestURL:url
                                        requestParams:nil
                                      completeHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                          if ( ! error ) {
                                              // null out any existing audioPlayer
                                              if ( audioPlayer ) {
                                                  audioPlayer = nil;
                                              }
                                              
                                              // init player with clip URL
                                              audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
                                              
                                              if ( ! error ) {
                                                  // if player init-ed OK...
                                                  
                                                  // delegate
                                                  audioPlayer.delegate = self;
                                                  
                                                  // prep the audio
                                                  [audioPlayer prepareToPlay];
                                                  
                                                  // start playback
                                                  [audioPlayer play];
                                              } else {
                                                  // else, output error to log
                                                  NSLog(@"Error: %@", [error localizedDescription]);
                                              }
                                          } else {
                                              NSLog(@"Error: %@", [error localizedDescription]);
                                          }
                                      }];                
    }
}

@end
