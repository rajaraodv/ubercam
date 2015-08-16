//
//  AddCouponViewController.m
//  ubercam
//
//  Created by Raja Rao DV on 8/15/15.
//  Copyright (c) 2015 danielxu. All rights reserved.
//

#import "AddCouponViewController.h"
#import <Parse/Parse.h>

@interface AddCouponViewController ()
- (IBAction)Add:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation AddCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Add:(id)sender {
     PFObject *coupon = [PFObject objectWithClassName:@"Coupon"];
    coupon[@"owner"] = [PFUser currentUser];
    coupon[@"text"] = self.textView.text;
    [coupon saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self showError];
        } else {
            self.textView.text = @"";
            [self.tabBarController setSelectedIndex:0];
        }
    }];
    
    
}

- (void)showError {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not post your coupon, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
