//
//  LoginViewController.m
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h" 

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(sessionStateChanged:)
//     name:FBSessionStateChangedNotification
//     object:nil];
    if (FBSession.activeSession.isOpen) {
        // valid account UI is shown whenever the session is open
//        [self.loginFailed setTitle:@"Log out" forState:UIControlStateNormal];

    } else {
        // login-needed account UI is shown whenever the session is closed
//        [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
//        [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }

    
    
}
- (void)didAuthenticate{

       [self performSegueWithIdentifier: @"SegueToRecord" sender: self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performLogin:(id)sender {
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }

    }




- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
}

@end
