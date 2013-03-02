//
//  AppDelegate.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
//- (void)openSession;
//extern NSString *const FBSessionStateChangedNotification;
//- (void) closeSession;
//- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
//
//@property (strong, nonatomic) UINavigationController* navController;
//@property (strong, nonatomic) UIViewController* mainViewController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBar *tabBar;
//@property (strong, nonatomic) UIStoryboard* goStoryboard;

// FBSample logic
// In this sample the app delegate maintains a property for the current
// active session, and the view controllers reference the session via
// this property, as well as play a role in keeping the session object
// up to date; a more complicated application may choose to introduce
// a simple singleton that owns the active FBSession object as well
// as access to the object by the rest of the application
@property (strong, nonatomic) FBSession *session;

@end
