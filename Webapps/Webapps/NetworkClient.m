//
//  NetworkClient.m
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkClient.h"

NSString *session_id;

@interface NetworkClient ()
+(NSMutableURLRequest*)createRequest;
@end

@implementation NetworkClient
NSMutableData *responseData;
NSString *url=@"https://www.doc.ic.ac.uk/~rj1411/server/listen.php";

+(void)setupURL
{
    NSLog(@"%@", url);
}

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
    NSURLConnection *connection = [[NSURLConnection alloc] init];
    (void)[connection initWithRequest:loginRequest delegate:[[NetworkClient alloc] init]];
    NSLog(@"initWithRequest done");
    NSLog(@"%@", [[loginRequest URL] absoluteString ]);
}

+(void)createAccount:(Account*)account
{
    
}

+(void)createBookmark:(Bookmark*)bookmark
{
    
}

+(void)shareTag:(NSString*)tag With:(NSSet*)users
{
    
}

+(void)deleteBookmark:(Bookmark*)bookmark
{
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error! %@ %ld", [error domain], (long)[error code]);
}

@end
