//
//  ProfileViewController.m
//  gramofon
//
//  Created by Dan Trenz on 7/7/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "ProfileViewController.h"
#import "Utilities.h"
#import "AudioClipModel.h"
#import "HTTPRequest.h"
#import "MBProgressHUD.h"
#import "GAI.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    // get profile photo    
    NSString *userPhotoURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [User sharedInstance].facebook_id];
    
    [[HTTPRequest sharedInstance] doAsynchRequest:@"GET" requestURL:userPhotoURL requestParams:nil completeHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( ! error ) {
            UIImage *userPhoto = [UIImage imageWithData:data];
            
            if ( userPhoto != nil ) {
                self.profileImage.image = userPhoto;
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    self.profileName.text = [NSString stringWithFormat:@"%@ %@", [User sharedInstance].firstname, [User sharedInstance].lastname];
    
    dispatch_queue_t loadingQ = dispatch_queue_create("user feed loading queue", NULL);
    dispatch_async(loadingQ, ^{
        feed = [NSMutableArray array];
        
        [self getFeedData:0 itemCount:20];
        
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    // track screen view in Google Analytics
    [[[GAI sharedInstance] defaultTracker] sendView:@"Profile Screen"];
}


- (void)getFeedData:(int)offset itemCount:(int)limit
{
    [AudioClipModel getAudioClipsByUser:[User sharedInstance].user_id
                             itemOffset:offset
                              itemCount:limit
                               complete:^ (NSData *data) {                               
        NSError *error;

        NSArray *clips = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if ( ! error ) {
            for ( NSDictionary *clipObject in clips ) {
                [feed addObject:clipObject];
            }
            
            [self.profileTable reloadData];
//            [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
        } else {
           NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feed count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableCell"];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProfileTableCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    // Set up the cell.
    NSDictionary *clip = [feed objectAtIndex:indexPath.row];
    
    NSString *clipTitle  = clip[@"title"];
    NSString *clipVenue  = clip[@"venue"];
    NSString *momentsAgo = [Utilities getRelativeTime:clip[@"created"]];
    
    if ( clipTitle.length == 0 ) {
        clipTitle = @"Untitled";
    }
    
    // title label
    cell.textLabel.text = clipTitle;

    // set subtitle text
    if ( clipVenue.length > 0 ) {
        // if we have a venue name, display timestamp + venue
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", momentsAgo, clipVenue];
    } else {
        // otherwise, just display timestamp
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", momentsAgo];
    }
    
    return cell;
}


@end
