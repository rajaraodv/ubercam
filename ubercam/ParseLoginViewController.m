//
//  ParseLoginViewController.m
//  ubercam
//
//  Created by Daniel Sheng Xu on 2/23/2014.
//  Copyright (c) 2014 danielxu. All rights reserved.
//

#import "ParseLoginViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"


@interface ParseLoginViewController ()

@end

@implementation ParseLoginViewController

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
//    self.logInView.backgroundColor = BLUE_COLOR;
//    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
//    [self.logInView.facebookButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    
    if([FBSDKAccessToken currentAccessToken] == nil ) {
        NSLog(@"Not Logged In");
        
    } else {
        // log the user directly in
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.window setRootViewController:appDelegate.tabBarController];
        
    }
}
- (IBAction)loginWitFacebook:(id)sender {
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logInWithReadPermissions:@[@"email", @"public_profile", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error) {
//             NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (result.isCancelled) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else {
//             NSLog(@"User logged in through Facebook!");
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if ([result.grantedPermissions containsObject:@"email"]
//                && [result.grantedPermissions containsObject:@"public_profile"]
//                && [result.grantedPermissions containsObject:@"user_friends"]) {
//                // Do work
//                 NSLog(@"User approved all perms");
//            } else {
//                //show alert
//                NSLog(@"User didnt approved all perms");
//
//            }
//        }
//    }];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"email", @"public_profile", @"user_friends"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             PFUser *user = [PFUser currentUser];
                             if (user) {
                                 // update current user with facebook name and id
                                 NSString *facebookName = result[@"name"];
                                 user.username = facebookName;
                                 NSString *facebookId = result[@"id"];
                                 user[@"facebookId"]=facebookId;
                                 
                                 // download user profile picture from facebook
                                 NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",facebookId]];
                                 NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL];
                                 [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
                             }
                         } else {
                             NSLog(@"Error: %@", error);
                         }
                     }];
                }
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window setRootViewController:appDelegate.tabBarController];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    self.logInView.facebookButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
//    
//    CGRect frame = self.logInView.logo.frame;
//    frame.origin.y = 150;
//    self.logInView.logo.frame = frame;
//    frame = self.logInView.facebookButton.frame;
//    frame.origin.y = 300;
//    self.logInView.facebookButton.frame = frame;
//}

//- (void)logInViewController:(PFLogInViewController *)controller
//               didLogInUser:(PFUser *)user {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(PFUI_NULLABLE NSError *)error {
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//    
//}

//
//
//- (void)facebookRequestDidLoad:(id)result {
//    PFUser *user = [PFUser currentUser];
//    if (user) {
//        // update current user with facebook name and id
//        NSString *facebookName = result[@"name"];
//        user.username = facebookName;
//        NSString *facebookId = result[@"id"];
//        user[@"facebookId"]=facebookId;
//        
//        // download user profile picture from facebook
//        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",facebookId]];
//        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL];
//        [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
//    }
//}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self showErrorAndLogout];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _profilePictureData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.profilePictureData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.profilePictureData.length == 0 || !self.profilePictureData) {
        [self showErrorAndLogout];
    }
    else {
        PFFile *profilePictureFile = [PFFile fileWithData:self.profilePictureData];
        [profilePictureFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!succeeded) {
                [self showErrorAndLogout];
            }
            else {
                PFUser *user = [PFUser currentUser];
                user[@"profilePicture"] = profilePictureFile;
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!succeeded) {
                        [self showErrorAndLogout];
                    }
                    else {
                        //[self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }
}


- (void)showErrorAndLogout {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login failed" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [PFUser logOut];
}

































@end
