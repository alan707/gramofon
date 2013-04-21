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
#import "ShortTableViewCell.h"

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

    [self.refreshControl beginRefreshing];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShortTableViewCell" bundle:nil] forCellReuseIdentifier:@"Short Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpandedTableViewCell" bundle:nil] forCellReuseIdentifier:@"Expanded Cell"];

    [self loadLatestAudioClips];
    [self.tableView reloadData];
    // commenting out; is this redundant?
    /*    
    dispatch_queue_t loadclipsQ = dispatch_queue_create("loading audio clips from database", NULL);
    
    dispatch_async(loadclipsQ, ^{

        [self loadLatestAudioClips];
  
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.refreshControl addTarget:self
                                    action:@selector(loadLatestAudioClips)
                          forControlEvents:UIControlEventValueChanged];

        });
        
    });
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)loadLatestAudioClips
{    
//    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t loadclipsQ = dispatch_queue_create("loading audio clips from database", NULL);
    
    dispatch_async(loadclipsQ, ^{
        feed = [NSMutableArray array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getFeedData:0 itemCount:20];
        });
    });
 }

- (void)handleRefresh:(id)paramSender
{
    /* Put a bit of delay between when the refresh control is released and when we actually do the refreshing to make
    the UI look a bit smoother than just doing the update without the animation*/
    int64_t delayInSeconds = 1.0f;
    dispatch_time_t popTime =
        dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    [self loadLatestAudioClips];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    });
}

- (void)getFeedData:(int)offset itemCount:(int)limit
{
    [AudioClipModel getAudioClips:offset itemCount:limit complete:^(NSData *data) {
        NSError *error;
        
        NSArray *clips = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
        if ( ! error ) {
            for (NSDictionary *clip in clips) {
                [feed addObject:clip];
            }
                
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (! [self.selectedPath isEqual:indexPath]) {
        ShortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Short Cell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        dispatch_queue_t profilepicQ = dispatch_queue_create("loading facebook pics Facebook", NULL);
        
        dispatch_async(profilepicQ, ^{
            // Configure the cell...
            
            // Try to retrieve from the table view a now-unused cell with the given identifier.
            // Set up the cell.
            NSDictionary *clip     = [feed objectAtIndex:indexPath.row];
            NSDictionary *clipUser = [clip objectForKey:@"user"];
            
            NSString *facebookpic  = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [clipUser objectForKey:@"facebook_id"]];
            
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookpic]];
            
            NSString *clipTitle    = [clip objectForKey:@"title"];
            NSString *clipVenue    = [clip objectForKey:@"venue"];
            NSString *momentsAgo   = [Utilities getRelativeTime:[clip objectForKey:@"created"]];
            
            if ( clipTitle.length == 0 ) {
                clipTitle = @"Untitled";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *facebook_image = [UIImage imageWithData:imageData];
                
                cell.theImage.image  = facebook_image;
                cell.titleLabel.text = clipTitle;
                cell.titleLabel.textAlignment = NSTextAlignmentLeft;
                
                // detail label
                cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                cell.subtitleLabel.text = [NSString stringWithFormat:@"near %@ - %@", clipVenue, momentsAgo];
            });
        });
        
        return cell;
    }else{
        expandedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Expanded Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        dispatch_queue_t profilepicQ = dispatch_queue_create("loading facebook pics Facebook", NULL);
        
        dispatch_async(profilepicQ, ^{
            // Configure the cell...
            
            // Try to retrieve from the table view a now-unused cell with the given identifier.
            // Set up the cell.
            NSDictionary *clip     = [feed objectAtIndex:indexPath.row];
            NSDictionary *clipUser = [clip objectForKey:@"user"];
            
            NSString *facebookpic  = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [clipUser objectForKey:@"facebook_id"]];
            
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookpic]];
            
            NSString *clipTitle    = [clip objectForKey:@"title"];
            NSString *clipVenue    = [clip objectForKey:@"venue"];
            NSString *momentsAgo   = [Utilities getRelativeTime:[clip objectForKey:@"created"]];
            
            if ( clipTitle.length == 0 ) {
                clipTitle = @"Untitled";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *facebook_image = [UIImage imageWithData:imageData];
                
                cell.theImage.image  = facebook_image;
                cell.titleLabel.text = clipTitle;
                cell.titleLabel.textAlignment = NSTextAlignmentLeft;
                
                // detail label
                cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                cell.subtitleLabel.text = [NSString stringWithFormat:@"near %@ - %@", clipVenue, momentsAgo];
            });
        });
        return cell;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *lastSelectedPath = self.selectedPath;
        
    
        
    
    if ( audioPlayer.isPlaying ) {
        // if clip is playing, stop it
        [audioPlayer stop];
        if ([self.selectedPath isEqual:indexPath]) {
            self.selectedPath = nil;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            return;
        }

    } else {
        self.selectedPath = indexPath;
        if (lastSelectedPath != nil) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,lastSelectedPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
       
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

@end
