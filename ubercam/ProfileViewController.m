//
//  ProfileViewController.m
//  ubercam
//
//  Created by Daniel Sheng Xu on 2/27/2014.
//  Copyright (c) 2014 danielxu. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ParseUI/ParseUI.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;

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
	// Do any additional setup after loading the view.
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUserStatus];
}

- (void)updateUserStatus {
    PFUser *user = [PFUser currentUser];
    self.profileImageView.file = user[@"profilePicture"];
    [self.profileImageView loadInBackground];
    self.userNameLabel.text = user.username;
    
    PFQuery *followingQuery = [PFQuery queryWithClassName:@"Activity"];
    [followingQuery whereKey:@"fromUser" equalTo:user];
    [followingQuery whereKey:@"type" equalTo:@"follow"];
    [followingQuery findObjectsInBackgroundWithBlock:^(NSArray *followingActivities, NSError *error) {
        if (!error) {
            self.followingNumberLabel.text = [[NSNumber numberWithInteger:followingActivities.count] stringValue];
        }
    }];
    
    PFQuery *followerQuery = [PFQuery queryWithClassName:@"Activity"];
    [followerQuery whereKey:@"toUser" equalTo:user];
    [followerQuery whereKey:@"type" equalTo:@"follow"];
    [followerQuery findObjectsInBackgroundWithBlock:^(NSArray *followerActivities, NSError *error) {
        if (!error) {
            self.followerNumberLabel.text = [[NSNumber numberWithInteger:followerActivities.count] stringValue];
        }
    }];
}

- (PFQuery *)queryForTable {
//    if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        return nil;
//    }
//    PFQuery *followingQuery = [PFQuery queryWithClassName:@"Activity"];
//    [followingQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
//    [followingQuery whereKey:@"type" equalTo:@"follow"];
//    
//    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:@"Photo"];
//    [photosFromFollowedUsersQuery whereKey:@"whoTook" matchesKey:@"toUser" inQuery:followingQuery];
//    
//    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:@"Photo"];
//    [photosFromCurrentUserQuery whereKey:@"whoTook" equalTo:[PFUser currentUser]];
//    
//    PFQuery *superQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromCurrentUserQuery,photosFromFollowedUsersQuery, nil]];
//    [superQuery includeKey:@"whoTook"];
//    [superQuery orderByDescending:@"createdAt"];
//    
//    return superQuery;
    
    
    if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        return nil;
    }
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
     [query includeKey:@"owner"];
     [query orderByDescending:@"createdAt"];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    return query;
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.window setRootViewController:appDelegate.loginViewController];
}
















@end
