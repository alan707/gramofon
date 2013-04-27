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
 
    // Check if user is cached and linked to Facebook, if so, bypass login
    
    //init FB data request
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
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
//            if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//                [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
//            }
//            if ([PFUser currentUser] && [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
//                [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
//            }

        }
    }];
       

}
    
    


-(void)viewDidDisappear:(BOOL)animated
{
    self.hud = nil;
}

#pragma mark - Login mehtods


/* Login to facebook method */
- (IBAction)performFBLogin:(id)sender{
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_spinner stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                // Notification Alert is missing here asking user to Authorize Gramofon under Settings/Facebook -> Gramofon
                // switch to "on"
                 NSLog(@"Notification Alert is missing here asking user to Authorize Gramofon under Settings/Facebook -> Gramofon");
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
    [_spinner startAnimating]; // Show loading indicator until login is finished
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end