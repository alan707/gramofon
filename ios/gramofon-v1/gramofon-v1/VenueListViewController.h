//
//  VenueListViewController.h
//  gramofon
//
//  Created by dtrenz on 3/18/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VenueListViewController : UITableViewController

@property (strong,nonatomic)NSArray* nearbyVenues;

@end
