//
//  LoginViewController.m
//  Webapps
//
//  Created by Goldsack, Briony on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkClient.h"
#import "AppDelegate.h"
#import "Account.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize txtUsername;
@synthesize txtPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClicked:(id)sender
{
    self.loginButton.enabled = NO;
    [Account loginUser:txtUsername.text Password:txtPassword.text LoginView:self];
}

@end