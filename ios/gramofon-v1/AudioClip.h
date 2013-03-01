//
//  AudioClip.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/27/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AudioClip : NSObject <CLLocationManagerDelegate>

+ (AudioClip *)sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSURL *fileName;
@property (nonatomic, strong) NSString *title;

@end
