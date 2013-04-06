//
//  AudioClipModel.m
//  gramofon
//
//  Created by Dan Trenz on 4/6/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "AudioClipModel.h"
#import "HTTPRequest.h"

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

@end
