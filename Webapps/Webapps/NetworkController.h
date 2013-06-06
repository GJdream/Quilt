//
//  NetworkController.h
//  Webapps
//
//  Created by Richard Jones on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "BookmarkDataController.h"

@interface NetworkController : NSObject

+(void)loginComplete:(NSData*)data LoginView:(LoginViewController*)loginVC;
+(void)gotBookmarks:(NSData*)data DataController:(BookmarkDataController*)bookmarkDC;

@end
