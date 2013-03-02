//
//  FeedViewController.h
//  gramofon-v1
//
//  Created by Alan Mond on 2/25/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *feedWebView;
@property (nonatomic, strong) UITabBarController *tabBarController;
//@property (strong, nonatomic) UIWindow *window;
//
//@property (nonatomic, strong) IBOutlet FBProfilePictureView *userProfileImage;
//@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;

@end
