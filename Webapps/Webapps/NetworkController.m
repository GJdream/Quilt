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
#import "FriendsDataController.h"
#import "RegisterViewController.h"
#import "Account.h"
#import "Friend.h"
#import "AccountViewController.h"

@implementation NetworkController

+(void)loginComplete:(NSData*)data LoginView:(LoginViewController*)loginVC
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"login"] boolValue];
    
    if(success)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        AppDelegate *d = [[UIApplication sharedApplication] delegate];
        [d.window setRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"rootViewDeckController"]];
        [d.window makeKeyAndVisible];
    }
    else
    {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [[[UIAlertView alloc] initWithTitle:@"Login error" message:@"Your username or password was incorrect" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
        
        loginVC.loginButton.enabled = YES;
    }
}

+(void)logoutComplete:(NSData*)data
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"logout"] boolValue];
    
    if(!success)
    {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [[[UIAlertView alloc] initWithTitle:@"Logout error" message:@"Something went wrong with logging out of your account" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
    }
}

+(void)changePasswordComplete:(NSData*)data AccountViewController:(AccountViewController*)avc
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    BOOL success = [(NSNumber*)[json valueForKey:@"change_password"] boolValue];
    
    if(success)
    {
        avc.oldPassword.text = @"";
        avc.password.text = @"";
        avc.confirmPassword.text = @"";
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Change password error" message:@"Something went wrong with your change of password" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
    }
    avc.saveChanges.enabled = YES;
}

+(void)changePhotoComplete:(NSData*)data AccountViewController:(AccountViewController*)avc
{
    NSError* error;
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    BOOL success = [(NSNumber*)[json valueForKey:@"update_user_picture"] boolValue];
    
    if(success)
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Change picture error" message:@"Something went wrong with your change of picture" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
    }
}

+(void)checkedUsername:(NSData*)data RegisterVC:(RegisterViewController*)rvc
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"username_valid"] boolValue];
    if(success)
    {
        rvc.registerButton.enabled = YES;
        rvc.validUsernameLabel.text = @"";
        rvc.username.textColor = [UIColor blackColor];
    }
    else
    {
        rvc.registerButton.enabled = NO;
        rvc.validUsernameLabel.text = @"username in use";
        rvc.username.textColor = [UIColor redColor];
    }
}

+(void)gotBookmarks:(NSData*)data
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    BookmarkDataController *bookmarkDC = [BookmarkDataController instantiate];
    
    NSArray *bookmarksArray = (NSArray*)[json objectForKey:@"bookmarks"];
    NSDictionary *tagsDict = (NSDictionary*)[json objectForKey:@"tags"];
    
    for(NSDictionary *bookmarkDict in bookmarksArray)
    {
        NSString *url = [(NSString*)[bookmarkDict objectForKey:@"url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *title = [(NSString*)[bookmarkDict objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSInteger p_height = [(NSNumber*)[bookmarkDict valueForKey:@"p_height"] integerValue];
        NSInteger p_width = [(NSNumber*)[bookmarkDict valueForKey:@"p_width"] integerValue];
        uint64_t b_id = [(NSNumber*)[bookmarkDict valueForKey:@"post_id"] longLongValue];
        NSMutableArray *tags = (NSMutableArray*)[tagsDict objectForKey:[[NSString alloc] initWithFormat:@"%lld", b_id]];	

        UIBookmark *bookmark = [[UIBookmark alloc] initWithTitle:title URL:url Tags:tags Width:p_width Height:p_height ID:b_id Image:nil];
        [bookmarkDC addBookmark:bookmark];
    }
    [bookmarkDC updateOnBookmarkInsertion];
}

+(void)gotFriends:(NSData*)data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    FriendsDataController *friendsDC = [FriendsDataController instantiate];
    NSLog(@"%@",json);
    
    NSArray *friendsArray = (NSArray*)[json objectForKey:@"friends"];
    
    for(NSString *friendName in friendsArray)
        [friendsDC addFriend:friendName];
    
    [friendsDC updateOnFriendInsertion];
}

+(void)gotPhoto:(NSData*)data ForFriend:(Friend*)friend
{
    UIImage *retImage = [[UIImage alloc] initWithData:data];
    [friend setPicture:retImage];
}

+(void)gotPhoto:(NSData*)data AccountViewController:(AccountViewController *)avc
{
    avc.imageView.image = [[UIImage alloc] initWithData:data];
}

+ (void)gotTagOwner:(NSData *)data Cell:(UITableViewCell *)cell
{
    NSString *username =[Account current].username;
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *owner = (NSString *)[json objectForKey:@"get_tag_owner_id"];
    
    if (![username isEqualToString:owner])
    {
        cell.detailTextLabel.text = owner;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    } else
    {
        cell.detailTextLabel.text = @".";
    }
}

+(void)gotBookmarkPicture:(NSData*)data ForBookmark:(UIBookmark*)bookmark
{
    UIImage *retImage = [[UIImage alloc] initWithData:data];
    [bookmark setPicture:retImage];
    UIImageWriteToSavedPhotosAlbum(retImage,nil,nil,nil);
}

+(void)accountCreated:(NSData*)data Account:(Account*)account RegisterVC:(RegisterViewController*)registerVC
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"account_ready"] boolValue];
    if(success)
    {
        [Account setCurrent:account];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        AppDelegate *d = [[UIApplication sharedApplication] delegate];
        [d.window setRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"rootViewDeckController"]];
        [d.window makeKeyAndVisible];
    }
    else
    {
        registerVC.registerButton.enabled = YES;
        [[[UIAlertView alloc] initWithTitle:@"Registration error" message:@"A problem occurred with registration" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }
}

@end
