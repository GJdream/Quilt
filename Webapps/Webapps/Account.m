//
//  Account.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "Account.h"
#import "NetworkClient.h"
#import "BookmarkDataController.h"
#import "FriendsDataController.h"

@interface Account ()
    @property (readwrite) NSString *username;
    @property (readwrite) NSString *password;
@end


@implementation Account

Account *currentAccount;

+ (void)loginUser:(NSString *)username Password:(NSString *)password LoginView:(LoginViewController *)lvc
{
    Account *newAccount = [[Account alloc] initWithUserName:username Password:password];
    currentAccount = newAccount;
    [NetworkClient loginUser:newAccount LoginView:lvc];
}

+ (void)logoutUser
{
    [NetworkClient logoutUser:currentAccount];
    BookmarkDataController *bookmarkDC = [BookmarkDataController instantiate];
    //[bookmarkDC emptyBookmarkArray];
    //[bookmarkDC.bookmarksArray removeAllObjects];
    //[bookmarkDC emptyTagTrie];
    [BookmarkDataController deleteInstance];
    currentAccount = nil;
    [FriendsDataController deleteInstance];
}

+ (void)registerUser:(NSString *)username Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword RegisterView:(RegisterViewController *)rvc
{
    [NetworkClient createAccount:[[Account alloc] initWithUserName:username Password:password] RegisterVC:rvc];
}

+ (void)changePasswordWithOldPassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword ConfirmPassword:(NSString *)confirmPassword AccountView:(AccountViewController *)avc
{
    if ([oldPassword isEqualToString:currentAccount.password])
    {
        if ([Account validPassword:newPassword ConfirmPassword:confirmPassword])
        {
            [NetworkClient changePassword:newPassword AccountVC:avc];
        } else
        {
            [[[UIAlertView alloc] initWithTitle:@"Change password error" message:@"Your new passwords do not match" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
            avc.uploadPicture.enabled = YES;
            avc.saveChanges.enabled = YES;
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Change password error" message:@"Your old password was not correct" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
        avc.uploadPicture.enabled = YES;
        avc.saveChanges.enabled = YES;
    }

}

+ (void)changePhoto:photo AccountView:(AccountViewController *)avc
{
    [NetworkClient changePhoto:photo AccountVC:avc];
}

- (void)setPhoto:(AccountViewController *)avc
{
    [NetworkClient getPhoto:avc];
}

+ (BOOL)validPassword:(NSString *)password ConfirmPassword:(NSString *)confirmPassword
{
    return ([password isEqualToString:confirmPassword]);
}

+ (void)setCurrent:(Account *)newCurrent
{
    currentAccount = newCurrent;
}

+ (Account *)current
{
    if (!currentAccount)
        NSLog(@"Error: Trying to execute action when no account is logged in!");
    
    return currentAccount;
}

- (Account *)initWithUserName:(NSString *)initUsername Password:(NSString *)initPassword
{
    self = [super init];
    
    if (self)
    {
        _username = initUsername;
        _password = initPassword;
    }
    
    return self;
}

+ (void)getTagOwner:(UITableViewCell *)cell
{
    [NetworkClient getTagOwner:cell];
}

@end
