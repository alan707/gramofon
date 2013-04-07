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
    [[HTTPRequest sharedInstance] getRequest:url complete:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( ! error ) {
            if ( completeCallback != nil ) {
                completeCallback(data);
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}

+ (void)uploadAudioClip;
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                               [AudioClip sharedInstance].title, @"clip[title]",
                               [AudioClip sharedInstance].longitude, @"clip[longitude]",
                               [AudioClip sharedInstance].latitude, @"clip[latitude]",
                               [AudioClip sharedInstance].venue, @"clip[venue]",
                               [User sharedInstance].user_id, @"clip[user_id]", nil];
    
    [[HTTPRequest sharedInstance] uploadFile:@"http://api.gramofon.co/clips"
                                    fileName:[AudioClip sharedInstance].fileName
                                    fileData:[AudioClip sharedInstance].fileData
                                  postParams:params];
}

@end
