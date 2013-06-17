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
#import "Friend.h"
#import "FriendsDataController.h"

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

+(void)getBookmarkPicture:(UIBookmark*)bookmark
{
    NSString *params = [[NSString alloc] initWithFormat:@"action=get_bookmark_picture&b_id=%llu", bookmark.b_id];
    (void)[NetworkClient createGETRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               dispatch_async(dispatch_get_main_queue(),
                              ^(void){
                                  [NetworkController gotBookmarkPicture:data ForBookmark:bookmark];
                              });
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)getNewFriends
{
    NSString *params = @"action=get_friends";
    (void)[NetworkClient createGETRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               dispatch_async(dispatch_get_main_queue(),
                              ^(void){
                                  [NetworkController gotFriends:data];
                              });
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)getFriendPhoto:(Friend *)friend
{
    NSString *params = [[NSString alloc] initWithFormat:@"action=get_user_picture&username=%@", friend.name];
    (void)[NetworkClient createGETRequest:params WithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
           {
               dispatch_async(dispatch_get_main_queue(),
                              ^(void){
                                  [NetworkController gotPhoto:data ForFriend:friend];
                              });
               
               if (error != nil)
                   NSLog(@"Connection failed! Error - %@ %@",
                         [error localizedDescription],
                         [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
           }];
}

+(void)getPhoto:(AccountViewController *)avc
{
    NSString *params = @"action=get_user_picture";
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

+(void)logoutUser:(Account*)logoutAccount
{
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"logout_user",nil] forKeys:[[NSArray alloc] initWithObjects:@"action", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
        loginCookie = nil;
        
        dispatch_async(dispatch_get_main_queue(),
                       ^(void){
                           [NetworkController logoutComplete:data];
                       });
        
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];

}

+(void)changePassword:(NSString *)password AccountVC:(AccountViewController *)avc
{
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
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"new_user_picture",nil]
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
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]
                        initWithObjects: [[NSArray alloc] initWithObjects:@"new_bookmark", [[Account current] username], [bookmark url], [[NSNumber alloc] initWithUnsignedInteger:[bookmark height]], [[NSNumber alloc] initWithUnsignedInteger:[bookmark width]],nil]
                        forKeys:[[NSArray alloc] initWithObjects:@"action",@"owner",@"url",@"p_height",@"p_width", nil]];
    
    for(NSUInteger i = 0; i < bookmark.tags.count; ++i)
        [paramDict setObject:bookmark.tags[i] forKey:[[NSString alloc] initWithFormat:@"tags[%u]", i]];
    
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:(NSDictionary*)paramDict];
    
    [NetworkClient appendToRequest:request Image:bookmark.image WithName:@"picture"];
    UIImageWriteToSavedPhotosAlbum(bookmark.image, nil, nil, nil);
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
        }];
}

+(void)shareTag:(NSString*)tag WithFriends:(NSArray*)users
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]
                                      initWithObjects: [[NSArray alloc] initWithObjects:@"share_tag", tag,nil]
                                      forKeys:[[NSArray alloc] initWithObjects:@"action", @"tag",nil]];
    
    for(NSUInteger i = 0; i < users.count; ++i)
        [paramDict setObject:((Friend*)users[i]).name forKey:[[NSString alloc] initWithFormat:@"users[%u]", i]];
    
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:(NSDictionary*)paramDict];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];
}

+(void)addFriend:(NSString*)friendName AccountVC:(AccountViewController *)avc
{
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"new_friend", friendName,nil]
                                                                  forKeys:[[NSArray alloc] initWithObjects:@"action",@"friend_name", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        dispatch_async(dispatch_get_main_queue(),
                       ^(void){
                           [[FriendsDataController instantiate] addFriend:friendName];
                           avc.friendAddedLabel.text = @"Friend added successfully";
                       });
        
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];
}

+(void)removeFriend:(NSString*)friendName
{
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"remove_friend", friendName,nil]
                                                                  forKeys:[[NSArray alloc] initWithObjects:@"action",@"friend_name", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];
}

+(void)deleteBookmark:(UIBookmark*)bookmark
{
    NSMutableURLRequest *request = [NetworkClient createPOSTRequestWithDictionary:
                                    [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"remove_bookmark", [NSNumber numberWithLongLong:bookmark.b_id],nil]
                                                                  forKeys:[[NSArray alloc] initWithObjects:@"action",@"post_id", nil]]];
    
    [NetworkClient SendRequest:request WithHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error != nil)
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }];
}



@end
