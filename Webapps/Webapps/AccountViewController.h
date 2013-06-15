//
//  AccountViewController.h
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    UIImageView *imageView;
    //UIImagePickerController *picker;
    UIPopoverController *popoverController;
    BOOL newMedia;
}

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (nonatomic, retain) IBOutlet UIButton *takeCameraPhoto;
@property (nonatomic, retain) IBOutlet UIButton *uploadPicture;

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *validPasswordLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveChanges;

@property BOOL validPassword;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UITextField *addFriendUsername;

- (IBAction)takeCameraPhotoClicked:(id)sender;
- (IBAction)uploadPictureClicked:(id)sender;
- (IBAction)saveChangesClicked:(id)sender;

- (IBAction)addFriend:(id)sender;

@end
