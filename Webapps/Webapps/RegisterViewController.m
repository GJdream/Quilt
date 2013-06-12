//
//  RegisterViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 12/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "RegisterViewController.h"
#import "Account.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize username;
@synthesize password;
@synthesize confirmPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (IBAction)registerClicked:(id)sender
{
    self.registerButton.enabled = NO;
    [Account registerUser:username.text Password:password.text ConfirmPassword:confirmPassword.text RegisterView:self];
}

@end
