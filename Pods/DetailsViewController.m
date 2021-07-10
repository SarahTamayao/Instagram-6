//
//  DetailsViewController.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/7/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set image
    [self.postImageView setImageWithURL:[NSURL URLWithString:self.post.imageURL]];
    
    // Get user
    PFUser *user = self.post.user;
    NSLog(@"%@", user.username);
    
    // Set caption
    NSString *editedCaption = [NSString stringWithFormat:@"  %@", self.post.text];
    NSAttributedString *caption = [[NSAttributedString alloc] initWithString:editedCaption];
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                    forKey:NSFontAttributeName];
    NSMutableAttributedString *username = [[NSMutableAttributedString alloc] initWithString:user.username attributes:attrsDictionary];
    [username appendAttributedString:caption];
    self.captionLabel.attributedText = username;
    
    // Set created time
    self.timeLabel.text = self.post.timeCreatedAt.shortTimeAgoSinceNow;
    
    // Set nav bar title
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Post", user.username];
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
