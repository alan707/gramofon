//
//  FeedModel.h
//  gramofon
//
//  Created by Dan Trenz on 4/3/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioClip.h"

@interface FeedModel : NSObject

- (NSMutableArray *)getGlobalFeed;
- (NSMutableArray *)getUserFeed:(NSInteger)userId;
- (NSMutableArray *)getFollowingFeed:(NSInteger)userId;

@end
