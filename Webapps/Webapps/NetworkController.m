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
#import "LoginViewController.h"
#import "BookmarkDataController.h"

@implementation NetworkController

+(void)loginComplete:(NSData*)data LoginView:(LoginViewController*)loginVC
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"login"] boolValue];
    if(success)
        [loginVC performSegueWithIdentifier:@"loginSegue" sender:nil];
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Login error" message:@"Your username or password was incorrect" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
        
        loginVC.loginButton.enabled = YES;
    }
}

+(void)gotBookmarks:(NSData*)data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    BookmarkDataController *bookmarkDC = [BookmarkDataController instantiate];
    
    NSArray *bookmarksArray = (NSArray*)[json objectForKey:@"bookmarks"];
    NSDictionary *tagsDict = (NSDictionary*)[json objectForKey:@"tags"];
    
    for(NSDictionary *bookmarkDict in bookmarksArray)
    {
        NSString *url = (NSString*)[bookmarkDict objectForKey:@"url"];
        NSInteger p_height = [(NSNumber*)[bookmarkDict valueForKey:@"p_height"] integerValue];
        NSInteger p_width = [(NSNumber*)[bookmarkDict valueForKey:@"p_width"] integerValue];
        uint64_t b_id = [(NSNumber*)[bookmarkDict valueForKey:@"post_id"] longLongValue];
        NSMutableArray *tags = (NSMutableArray*)[tagsDict objectForKey:[[NSString alloc] initWithFormat:@"%lld", b_id]];

        UIBookmark *bookmark = [[UIBookmark alloc] initWithTitle:url URL:url Tags:tags Width:p_width Height:p_height ID:b_id];
        [bookmarkDC addBookmark:bookmark];
    }
    
    [bookmarkDC updateOnBookmarkInsertion];
}

@end
