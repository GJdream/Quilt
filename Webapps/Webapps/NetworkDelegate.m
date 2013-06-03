//
//  NetworkDelegate.m
//  Webapps
//
//  Created by Richard Jones on 03/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NetworkDelegate.h"

@interface NSObject(MyDelegateMethods)

@end

@implementation NetworkDelegate

NSMutableData *responseData;
SEL callbackSelector;
id callbackObject;

- (NetworkDelegate*)initWithCallback:(SEL)selector withObject:(id)object
{
    self = [super init];
    
    if(self)
    {
        callbackSelector = selector;
        callbackObject = object;
    }
    
    return self;
}

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
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

@end
