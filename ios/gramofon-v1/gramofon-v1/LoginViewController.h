//
//  LoginViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonText;
- (void)loginFailed;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (IBAction)performLogin:(id)sender;

@end
