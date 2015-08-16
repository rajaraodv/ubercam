//
//  AppDelegate.h
//  ubercam
//
//  Created by Daniel Sheng Xu on 2/10/2014.
//  Copyright (c) 2014 danielxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseLoginViewController.h"
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableData *profilePictureData;
@property(nonatomic,strong)UITabBarController *tabBarController;
@property(nonatomic,strong)UIViewController *loginViewController;

//- (void)presentLoginControllerAnimated:(BOOL)animated;
@end
