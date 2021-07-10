//
//  ProfileViewController.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/9/21.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "ImageCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting data sources and delegates
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self setBasicProfile];
    
    [self loadPosts];
    
    // Specifying collection view layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)  self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    CGFloat imagesPerLine = 3;
    CGFloat itemWidth = ((self.collectionView.frame.size.width-30-layout.minimumInteritemSpacing * (imagesPerLine - 1)))/imagesPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}


-(void)viewDidAppear:(BOOL)animated {
    // Reload movies every time you visit a page
    [self loadPosts];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Identifying movie
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    
    // Retrieving image and setting image
    cell.postImageView.image = nil;
    [cell.postImageView setImageWithURL:[NSURL URLWithString:post.imageURL]];
    
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


- (void)setBasicProfile {
    // Setting username label
    self.usernameLabel.text = [PFUser currentUser].username;
    
    // Setting navigation bar title
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile", [PFUser currentUser].username];
}


- (void)loadPosts {
    // Construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Instagram_Posts"];
    [query includeKey:@"image"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    
    // Fetch posts asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = [Post createPostArray:posts];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
