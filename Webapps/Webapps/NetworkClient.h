//
//  NetworkClient.h
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bookmark.h"
#import "Account.h"

@interface NetworkClient : NSObject

+(void)getNewBookmarks;
+(void)createAccount:(Account*)account;
+(void)createBookmark:(Bookmark*)bookmark;
+(void)shareTag:(NSString*)tag With:(NSSet*)users;
+(void)deleteBookmark:(Bookmark*)bookmark;
+(void)loginUser:(Account*)loginAccount;

@end
