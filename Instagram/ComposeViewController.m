//
//  ComposeViewController.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/6/21.
//

#import "ComposeViewController.h"
#import "HomeViewController.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIImage *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)didTapImage:(id)sender {
    NSLog(@"tapped!");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize imageSize = CGSizeMake(300, 300);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:imageSize];

    // Do something with the images (based on your use case)
    self.postImage = resizedImage;
    self.postImageView.image = resizedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapShare:(id)sender {
    PFObject *post = [PFObject objectWithClassName:@"Instagram_Posts"];
    post[@"text"] = self.postTextView.text;
    post[@"user"] = PFUser.currentUser;
    NSData *imageData = UIImagePNGRepresentation(self.postImage);
    post[@"image"] = [PFFileObject fileObjectWithName:@"image.png" data:imageData contentType:@"image/png"];
    post[@"likes"] = [NSNumber numberWithInt:0];
    post[@"users_who_liked"] = [NSMutableArray array];
    
    // Progress HUD while post is saved
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Saving new post
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.delegate didPost];
            } else {
                NSLog(@"Problem posting image: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error posting image." preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{}];
            }
            
            // Adding a slight delay so progress HUD doesn't just flash
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        }];
    });
}


- (void)stopAnimation {
    // Stopping progress HUD
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
