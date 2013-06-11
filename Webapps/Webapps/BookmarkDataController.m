//
//  BookmarkDataController.m
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights

#import "BookmarkDataController.h"
#import "NetworkClient.h"

@interface BookmarkDataController ()
@property NSMutableArray *updatedBookmarks;
@property (readwrite) NSMutableDictionary *tagToBookmark;

@end

@implementation BookmarkDataController

/*- (void)initDefaultBookmarks
{
    NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
    self.bookmarksArray = bookmarks;
    NSMutableArray *defaultTags = [[NSMutableArray alloc] initWithObjects:@"search", @"engine", @"google", @"test", nil];
    UIBookmark *bookmark = [[UIBookmark alloc] initWithTitle:@"Google" URL:@"http://google.com" Tags:defaultTags Width:1 Height:1];
    [self addBookmark:bookmark];
    defaultTags = [[NSMutableArray alloc] initWithObjects:@"social networks", @"friends", @"facebook", @"test", nil];
    bookmark = [[UIBookmark alloc] initWithTitle:@"Facebook" URL:@"http://facebook.com" Tags:defaultTags Width:1 Height:1];
    [self addBookmark:bookmark];
    defaultTags = [[NSMutableArray alloc] initWithObjects:@"social networks", @"cats", @"youtube", @"videos", @"test", nil];
    bookmark = [[UIBookmark alloc] initWithTitle:@"Youtube" URL:@"http://youtube.com" Tags:defaultTags Width:1 Height:1];
    [self addBookmark:bookmark];
    //defaultTags = [[NSMutableArray alloc] initWithObjects:@"socialnetworks", @"friends", "@twitter", @"test", nil];
    bookmark = [[UIBookmark alloc] initWithTitle:@"Twitter" URL:@"http://twitter.com" Tags:defaultTags Width:1 Height:1];
    [self addBookmark:bookmark];
    //defaultTags = [[NSMutableArray alloc] initWithObjects:@"social networks", @"friends", @"tumblr", @"test", nil];
    bookmark = [[UIBookmark alloc] initWithTitle:@"Tumblr" URL:@"http://tumblr.com" Tags:defaultTags Width:1 Height:1];
    [self addBookmark:bookmark];
}*/

- (void)setBookmarksArray:(NSMutableArray *)newArray
{
    if(_bookmarksArray != newArray)
    {
        _bookmarksArray = [newArray mutableCopy];
        _tagTrie = [[NDMutableTrie alloc] init];
    }
}

- (id)init
{
    if (self = [super init])
    {
        _bookmarksArray = [[NSMutableArray alloc] init];
        _tagTrie = [[NDMutableTrie alloc] init];
        //[self initDefaultBookmarks];
        [NetworkClient getNewBookmarks:self];
    }
    return self;
}

- (BookmarkDataController*)initWithViewController:(BookmarkViewController*)bookmarkVC
{
    if(self = [super init])
    {
        _bookmarksArray = [[NSMutableArray alloc] init];
        _updatedBookmarks = [[NSMutableArray alloc] init];
        _tagTrie = [[NDMutableTrie alloc] init];
        self.bookmarkVC = bookmarkVC;
        [NetworkClient getNewBookmarks:self];
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
    NSUInteger index = [self.bookmarksArray indexOfObject:bookmark];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.updatedBookmarks addObject:indexPath];
    
    [self.tagTrie addArray:bookmark.tags];
    
    for (NSString *tag in bookmark.tags) {
        NSMutableSet *bookmarkSet = [self.tagToBookmark objectForKey:tag];
        if(!bookmarkSet)
        {
            bookmarkSet = [[NSMutableSet alloc] initWithObjects:bookmark, nil];
            [self.tagToBookmark setValue:bookmarkSet forKey:tag];
        }
        else
            [bookmarkSet addObject:bookmark];
    }
}

- (void)updateOnBookmarkInsertion
{
    [self.bookmarkVC.collectionView insertItemsAtIndexPaths:(NSArray*)self.updatedBookmarks];
    [self.updatedBookmarks removeAllObjects];
}

@end
