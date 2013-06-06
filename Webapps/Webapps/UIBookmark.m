//
//  UIBookmark.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "UIBookmark.h"

@implementation UIBookmark

- (UIBookmark *)initWithTitle:(NSString*)label URL:(NSString*)url Tags:(NSMutableArray*)tags Width:(NSInteger)width Height:(NSInteger)height
{
    self = [super init];
    if (self)
    {
        _label = [[UILabel alloc] init];
        _label.text = label;
        _url = url;
        _tags = tags;
        _width = width;
        _height = height;
    }
    return self;
}
@end

