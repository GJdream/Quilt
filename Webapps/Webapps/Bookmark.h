//
//  Bookmark.h
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject

@property NSString *url;
@property NSMutableArray *tags;
@property NSInteger width;
@property NSInteger height;

-(Bookmark*)initWithURL:(NSString*)url Tags:(NSMutableArray*)tags Width:(NSInteger)width Height:(NSInteger)height;

@end
