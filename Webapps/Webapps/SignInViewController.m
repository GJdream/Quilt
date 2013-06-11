//
//  SignInViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 11/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "SignInViewController.h"
#import "LoginViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController{
    UIPopoverController *loginPopover;
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"signInSegue"])
    {
        loginPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}

@end
