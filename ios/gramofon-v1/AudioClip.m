//
//  AudioClip.m
//  gramofon-v1
//
//  Created by Alan Mond on 2/27/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "AudioClip.h"

@implementation AudioClip

@synthesize fileName, fileURL, title, latitude, longitude, venue;

+ (AudioClip *)sharedInstance
{
    // the instance of this class is stored here
    static AudioClip *myInstance = nil;
	
    // check to see if an instance already exists
    if ( nil == myInstance ) {
        myInstance  = [[[self class] alloc] init];
    }
    
    // return the instance of this class
    return myInstance;
}

@end
