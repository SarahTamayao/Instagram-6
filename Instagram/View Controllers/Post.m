//
//  Post.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/9/21.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@implementation Post

@dynamic user;
@dynamic text;
@dynamic likes;
@dynamic imageURL;
@dynamic usersWhoLiked;
@dynamic objectID;
@dynamic timeCreatedAt;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

- (void)initPostWithObject:(PFObject *)object {
    // Setting Post object given PFObject
    self.user = object[@"user"];
    self.text = object[@"text"];
    self.likes = object[@"likes"];
    PFFileObject *image = object[@"image"];
    self.imageURL = image.url;
    self.usersWhoLiked = object[@"users_who_liked"];
    self.objectID = object.objectId;
    self.timeCreatedAt = object.createdAt;
}

+ (NSMutableArray *)createPostArray:(NSArray *)objects {
    // Returns array of Post objects given array of PFObjects
    NSMutableArray *newPosts = [[NSMutableArray alloc] init];
    for (PFObject *post in objects) {
        Post *newPost = [Post new];
        [newPost initPostWithObject:post];
        [newPosts addObject:newPost];
    }
    return newPosts;
}
    
@end
