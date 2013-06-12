//
//  NetworkClient.h
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "UIBookmark.h"
#import "BookmarkDataController.h"

@interface NetworkClient : NSObject

+(void)getNewBookmarks;
+(void)createAccount:(Account*)account;
+(void)createBookmark:(UIBookmark*)bookmark;
+(void)shareTag:(NSString*)tag With:(NSSet*)users;
+(void)deleteBookmark:(UIBookmark*)bookmark;
+(void)loginUser:(Account*)loginAccount LoginView:(LoginViewController*)lvc;

@end
