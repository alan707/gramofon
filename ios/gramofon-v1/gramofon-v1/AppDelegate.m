//
//  AppDelegate.m
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RecordViewController.h"

@implementation AppDelegate
@synthesize session = _session;
@synthesize tabBar;
//@synthesize openedURL = _openedURL;


NSString *const FBSessionStateChangedNotification =
@"com.gramofon.gramofon:FBSessionStateChangedNotification";

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */


/*
 * Opens a Facebook session and optionally shows the login UX.
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [UITabBarItem Record];
//    [tabBar setSelectedItem:UITabBarItem Record];

    return YES;
}

/*
 * Callback for session changes.
// */
//- (void)populateUserDetails
//{
//    if (FBSession.activeSession.isOpen) {
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection,
//           NSDictionary<FBGraphUser> *user,
//           NSError *error) {
//             if (!error) {
//                 self.userNameLabel.text = user.name;
//                 self.userProfileImage.profileID = user.id;
//             }
//         }];
//    }
//}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
