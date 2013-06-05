//
//  Bookmark.m
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

-(Bookmark*)initWithTitle:(NSString *)title URL:(NSString*)url Tags:(NSMutableArray*)tags Width:(NSInteger)width Height:(NSInteger)height
{
    self = [super init];
    if (self)
    {
        _title = title;
        _url = url;
        _tags = tags;
        _width = width;
        _height = height;
    }
    return self;
}

@end
