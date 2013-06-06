//
//  NetworkController.m
//  Webapps
//
//  Created by Richard Jones on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@implementation NetworkController

+(void)loginComplete:(NSData*)data
{
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    LoginViewController *currentVC = (LoginViewController*)d.window.rootViewController;
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"login"] boolValue];
    if(success)
        [currentVC performSegueWithIdentifier:@"loginSegue" sender:nil];
    else //if(![(NSNumber*)[json valueForKey:@"user_exists"] boolValue])
    {
        [[[UIAlertView alloc] initWithTitle:@"Login error" message:@"Your username or password was incorrect" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] show];
        
        currentVC.loginButton.enabled = NO;
    }
}

@end
