//
//  NetworkClient.m
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkClient.h"
#import "NetworkController.h"

NSString *session_id;

@implementation NetworkClient
NSString *url=@"https://www.doc.ic.ac.uk/~rj1411/server/listen.php";
NSString *loginCookie;
NSUInteger lastUpdatedTime = 0;

+(NSMutableURLRequest*)createGETRequest:(NSString*)params WithCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    params = [params stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *retRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", url, params]]];
    [retRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if(session_id)
    {
        [retRequest setValue:session_id forHTTPHeaderField:@"Cookie"];
    }
    
    [retRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:retRequest queue: queue completionHandler:handler];
    
    return retRequest;
}

+(NSMutableURLRequest*)createPOSTRequest:(NSString*)params WithCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    params = [params stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *retRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [retRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    if(session_id)
    {
        [retRequest setValue:session_id forHTTPHeaderField:@"Cookie"];
    }
    
    [retRequest setHTTPMethod:@"POST"];
    [retRequest setHTTPBody:[NSData dataWithBytes:[params UTF8String] length:[params length]]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:retRequest queue: queue completionHandler:handler];
    
    return retRequest;
}

+(void)getNewBookmarks:(BookmarkDataController*)bookmarkDC
{
    NSString *params = @"action=get_bookmarks";
    (void)[NetworkClient createGETRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
               
               dispatch_async(dispatch_get_main_queue(),
                            ^(void){
                                    [NetworkController gotBookmarks:data DataController:bookmarkDC];
                                });
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)loginUser:(Account*)account LoginView:(LoginViewController*)lvc
{
    NSString *params = [NSString stringWithFormat:@"action=attempt_login&username=%@&password=%@", [account username], [account password]];
 
    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
        loginCookie = [fields valueForKey:@"Set-Cookie"];
        
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        dispatch_async(dispatch_get_main_queue(),
                       ^(void){
                           [NetworkController loginComplete:data LoginView:lvc];
                       });

        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];
}

+(void)createAccount:(Account*)account
{
    NSString *params = [NSString stringWithFormat:@"action=new_account&username=%@&password=%@", [account username], [account password]];
    params = [params stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)createBookmark:(UIBookmark*)bookmark
{
    NSString *params = [NSString stringWithFormat:@"action=new_bookmark&owner=%@&url=%@&p_height=%ld&p_width=%ld", [[Account current] username], [bookmark url], (long)[bookmark height], (long)[bookmark width]];
    params = [params stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)shareTag:(NSString*)tag With:(NSSet*)users
{
    
}

+(void)deleteBookmark:(UIBookmark*)bookmark
{
    
}

@end
