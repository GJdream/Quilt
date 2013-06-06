//
//  BookmarkDataController.m
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights

#import "BookmarkDataController.h"

@interface BookmarkDataController ()

- (void)initDefaultBookmarks;

@end

@implementation BookmarkDataController

- (void)initDefaultBookmarks
{
    NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
    self.bookmarksArray = bookmarks;
    NSMutableArray *defaultTags = [[NSMutableArray alloc] initWithObjects:@"search", @"engine", @"test", nil];
/*    UILabel *label = [[UILabel alloc] init];
    label.text = @"Google";*/
    UIBookmark *bookmark = [[UIBookmark alloc] initWithTitle:@"Google" URL:@"www.google.com" Tags:defaultTags Width:1 Height:1];
    [self addBookmark:bookmark];
}

- (void)setBookmarksArray:(NSMutableArray *)newArray
{
    if(_bookmarksArray != newArray)
    {
        _bookmarksArray = [newArray mutableCopy];
    }
}

- (id)init
{
    if (self = [super init])
    {
        [self initDefaultBookmarks];
    }
    return self;
}

- (NSUInteger)countOfBookmarks
{
    return [self.bookmarksArray count];
}

- (UIBookmark *)bookmarkInListAtIndex:(NSUInteger)index
{
    return [self.bookmarksArray objectAtIndex:index];
}

- (void)addBookmark:(UIBookmark *)bookmark
{
    [self.bookmarksArray addObject:bookmark];
}

@end
