//
//  Account.h
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

@interface Account : NSObject

@property (readonly) NSString *username;
@property (readonly) NSString *password;
@property (readonly) NSDictionary *tagToBookmark;
@property (readonly) NSDictionary *urlToBookmark;

-(Account*)initWithUserName:(NSString*)initUsername Password:(NSString*)initPassword;
//-(void)addBookmark:(NSString*)url WithTags:(NSArray*)tags Width:(NSInteger)width Height:(NSInteger)height;
+(Account*)current;
+(void)setCurrent:(Account*)newCurrent;
+(void)loginUser:(NSString*)username Password:(NSString*)password LoginView:(LoginViewController*)lvc;

@end
