//
//  UIBookmark.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "UIBookmark.h"
#import <QuartzCore/CALayer.h>

@implementation UIBookmark

- (UIBookmark *)initWithTitle:(NSString*)title URL:(NSString*)url Tags:(NSMutableArray*)tags Width:(NSInteger)width Height:(NSInteger)height ID:(uint64_t)id
{
    self = [super init];
    if (self)
    {
        _label.text = title;
        _label.backgroundColor = [UIColor redColor];
        _title = title;
        _url = url;
        _tags = tags;
        _width = width;
        _height = height;
        _b_id = id;
    }
    return self;
}

@end

