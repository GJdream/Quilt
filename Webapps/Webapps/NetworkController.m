//
//  NetworkController.m
//  Webapps
//
//  Created by Richard Jones on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkController.h"
#import "AppDelegate.h"

@implementation NetworkController

+(void)loginComplete:(NSData*)data
{
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    UIViewController *currentVC = d.window.rootViewController;
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL success = [(NSNumber*)[json valueForKey:@"login"] boolValue];
    if(success)
        [currentVC performSegueWithIdentifier:@"loginSegue" sender:nil];
    else if(![(NSNumber*)[json valueForKey:@"user_exists"] boolValue])
    {
        
    }
}

@end
