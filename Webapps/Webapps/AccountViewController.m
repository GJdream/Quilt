//
//  AccountViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.username.text =
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveChangesClicked:(id)sender
{
    //self.saveChanges.enabled = NO;
    //self.uploadPicture.enabled = NO;
    // [Account changeUser:username.text ProfilePicture:profilePicture.image Password:password.text ConfirmPassword:confirmPassword.text];
}

- (IBAction)uploadPictureClicked:(id)sender
{
    //UIImagePickerController
    // ...
    //self.profilePicture.image
}

@end
