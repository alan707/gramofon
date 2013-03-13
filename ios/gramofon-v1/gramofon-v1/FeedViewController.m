//
//  FeedViewController.m
//  gramofon
//
//  Created by Dan Trenz on 3/9/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

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
    
    // Inside a Table View Controller's viewDidLoad method
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
   refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
     action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    NSError *error;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gramofon.herokuapp.com/audio_clips.json?limit=20"]];
    NSData *response      = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if ( ! error ) {
        feed = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
        
        if ( ! error ) {
            for (NSDictionary *clip in feed) {
                NSLog(@"%@", [clip objectForKey:@"title"]);
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // There is only one section.
    return 1;
}

-(void)refreshView:(UIRefreshControl *)refresh {
     refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];

    // custom refresh logic would be placed here...
    NSError *error;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gramofon.herokuapp.com/audio_clips.json?limit=20"]];
    NSData *response      = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if ( ! error ) {
        feed = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
        
        if ( ! error ) {
            for (NSDictionary *clip in feed) {
                NSLog(@"%@", [clip objectForKey:@"title"]);
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }

    
    [self.tableView reloadData];
    
 

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
     [formatter stringFromDate:[NSDate date]]];
     refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
     [refresh endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if ( cell == nil ) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell.
    NSDictionary *clip  = [feed objectAtIndex:indexPath.row];
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
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( audioPlayer.isPlaying ) {
        [audioPlayer stop];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"speaker" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row + 1 == [feed count] ) {
        NSLog(@"bottom reached!");
    } else {
        NSLog(@"will display cell: %i", indexPath.row);
        
        //        NSArray *insertIndexPaths = [NSArray arrayWithObjects:
        //                                     [NSIndexPath indexPathForRow:0 inSection:0],
        //                                     [NSIndexPath indexPathForRow:3 inSection:0],
        //                                     [NSIndexPath indexPathForRow:5 inSection:0],
        //                                     nil];
        //        [tableView insertRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]'
    }
}

@end
