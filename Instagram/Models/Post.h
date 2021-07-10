//
//  Post.h
//  Instagram
//
//  Created by Sabrina P Meng on 7/9/21.
//

#import "Parse/Parse.h"

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSMutableArray *usersWhoLiked;
@property (nonatomic, strong) NSDate *timeCreatedAt;

- (void)initPostWithObject:(PFObject *)object;
+ (NSMutableArray *)createPostArray:(NSArray *)objects;
    
@end
