//
//  User.m
//  gramofon-v1
//
//  Created by dtrenz on 3/1/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "User.h"

@implementation User

//@synthesize user_id, username, facebook_id, firstname, lastname, email;

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
    // go get the user from the API
    [self fetchUser];
    
    // if we did not find a user id to store...
    if ( self.user_id == nil ) {
        // create a new user
        [self createUser];
        [self fetchUser];
    }
}

- (void)fetchUser
{
    // GET user by self.facebook_id after logging in through facebook login button.    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.gramofon.co/users/facebook_%@", self.facebook_id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request setHTTPMethod:@"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    // check for an error. If there is a network error, you should handle it here.
    if( !requestError )
    {
        //Take the JSON data from the API and store it in a data dictionary
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
        // then store the user's id in self.user_id
        self.user_id = [dictionary valueForKey:@"id"];
    }

}

- (void)createUser
{
    NSString *post = [NSString stringWithFormat:@"user[username]=%@&user[firstname]=%@&user[lastname]=%@&user[email]=%@&user[facebook_id]=%@", self.username, self.firstname, self.lastname, self.email, self.facebook_id];
    NSURL *aUrl = [NSURL URLWithString:@"http://api.gramofon.co/users"];
 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl];
        
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
}

@end
