//
//  FeedTableViewController.m
//  gramofon
//
//  Created by Alan Mond on 3/21/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "FeedTableViewController.h"
#import "Utilities.h"
#import "expandedCell.h"
#import "AudioClipModel.h"
#import "HTTPRequest.h"


@interface FeedTableViewController ()
@property (nonatomic, strong) NSIndexPath *selectedPath;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedTableViewController

#define kCellHeight 70.0

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"ExpandedTableViewCell" bundle:nil] forCellReuseIdentifier:@"Expanded Cell"];
    
    [self.refreshControl beginRefreshing];
    [self loadLatestAudioClips];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)loadLatestAudioClips
{
    feed = [NSMutableArray array];
    
    [self getFeedData:0 itemCount:20];
 }

- (void)handleRefresh:(id)paramSender
{
    /* Put a bit of delay between when the refresh control is released and when we actually do the refreshing to make
    the UI look smoother than just doing the update without the animation*/
    int64_t delayInSeconds = 1.0f;
    dispatch_time_t popTime =
        dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        [self loadLatestAudioClips];
        
    });
}

- (void)getFeedData:(int)offset itemCount:(int)limit
{
    [AudioClipModel getAudioClips:offset itemCount:limit complete:^(NSData *data) {
        NSError *error;
        
        NSArray *clips = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
        if ( ! error ) {
            for ( NSDictionary *clipObject in clips ) {
                
                NSUInteger intClipIndex = [feed count];
                
                NSMutableDictionary *clip = [NSMutableDictionary dictionaryWithDictionary:clipObject];
                
                clip[@"index"] = [NSNumber numberWithInt:intClipIndex];
                
                clip[@"user"] = [NSMutableDictionary dictionaryWithDictionary:clip[@"user"]];
                
                [clip addObserver:self forKeyPath:@"user.photo" options:NSKeyValueObservingOptionNew context:@"myContext"];
                
                [feed addObject:clip];
                
                // get profile photo
                
                NSDictionary *clipUser = [clip objectForKey:@"user"];
                
                NSString *userPhotoURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [clipUser objectForKey:@"facebook_id"]];
                
                [[HTTPRequest sharedInstance] doAsynchRequest:@"GET" requestURL:userPhotoURL requestParams:nil completeHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if ( ! error ) {
                        UIImage *userPhoto = [UIImage imageWithData:data];
                        
                        if ( userPhoto != nil ) {
                            feed[intClipIndex][@"user"][@"photo"] = userPhoto;
                        }
                    } else {
                        NSLog(@"Error: %@", [error localizedDescription]);
                    }
                }];
            }
                
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // user photo has been loaded/added, refresh cell data to see it
    [self.tableView reloadData];

    // ideally, we would only update this row, but i can't get it to work -dt
//    NSUInteger row         = [object[@"index"] intValue];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    expandedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Expanded Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    // Set up the cell.
    NSDictionary *clip     = [feed objectAtIndex:indexPath.row];  
    NSString *clipTitle    = clip[@"title"];
    NSString *clipVenue    = clip[@"venue"];
    NSString *momentsAgo   = [Utilities getRelativeTime:clip[@"created"]];
    
    if ( clipTitle.length == 0 ) {
        clipTitle = @"Untitled";
    }
    
    if ( clip[@"user"][@"photo"] != nil ) {
        cell.theImage.image = clip[@"user"][@"photo"];
    }
    
    cell.titleLabel.text = clipTitle;
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    // detail label
    cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    
    // set subtitle text
    if ( clipVenue ) {
        // if we have a venue name, display timestamp + venue
        cell.subtitleLabel.text = [NSString stringWithFormat:@"%@ - %@", momentsAgo, clipVenue];
    } else {
        // otherwise, just display timestamp
        cell.subtitleLabel.text = [NSString stringWithFormat:@"%@", momentsAgo];        
    }
    
    return cell;
}


#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( audioPlayer.isPlaying ) {
        // if clip is playing, stop it
        [audioPlayer stop];
        if ([self.selectedPath isEqual:indexPath]) {
            self.selectedPath = nil;
            
            // If cell is selected again, reload row to compress the cell back to the short size
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

    } else {
        self.selectedPath = indexPath;
      
        // Begin expandable cell code...        
        // This is where magic happens...
        [tableView beginUpdates];
        [tableView endUpdates];
        
        // Begin audio playback code...
        
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
//                    [self performSelectorInBackground:@selector(playbackProgress) withObject:nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    
    if ([indexPath isEqual:self.selectedPath]) {
        rowHeight = kCellHeight * 2.0;
    }else{
        rowHeight = kCellHeight;
    }
    return rowHeight;
}


- (void)playbackProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
    
//        [NSTimer  scheduledTimerWithTimeInterval:0 target:self selector:@selector(progressBar) userInfo:nil repeats:NO];
        float progress = (float)audioPlayer.deviceCurrentTime/(float)audioPlayer.duration;
        [self.progressBar setProgress:progress];
       });
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Are we at the bottom of the feed table?
    if ( indexPath.row + 1 == [feed count] ) {        
        int offset = (unsigned int)[feed count];
        
        [self getFeedData:offset itemCount:20];
        
        [self.tableView reloadData];
    }
}

- (IBAction)shareButton:(id)sender {
    NSString* someText = @"Dude, I just sent you this text from the app!!";
    NSArray* dataToShare = @[someText];  // ...or whatever pieces of data you want to share.
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}
@end
