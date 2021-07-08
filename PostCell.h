//
//  PostCell.h
//  Instagram
//
//  Created by Sabrina P Meng on 7/6/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) PFObject *post;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *doubleTapButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


- (void)setCell:(PFObject *)post;

@end

NS_ASSUME_NONNULL_END
