//
//  LoginViewController.h
//  Webapps
//
//  Created by Goldsack, Briony on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
///Users/bkg11/Documents/webapps/Webapps/LoginViewController.h

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)loginClicked:(id)sender;
- (IBAction)backgroundClick:(id)sender;

@end
