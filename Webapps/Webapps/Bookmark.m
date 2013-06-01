//
//  Bookmark.m
//  Webapps
//
//  Created by Richard Jones on 01/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

-(Bookmark*)initWithURL:(NSString*)url Tags:(NSMutableArray*)tags Width:(NSInteger)width Height:(NSInteger)height
{
    self = [super init];
    if(self)
    {
        self.url = url;
        self.tags = tags;
        self.width = width;
        self.height = height;
    }
}
@end
