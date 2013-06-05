//
//  LoginViewController.h
//  Login
//
//  Created by Goldsack, Briony on 04/06/2013.
//  Copyright (c) 2013 Goldsack, Briony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)loginClicked:(id)sender;
- (IBAction)backgroundClick:(id)sender;
@end
