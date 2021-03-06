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
#import "NavigationBarViewController.h"

@interface Account : NSObject

@property (readonly) NSString *username;
@property (readonly) NSString *password;

- (Account *)initWithUserName:(NSString *)initUsername Password:(NSString *)initPassword;
//-(void)addBookmark:(NSString*)url WithTags:(NSArray*)tags Width:(NSInteger)width Height:(NSInteger)height;
+ (Account *)current;
+ (void)setCurrent:(Account *)newCurrent;

+ (void)loginUser:(NSString *)username Password:(NSString *)password LoginView:(LoginViewController *)lvc;
+ (void)logoutUser;

+ (void)registerUser:(NSString *)username Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword RegisterView:(RegisterViewController *)rvc;
+ (BOOL)validPassword:(NSString *)password ConfirmPassword:(NSString *)confirmPassword;
+ (void)changePasswordWithOldPassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword ConfirmPassword:(NSString *)confirmPassword AccountView:(AccountViewController *)avc;
+ (void)changePhoto:(UIImage *)image AccountView:(AccountViewController *)avc;
- (void)setPhoto:(AccountViewController *)avc;

+ (void)getTagOwner:(UITableViewCell *)cell;

@end
