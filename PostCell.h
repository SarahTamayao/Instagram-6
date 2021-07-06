//
//  PostCell.h
//  Instagram
//
//  Created by Sabrina P Meng on 7/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;

@end

NS_ASSUME_NONNULL_END
