//
//  HomeViewController.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/6/21.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSNumber *numPosts;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting default number of posts
    self.numPosts = [NSNumber numberWithInt:20];
    
    // Setting data source and delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Loading posts
    [self loadPosts];
    
    // Pull to refresh controller
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    /*
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PostCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PostHeader"];
     */
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}



- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    // Showing login screen after logout
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    // Logging out and swtiching to login view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
}

- (void)loadPosts {
    // Construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Instagram_Posts"];
    [query includeKey:@"text"];
    [query includeKey:@"image"];
    [query includeKey:@"user"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"users_who_liked"];
    [query includeKey:@"likes"];
    query.limit = [self.numPosts intValue];
    [query orderByDescending:@"createdAt"];
    
    // Fetch posts asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Table view dequeueing
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    // Setting post
    PFObject *post = self.posts[indexPath.row];
    
    [cell setCell:post];
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.numPosts intValue]){
        NSNumber *newNumPosts = [NSNumber numberWithInt:[self.numPosts intValue]+20];
        self.numPosts = newNumPosts;
        [self loadPosts];
    }
}


- (void)didPost {
    [self loadPosts];
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PostHeader"];
    header.textLabel.text = self.posts[section][@"user"][@"username"];
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"toDetails"]) {
        // Identify tapped cell
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        // Get post corresponding to the cell
        PFObject *post = self.posts[indexPath.row];
        
        // Send information
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    } else if ([segue.identifier  isEqual: @"toCompose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}

@end
