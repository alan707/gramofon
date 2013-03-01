//
//  LoginViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController : UIViewController
- (void)openSession;
extern NSString *const FBSessionStateChangedNotification;
- (void) closeSession;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;


@property (weak, nonatomic) IBOutlet UIButton *buttonText;
- (void)loginFailed;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (IBAction)performLogin:(id)sender;

//@property (strong, nonatomic) FBSession *session;

@end
