//
//  AudioClip.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/27/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AudioClip : NSObject

+ (AudioClip *)sharedInstance;

@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSURL *fileURL;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *venue;

@end
