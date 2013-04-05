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

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

#define kCellHeight 70.0
#define MAINLABEL_TAG 1
#define SECONDLABEL_TAG 2
#define PHOTO_TAG 3

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t loadclipsQ = dispatch_queue_create("loading audio clips from database", NULL);
    
    dispatch_async(loadclipsQ, ^{

        [self loadLatestAudioClips];
  
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.refreshControl addTarget:self
                                    action:@selector(loadLatestAudioClips)
                          forControlEvents:UIControlEventValueChanged];

        });
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(IBAction)loadLatestAudioClips
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t loadclipsQ = dispatch_queue_create("loading audio clips from database", NULL);
    
    dispatch_async(loadclipsQ, ^{
        feed = [NSMutableArray array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getFeedData:0 itemCount:20];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        });
    });
 }


- (void)getFeedData:(int)offset itemCount:(int)limit
{
    NSError *error;
    
    NSString *url = [NSString stringWithFormat:@"http://api.gramofon.co/clips?offset=%i&limit=20", offset];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response      = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if ( ! error ) {
        NSArray *data = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];

        if ( ! error ) {
            for (NSDictionary *clip in data) {
                [feed addObject:clip];
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Audio Clip";
    
    expandedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                         forIndexPath:indexPath];

    // If no cell is available, create a new one using the given identifier.
    if ( cell == nil ) {
        cell = [[expandedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // disable selection highlight
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

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
        
            // detail label
            cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
            cell.subtitleLabel.text = [NSString stringWithFormat:@"near %@ - %@", clipVenue, momentsAgo];
        });
    });
  
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( audioPlayer.isPlaying ) {
        // if clip is playing, stop it
        [audioPlayer stop];
    } else {
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
        NSString *clipURL = [clip objectForKey:@"url"];
        NSURL *soundFileURL = [NSURL URLWithString:clipURL];
        
        // can we speed this up?
        NSData *soundFileData=[[NSData alloc]initWithContentsOfURL:soundFileURL];
        
        // null out any existing audioPlayer
        if ( audioPlayer ) {
            audioPlayer = nil;
        }
        
        // init player with clip URL
        audioPlayer = [[AVAudioPlayer alloc] initWithData:soundFileData error:&error];
        
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
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    
    // get selected row path
    NSInteger selectedRow = [tableView indexPathForSelectedRow].row;
    NSInteger currentRow  = indexPath.row;
    
	// If our cell is selected, return double height
	if ( currentRow == selectedRow ) {
		rowHeight = kCellHeight * 2.0;
	} else {
        // Cell isn't selected so return single height
        rowHeight = kCellHeight;
    }
    
    return rowHeight;
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
