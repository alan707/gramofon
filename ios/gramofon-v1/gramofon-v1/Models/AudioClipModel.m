//
//  AudioClipModel.m
//  gramofon
//
//  Created by Dan Trenz on 4/6/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "AudioClipModel.h"
#import "HTTPRequest.h"
#import "AudioClip.h"
#import "User.h"

@implementation AudioClipModel

+ (void)getAudioClips:(int)offset itemCount:(int)limit complete:(void (^)(NSData *))completeCallback
{
    NSString *url = [NSString stringWithFormat:@"http://api.gramofon.co/clips?offset=%i&limit=%i", offset, limit];
    
    // asynchrous loading of clips w/ complete callback handler
    [[HTTPRequest sharedInstance] doAsynchRequest:@"GET"
                                       requestURL:url
                                    requestParams:nil
                                  completeHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                                  {
                                      if ( ! error ) {
                                          if ( completeCallback != nil ) {
                                              completeCallback(data);
                                          }
                                      } else {
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                      }
                                  }];
}

+ (void)getAudioClipsByUser:(NSNumber *)user_id itemOffset:(int)offset itemCount:(int)limit complete:(void (^)(NSData *))completeCallback
{
    NSString *url = [NSString stringWithFormat:@"http://api.gramofon.co/users/%@/clips?offset=%i&limit=%i", user_id, offset, limit];
    
    // asynchrous loading of clips w/ complete callback handler
    [[HTTPRequest sharedInstance] doAsynchRequest:@"GET"
                                       requestURL:url
                                    requestParams:nil
                                  completeHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                                  {
                                      if ( ! error ) {
                                          if ( completeCallback != nil ) {
                                              completeCallback( data );
                                          }
                                      } else {
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                      }
                                  }];
}

+ (void)uploadAudioClip;
{
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                               [AudioClip sharedInstance].title, @"clip[title]",
//                               [AudioClip sharedInstance].longitude, @"clip[longitude]",
//                               [AudioClip sharedInstance].latitude, @"clip[latitude]",
//                               [AudioClip sharedInstance].venue, @"clip[venue]",
//                               [User sharedInstance].user_id, @"clip[user_id]", nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // required params
    params[@"clip[user_id]"] = [User sharedInstance].user_id;
    params[@"clip[title]"]   = [AudioClip sharedInstance].title;
    
    // optional location params
    if ( [AudioClip sharedInstance].longitude && [AudioClip sharedInstance].latitude ) {
        params[@"clip[longitude]"] = [AudioClip sharedInstance].longitude;
        params[@"clip[latitude]"]  = [AudioClip sharedInstance].latitude;
    }
    
    // optional venue params
    if ( [AudioClip sharedInstance].venue ) {
        params[@"clip[venue]"]  = [AudioClip sharedInstance].venue;        
    }
    NSLog(@"%@", params);
    NSDictionary *params2 = [NSDictionary dictionaryWithDictionary:params];
    
    [[HTTPRequest sharedInstance] uploadFile:@"http://api.gramofon.co/clips"
                                    fileName:[AudioClip sharedInstance].fileName
                                    fileData:[AudioClip sharedInstance].fileData
                                  postParams:params2];
}

+ (void)deleteAudioClip:(NSNumber *)clip_id complete:(void (^)(void))completeCallback
{
    NSString *url = [NSString stringWithFormat:@"http://api.gramofon.co/clips/%@", clip_id];
    
    // asynchrous loading of clips w/ complete callback handler
    [[HTTPRequest sharedInstance] doAsynchRequest:@"DELETE"
                                       requestURL:url
                                    requestParams:nil
                                  completeHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                                  {
                                      if ( ! error ) {
                                          if ( completeCallback != nil ) {
                                              completeCallback();
                                          }
                                      } else {
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                      }
                                  }];
}

@end
