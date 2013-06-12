//
//  RegisterViewController.h
//  Quilt
//
//  Created by Thomas, Anna E on 12/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)registerClicked:(id)sender;

@end
