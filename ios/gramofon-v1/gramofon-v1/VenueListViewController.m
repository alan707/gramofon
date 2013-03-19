//
//  VenueListViewController.m
//  gramofon
//
//  Created by dtrenz on 3/18/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "VenueListViewController.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "AudioClip.h"

@interface VenueListViewController ()

@end

@implementation VenueListViewController

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
    
    [self getVenuesForLocation:[AudioClip sharedInstance].location];
}

-(void)getVenuesForLocation:(CLLocation *)location
{
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
								  longitude:@(location.coordinate.longitude)
								 accuracyLL:nil
								   altitude:nil
								accuracyAlt:nil
									  query:nil
									  limit:nil
									 intent:intentCheckin
                                     radius:@(100)
								   callback:^(BOOL success, id result){
									   if (success) {
										   NSDictionary *dic = result;
										   NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc]init];
                                           self.nearbyVenues = [converter convertToObjects:venues];
                                           [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                                           
									   }
								   }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.nearbyVenues.count ) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyVenues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.nearbyVenues[indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AudioClip sharedInstance].venue = [self.nearbyVenues[indexPath.row] name];
    [self performSegueWithIdentifier:@"SegueFromVenueList" sender:self];
}
                  
@end
