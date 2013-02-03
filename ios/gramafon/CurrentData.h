//
//  CurrentData.h
//  gramafon
//
//  Created by Christopher Nowak on 2/2/13.
//  Copyright (c) 2013 Elexicon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentData : NSObject<CLLocationManagerDelegate>

+ (CurrentData *)sharedInstance;

@property (nonatomic, strong) NSString * username;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString * fileName;

@end
