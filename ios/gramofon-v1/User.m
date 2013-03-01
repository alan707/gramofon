//
//  User.m
//  gramofon-v1
//
//  Created by dtrenz on 3/1/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username, facebook_id, firstname, lastname, email;

+ (User *)sharedInstance
{
    // the instance of this class is stored here
    static User *myInstance = nil;
	
    // check to see if an instance already exists
    if ( nil == myInstance ) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here        
    }
    
    // return the instance of this class
    return myInstance;
}

@end
