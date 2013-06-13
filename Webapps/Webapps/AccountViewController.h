//
//  AccountViewController.h
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *uploadPicture;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *validPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveChanges;

@property BOOL validPassword;

- (IBAction)uploadPictureClicked:(id)sender;
- (IBAction)saveChangesClicked:(id)sender;

@end
