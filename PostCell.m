//
//  PostCell.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/6/21.
//

#import "PostCell.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Make transparent button sensitive to double tap to like image
    [self.doubleTapButton addTarget:self action:@selector(multipleTap:withEvent:)
                 forControlEvents:UIControlEventTouchDownRepeat];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)multipleTap:(id)sender withEvent:(UIEvent*)event {
   UITouch* touch = [[event allTouches] anyObject];
    // Double tap to like image
   if (touch.tapCount == 2) {
       // construct query
       PFQuery *query = [PFQuery queryWithClassName:@"Instagram_Posts"];
       [query whereKey:@"objectId" equalTo:self.post.objectId];
       // fetch data asynchronously
       [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
           if (posts != nil) {
               PFObject *queriedPost = posts[0];
               NSMutableArray *usersWhoLiked = queriedPost[@"users_who_liked"];
               
               if ([usersWhoLiked containsObject:[PFUser currentUser].username]) {
                   // User has liked photo, tapping should unlike it
                   // Updating likes
                   NSNumber *numLikes = queriedPost[@"likes"];
                   NSNumber *newLikes = [NSNumber numberWithInt:([numLikes intValue] - 1)];
                   queriedPost[@"likes"] = newLikes;
                   
                   // Updating users who liked
                   [usersWhoLiked removeObject:[PFUser currentUser].username];
                   queriedPost[@"users_who_liked"] = usersWhoLiked;
                   
                   // Updating button
                   [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
               } else {
                   // User has no liked photo, tapping should like it
                   // Updating likes
                   NSNumber *numLikes = queriedPost[@"likes"];
                   NSNumber *newLikes = [NSNumber numberWithInt:([numLikes intValue] + 1)];
                   queriedPost[@"likes"] = newLikes;
                   
                   // Updating users who liked
                   [usersWhoLiked addObject:[PFUser currentUser].username];
                   queriedPost[@"users_who_liked"] = usersWhoLiked;
                   
                   // Updating button
                   [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
               }
               // Saving changes to post
               [queriedPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                   if (succeeded) {
                       self.post = queriedPost;
                       [self reloadData];
                   } else {
                       NSLog(@"Problem liking image: %@", error.localizedDescription);
                   }
               }];
               
           } else {
               NSLog(@"%@", error.localizedDescription);
           }
       }];
   }
}


- (IBAction)didTapLike:(id)sender {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Instagram_Posts"];
    [query whereKey:@"objectId" equalTo:self.post.objectId];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            PFObject *queriedPost = posts[0];
            NSMutableArray *usersWhoLiked = queriedPost[@"users_who_liked"];
            
            if ([usersWhoLiked containsObject:[PFUser currentUser].username]) {
                // User has liked photo, tapping should unlike it
                // Updating likes
                NSNumber *numLikes = queriedPost[@"likes"];
                NSNumber *newLikes = [NSNumber numberWithInt:([numLikes intValue] - 1)];
                queriedPost[@"likes"] = newLikes;
                
                // Updating users who liked
                [usersWhoLiked removeObject:[PFUser currentUser].username];
                queriedPost[@"users_who_liked"] = usersWhoLiked;
                
                // Updating button
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
            } else {
                // User has no liked photo, tapping should like it
                // Updating likes
                NSNumber *numLikes = queriedPost[@"likes"];
                NSNumber *newLikes = [NSNumber numberWithInt:([numLikes intValue] + 1)];
                queriedPost[@"likes"] = newLikes;
                
                // Updating users who liked
                [usersWhoLiked addObject:[PFUser currentUser].username];
                queriedPost[@"users_who_liked"] = usersWhoLiked;
                
                // Updating button
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
            }
            // Saving changes to post
            [queriedPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    self.post = queriedPost;
                    [self reloadData];
                } else {
                    NSLog(@"Problem liking image: %@", error.localizedDescription);
                }
            }];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void)reloadData {
    // Displaying likes
    if ([self.post[@"likes"] intValue] == 1) {
        self.likesLabel.text = [NSString stringWithFormat:@"%@ like", self.post[@"likes"]];
    } else {
        self.likesLabel.text = [NSString stringWithFormat:@"%@ likes", self.post[@"likes"]];
    }
}


- (void)setCell:(PFObject *)post {
    // Setting post caption
    // Set caption
    PFUser *user = post[@"user"];
    NSString *editedCaption = [NSString stringWithFormat:@"  %@", post[@"text"]];
    NSAttributedString *caption = [[NSAttributedString alloc] initWithString:editedCaption];
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                    forKey:NSFontAttributeName];
    NSMutableAttributedString *username = [[NSMutableAttributedString alloc] initWithString:user.username attributes:attrsDictionary];
    [username appendAttributedString:caption];
    self.postCaptionLabel.attributedText = username;
    
    // Displaying post image
    self.postImageView.image = nil;
    PFFileObject *image = post[@"image"];
    [self.postImageView setImageWithURL:[NSURL URLWithString:image.url]];
    
    // Displaying likes
    if ([post[@"likes"] intValue] == 1) {
        self.likesLabel.text = [NSString stringWithFormat:@"%@ like", post[@"likes"]];
    } else {
        self.likesLabel.text = [NSString stringWithFormat:@"%@ likes", post[@"likes"]];
    }
    
    // Setting post
    self.post = post;
    
    // Setting button color
    NSMutableArray *usersWhoLiked = post[@"users_who_liked"];
    if ([usersWhoLiked containsObject:[PFUser currentUser].username]) {
        // User has liked, button is red
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    } else {
        // User has not liked, button is gray
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
    }
    
    // Set date label
    self.timeLabel.text = [post createdAt].shortTimeAgoSinceNow;
}


@end
