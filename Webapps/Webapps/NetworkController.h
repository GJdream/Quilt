//
//  NetworkController.h
//  Webapps
//
//  Created by Richard Jones on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RegisterViewController;
@class LoginViewController;
@class Account;
@class AccountViewController;

@interface NetworkController : NSObject

+(void)loginComplete:(NSData*)data LoginView:(LoginViewController*)loginVC;
+(void)gotBookmarks:(NSData*)data;
+(void)checkedUsername:(NSData*)data RegisterVC:(RegisterViewController*)rvc;
+(void)accountCreated:(NSData*)data Account:(Account*)account RegisterVC:(RegisterViewController*)registerVC;
+(void)changePasswordComplete:(NSData*)data AccountViewController:(AccountViewController*)avc;
+(void)changePhotoComplete:(NSData*)data AccountViewController:(AccountViewController*)avc;
+(void)gotPhoto:(NSData*)data AccountViewController:(AccountViewController *)avc;

@end
