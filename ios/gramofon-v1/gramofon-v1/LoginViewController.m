//
//  LoginViewController.m
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "AudioClip.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LoginViewController


/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch ( state ) {
        case FBSessionStateOpen:
            if ( !error ) {
                [self getUser];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if ( error ) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //initiate the Spinning HUD
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"We are going to space";
    
    //give it a quick 0.5 sec so users can see something is loading
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    
    // dispatch to main queue and run the FB authentication code
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self openSession];
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [self getUser];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //Segue to Record Screen
        [self didAuthenticate];
    });
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.hud = nil;
}

- (void)getUser
{
    // We have a valid session, go get user profile info
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if ( !error ) {
             [User sharedInstance].username    = user.username;
             [User sharedInstance].facebook_id = user.id;
             [User sharedInstance].firstname   = user.first_name;
             [User sharedInstance].lastname    = user.last_name;
             [User sharedInstance].email       = [user objectForKey:@"email"];
             
             // get their Gramofon user id, or create a new user account for this user.
             [[User sharedInstance] authenticateGramofonUser];
         }
     }];
}

- (void)didAuthenticate
{
//    NSLog(@"User.user_id: %@", [User sharedInstance].user_id);
//    NSLog(@"User.username: %@", [User sharedInstance].username);
//    NSLog(@"User.facebook_id: %@", [User sharedInstance].facebook_id);
//    NSLog(@"User.firstname: %@", [User sharedInstance].firstname);
//    NSLog(@"User.lastname: %@", [User sharedInstance].lastname);
//    NSLog(@"User.email: %@", [User sharedInstance].email);
    [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openSession
{
    //    NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
         if ( error ) {
             NSLog(@"%@", error);
         }
     }];
    
    //     [self.mainViewController pushViewController:RecordViewController animated:true];
    
    
}

- (void)showLoginView
{
    [self didAuthenticate];
    
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    //    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
    //        LoginViewController* loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController"
    //                                                      bundle:nil];
    //        [topViewController presentModalViewController:loginViewController animated:NO];
    //    } else {
    //        LoginViewController* loginViewController =
    //        (LoginViewController*)modalViewController;
    //        [loginViewController loginFailed];
    //    }
}

- (IBAction)performLogin:(id)sender
{
    
    //    AppDelegate *appDelegate =
    //    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [self closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [self openSessionWithAllowLoginUI:YES];
    }
    
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
}

@end