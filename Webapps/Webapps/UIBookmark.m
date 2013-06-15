//
//  UIBookmark.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "UIBookmark.h"
#import "BookmarkDataController.h"
#import "BookmarkViewController.h"
#import <QuartzCore/CALayer.h>

@implementation UIBookmark

- (UIBookmark *)initWithTitle:(NSString*)title URL:(NSString*)url Tags:(NSMutableArray*)tags Width:(NSInteger)width Height:(NSInteger)height ID:(uint64_t)id Image:(UIImage*)image
{
    self = [super init];
    if (self)
    {
        _titleLabel.text = title;
        _titleLabel.backgroundColor = [UIColor redColor];
        _image = image;
        _title = title;
        _url = url;
        _tags = tags;
        _width = width;
        _height = height;
        _b_id = id;
        _viewBookmark = nil;
        _dataBookmark = nil;
        _imageView = nil;
    }
    return self;
}

- (void)setPicture:(UIImage*)picture
{
    self.image = picture;
    self.viewBookmark.imageView.image = picture;
    [self.viewBookmark setNeedsDisplay];
}

- (IBAction)tagClicked:(id)sender
{
    [[BookmarkDataController instantiate] showTag:_firstTag.titleLabel.text];
}

- (IBAction)deleteClicked:(id)sender
{
    self.viewBookmark = nil;
    [[BookmarkDataController instantiate] deleteBookmark:self];
}

@end