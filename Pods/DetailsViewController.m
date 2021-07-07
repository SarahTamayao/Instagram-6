//
//  DetailsViewController.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/7/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set caption
    self.captionLabel.text = self.post[@"text"];
    
    // Set image
    PFFileObject *image = self.post[@"image"];
    [self.postImageView setImageWithURL:[NSURL URLWithString:image.url]];
    
    // Set user
    NSLog(@"%@", self.post);
    //NSLog(@"%@", self.post[@"createdAt"]);
    NSLog(@"%@", self.post[@"user"]);
    PFUser *user = self.post[@"author"];
    self.usernameLabel.text = user.username;
    
    // Set created time
    //self.timeLabel.text = self.post[@"createdAt"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
