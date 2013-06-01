//
//  Account.h
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (readonly) NSString *username;
@property (readonly) NSString *passwordhash;
@property (readonly) NSDictionary *tagToBookmark;
@property (readonly) NSDictionary *urlToBookmark;


-(Account*)initWithUserName:(NSString*)iUName Password:(NSString*)initPWord;
-(void)addBookmark:(NSString*)url WithTags:(NSArray*)tags Width:(NSInteger)width Height:(NSInteger)height;


@end