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
    // GET user by self.facebook_id after logging in through facebook login button.

    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://gramofon.herokuapp.com/users/facebook/%@.json", self.facebook_id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    // check for an error. If there is a network error, you should handle it here.
    if(!requestError)
    {
        //Take the JSON data from the API and store it in a data dictionary
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
        // then store the user's id in self.user_id
        self.user_id = [dictionary valueForKey:@"id"];
    }
//  For troubleshooting purposes left code below:
//  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//  NSLog(@"Response from server = %@", responseString);
//  NSLog(@"user_id = %@", self.user_id);
//  NSLog(@"User's Facebook ID: %@", self.facebook_id);

}

- (void)createUser
{
    
    NSURL *aUrl = [NSURL URLWithString:@"http://gramofon.herokuapp.com/users.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
//    
//    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
//                                                                 delegate:self];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                         email, [NSString stringWithFormat: @"%@",self.email],
                         facebook_id, [NSString stringWithFormat: @"%@",self.facebook_id],
                         firstname, [NSString stringWithFormat: @"%@",self.firstname],
                         lastname, [NSString stringWithFormat: @"%@",self.lastname],
                         // facebook username is currently not in the iOS app. 
//                       facebook_username, [NSString stringWithFormat: @"%@",self.username],
//                       photo_url, [NSString stringWithFormat: @"%@", self.] --> add when we have a picture
                          
                          nil];
    
    [request setHTTPMethod:@"POST"];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
//    NSString *postString = @"firstname=&quality=AWESOME!";
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
  
    

    
    // POST user data (self.username, self.facebook_id, etc)
    // to API to create a new user
}

@end
