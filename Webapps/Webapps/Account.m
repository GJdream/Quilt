//
//  Account.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "Account.h"
#import "NetworkClient.h"

@interface Account ()
    @property (readwrite) NSString *username;
    @property (readwrite) NSString *password;
@end


@implementation Account

Account *currentAccount;

+ (void)loginUser:(NSString *)username Password:(NSString *)password LoginView:(LoginViewController *)lvc
{
    NSLog(@"loginUser: %@, %@", username, password);
    Account *newAccount = [[Account alloc] initWithUserName:username Password:password];
    currentAccount = newAccount;
    [NetworkClient loginUser:newAccount LoginView:lvc];
}

+ (void)registerUser:(NSString *)username Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword RegisterView:(RegisterViewController *)rvc
{
    // Confirm passwords
    BOOL validPassword = [Account validPassword:password ConfirmPassword:confirmPassword];
    
    //[NetworkClient registerUser:newAccount LoginView:lvc];
    
    NSLog(@"registerUser: %@, %@, %@", username, password, confirmPassword);
    
    // Check username is valid
    BOOL validUsername = NO;
    
    if (validUsername && validPassword)
    {
        // Create account
        //[Account loginUser:username Password:password LoginView:rvc];
    } else
    {
        // Error message
    }
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

@end
