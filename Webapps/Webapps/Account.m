//
//  Account.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "Account.h"
#import "Bookmark.h"

@interface Account ()
    @property (readwrite) NSString *username;
    @property (readwrite) NSString *passwordhash;
    @property (readwrite) NSDictionary *tagToBookmark;
    @property (readwrite) NSDictionary *urlToBookmark;
@end


@implementation Account

-(Account*)initWithUserName:(NSString*)initUsername PasswordHash:(NSString*)initPasswordHash
{
    self = [super init];
    if(self)
    {
        self.username = initUsername;
        self.passwordhash = initPasswordHash;
        self.tagToBookmark = [[NSDictionary alloc] init];
        self.urlToBookmark = [[NSDictionary alloc] init];
    }
}

// Dictionaries are a bad choice; we need many-to-many, not many-to-one mappings.
-(void)addBookmark:(NSString*)url WithTags:(NSArray*)tags Width:(NSInteger)width Height:(NSInteger)height
{
    Bookmark *newBookmark = [[Bookmark alloc] initWithURL:url Tags:tags Width:width Height:height];
    for (NSString *tag in tags) {
        NSMutableSet *bookmarkSet = [self.tagToBookmark objectForKey:tag];
        if(!bookmarkSet)
            bookmarkSet = [[NSSet alloc] initWithObjects:newBookmark, nil];
        else
            [bookmarkSet addObject:newBookmark];
    }
}

@end
