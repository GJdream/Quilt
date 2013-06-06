//
//  NetworkController.m
//  Webapps
//
//  Created by Richard Jones on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkController.h"
#import "AppDelegate.h"
#import "UIBookmark.h"

@implementation NetworkController

+(void)loginComplete:(NSData*)data LoginView:(LoginViewController*)loginVC
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"login"] boolValue];
    if(success)
        [loginVC performSegueWithIdentifier:@"loginSegue" sender:nil];
    else //if(![(NSNumber*)[json valueForKey:@"user_exists"] boolValue])
    {
        [[[UIAlertView alloc] initWithTitle:@"Login error" message:@"Your username or password was incorrect" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
        
        loginVC.loginButton.enabled = YES;
    }
}

+(void)gotBookmarks:(NSData*)data DataController:(BookmarkDataController*)bookmarkDC
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSArray *bookmarksArray = (NSArray*)[json objectForKey:@"bookmarks"];
    
    for(NSDictionary *bookmarkDict in bookmarksArray)
    {
        NSString *url = (NSString*)[bookmarkDict objectForKey:@"url"];
        NSInteger p_height = [(NSNumber*)[bookmarkDict valueForKey:@"p_height"] integerValue];
        NSInteger p_width = [(NSNumber*)[bookmarkDict valueForKey:@"p_width"] integerValue];
        
        UIBookmark *bookmark = [[UIBookmark alloc] initWithTitle:url URL:url Tags:[[NSMutableArray alloc] init] Width:p_width Height:p_height];
        [bookmarkDC addBookmark:bookmark];
    }
    
    [bookmarkDC updateOnBookmarkInsertion];
}

@end
