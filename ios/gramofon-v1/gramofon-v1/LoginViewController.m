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
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LoginViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //initiate the Spinning HUD
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"We are going to space";
 
    // Check if user is cached and linked to Facebook, if so, bypass login
    
    //init FB data request
   //give it a quick 0.01 sec so users can see something is loading
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        FBRequest *request = [FBRequest requestForMe];
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // handle successful response
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                NSString *facebookUsername = userData[@"username"];
                NSString *email = userData[@"email"];
                NSString *facebookID = userData[@"id"];
                NSString *firstname = userData[@"first_name"];
                NSString *lastname = userData[@"last_name"];
                
                
                [User sharedInstance].username    = facebookUsername;
                [User sharedInstance].facebook_id = facebookID;
                [User sharedInstance].firstname   = firstname;
                [User sharedInstance].lastname    = lastname;
                [User sharedInstance].email       = email;
                
                // get their Gramofon user id, or create a new user account for this user.
                [[User sharedInstance] authenticateGramofonUser];
                if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
                    [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
                }
                
            } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Authorize Gramofon"
                                                                message:@"You must authorize Gramofon to use your Facebook account.  Please click the Facebook login button again and follow Facebook's instructions."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
               [self logoutButtonTouchHandler:nil];
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];

            [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

}
    
    


-(void)viewDidDisappear:(BOOL)animated
{
    self.hud = nil;
}

#pragma mark - Login mehtods


/* Login to facebook method */
- (IBAction)performFBLogin:(id)sender{
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"publish_actions"];
  
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_spinner stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                // Notification Alert is missing here asking user to Authorize Gramofon under Settings/Facebook -> Gramofon
                // switch to "on"
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Authorize Gramofon"
                                                                message:@"You must authorize Gramofon to use your Facebook account.  Please click the Facebook login button again and follow Facebook's instructions."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
            
        } else {
            NSLog(@"User with facebook logged in!");
            [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
        }
    }];
    
}

- (IBAction)performTwitterLogin:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    if (![PFTwitterUtils isLinkedWithUser:user]) {
        [PFTwitterUtils linkUser:user block:^(BOOL succeeded, NSError *error) {
            if ([PFTwitterUtils isLinkedWithUser:user]) {
                NSLog(@"Woohoo, user logged in with Twitter!");
            }
        }];
    }
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
        } else {
            NSLog(@"User logged in with Twitter!");
            [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
        }     
    }];
}
- (void)logoutButtonTouchHandler:(id)sender  {
    [PFUser logOut]; // Log out
    
    // Return to login page
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end