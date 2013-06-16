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
@class UIBookmark;
@class Friend;

@interface NetworkController : NSObject

+(void)loginComplete:(NSData*)data LoginView:(LoginViewController*)loginVC;
+(void)logoutComplete:(NSData*)data;

+(void)gotBookmarks:(NSData*)data;
+(void)gotFriends:(NSData*)data;
+(void)gotPhoto:(NSData*)data AccountViewController:(AccountViewController *)avc;
+(void)gotBookmarkPicture:(NSData*)data ForBookmark:(UIBookmark*)bookmark;
+(void)gotPhoto:(NSData*)data ForFriend:(Friend*)friend;

+(void)checkedUsername:(NSData*)data RegisterVC:(RegisterViewController*)rvc;
+(void)accountCreated:(NSData*)data Account:(Account*)account RegisterVC:(RegisterViewController*)registerVC;
+(void)changePasswordComplete:(NSData*)data AccountViewController:(AccountViewController*)avc;
+(void)changePhotoComplete:(NSData*)data AccountViewController:(AccountViewController*)avc;

@end
