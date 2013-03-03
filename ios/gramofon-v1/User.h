//
//  User.h
//  gramofon-v1
//
//  Created by dtrenz on 3/1/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)sharedInstance;

- (void)authenticateGramofonUser;

@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *facebook_id;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *email;

@end
