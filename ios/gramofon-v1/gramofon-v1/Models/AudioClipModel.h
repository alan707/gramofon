//
//  AudioClipModel.h
//  gramofon
//
//  Created by Dan Trenz on 4/6/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioClipModel : NSObject

+ (void)getAudioClips:(int)offset itemCount:(int)limit complete:(void (^)(NSData *data))completeCallback;

+ (void)getAudioClipsByUser:(NSNumber *)user_id itemOffset:(int)offset itemCount:(int)limit complete:(void (^)(NSArray *clips))completeCallback;

+ (void)uploadAudioClip;

+ (void)deleteAudioClip:(NSNumber *)clip_id complete:(void (^)(void))completeCallback;

@end
