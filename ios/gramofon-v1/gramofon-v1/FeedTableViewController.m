//
//  FeedTableViewController.m
//  gramofon
//
//  Created by Alan Mond on 3/21/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "FeedTableViewController.h"
#import "Utilities.h"

@interface FeedTableViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation FeedTableViewController

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

    [self loadLatestAudioClips];
    [self.refreshControl addTarget:self
                            action:@selector(loadLatestAudioClips)
                  forControlEvents:UIControlEventValueChanged];
    
//    dispatch_queue_t getdataQ = dispatch_queue_create("load Audio Clips into table", NULL);
//    dispatch_async(getdataQ, ^{
//        feed = [NSMutableArray array];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self getFeedData:0 itemCount:20];
//        });
//    });
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
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
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
       
    // image
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"speaker" of Type:@"png"];
    static NSString *CellIdentifier = @"Audio Clip";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    // If no cell is available, create a new one using the given identifier.
    if ( cell == nil ) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    dispatch_queue_t profilepicQ = dispatch_queue_create("loading facebook pics Facebook", NULL);
    dispatch_async(profilepicQ, ^{
                
        
        // Configure the cell...
        
        // Try to retrieve from the table view a now-unused cell with the given identifier.
               // Set up the cell.
        NSDictionary *clip     = [feed objectAtIndex:indexPath.row];
        NSDictionary *clipUser = [clip objectForKey:@"user"];

    NSString *facebookpic = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [clipUser objectForKey:@"facebook_id"]];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookpic]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *clipTitle    = [clip objectForKey:@"title"];
        NSString *clipVenue    = [clip objectForKey:@"venue"];
        NSString *momentsAgo   = [Utilities getRelativeTime:[clip objectForKey:@"created"]];
               
        if ( clipTitle.length == 0 ) {
            clipTitle = @"Untitled";
        }

        
        cell.imageView.image = [UIImage imageWithData: imageData];
        cell.textLabel.text = clipTitle;
        
        // detail label
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"near %@ - %@", clipVenue, momentsAgo];
        
    });
        });
            return cell;
    // primary label
    }




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
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
        NSDictionary *clip = [feed objectAtIndex:indexPath.row];
        NSString *clipURL = [clip objectForKey:@"url"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


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
