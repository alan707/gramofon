//
//  ProfileViewController.m
//  gramofon-v1
//
//  Created by Dan Trenz on 3/3/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "Utilities.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    NSString *httpSource = [NSString stringWithFormat:@"http://gramofon.co/%@", [User sharedInstance].username];
    NSURL *fullUrl = [NSURL URLWithString:httpSource];
    NSURLRequest *httpRequest = [NSURLRequest requestWithURL:fullUrl];
    [_profileWebView loadRequest:httpRequest];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *httpSource = [NSString stringWithFormat:@"http://gramofon.co/%@", [User sharedInstance].username];
    NSURL *fullUrl = [NSURL URLWithString:httpSource];
    NSURLRequest *httpRequest = [NSURLRequest requestWithURL:fullUrl];
    [_profileWebView loadRequest:httpRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
