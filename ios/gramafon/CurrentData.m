//
//  CurrentData.m
//  gramafon
//
//  Created by Christopher Nowak on 2/2/13.
//  Copyright (c) 2013 Elexicon, Inc. All rights reserved.
//

#import "CurrentData.h"

@implementation CurrentData

@synthesize username, locationManager, currentLocation, fileName;

+ (CurrentData *)sharedInstance
{
    // the instance of this class is stored here
    static CurrentData *myInstance = nil;
	
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
		myInstance.locationManager = [[CLLocationManager alloc] init];
        myInstance.locationManager.delegate = myInstance;
        [myInstance.locationManager startUpdatingLocation];
        // initialize variables here
        
    }
    // return the instance of this class
    return myInstance;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    
    //if(newLocation.horizontalAccuracy <= 100.0f) { [locationManager stopUpdatingLocation]; }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
