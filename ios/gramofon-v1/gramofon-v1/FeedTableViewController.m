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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (BOOL)cellIsSelected:(NSIndexPath *)indexPath;
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
     selectedIndexes = [[NSMutableDictionary alloc] init];

    [self loadLatestAudioClips];
    [self.refreshControl addTarget:self
                            action:@selector(loadLatestAudioClips)
                  forControlEvents:UIControlEventValueChanged];
}



- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [selectedIndexes objectForKey:indexPath];
	return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
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
//    dispatch_queue_t loadclipsQ = dispatch_queue_create("loading audio clips from database", NULL);
//    dispatch_async(loadclipsQ, ^{
        feed = [NSMutableArray array];
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self getFeedData:0 itemCount:20];
          
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

//        });
//    });
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

/*

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"myCell";
    
    UILabel *mainLabel, *secondLabel;
    UIImageView *photo;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       
        cell = [[[UITableViewCell alloc] initWithStyle: reuseIdentifier:<#(NSString *)#> reuseIdentifier:CellIdentifier]];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        mainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 220.0, 15.0)]];
        mainLabel.tag = MAINLABEL_TAG;
        mainLabel.font = [UIFont systemFontOfSize:14.0];
        mainLabel.textAlignment = NSTextAlignmentLeft;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:mainLabel];
        
        secondLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 220.0, 25.0)]];
        secondLabel.tag = SECONDLABEL_TAG;
        secondLabel.font = [UIFont systemFontOfSize:12.0];
        secondLabel.textAlignment = NSTextAlignmentLeft;
        secondLabel.textColor = [UIColor darkGrayColor];
        secondLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:secondLabel];
        
        photo = [[[UIImageView alloc] initWithFrame:CGRectMake(225.0, 0.0, 80.0, 45.0)]];
        photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
    
         }
        
         else {
        mainLabel = (UILabel *)[cell.contentView viewWithTag:MAINLABEL_TAG];
        secondLabel = (UILabel *)[cell.contentView viewWithTag:SECONDLABEL_TAG];
        photo = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
}
    NSDictionary *clip     = [feed objectAtIndex:indexPath.row];
    NSDictionary *clipUser = [clip objectForKey:@"user"];
    NSString *facebookpic = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [clipUser objectForKey:@"facebook_id"]];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookpic]];

    mainLabel.text = [clip objectForKey:@"title"];
    secondLabel.text = [clip objectForKey:@"venue"];
//    NSString *momentsAgo   = [Utilities getRelativeTime:[clip objectForKey:@"created"]];

    if ( mainLabel.text.length == 0 ) {
        mainLabel.text = @"Untitled";
    }


//    NSDictionary *aDict = [self.list objectAtIndex:indexPath.row];
    
    
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[aDict objectForKey:@"imageKey"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithData:imageData];
    photo.image = theImage;
    
    return cell;
}

*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    static NSString *CellIdentifier = @"Audio Clip";
    expandedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    
    // If no cell is available, create a new one using the given identifier.
    if ( cell == nil ) {
        // Use the default cell style.
//        cell = [[expandedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell = [[expandedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

//    dispatch_queue_t profilepicQ = dispatch_queue_create("loading facebook pics Facebook", NULL);
//    dispatch_async(profilepicQ, ^{
    
        
        // Configure the cell...
        
        // Try to retrieve from the table view a now-unused cell with the given identifier.
               // Set up the cell.
        NSDictionary *clip     = [feed objectAtIndex:indexPath.row];
        NSDictionary *clipUser = [clip objectForKey:@"user"];

        NSString *facebookpic = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [clipUser objectForKey:@"facebook_id"]];
//                dispatch_async(dispatch_get_main_queue(), ^{
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:facebookpic]];

        NSString *clipTitle    = [clip objectForKey:@"title"];
        NSString *clipVenue    = [clip objectForKey:@"venue"];
        NSString *momentsAgo   = [Utilities getRelativeTime:[clip objectForKey:@"created"]];
               
        if ( clipTitle.length == 0 ) {
            clipTitle = @"Untitled";
        }

        UIImage *facebook_image = [UIImage imageWithData:imageData];
        cell.theImage.image = facebook_image;
        cell.titleLabel.text = clipTitle;
        
        // detail label
        cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
        cell.subtitleLabel.text = [NSString stringWithFormat:@"near %@ - %@", clipVenue, momentsAgo];
        
        
  
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect cell
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if ( audioPlayer.isPlaying ) {
        [audioPlayer stop];
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"speaker" ofType:@"png"];
//        UIImage *theImage = [UIImage imageWithContentsOfFile:path];
//        cell.imageView.image = theImage;
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
//        dispatch_queue_t clipFetch = dispatch_queue_create("getting feed for clip", NULL);
//        dispatch_async(clipFetch, ^{
//            <#code#>
//        })
        
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
//                NSString *path = [[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"];
//                UIImage *theImage = [UIImage imageWithContentsOfFile:path];
//                cell.imageView.image = theImage;
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }

    
	
	// Toggle 'selected' state
	BOOL isSelected = ![self cellIsSelected:indexPath];
	
//	// Store cell 'selected' state keyed on indexPath
	NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
	[selectedIndexes setObject:selectedIndex forKey:indexPath];
    
	// This is where magic happens...
	

    [tableView beginUpdates];
	[tableView endUpdates];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// If our cell is selected, return double height
	if([self cellIsSelected:indexPath]) {
		return kCellHeight * 2.0;
	}
	// Cell isn't selected so return single height
	return kCellHeight;
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
