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

@interface LoginViewController ()
@property (nonatomic, strong) SSHUDView *hud;
@end

@implementation LoginViewController


//NSString *const FBSessionStateChangedNotification =
//@"com.gramofon.gramofon:FBSessionStateChangedNotification";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
    
    [self openSession];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self getUser];
    }
    
}

- (void)getUser
{
    // We have a valid session, go get user profile info
    
    //Run HUD spinner
    self.hud = [[SSHUDView alloc] initWithTitle:@"Going to space ..."];
    //	_hud.hudSize = CGSizeMake(60.0f, 60.0f);
    //	_hud.textLabelHidden = YES;
    //	_hud.hidesVignette = YES;
	[self.hud show];

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
             
             [self didAuthenticate];
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
    [self performSelector:@selector(complete:) withObject:nil afterDelay:0];
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
    
}

# pragma mark - Actions

- (void)complete:(id)sender {
//	[self.hud completeWithTitle:@"Finished"];
	[self performSelector:@selector(pop:) withObject:nil afterDelay:0];
}


- (void)pop:(id)sender {
	[self.hud dismiss];
	[self.navigationController popViewControllerAnimated:YES];
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