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
NSString *boundary;

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


//TODO: Function to append image to body for sending over network.
+(void)SendRequest:(NSMutableURLRequest*)request WithHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    NSMutableData *body = (NSMutableData*)request.HTTPBody;
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    //NSLog(@"Data: %@", body);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue: queue completionHandler:handler];
}

+(NSMutableURLRequest*)createPOSTRequestWithDictionary:(NSDictionary*)params
{
    if(!boundary)
        boundary = [[NSUUID UUID] UUIDString];
    
    NSMutableURLRequest *retRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [retRequest setValue:[[NSString alloc] initWithFormat:@"multipart/form-data, boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    if(session_id)
        [retRequest setValue:session_id forHTTPHeaderField:@"Cookie"];
    
    NSMutableData *body = [[NSMutableData alloc] init];

    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [body appendData:[[[NSString alloc] initWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[[NSString stringWithFormat:@"%@", obj] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [retRequest setHTTPMethod:@"POST"];
    [retRequest setHTTPBody:body];
    return retRequest;
}

+(void)appendToRequest:(NSMutableURLRequest*)request Image:(UIImage*)image WithName:(NSString*)name
{
    if(!boundary)
        boundary = [[NSUUID UUID] UUIDString];
    
    NSMutableData *body = (NSMutableData*)request.HTTPBody;
    
    [body appendData:[[[NSString alloc] initWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: octet-stream; name=\"%@\"; filename=\"%@\"\r\n\r\n", name, name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:UIImagePNGRepresentation(image)];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
}

+(NSMutableURLRequest*)createPOSTRequestWithData:(NSData*)body WithCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if(!boundary)
        boundary = [[NSUUID UUID] UUIDString];
    
    NSMutableURLRequest *retRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [retRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(session_id)
    {
        [retRequest setValue:session_id forHTTPHeaderField:@"Cookie"];
    }
    
    [retRequest setHTTPMethod:@"POST"];
    [retRequest setHTTPBody:body];
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

+(void)getPhoto:(AccountViewController *)avc
{
    NSString *params = @"action=get_picture";
    (void)[NetworkClient createGETRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               dispatch_async(dispatch_get_main_queue(),
                              ^(void){
                                  [NetworkController gotPhoto:data AccountViewController:avc];
                              });
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)loginUser:(Account*)account LoginView:(LoginViewController*)lvc
{
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"attempt_login",[account username],[account password],nil]
                                                                  forKeys:[[NSArray alloc] initWithObjects:@"action", @"username", @"password", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
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

+(void)changePassword:(NSString *)password AccountVC:(AccountViewController *)avc
{
//    NSString *params = [NSString stringWithFormat:@"action=change_password&password=%@", password];
    
/*    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^(void){
                           [NetworkController changePasswordComplete:data AccountViewController:avc];
                       });
        
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];*/
    
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"change_password",password,nil]
                                                                  forKeys:[[NSArray alloc] initWithObjects:@"action",@"password", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
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

+(void)changePhoto:(UIImage *)photo AccountVC:(AccountViewController *)avc
{
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"new_picture",nil]
                                                                  forKeys:[[NSArray alloc] initWithObjects:@"action", nil]]];
    
    [NetworkClient appendToRequest:request Image:photo WithName:@"picture"];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               dispatch_async(dispatch_get_main_queue(),
                              ^(void){
                                  [NetworkController changePhotoComplete:data AccountViewController:avc];
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
    
/*    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
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
           }];*/
    
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"new_account",[account username], [account password],nil]
                                                                  forKeys:[[NSArray alloc] initWithObjects:@"action",@"username",@"password", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
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
    
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"new_bookmark", [[Account current] username], [bookmark url], [[NSNumber alloc] initWithUnsignedInteger:[bookmark height]], [[NSNumber alloc] initWithUnsignedInteger:[bookmark width]],nil]
                                                        forKeys:[[NSArray alloc] initWithObjects:@"action",@"owner",@"url",@"p_height",@"p_width", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
        }];
    
/*    (void)[NetworkClient createPOSTRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];*/
}

+(void)shareTag:(NSString*)tag With:(NSSet*)users
{
    
}

+(void)deleteBookmark:(UIBookmark*)bookmark
{
    
}

@end
