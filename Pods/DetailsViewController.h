//
//  DetailsViewController.h
//  Instagram
//
//  Created by Sabrina P Meng on 7/7/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) PFObject *post;

@end

NS_ASSUME_NONNULL_END
