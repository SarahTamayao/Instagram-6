//
//  PostCell.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/6/21.
//

#import "PostCell.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapLike:(id)sender {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Instagram_Posts"];
    [query whereKey:@"objectId" equalTo:self.post.objectId];
    // [query includeKey:@"likes"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            PFObject *queriedPost = posts[0];
            NSMutableArray *usersWhoLiked = queriedPost[@"users_who_liked"];
            
            if ([usersWhoLiked containsObject:[PFUser currentUser].username]) {
                // Updating likes
                NSNumber *numLikes = queriedPost[@"likes"];
                NSNumber *newLikes = [NSNumber numberWithInt:([numLikes intValue] - 1)];
                queriedPost[@"likes"] = newLikes;
                
                // Updating users who liked
                [usersWhoLiked removeObject:[PFUser currentUser].username];
                queriedPost[@"users_who_liked"] = usersWhoLiked;
            } else {
                // Updating likes
                NSNumber *numLikes = queriedPost[@"likes"];
                NSNumber *newLikes = [NSNumber numberWithInt:([numLikes intValue] + 1)];
                queriedPost[@"likes"] = newLikes;
                
                // Updating users who liked
                [usersWhoLiked addObject:[PFUser currentUser].username];
                queriedPost[@"users_who_liked"] = usersWhoLiked;
            }
            
            [queriedPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    [self setCell:queriedPost];
                } else {
                    NSLog(@"Problem liking image: %@", error.localizedDescription);
                }
            }];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void)setCell:(PFObject *)post {
    // Setting post
    self.post = post;
    if(post) {
        
    } else {
        NSLog(@"");
    }
    
    // Setting post attributes
    self.postCaptionLabel.text = post[@"text"];
    
    // Displaying post image
    self.postImageView.image = nil;
    PFFileObject *image = post[@"image"];
    [self.postImageView setImageWithURL:[NSURL URLWithString:image.url]];
    
    // Displaying likes
    self.likesLabel.text = [NSString stringWithFormat:@"%@ likes", post[@"likes"]];
}


@end
