//
//  HomeViewController.m
//  ubercam
//
//  Created by Daniel Sheng Xu on 2/22/2014.
//  Copyright (c) 2014 danielxu. All rights reserved.
//

#import "HomeViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface HomeViewController ()
@property (nonatomic, strong) NSMutableArray *followingArray;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"Coupon";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
        self.loading = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_logo"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewDataSource and Delegates
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"type" equalTo:@"follow"];
    [query includeKey:@"toUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            self.followingArray = [NSMutableArray array];
            if (objects.count >0) {
                for (PFObject *activity in objects) {
                    PFUser *user = activity[@"toUser"];
                    [self.followingArray addObject:user.objectId];
                }
            }
            [self.tableView reloadData];
        }
    }];
    
}

//// return objects in a different indexpath order. in this case we return object based on the section, not row, the default is row
//
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.row];
    }
    else {
        return nil;
    }
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == self.objects.count) {
//        return nil;
//    }
//    static NSString *CellIdentifier = @"SectionHeaderCell";
//    UITableViewCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    PFImageView *profileImageView = (PFImageView *)[sectionHeaderView viewWithTag:1];
//    profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
//    profileImageView.layer.masksToBounds = YES;
//    
//    UILabel *userNameLabel = (UILabel *)[sectionHeaderView viewWithTag:2];
//    UILabel *titleLabel = (UILabel *)[sectionHeaderView viewWithTag:3];
//    
//    PFObject *photo = [self.objects objectAtIndex:section];
//    PFUser *user = [photo objectForKey:@"whoTook"];
//    PFFile *profilePicture = [user objectForKey:@"profilePicture"];
//    NSString *title = photo[@"title"];
//    
//    userNameLabel.text = user.username;
//    titleLabel.text = title;
//    
//    profileImageView.file = profilePicture;
//    [profileImageView loadInBackground];
//    
//    //follow button
//    FollowButton *followButton = (FollowButton *)[sectionHeaderView viewWithTag:4];
//    followButton.delegate = self;
//    followButton.sectionIndex = section;
//    
//    if (!self.followingArray || [user.objectId isEqualToString:[PFUser currentUser].objectId]) {
//        followButton.hidden = YES;
//    }
//    else {
//        followButton.hidden = NO;
//        NSInteger indexOfMatchedObject = [self.followingArray indexOfObject:user.objectId];
//        if (indexOfMatchedObject == NSNotFound) {
//            followButton.selected = NO;
//        }
//        else {
//            followButton.selected = YES;
//        }
//    }
//    
//    return sectionHeaderView;
//}

//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSInteger sections = self.objects.count;
//    if (self.paginationEnabled && sections >0) {
//        sections++;
//    }
//    return sections;
//}
//


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        NSInteger rows = self.objects.count;
        if (self.paginationEnabled && rows >0) {
            rows++;
        }
        return rows;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
//    if (indexPath.section == self.objects.count) {
//        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
//        return cell;
//    }
////    static NSString *CellIdentifier = @"PhotoCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////    PFImageView *photo = (PFImageView *)[cell viewWithTag:1];
////    photo.file = object[@"image"];
//    [photo loadInBackground];
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    int index = (int) indexPath.row;
    NSLog(@"Index: %d ",index);
    NSLog(@"%@",indexPath);
    static NSString *cellIdentifier = @"CouponCell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }

    if (index == self.objects.count) {
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    }
   

        PFImageView *profileImageView = (PFImageView *)[cell viewWithTag:1];
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
        profileImageView.layer.masksToBounds = YES;
    
        UILabel *userNameLabel = (UILabel *)[cell viewWithTag:2];
        UILabel *textLabel = (UILabel *)[cell viewWithTag:4];
    
        PFObject *coupon = object;
    
        PFUser *user = [coupon objectForKey:@"owner"];
        PFFile *profilePicture = [user objectForKey:@"profilePicture"];
        profileImageView.file = profilePicture;
        [profileImageView loadInBackground];
    
        userNameLabel.text = user.username;
        textLabel.text = coupon[@"text"];
    
        //follow button
        FollowButton *followButton = (FollowButton *)[cell viewWithTag:5];
        followButton.delegate = self;
        followButton.sectionIndex = indexPath.row;
    
        if (!self.followingArray || [user.objectId isEqualToString:[PFUser currentUser].objectId]) {
            followButton.hidden = YES;
        }
        else {
            followButton.hidden = NO;
            NSInteger indexOfMatchedObject = [self.followingArray indexOfObject:user.objectId];
            if (indexOfMatchedObject == NSNotFound) {
                followButton.selected = NO;
            }
            else {
                followButton.selected = YES;
            }
        }
//    PFImageView *photo = (PFImageView *)[cell viewWithTag:1];
//    photo.file = object[@"image"];
//    [photo loadInBackground];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.objects.count) {
        return 50.0f;
    }
    return 150.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LoadMoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.objects.count && self.paginationEnabled) {
        [self loadNextPage];
    }
}

- (PFQuery *)queryForTable {
    if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        return nil;
    }
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    
    [query includeKey:@"owner"];
    
    [query orderByDescending:@"createdAt"];
    return query;
}

- (void)followButton:(FollowButton *)button didTapWithSectionIndex:(NSInteger)index {
    PFObject *coupon = [self.objects objectAtIndex:index];
    PFUser *user = coupon[@"owner"];
    
    if (!button.selected) {
        [self followUser:user];
    }
    else {
        [self unfollowUser:user];
    }
    [self.tableView reloadData];
}

- (void)followUser:(PFUser *)user {
    if (![user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        [self.followingArray addObject:user.objectId];
        PFObject *followActivity = [PFObject objectWithClassName:@"Activity"];
        followActivity[@"fromUser"] = [PFUser currentUser];
        followActivity[@"toUser"] = user;
        followActivity[@"type"] = @"follow";
        [followActivity saveEventually];
    }
}

- (void)unfollowUser:(PFUser *)user {
    [self.followingArray removeObject:user.objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"toUser" equalTo:user];
    [query whereKey:@"type" equalTo:@"follow"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        if (!error) {
            for (PFObject *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    
    }];
}

























@end
