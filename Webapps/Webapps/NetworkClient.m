//
//  NetworkClient.m
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkClient.h"
#import "NetworkController.h"
#import "Account.h"
#import "UIBookmark.h"
#import "BookmarkDataController.h"
#import "RegisterViewController.h"
#import "AccountViewController.h"

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

+(void)getNewBookmarks
{
    NSString *params = @"action=get_bookmarks";
    (void)[NetworkClient createGETRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {   
               dispatch_async(dispatch_get_main_queue(),
                            ^(void){
                                    [NetworkController gotBookmarks:data];
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

+(void)changePassword:(Account *)account Password:(NSString *)password AccountVC:(AccountViewController *)avc
{
    NSString *params = [NSString stringWithFormat:@"action=change_password&username=%@&password=%@", [account username], [account password]];
    
    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^(void){
                           [NetworkController changePasswordComplete:data AccountViewController:avc];
                       });
        
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];
}

+(void)createAccount:(Account*)account RegisterVC:(RegisterViewController *)rvc
{
    NSString *params = [NSString stringWithFormat:@"action=new_account&username=%@&password=%@", [account username], [account password]];
    params = [params stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
               loginCookie = [fields valueForKey:@"Set-Cookie"];
               dispatch_async(dispatch_get_main_queue(),
                              ^(void){
                                  [NetworkController accountCreated:data Account:account RegisterVC:rvc];
                              });
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)checkUsername:(NSString*)uname RegisterVC:(RegisterViewController*)rvc
{
    NSString *params = [NSString stringWithFormat:@"action=check_username&username=%@", uname];
    (void)[NetworkClient createGETRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               dispatch_async(dispatch_get_main_queue(),
                              ^(void){
                                  [NetworkController checkedUsername:data RegisterVC:rvc];
                              });
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)createBookmark:(UIBookmark*)bookmark
{
    NSString *params = [NSString stringWithFormat:@"action=new_bookmark&owner=%@&url=%@&p_height=%ld&p_width=%ld", [[Account current] username], [bookmark url], (long)[bookmark height], (long)[bookmark width]];
    
    for(NSUInteger i = 0; i < [bookmark.tags count]; ++i)
    {
        params = [NSString stringWithFormat:@"%@&tags[%d]=%@", params, i, bookmark.tags[i]];
    }
    
    params = [params stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
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
