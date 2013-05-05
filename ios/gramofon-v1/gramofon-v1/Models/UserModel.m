//
//  UserModel.m
//  gramofon
//
//  Created by Dan Trenz on 4/3/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "UserModel.h"
#import "HTTPRequest.h"
#import "User.h"

@implementation UserModel

+ (BOOL)authenticateUser:(NSInteger)facebookId
{
    BOOL success = FALSE;
    
    return success;
}

+ (User *)getUser:(NSInteger)userId
{
    User *user;
    
    return user;
}

+ (BOOL)createUser:(User *)user
{
    BOOL success = FALSE;
    
    return success;
}

+ (BOOL)followUser:(NSNumber *)followedId
{
    BOOL success = FALSE;
    
    NSString *url = @"http://api.gramofon.co/following";
        
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                               followedId, @"followed_id",
                               [User sharedInstance].user_id, @"follower_id", nil];
    
    // asynchrously add following relationship
    [[HTTPRequest sharedInstance] doAsynchRequest:@"POST"
                                       requestURL:url
                                    requestParams:params
                                  completeHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"%@", responseString);
         
         if ( error ) {
             NSLog(@"Error: %@", [error localizedDescription]);
         }
     }];
    
    return success;
}

@end
