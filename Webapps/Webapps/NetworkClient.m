//
//  NetworkClient.m
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkClient.h"
#import "NetworkDelegate.h"

NSString *session_id;

@interface NetworkClient ()
+(NSMutableURLRequest*)createRequest;
@end

@implementation NetworkClient
NSString *url=@"https://www.doc.ic.ac.uk/~rj1411/server/listen.php";
NSString *loginCookie;

+(NSMutableURLRequest*)createRequest
{
    NSMutableURLRequest *retRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [retRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if(session_id)
    {
        [retRequest setValue:session_id forHTTPHeaderField:@"Cookie"];
    }
    
    return retRequest;
}

+(void)getNewBookmarks
{
    
}

+(void)loginUser:(NSString*)uname Password:(NSString*)pass
{
    NSMutableURLRequest *loginRequest = [NetworkClient createRequest];
    [loginRequest setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"action=attempt_login&username=%@&password=%@",uname,pass];
    [loginRequest setHTTPBody:[NSData dataWithBytes:[params UTF8String] length:[params length]]];
    //NSURLConnection *connection = [[NSURLConnection alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:loginRequest queue: queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
        loginCookie = [fields valueForKey:@"Set-Cookie"];
        
        /*if ([data length] > 0 && error == nil)
            [delegate receivedData:data];
        else if ([data length] == 0 && error == nil)
            [delegate emptyReply];*/
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];
}

+(void)createAccount:(Account*)account
{
    
}

+(void)createBookmark:(Bookmark*)bookmark
{
    NSLog(@"createBookmark");
    NSMutableURLRequest *bookmarkRequest = [NetworkClient createRequest];
    [bookmarkRequest setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"action=new_bookmark&owner=%@&url=%@&p_height=1&p_width=1", [[Account current] username], [bookmark url]];
    [bookmarkRequest setHTTPBody:[NSData dataWithBytes:[params UTF8String] length:[params length]]];
    [bookmarkRequest setValue:loginCookie forHTTPHeaderField:@"Cookie"];
    //NSURLConnection *connection = [[NSURLConnection alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:bookmarkRequest queue: queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
         //[(NSHTTPURLResponse *)response allHeaderFields];
         /*if ([data length] > 0 && error == nil)
          [delegate receivedData:data];
          else if ([data length] == 0 && error == nil)
          [delegate emptyReply];*/
         if (error != nil)
             NSLog(@"Connection failed! Error - %@ %@",
                   [error localizedDescription],
                   [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
     }];
}

+(void)shareTag:(NSString*)tag With:(NSSet*)users
{
    
}

+(void)deleteBookmark:(Bookmark*)bookmark
{
    
}

@end
