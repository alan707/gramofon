//
//  LoginViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface LoginViewController : UIViewController

extern NSString *const FBSessionStateChangedNotification;


@property (weak, nonatomic) IBOutlet UIButton *buttonText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)openSession;
- (void)closeSession;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)loginFailed;
- (IBAction)performLogin:(id)sender;

@end
