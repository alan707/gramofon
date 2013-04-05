//
//  UserModel.h
//  gramofon
//
//  Created by Dan Trenz on 4/3/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserModel : NSObject

- (BOOL)authenticateUser:(NSInteger)facebookId;
- (User *)getUser:(NSInteger)userId;
- (BOOL)createUser:(User *)user;

@end
