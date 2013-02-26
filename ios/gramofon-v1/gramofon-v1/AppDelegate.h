//
//  AppDelegate.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
- (void)openSession;

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) RecordViewController* mainViewController;

@property (strong, nonatomic) UIWindow *window;

@end
