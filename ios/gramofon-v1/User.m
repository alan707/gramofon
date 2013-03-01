//
//  User.m
//  gramofon-v1
//
//  Created by dtrenz on 3/1/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize user_id, username, facebook_id, firstname, lastname, email;

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

- (void)authenticateGramofonUser
{
    NSLog(@"Yeah!");
    // go get the user from the API
    [self fetchUser];
    
    // if we did not find a user id to store...
    if ( self.user_id == nil ) {
        // create a new user
        [self createUser];
    }
}

- (void)fetchUser
{
    // GET user by self.facebook_id,
    // then store the user's id in self.user_id
}

- (void)createUser
{
    // POST user data (self.username, self.facebook_id, etc)
    // to API to create a new user
}

@end
