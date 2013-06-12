//
//  BookmarkDataController.m
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights

#import "BookmarkDataController.h"
#import "NetworkClient.h"
#import "UIBookmark.h"
#import "BookmarkViewController.h"
#import "NDTrie.h"
#import "NavigationBarViewController.h"

@interface BookmarkDataController ()
@property NSMutableArray *updatedBookmarks;
@property (readwrite) NSMutableDictionary *tagToBookmark;
@property NSMutableArray *watchingMethods;
@end

@implementation BookmarkDataController

static BookmarkDataController *instance = nil;
static BookmarkViewController *staticVC = nil;

+ (void)setViewController:(BookmarkViewController*)newVC
{
    staticVC = newVC;
    if(instance)
        instance.bookmarkVC = newVC;
}

+ (BookmarkDataController*)instantiate
{
    if(!instance)
        instance = [[BookmarkDataController alloc] initWithViewController:staticVC];
    
    return instance;
}

- (void)registerUpdate:(void (^)(void))updateMethod
{
    [self.watchingMethods addObject:updateMethod];
}

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
        _bookmarkDisplayArray = _bookmarksArray;
        _tagTrie = [[NDMutableTrie alloc] init];
        _tagToBookmark = [[NSMutableDictionary alloc] init];
        _updatedBookmarks = [[NSMutableArray alloc] init];
        _watchingMethods = [[NSMutableArray alloc] init];
        [NetworkClient getNewBookmarks];
    }
    return self;
}

- (BookmarkDataController*)initWithViewController:(BookmarkViewController*)bookmarkVC
{
    if(self = [super init])
    {
        _bookmarksArray = [[NSMutableArray alloc] init];
        _bookmarkDisplayArray = _bookmarksArray;
        _updatedBookmarks = [[NSMutableArray alloc] init];
        _tagTrie = [[NDMutableTrie alloc] init];
        _tagToBookmark = [[NSMutableDictionary alloc] init];
        _updatedBookmarks = [[NSMutableArray alloc] init];
        _watchingMethods = [[NSMutableArray alloc] init];
        _bookmarkVC = bookmarkVC;
        [NetworkClient getNewBookmarks];
    }
    
    return self;
}

- (NSUInteger)countOfBookmarks
{
    //return [self.bookmarksArray count];
    return [self.bookmarkDisplayArray count];
}

- (UIBookmark *)bookmarkInListAtIndex:(NSUInteger)index
{
    //return [self.bookmarksArray objectAtIndex:index];
    return [self.bookmarkDisplayArray objectAtIndex:index];
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
            [self.tagToBookmark setObject:bookmarkSet forKey:tag];
        }
        else
            [bookmarkSet addObject:bookmark];
    }
}

- (void)updateOnBookmarkInsertion
{
    if(self.updatedBookmarks)
        [self.bookmarkVC.collectionView insertItemsAtIndexPaths:(NSArray*)self.updatedBookmarks];
    [self.updatedBookmarks removeAllObjects];
    
    for (void (^f)(void) in self.watchingMethods)
        f();
}

- (void)showAll
{
    NSUInteger prevCount = self.bookmarkDisplayArray.count;
    [self.updatedBookmarks removeAllObjects];
    for (NSUInteger i = 0; i < prevCount; ++i) {
        [self.updatedBookmarks addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    self.bookmarkDisplayArray = nil;
    
    [self.bookmarkVC.collectionView deleteItemsAtIndexPaths:self.updatedBookmarks];
    
    [self.updatedBookmarks removeAllObjects];
    
    self.bookmarkDisplayArray = self.bookmarksArray;
    
    for (NSUInteger i = 0; i < self.bookmarkDisplayArray.count; ++i) {
        [self.updatedBookmarks addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.bookmarkVC.collectionView insertItemsAtIndexPaths:(NSArray*)self.updatedBookmarks];
}

- (void)showTag:(NSString*)tag
{
    NSUInteger prevCount = self.bookmarkDisplayArray.count;
    [self.updatedBookmarks removeAllObjects];
    for (NSUInteger i = 0; i < prevCount; ++i) {
        [self.updatedBookmarks addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    self.bookmarkDisplayArray = nil;
    
    [self.bookmarkVC.collectionView deleteItemsAtIndexPaths:self.updatedBookmarks];
    
    [self.updatedBookmarks removeAllObjects];
    
    self.bookmarkDisplayArray = (NSMutableArray*)[[self.tagToBookmark objectForKey:tag] allObjects];
    
    for (NSUInteger i = 0; i < self.bookmarkDisplayArray.count; ++i) {
        [self.updatedBookmarks addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.bookmarkVC.collectionView insertItemsAtIndexPaths:(NSArray*)self.updatedBookmarks];
}

@end
