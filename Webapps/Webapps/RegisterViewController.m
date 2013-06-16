//
//  RegisterViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 12/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "RegisterViewController.h"
#import "Account.h"
#import "NetworkClient.h"

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
    self.username.delegate = (id)self;
    self.password.delegate = (id)self;
    self.confirmPassword.delegate = (id)self;
    // Do any additional setup after loading the view.
    self.registerButton.enabled = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"QuiltTexture.png"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.username)
        [NetworkClient checkUsername:textField.text RegisterVC:self];
    else if(textField == self.confirmPassword)
    {
        if([self.confirmPassword.text isEqualToString:self.password.text])
        {
            self.registerButton.enabled = YES;
            self.validPasswordLabel.text = @"";
            self.password.textColor = [UIColor blackColor];
            self.confirmPassword.textColor = [UIColor blackColor];
        }
        else
        {
            if(![self.password.text isEqualToString:@""])
            {
                self.registerButton.enabled = NO;
                self.validPasswordLabel.text = @"mismatched passwords";
                self.password.textColor = [UIColor redColor];
                self.confirmPassword.textColor = [UIColor redColor];
            }
        }
    }
    else if(textField == self.password)
    {
        if([self.confirmPassword.text isEqualToString:self.password.text])
        {
            self.registerButton.enabled = YES;
            self.validPasswordLabel.text = @"";
            self.password.textColor = [UIColor blackColor];
            self.confirmPassword.textColor = [UIColor blackColor];
        }
        else
        {
            if(![self.confirmPassword.text isEqualToString:@""])
            {
                self.registerButton.enabled = NO;
                self.validPasswordLabel.text = @"mismatched passwords";
                self.password.textColor = [UIColor redColor];
                self.confirmPassword.textColor = [UIColor redColor];
            }
        }
    }
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
