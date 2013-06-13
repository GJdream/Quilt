//
//  Account.h
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AccountViewController.h"

@interface Account : NSObject

@property (readonly) NSString *username;
@property (readonly) NSString *password;

- (Account *)initWithUserName:(NSString *)initUsername Password:(NSString *)initPassword;
//-(void)addBookmark:(NSString*)url WithTags:(NSArray*)tags Width:(NSInteger)width Height:(NSInteger)height;
+ (Account *)current;
+ (void)setCurrent:(Account *)newCurrent;
+ (void)loginUser:(NSString *)username Password:(NSString *)password LoginView:(LoginViewController *)lvc;
+ (void)registerUser:(NSString *)username Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword RegisterView:(RegisterViewController *)rvc;
+ (BOOL)validPassword:(NSString *)password ConfirmPassword:(NSString *)confirmPassword;
+ (void)changePassword:(NSString *)username NewPassword:(NSString *)newPassword OldPassword:(NSString *)oldPassword ConfirmPassword:(NSString *)confirmPassword AccountView:(AccountViewController *)avc;

@end
