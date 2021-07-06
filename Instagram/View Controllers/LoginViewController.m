//
//  LoginViewController.m
//  Instagram
//
//  Created by Sabrina P Meng on 7/6/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Attach tap gesture recognizer to dismiss keyboard
    // [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}


- (IBAction)didTapSignUp:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill out all fields to continue." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else{
        [self registerUser];
        self.usernameField.text = @"";
        self.passwordField.text = @"";
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome!"
                                                                       message:@"Sign up complete."
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
         
        }];*/
    }
}


- (void)registerUser {
    // Initialize a user object
    PFUser *newUser = [PFUser user];
    
    // Set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    // Call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            // Display alert of registration failed
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
            // NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");

            // Manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}


- (void)loginUser {
    // Retrieving user-entered credentials
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // Attempt login
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            // Present alert if error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"User log in failed: %@", error.localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {
            // Performs segue to main Instagram app
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
