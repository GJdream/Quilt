//
//  NetworkClient.h
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RegisterViewController;
@class UIBookmark;
@class Account;
@class LoginViewController;
@class AccountViewController;
@class Friend;

@interface NetworkClient : NSObject

+(void)getNewBookmarks;
+(void)getNewFriends;
+(void)getPhoto:(AccountViewController *)avc;
+(void)getBookmarkPicture:(UIBookmark*)bookmark;
+(void)getFriendPhoto:(Friend *)friend;

+(void)addFriend:(NSString*)friendName;
+(void)removeFriend:(NSString*)friendName;
+(void)createAccount:(Account*)account RegisterVC:(RegisterViewController*)rvc;
+(void)createBookmark:(UIBookmark*)bookmark;
+(void)shareTag:(NSString*)tag WithFriends:(NSArray*)users;
+(void)deleteBookmark:(UIBookmark*)bookmark;

+(void)loginUser:(Account*)loginAccount LoginView:(LoginViewController*)lvc;
+(void)logoutUser:(Account*)logoutAccount;

+(void)checkUsername:(NSString*)uname RegisterVC:(RegisterViewController*)rvc;
+(void)changePassword:(NSString *)password AccountVC:(AccountViewController *)avc;
+(void)changePhoto:(UIImage *)photo AccountVC:(AccountViewController *)avc;

@end
