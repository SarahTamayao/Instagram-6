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
#import "Post.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSNumber *numPosts;
@property (nonatomic, strong) NSArray *usernames;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    
    // Setting default number of posts
    self.numPosts = [NSNumber numberWithInt:20];
    
    // Setting data source and delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Pull to refresh controller
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Initializing table headers
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PostHeader"];
    
    // Piece of code that stops header view from floating when scrolling -- hides refreshControl though
    /*
    CGFloat dummyViewHeight = 50;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
    [dummyView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = dummyView;
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
     */
    
    // Refresh table view every 10 minutes
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:600
        target:self selector:@selector(reloadTableView:) userInfo:nil repeats:true];
    
    // Loading posts
    [self loadPosts];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (void)reloadTableView:(NSTimer *)timer {
    [self.tableView reloadData];
    NSLog(@"refreshed!");
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
            self.posts = [Post createPostArray:posts];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PostHeader"];
    header.textLabel.text = [NSString stringWithFormat:@"          %@", self.posts[section][@"user"][@"username"]];
    UIImage *image = [UIImage imageNamed:@"user2"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(10,10,40,40);
    [header addSubview:imageView];
    //[header addSubview:imageView];
    //[imageView setTranslatesAutoresizingMaskIntoConstraints:false];
    //[imageView setCenter:CGPointMake(60, 60)];
    return header;
}


-(void)tableView:(UITableView *)tableView
    willDisplayHeaderView:(UIView *)view
      forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithWhite:1.0 alpha:0.9];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Table view dequeueing
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    // Setting post
    PFObject *post = self.posts[indexPath.section];
    
    [cell setCell:post];
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

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
