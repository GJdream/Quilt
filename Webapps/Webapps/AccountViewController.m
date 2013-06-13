//
//  AccountViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "AccountViewController.h"
#import "Account.h"

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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.password)
    {
        NSLog(@"Editing");
        if([self.confirmPassword.text isEqualToString:self.password.text])
        {
            self.saveChanges.enabled = YES;
            self.validPasswordLabel.text = @"";
            self.password.textColor = [UIColor blackColor];
            self.confirmPassword.textColor = [UIColor blackColor];
        }
        else
        {
            if(![self.confirmPassword.text isEqualToString:@""])
            {
                self.saveChanges.enabled = NO;
                self.validPasswordLabel.text = @"mismatched passwords";
                self.password.textColor = [UIColor redColor];
                self.confirmPassword.textColor = [UIColor redColor];
            }
        }
    }
}

- (IBAction)saveChangesClicked:(id)sender
{
    self.saveChanges.enabled = NO;
    self.uploadPicture.enabled = NO;
    [Account changePasswordWithOldPassword:self.oldPassword.text NewPassword:self.password.text ConfirmPassword:self.confirmPassword.text AccountView:self];
}

- (IBAction)uploadPictureClicked:(id)sender
{
    //UIImagePickerController
    // ...
    //self.profilePicture.image
}

@end
