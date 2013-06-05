//
//  Account.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "Account.h"
#import "NetworkClient.h"
#import "Bookmark.h"

@interface Account ()
    @property (readwrite) NSString *username;
    @property (readwrite) NSString *password;
    @property (readwrite) NSDictionary *tagToBookmark;
    @property (readwrite) NSDictionary *urlToBookmark;
@end


@implementation Account

Account *currentAccount;

+(void)setCurrent:(Account*)newCurrent
{
    currentAccount = newCurrent;
}

+(Account*)current
{
    if(!currentAccount)
        NSLog(@"Error: Trying to execute action when no account is logged in!");
    
    return currentAccount;
}

-(Account*)initWithUserName:(NSString*)initUsername Password:(NSString*)initPassword
{
    self = [super init];
    
    if(self)
    {
        _username = initUsername;
        _password = initPassword;
        _tagToBookmark = [[NSDictionary alloc] init];
        _urlToBookmark = [[NSDictionary alloc] init];
    }
    
    return self;
}

-(void)addBookmark:(NSString*)url WithTags:(NSMutableArray*)tags Width:(NSInteger)width Height:(NSInteger)height
{
    Bookmark *newBookmark = [[Bookmark alloc] initWithTitle:url URL:url Tags:tags Width:width Height:height];
    for (NSString *tag in tags) {
        NSMutableSet *bookmarkSet = [self.tagToBookmark objectForKey:tag];
        if(!bookmarkSet)
            bookmarkSet = [[NSMutableSet alloc] initWithObjects:newBookmark, nil];
        else
            [bookmarkSet addObject:newBookmark];
    }
}

+(void)loginUser:(NSString*)username Password:(NSString*)password
{
    NSLog(@"loginUser: %@, %@", username, password);
    Account *newAccount = [[Account alloc] initWithUserName:username Password:password];
    currentAccount = newAccount;
    [NetworkClient loginUser:newAccount];
}

@end
